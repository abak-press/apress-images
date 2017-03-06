/*
* Универсальный модуль для загрузки картинок.
* app.config.images {
*   maxFileSize - по умолчанию 2
*   maxFilesCount - по умолчанию 1
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
    _$imagesContainer,
    crop = app.config.images.crop_enable || false,
    maxWidth = app.config.images.max_width || null,
    minWidth  = app.config.images.min_width || null,
    maxHeight = app.config.images.max_height || null,
    minHeight = app.config.images.min_height || null,
    _file = null,
    _scale = 1;

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
        _images.length && setTimeout(_processing, _options.processingTime);
      },
      error: function() {
        _process = false;
        $.merge(_images, images);
        $doc.trigger('imageProcessingFail:images', _$imagesContainer);
      }
    });
    _images.splice(0, _images.length);
  }

  function _uploadFiles(files) {
    if (_isImagesLimitExceeds(files)) {
      $doc.trigger('imageLimitExceeds:images', _$imagesContainer);
      files = files.slice(0, _options.maxFilesCount - (files.length + _getImagesCount()));
    }
    if (!files.length) {
      return false;
    }
    FileAPI.upload({
      url: app.config.images.uploadUrl,
      data: app.config.images.uploadData || null,
      files: {'images[]': files},
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
      files.length && _uploadFiles(files);
    });
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

  function _showDialog() {
    $('.js-cover-blog-preview-popup').dialog({
      modal: true,
      width: 'auto',
      height: 'auto'
    });
  }

  function _checkSizes() {
    if (width >= minWidth && width <= maxWidth) {
      if (height >= minHeight && height <= maxHeight) {
        _sendImg();
      } else if (height < minHeight) {
        _sendImg();
      } else if (height > maxHeight) {
        _showDialog();
      }
    } else if (width < minWidth) {
      if (height >= minHeight && height <= maxHeight) {
        _sendImg();
      } else if (height < minHeight) {
        _sendImg();
      } else if (height > maxHeight) {
        _showDialog();
      }
    } else if (width > maxWidth) {
      if (height >= minHeight && height <= maxHeight) {
        _showDialog();
      } else if (height < minHeight) {
        _showDialog();
      } else if (height > maxHeight) {
        _showDialog();
      }
    }
  }




  function _saveImage(size) {
    var
      ctx,
      canvas = $('<canvas>')[0],
      img = $('.js-images-preview-image')[0],
      $crop = $('.js-images-preview-crop');

    if (!size) {
      canvas.width = $crop.width() * _scale;
      canvas.height = $crop.height() * _scale;
    } else {
      canvas.width = size.width;
      canvas.height = size.height;
    }
    ctx = canvas.getContext('2d');
    ctx.fillStyle = 'white';
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    ctx.drawImage(
      img,
      parseInt(parseInt(!size ? $crop[0].style.left : 0) * _scale),
      parseInt(parseInt(!size ? $crop[0].style.top : 0) * _scale),
      canvas.width, canvas.height,
      0, 0,
      canvas.width, canvas.height
    );

    canvas.toBlob(function(blob) {
      _save(blob, _file.name);
    }, _file.type, 1.0);
  }






  function _listeners() {
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
            files.length && _uploadFiles(files);
          });
        }
      })
      .on('click', '.js-images-preview-close-preview', function() {
        $('.js-images-preview').dialog('close');
      })
      .on('click', '.js-images-preview-save-cover', function() {
        $('.js-images-preview').dialog('close');
      });



    FileAPI.event.on($(_options.selectors.fileInput)[0], 'change', function(event) {
      if ($(this).val()) {
        _loadFiles(FileAPI.getFiles(event));
      }
    });
  }

  self.load = function() {
    _listeners();
  };

  return self;
}(app.modules.images || {}));
