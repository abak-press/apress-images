/*
* Универсальный модуль для загрузки картинок.
* app.config.images {
*   maxFileSize - по умолчанию 2
*   maxFilesCount - по умолчанию 1
*   cropable - по умолчанию false
*   sizeType - по умолчанию 'medium'
*   uploadData: {
*     model
*     'subject_type'
*     'subject_id'
*   }
*   multiple - по умолчанию false
* }
* */
app.modules.images = (function(self) {
  var
    _options = {
      maxFileSize: app.config.images.maxFileSize || 2,
      maxFilesCount: app.config.images.maxFilesCount || 1,
      processingTime: 2000,
      selectors: {
        imagesContainer: '.js-images-container',
        fileInput: '.js-input-file-image',
        buttonUpload: '.js-upload-image',
        visibleImages: '.js-image:visible',
        imageRow: '.js-image-row',
        imagesWrapper: '.js-images-wrapper'
      }
    },
    _images = [],
    _process = false,
    MAX_CROP_POPUP_WIDTH = 640,
    MIN_CROP_POPUP_WIDTH = 460,
    MAX_CROP_POPUP_HEIGHT = 350,
    _$imagesContainer,
    _$cropingDialog,
    _cropRatio,
    _cropData,
    _processedImage,
    _forbiddenForCropMimeTypes = /^image\/svg/;

  _images.add = function(params) {
    this.push(params);
    _processing();
  };

  function _processing() {
    var images = $.merge([], _images);

    if (_process || !images.length) {
      return false;
    }

    _process = true;
    $.ajax({
      url: app.config.images.previewUrl,
      data: {
        ids: images,
        model: app.config.images.uploadData.model || null,
        style: app.config.images.sizeType || 'medium'
      },
      success: function(response) {
        _process = false;
        $.each(response, function() {
          var id = Object.keys(this)[0];
          if (this[id] === 'processing') {
            _images.push(id);
          } else {
            $('.js-image[data-id="' + id + '"]').attr({src: this[id]});
          }
        });
        if (_images.length) {
          setTimeout(_processing, _options.processingTime);
        } else {
          $doc.trigger('imageProcessingComplete:images', _$imagesContainer);
        }
      },
      error: function() {
        _process = false;
        $.merge(_images, images);
        $doc.trigger('imageProcessingFail:images', _$imagesContainer);
      }
    });
    _images.splice(0, _images.length);
  }

  function _checkIfImageShouldBeCroped(file, fileInfo) {
    switch (true) {
      case fileInfo.width > app.config.images.cropOptions['min_width'] &&
      fileInfo.height > app.config.images.cropOptions['min_height']:
        _showCropingDialog(file, fileInfo);
        _processedImage = file;
        break;

      case fileInfo.width > app.config.images.cropOptions['min_width'] &&
      fileInfo.height === app.config.images.cropOptions['min_height']:
        _showCropingDialog(file, fileInfo);
        _processedImage = file;
        break;

      case fileInfo.width === app.config.images.cropOptions['min_width'] &&
      fileInfo.height > app.config.images.cropOptions['min_height']:
        _showCropingDialog(file, fileInfo);
        _processedImage = file;
        break;

      case fileInfo.width < app.config.images.cropOptions['min_width'] ||
      fileInfo.height < app.config.images.cropOptions['min_height']:
        $doc.trigger('imageTooSmall:images', _$imagesContainer);
        if (app.config.images.cropOptions['require_save_aspect_ratio']) { return; }
        _uploadFiles([file], app.config.images.uploadData);
        break;

      case fileInfo.width === app.config.images.cropOptions['min_width'] &&
      fileInfo.height === app.config.images.cropOptions['min_height']:
        _uploadFiles([file], app.config.images.uploadData);
        break;
    }
  }

  function _getImageSize(file) {
    var imageSize;

    FileAPI.getInfo(file, function(error, fileInfo) {
      imageSize = {
        width: fileInfo.width,
        height: fileInfo.height
      }
    });
    return imageSize;
  }

  function _showCropingDialog(file, fileInfo) {
    FileAPI.Image(file)
      .resize(MAX_CROP_POPUP_WIDTH, MAX_CROP_POPUP_HEIGHT, 'max')
      .get(function(error, image) {
        _cropRatio = image.width / fileInfo.width;
        _$cropingDialog.html(HandlebarsTemplates['images/croping_popup']({
          image: image.toDataURL(),
          title: app.config.images.popupTitle,
          showSaveOriginalButton: app.config.images.showSaveOriginalButton
        })).dialog({
          modal: true,
          resizable: false,
          width: image.width < MIN_CROP_POPUP_WIDTH ? MIN_CROP_POPUP_WIDTH : image.width,
          dialogClass: 'croping-popup'
        });

        _initCropArea(image.width, image.height);
      });

  }

  function _getInitialSideSize(imageSize, minSize, metric, cropRatio) {
    var
      initSize = (app.config.images.cropOptions[metric] || 0) * cropRatio,
      resultSize;

    if (initSize) {
      resultSize = initSize < imageSize ? initSize : imageSize;
    } else {
      resultSize = minSize;
    }

    return resultSize;
  }

  function _initCropArea(imageWidth, imageHeight) {
    var
      $cropArea = _$cropingDialog.find('.js-image-crop-area'),
      $cloneImage = _$cropingDialog.find('.js-clone-image-for-crop'),
      minWidth = app.config.images.cropOptions['min_width'] * _cropRatio,
      minHeight = app.config.images.cropOptions['min_height'] * _cropRatio,
      initWidth = _getInitialSideSize(imageWidth, minWidth, 'init_width', _cropRatio),
      initHeight =  _getInitialSideSize(imageHeight, minHeight, 'init_height', _cropRatio),
      aspectRatio = minWidth / minHeight;

    initWidth = initWidth > (initHeight * aspectRatio) ? (initHeight * aspectRatio) : initWidth;
    initHeight = initHeight > (initWidth / aspectRatio) ? (initWidth / aspectRatio) : initHeight;

    _setCropData({left: 0, top: 0}, {width: initWidth, height: initHeight});

    $cropArea.resizable({
      aspectRatio: true,
      containment: 'parent',
      handles: 'all',
      minWidth: minWidth,
      minHeight: minHeight,
      resize: function(event, ui) {
        $cloneImage.css({
          left: -ui.position.left,
          top: -ui.position.top
        });
        _setCropData(ui.position, ui.size);
      }
    }).draggable({
      containment: 'parent',
      drag: function(event, ui) {
        if (ui.position.left < 0) {
          ui.position.left = 0;
        }
        if (ui.position.top < 0) {
          ui.position.top = 0;
        }
        $cloneImage.css({
          left: -ui.position.left,
          top: -ui.position.top
        });
        _setCropData(ui.position, {width: event.target.offsetWidth, height: event.target.offsetHeight});
      }
    }).css({
      width: initWidth,
      height: initHeight,
      top: 0,
      left: 0
    }).find('img').css({
      top: 0,
      left: 0
    });
  }

  function _setCropData(position, size) {
    _cropData = {
      'crop_x': parseInt(position.left / _cropRatio),
      'crop_y': parseInt(position.top / _cropRatio),
      'crop_w': parseInt(size.width / _cropRatio),
      'crop_h': parseInt(size.height / _cropRatio),
      transformImg: true
    };
  }

  function _checkFileSizeAndExtension(file) {
    var invalidType = !/^image/.test(file.type);
    var invalidSize = !(file.size <= _options.maxFileSize * FileAPI.MB); 

    if (invalidType && invalidSize) {
      $doc.trigger('imageTypeInvalid:images', _$imagesContainer);
      return true;
    }

    invalidType && $doc.trigger('imageTypeInvalid:images', _$imagesContainer);
    invalidSize && $doc.trigger('imageTooBig:images', _$imagesContainer);

    return invalidType || invalidSize;
  }

  function _checkFilesBeforeUpload(files) {
    for (var i = 0; i < files.length; i++) {
      if(_checkFileSizeAndExtension(files[i])) {
        return true;
      }
    }
  }

  function _uploadFiles(files, data) {
    $doc.trigger('imageStartUploading:images', _$imagesContainer);
    var transformImg;

    if (_isImagesLimitExceeds(files)) {
      $doc.trigger('imageLimitExceeds:images', _$imagesContainer);
      files = files.slice(0, _options.maxFilesCount - (files.length + _getImagesCount()));
    }
    if (!files.length) {
      return false;
    }

    var isThereConfig = app.config.imagesUploader && app.config.imagesUploader.checkBeforeUpload;
    if (isThereConfig && _checkFilesBeforeUpload(files)) {
      return false;
    }

    if (data.transformImg) {
      transformImg = {
        maxWidth: app.config.images.originalStyle.width,
        maxHeight: app.config.images.originalStyle.height
      };
    }

    FileAPI.upload({
      url: app.config.images.uploadUrl,
      data: data || null,
      files: {'images[]': files},
      imageTransform: transformImg,
      upload: function() {
        _$imagesContainer.find(_options.selectors.buttonUpload).prop({disabled: true});
      },
      filecomplete: function(err, xhr) {
        if (!err) {
          var previewImage = JSON.parse(xhr.responseText).ids[0];
          _images.add(previewImage);
          $doc.trigger('imageUploaded:images', {image: previewImage, container: _$imagesContainer});
        } else {
          $doc.trigger('imageUploadFail:images', _$imagesContainer);
        }
      },
      complete: function() {
        $(_options.selectors.fileInput).attr({value: ''});
        _$imagesContainer.find(_options.selectors.buttonUpload).prop({disabled: false});
      }
    });
  }

  function _loadFiles(files) {
    $doc.trigger('imageStartLoading:images', _$imagesContainer);
    FileAPI.filterFiles(files, function(file) {
      if (/^image/.test(file.type)) {
        var fileSizeIsNormal = file.size <= _options.maxFileSize * FileAPI.MB;
        if (!fileSizeIsNormal) {
          $doc.trigger('imageTooBig:images', _$imagesContainer);
        }
        return fileSizeIsNormal;
      }
      else {
        $doc.trigger('imageTypeInvalid:images', _$imagesContainer);
      }
    }, function(files) {
      if (files.length === 0) {
        return;
      }

      var file = files[0];

      // На текущий момент кроп предусмотрен только в случае одиночной загрузки картинок
      if (!_allowCrop(file)) {
        _uploadFiles(files, app.config.images.uploadData);
        return;
      }

      if (app.config.images.originalStyle.width && app.config.images.originalStyle.height) {
        FileAPI.Image(file)
          //уменьшаем картинку до размеров оригинального стиля, относительно которого backend обрезает изображение
          .resize(app.config.images.originalStyle.width, app.config.images.originalStyle.height, 'max')
          .get(function(error, image) {
            _checkIfImageShouldBeCroped(file, {width: image.width, height: image.height});
          });
      } else {
        _checkIfImageShouldBeCroped(file, _getImageSize(file));
      }
    });
  }

  function _allowCrop(file) {
    return app.config.images.cropable && !_forbiddenForCropMimeTypes.test(file.type);
  }

  function _getImagesCount() {
    return _$imagesContainer.find(_options.selectors.visibleImages).length;
  }

  function _isImagesLimitExceeds(files) {
    return files.length + _getImagesCount() > _options.maxFilesCount;
  }

  function _setContainer(el) {
    _$imagesContainer = $($(el).data('container'));
  }

  function _listener() {
    $doc
      .on('click', _options.selectors.buttonUpload, function(event) {
        _setContainer(this);
        $(_options.selectors.fileInput).click();
        event.preventDefault();
      })
      .on('wrapperOpened:images', function() {
        if (FileAPI.support.dnd) {
          $(_options.selectors.imagesWrapper).dnd($.noop, function(files) {
            _setContainer(this);
            if (files.length) {
              app.config.images.cropable ? _loadFiles(files) : _uploadFiles(files, app.config.images.uploadData);
            }
          });
        }
      });

    FileAPI.event.on($(_options.selectors.fileInput)[0], 'change', function(event) {
      if ($(this).val()) {
        _loadFiles(FileAPI.getFiles(event));
      }
    });

    _$cropingDialog && _$cropingDialog
      .on('dialogclose', function() {
        $(_options.selectors.fileInput).val('');
      })
      .on('click', '.js-save-croped-image', function() {
        _uploadFiles([_processedImage], $.extend({}, app.config.images.uploadData, _cropData));
        _$cropingDialog.dialog('close');
      })
      .on('click', '.js-save-original-image', function() {
        _uploadFiles([_processedImage], app.config.images.uploadData);
        _$cropingDialog.dialog('close');
      });
  }

  function _init() {
    if (app.config.images.cropable) {
      $('body').append(_$cropingDialog = $('<div>').addClass('js-croping-dialog dn'));
    }
  }

  self.load = function() {
    _init();
    _listener();
  };

  return self;
}(app.modules.images || {}));
