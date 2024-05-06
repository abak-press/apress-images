# v7.8.4

* 2024-05-03 [8af2d52](../../commit/8af2d52) - __(git2-railsc)__ Release 7.8.4 
* 2024-05-03 [59bea6e](../../commit/59bea6e) - __(gevhoo)__ fix: id_partition when ID more then billion 
https://jira.railsc.ru/browse/GOODS-4093

# v7.8.3

* 2024-04-03 [e171b32](../../commit/e171b32) - __(ArtemBorodinEvgenyevich)__ Release: v7.8.3 
* 2024-03-13 [5a9cd0e](../../commit/5a9cd0e) - __(Vasilkov Ivan)__ fix: добавит проверку размера и расширения перед загрузкой картинки 
https://jira.railsc.ru/browse/PC4-30113

# v7.8.2

* 2024-02-06 [f7f55b4](../../commit/f7f55b4) - __(Andrew N. Shalaev)__ fix: do not rm lock files in drone 
* 2023-10-03 [7aeea67](../../commit/7aeea67) - __(Andrew N. Shalaev)__ Release v7.8.1 
* 2023-10-03 [4a2c43d](../../commit/4a2c43d) - __(Andrew N. Shalaev)__ fix: refresh dependencies 
* 2023-08-04 [945f162](../../commit/945f162) - __(git1-railsc)__ Release 7.8.0 
* 2023-07-18 [21f8e3f](../../commit/21f8e3f) - __(GIGrave)__ fix: no raise error if record not found 
https://jira.railsc.ru/browse/BPC-22320

* 2023-07-18 [59914ef](../../commit/59914ef) - __(GIGrave)__ feature: do not ignore lock files 
* 2023-07-18 [3db552d](../../commit/3db552d) - __(GIGrave)__ fix: shut up redis 
* 2023-07-18 [6f881c3](../../commit/6f881c3) - __(GIGrave)__ fix: lock loofah gem 

# v7.7.0

return true when images destroy

you do not need to do anything to connect to the project

* 2022-05-13 [d3cd00f](../../commit/d3cd00f) - __(GIGrave)__ feature: return true when images destroy 
https://jira.railsc.ru/browse/BPC-20526

# v7.6.0

* 2022-04-14 [3a8ffd3](../../commit/3a8ffd3) - __(Mikhail Nelaev)__ feature: поддержка webp 
https://jira.railsc.ru/browse/GOODS-3124

# v7.5.2

* 2022-01-13 [ea7c541](../../commit/ea7c541) - __(Andrew N. Shalaev)__ fix: extract online_processing attr to model 
https://jira.railsc.ru/browse/BPC-19985

# v7.5.1

* 2021-10-10 [0a790bb](../../commit/0a790bb) - __(TamarinEA)__ chore: do not lock appraisal 
* 2021-10-10 [d946853](../../commit/d946853) - __(TamarinEA)__ fix: add space to identify error message 

# v7.5.0

* 2021-10-05 [1c3ed8c](../../commit/1c3ed8c) - __(Gelani Geliskhanov)__ fix: lock appraisal version 
* 2021-09-16 [c9cf6c0](../../commit/c9cf6c0) - __(Gelani Geliskhanov)__ chore: corrected mapping in docker-compose.yml 
* 2021-09-16 [3901716](../../commit/3901716) - __(Gelani Geliskhanov)__ fix: corrected uploading for animated images 
https://jira.railsc.ru/browse/PC4-27093

* 2021-09-16 [9a721b3](../../commit/9a721b3) - __(Gelani Geliskhanov)__ chore: locked rspec-rails and pundit versions 
* 2021-06-17 [677991d](../../commit/677991d) - __(terentev)__ lock rails-assets-jquery 
* 2021-06-17 [87e54f6](../../commit/87e54f6) - __(terentev)__ fix: previews for images without background processing 
https://jira.railsc.ru/browse/PC4-26810

# v7.4.0

* 2021-07-26 [f46211b](../../commit/f46211b) - __(KonstantinBel)__ fix: fix image size in croping popup 
https://jira.railsc.ru/browse/BPC-19097

# v7.3.3

* 2021-07-26 [9bec9ca](../../commit/9bec9ca) - __(TamarinEA)__ chore: add ruby 2.4 support 

# v7.3.2

* 2020-11-16 [cae5244](../../commit/cae5244) - __(Andrew N. Shalaev)__ fix: check on enqueue_dangling_image method exists 

# v7.3.1

* 2020-10-23 [fdca393](../../commit/fdca393) - __(Mikhail Nelaev)__ fix: ActiveRecord::RecordNotFound in UpdateDuplicateImageJob 
https://jira.railsc.ru/browse/GOODS-2576

# v7.3.0

* 2020-10-01 [0ec64c5](../../commit/0ec64c5) - __(Mikhail Nelaev)__ fix: define perform method for delayed job 
https://jira.railsc.ru/browse/GOODS-2524

* 2020-09-24 [b52d23d](../../commit/b52d23d) - __(Mikhail Nelaev)__ feature: обновление дублей в отложенном джобе 
https://jira.railsc.ru/browse/GOODS-2524

# v7.2.0

* 2020-05-29 [8c217da](../../commit/8c217da) - __(konstantinbel)__ fix: save aspect ratio 
https://jira.railsc.ru/browse/BPC-16802

* 2020-04-17 [f14540f](../../commit/f14540f) - __(konstantinbel)__ feature: add "save original" button 
[MINOR] Добавит кнопку "Сохранить без изменений" в попап кропа.
https://jira.railsc.ru/browse/BPC-16487

* 2020-04-17 [c259268](../../commit/c259268) - __(konstantinbel)__ feature: add initial crop size 
[MINOR] Добавит возможность передать параметры init_width и init_height, для выставления начального размера области кропа.
https://jira.railsc.ru/browse/BPC-16487

# v7.1.1

* 2020-05-07 [cc696d1](../../commit/cc696d1) - __(Mikhail Nelaev)__ fix: attempt to fix processing flag for duplicates 
https://jira.railsc.ru/browse/GOODS-2367

* 2020-04-30 [d0086b7](../../commit/d0086b7) - __(Mikhail Nelaev)__ fix: не будем показывать на проде ошибку imagemagick 
https://jira.railsc.ru/browse/GOODS-2265

# v7.1.0

* 2020-03-24 [f1cd6a6](../../commit/f1cd6a6) - __(Andrew N. Shalaev)__ fix: lock dry gem 
* 2020-03-18 [332c8d1](../../commit/332c8d1) - __(konstantinbel)__ fix: add min crop popup width/height 
[PATCH]: Установит минимальную ширину (460px) и высоту (380px) попапа для нарезки изображений.
https://jira.railsc.ru/browse/BPC-16125

* 2020-03-12 [7076a12](../../commit/7076a12) - __(konstantinbel)__ feature: add custom title to crop popup, add imageStartUploading event 
[MINOR] Доавлен параметр popup_title, для изменения заголовка попапа кропа (прежний заголовок остался значением по умолчанию). Добавлено событие начала загрузки (после нажатия кнопки "сохранить").
https://jira.railsc.ru/browse/BPC-16125

* 2020-03-11 [f56919d](../../commit/f56919d) - __(Andrew N. Shalaev)__ feature: add event onCompleteProcessing of images 
https://jira.railsc.ru/browse/BPC-16304

# v7.0.0

* 2020-02-28 [403f6f9](../../commit/403f6f9) - __(terentev)__ feat: remove search of biggest style 
https://jira.railsc.ru/browse/GOODS-2008

# v6.11.0

* 2020-02-07 [d0323ea](../../commit/d0323ea) - __(terentev)__ fix: validate image file only on create 
https://jira.railsc.ru/browse/GOODS-1799

* 2020-01-31 [4d7cd7d](../../commit/4d7cd7d) - __(terentev)__ feat: add corrupted_image_file_validation 
https://jira.railsc.ru/browse/GOODS-1799

* 2020-01-31 [2c35fce](../../commit/2c35fce) - __(terentev)__ chore: fix floating test 
* 2020-01-29 [546add7](../../commit/546add7) - __(terentev)__ chore: drone 1.6 

# v6.10.3

* 2019-11-21 [5c99c19](../../commit/5c99c19) - __(TamarinEA)__ chore: lock gems 
* 2019-11-21 [db27328](../../commit/db27328) - __(TamarinEA)__ fix: retry on load file when fill img fingerprint 
https://jira.railsc.ru/browse/GOODS-1893

* 2019-11-07 [8d24807](../../commit/8d24807) - __(TamarinEA)__ fix: correct img fingerprint filling 
https://jira.railsc.ru/browse/GOODS-1893

# v6.10.2

* 2019-10-18 [9a98c77](../../commit/9a98c77) - __(Andrew N. Shalaev)__ fix: remove default options for original style 
https://jira.railsc.ru/browse/BPC-15426

# v6.10.1

* 2019-10-03 [17d4765](../../commit/17d4765) - __(TamarinEA)__ chore: lock some gems by ruby version 
* 2019-10-01 [a9f0b86](../../commit/a9f0b86) - __(TamarinEA)__ fix: always use index when find original 
https://jira.railsc.ru/browse/GOODS-2013

# v6.10.0

* 2019-08-15 [3f89b02](../../commit/3f89b02) - __(Andrew N. Shalaev)__ feature: configure default image styles 
https://jira.railsc.ru/browse/BPC-15117

# v6.9.2

* 2019-07-23 [7de7e9a](../../commit/7de7e9a) - __(Andrew N. Shalaev)__ fix: do not verify ssl 
https://jira.railsc.ru/browse/BPC-14977

# v6.9.1

* 2019-06-21 [c5d9737](../../commit/c5d9737) - __(TamarinEA)__ chore: lock some gems by ruby version 
* 2019-06-21 [0a11ff8](../../commit/0a11ff8) - __(TamarinEA)__ chore: up deduplication retry limit to 3 

# v6.9.0

* 2019-04-05 [51786e5](../../commit/51786e5) - __(TamarinEA)__ chore: lock pry-byebug for old ruby 
* 2019-04-05 [df8746e](../../commit/df8746e) - __(TamarinEA)__ fix: retry when webdav error in deduplication task 
https://jira.railsc.ru/browse/GOODS-1644

* 2019-04-03 [da868fd](../../commit/da868fd) - __(TamarinEA)__ fix: do not delete file when processed 
https://jira.railsc.ru/browse/GOODS-1644

* 2019-03-28 [10c794c](../../commit/10c794c) - __(TamarinEA)__ fix: enqueue clean dangling original image after destroy 
https://jira.railsc.ru/browse/GOODS-1644

* 2019-03-22 [1ff9bce](../../commit/1ff9bce) - __(TamarinEA)__ chore: remove support rails 3 
* 2019-03-22 [f050ded](../../commit/f050ded) - __(TamarinEA)__ fix: take fingerprint parent when duplicate from 
https://jira.railsc.ru/browse/GOODS-1644

* 2019-02-06 [6caac3d](../../commit/6caac3d) - __(TamarinEA)__ feature: add deduplication 
* 2019-02-07 [39b2af2](../../commit/39b2af2) - __(TamarinEA)__ chore: lock some gems for old ruby 

# v6.8.4

* 2019-04-04 [cfc0bbf](../../commit/cfc0bbf) - __(Andrew N. Shalaev)__ release v6.8.4 
* 2019-04-04 [99d2c12](../../commit/99d2c12) - __(Andrew N. Shalaev)__ feature: add ruby2.3 support and drop rails3.2 support 

# v6.8.3

* 2019-01-29 [54b25d7](../../commit/54b25d7) - __(TamarinEA)__ fix: typo in rename updated_at task 

# v6.8.2

* 2019-01-16 [36d5a9c](../../commit/36d5a9c) - __(Mikhail Nelaev)__ fix: clear file if image creation failed 
https://jira.railsc.ru/browse/GOODS-1571

# v6.8.1

* 2018-12-17 [76c93f9](../../commit/76c93f9) - __(Andrew N. Shalaev)__ fix: rename updated_at to img_updated_at 
https://jira.railsc.ru/browse/BPC-13545

# v6.8.0

* 2018-12-12 [881e7ff](../../commit/881e7ff) - __(Andrew N. Shalaev)__ fix: add img_updated_at and fill them 

# v6.7.3

* 2018-06-04 [5d41429](../../commit/5d41429) - __(Oleg Perminov)__ fix: image style when node is not available 
https://jira.railsc.ru/browse/BPC-9723

# v6.7.2

* 2018-05-04 [308e33d](../../commit/308e33d) - __(Mikhail Nelaev)__ fix: не удалялись джобы обработки картинок 
https://jira.railsc.ru/browse/GOODS-1137

* 2018-05-04 [94af71c](../../commit/94af71c) - __(Mikhail Nelaev)__ chore: use pg 9.6 

# v6.7.1

* 2018-02-02 [c8f9199](../../commit/c8f9199) - __(korotaev)__ fix: correct upload from url 
https://jira.railsc.ru/browse/GOODS-1055

# v6.7.0

* 2018-01-23 [20e5958](../../commit/20e5958) - __(Valery Glyantsev)__ fix: use original image in api view 
https://jira.railsc.ru/browse/PC4-21284

# v6.6.2

* 2018-01-19 [ce4357e](../../commit/ce4357e) - __(Denis Korobicyn)__ fix(rails 4): remove constantize and model_name 
https://jira.railsc.ru/browse/PC4-21423

# v6.6.1

* 2017-11-23 [2b34693](../../commit/2b34693) - __(levushkina)__ fix(crop): fix upload cropable img for ie 
https://jira.railsc.ru/browse/CK-1267
https://jira.railsc.ru/browse/BPC-11560

# v6.6.0

* 2017-09-11 [f186e84](../../commit/f186e84) - __(Dmitry Bochkarev)__ feature: подстановка расширения из содержимого файла 
https://jira.railsc.ru/browse/SERVICES-1197

# v6.5.3

* 2017-08-11 [aac0519](../../commit/aac0519) - __(Pavel Galkin)__ Release 6.5.4 
* 2017-08-11 [070fb05](../../commit/070fb05) - __(Pavel Galkin)__ fix: error in ProcessJob when image was not found 
https://jira.railsc.ru/browse/CK-1073

* 2017-08-11 [3c090aa](../../commit/3c090aa) - __(Pavel Galkin)__ test: wrap `.perform` test in context and simplify 
Если используется expect_any_instance_of, то allow_any_instance_of не
нужен.

# v6.5.2

* 2017-07-26 [521f040](../../commit/521f040) - __(korotaev)__ fix(image): use send for define callback 

# v6.5.1

* 2017-07-20 [adc029a](../../commit/adc029a) - __(Andrew N. Shalaev)__ chore: improve backoff strategy for process jobs 

# v6.5.0

* 2017-07-11 [4c919d0](../../commit/4c919d0) - __(levushkina)__ feature: add crop to dnd file-uploader 
https://jira.railsc.ru/browse/SG-6121
https://jira.railsc.ru/browse/CK-992

# v6.4.4

* 2017-06-01 [ddd0ff3](../../commit/ddd0ff3) - __(levushkina)__ fix: add max height to popup, fit popup by image [SKIP CI] 
https://jira.railsc.ru/browse/CK-936
https://jira.railsc.ru/browse/PC4-19841

# v6.4.3

* 2017-07-05 [00825bf](../../commit/00825bf) - __(Dmitry Bochkarev)__ fix: невалидная UTF-8 последовательность в результате вызова Addressable::URI.unescape 
https://jira.railsc.ru/browse/SERVICES-1919

# v6.4.2

* 2017-06-29 [28c4327](../../commit/28c4327) - __(Dmitry Bochkarev)__ fix: удаление невалидных последовательностей из названий файлов 
https://jira.railsc.ru/browse/SERVICES-1919

* 2017-06-01 [3339c9d](../../commit/3339c9d) - __(Andrew N. Shalaev)__ chore: correct homepage in gemspec 

# v6.4.1

* 2017-06-01 [880ce02](../../commit/880ce02) - __(antonnikulin)__ fix(images_load): The correct setting handlers 
https://jira.railsc.ru/browse/PC4-19039

# v6.4.0

* 2017-05-29 [622ef13](../../commit/622ef13) - __(korotaev)__ fix: geometry extraction, style_geometry for custom attribute 
* 2017-05-15 [db10431](../../commit/db10431) - __(korotaev)__ feat(upload): make position and processing optional for model 
https://jira.railsc.ru/browse/GOODS-565

* 2017-05-15 [c18fa50](../../commit/c18fa50) - __(korotaev)__ feat(imageable): add attachment_attribute option 
https://jira.railsc.ru/browse/GOODS-565

# v6.3.0

* 2017-05-26 [9360eb3](../../commit/9360eb3) - __(Andrew N. Shalaev)__ feature: move haml dependency to Gemfile 
* 2017-05-26 [f01f56d](../../commit/f01f56d) - __(Andrew N. Shalaev)__ fix: decrease quality to 80% by default 
Раньше для товарных было качество 80, прдлагаю для всех так оставить по-умолчанию.

* 2017-05-23 [1c8e037](../../commit/1c8e037) - __(Andrew N. Shalaev)__ feature: add options -filter Triangle and disable ditheraztion (it enabled by default) 
https://jira.railsc.ru/browse/BPC-10323

Examples:

Before:

```
andy@andypc:~/work/blizko/public/system/images/product on feature/BPC-8899 [!$]
$ ls -l | grep 123922020
-rw-r--r-- 1 root root 15509 May 23 15:04 123922020_big.jpg
-rw-r--r-- 1 root root  5208 May 23 15:04 123922020_medium.jpg
-rw-r--r-- 1 root root 47231 May 23 15:04 123922020_original.jpg
-rw-r--r-- 1 root root   876 May 23 15:04 123922020_small.jpg
-rw-r--r-- 1 root root  1956 May 23 15:04 123922020_thumb.jpg
```

After:
```
andy@andypc:~/work/blizko/public/system/images/product on feature/BPC-8899 [!$]
$ ls -l | grep 123922021
-rw-r--r-- 1 root root 14124 May 23 15:12 123922021_big.jpg
-rw-r--r-- 1 root root  4813 May 23 15:12 123922021_medium.jpg
-rw-r--r-- 1 root root 47231 May 23 15:12 123922021_original.jpg
-rw-r--r-- 1 root root   841 May 23 15:12 123922021_small.jpg
-rw-r--r-- 1 root root  1831 May 23 15:12 123922021_thumb.jpg
```

fix: set default options of paperclip after load config

fix: missing strip option

* 2017-05-23 [6fe21b3](../../commit/6fe21b3) - __(Andrew N. Shalaev)__ feature: move global convert options to engine initializator 
* 2017-05-23 [14516fc](../../commit/14516fc) - __(Andrew N. Shalaev)__ chore: git ignore all log files 

# v6.2.0

Кадрирование изображений.
Использование в слайдере -
https://github.com/abak-press/apress-companies-sliders/pull/55.
Дополнительных действий при подключении и релизе не требует.

* 2017-05-19 [a4f2700](../../commit/a4f2700) - __(Konstantin Lazarev)__ Revert "feat: add presenter for crop image form" 
This reverts commit 74feaf28b8b3ee792a1c3ebdeddabbc241122e38.

Нигде не используется, был добавлен по несогласованности

* 2017-05-15 [46591ba](../../commit/46591ba) - __(Konstantin Lazarev)__ feat: метод для получения геометрии определенного стиля 
https://jira.railsc.ru/browse/CK-886

* 2017-05-15 [1016211](../../commit/1016211) - __(Gorshkov Ivan)__ fix: show popup condition, resize image 
https://jira.railsc.ru/browse/CK-886
https://jira.railsc.ru/browse/SG-5714

* 2017-04-13 [e99b353](../../commit/e99b353) - __(Lekontsev)__ feature: crop feature added 
https://jira.railsc.ru/browse/CK-773

* 2017-04-10 [d3b5f51](../../commit/d3b5f51) - __(Konstantin Lazarev)__ chore: переставит crop_ аттрибуты в логичном порядке 
* 2017-04-10 [397760c](../../commit/397760c) - __(Konstantin Lazarev)__ feat: позволит кадрировать несколько стилей одной картинки 
https://jira.railsc.ru/browse/CK-835 - пункт 2 в комментарии

* 2017-04-07 [342298d](../../commit/342298d) - __(Konstantin Lazarev)__ fix: исправит кадрирование больших изображений 
https://jira.railsc.ru/browse/CK-835

пункт 1 в комментарии

* 2017-04-07 [cb58e11](../../commit/cb58e11) - __(Konstantin Lazarev)__ feat: возможность извлекать оригинальные размеры изображения 
https://jira.railsc.ru/browse/CK-835

* 2017-02-28 [74feaf2](../../commit/74feaf2) - __(Eugene Zhukov)__ feat: add presenter for crop image form 
https://jira.railsc.ru/browse/CK-770

* 2017-01-31 [6af3dc2](../../commit/6af3dc2) - __(Konstantin Lazarev)__ feature: implement image croping 
https://jira.railsc.ru/browse/CK-740

# v6.1.0

* 2017-04-05 [bbe0ebf](../../commit/bbe0ebf) - __(Andrew N. Shalaev)__ feature: add http read and open timeouts 
https://jira.railsc.ru/browse/BPC-10129

* 2017-04-05 [a601749](../../commit/a601749) - __(Andrew N. Shalaev)__ fix: allow safe redirection from http to https when download image 
https://jira.railsc.ru/browse/BPC-10129

* 2017-04-05 [610ef90](../../commit/610ef90) - __(Andrew N. Shalaev)__ feature: require pry-byebug in test env 
* 2017-04-05 [10ac030](../../commit/10ac030) - __(Andrew N. Shalaev)__ feature: autorelease 
* 2017-04-05 [7c09bce](../../commit/7c09bce) - __(Andrew N. Shalaev)__ feature: drop ruby 1.9 and rails 3.1 support 

# v6.0.1

* 2017-01-27 [5903284](../../commit/5903284) - __(Andrew N. Shalaev)__ fix: use model attribute for determine if subject nil 
https://jira.railsc.ru/browse/BPC-9710

# v6.0.0

* 2016-12-28 [0f2280b](../../commit/0f2280b) - __(Andrew N. Shalaev)__ fix: nokogiri for ruby 1.9 
* 2016-12-27 [dfe419c](../../commit/dfe419c) - __(Andrew N. Shalaev)__ feature: remove grabage_collector service 
* 2016-12-08 [e537eb3](../../commit/e537eb3) - __(Andrew N. Shalaev)__ feature: delayed processing of unowned images 
https://jira.railsc.ru/browse/BPC-9384

* 2016-12-08 [05fa2f4](../../commit/05fa2f4) - __(Andrew N. Shalaev)__ feature: extract cleanup images into interactor 
* 2016-12-08 [a1536cf](../../commit/a1536cf) - __(Andrew N. Shalaev)__ chore: improves droneio config 
* 2016-12-08 [afd1ba8](../../commit/afd1ba8) - __(Andrew N. Shalaev)__ fix: #find_by_* is deprecated 
* 2016-12-08 [cfcdcb3](../../commit/cfcdcb3) - __(Andrew N. Shalaev)__ fix: webmock for 1.9.3 

# v5.2.0

* 2016-11-25 [8248fd8](../../commit/8248fd8) - __(Andrew N. Shalaev)__ fix: public_suffix version for ruby 1.9 
* 2016-11-25 [392e810](../../commit/392e810) - __(Andrew N. Shalaev)__ feature: backoff strategy for process images 
https://jira.railsc.ru/browse/BPC-9264

# v5.1.0

* 2016-11-17 [94353f0](../../commit/94353f0) - __(Shangin Alexey)__ fix(images.js): Добавит триггер [SKIP CI] 
Добавлено событие при выборе невереного типа файла, при отсутствии в
инпуте сведений о файле добавлена отмена попытки загрузки и, как
следствие, исчезновение кнопки загрузки файла
https://jira.railsc.ru/browse/CK-582

# v5.0.0

* 2016-10-27 [9925330](../../commit/9925330) - __(Dmitry Bochkarev)__ feature: разделение обработки на онлайн и не онлайн 
https://jira.railsc.ru/browse/SERVICES-1400

* 2016-10-20 [d538cc8](../../commit/d538cc8) - __(Andrew N. Shalaev)__ chore: add droneio 

# v4.2.0

* 2016-09-09 [23cd136](../../commit/23cd136) - __(Denis Korobicyn)__ fix: show full image url 
https://jira.railsc.ru/browse/PC4-17992

* 2016-08-09 [f93509d](../../commit/f93509d) - __(Denis Korobicyn)__ docs: hound and params fixes (#40) 
https://jira.railsc.ru/browse/PC4-17773
* 2016-08-08 [ec9e3e8](../../commit/ec9e3e8) - __(Denis Korobicyn)__ feature: swagger docs for image (#39) 
https://jira.railsc.ru/browse/PC4-17773

# v4.1.0

* 2016-06-01 [781d1ba](../../commit/781d1ba) - __(Denis Korobicyn)__ fix: most_existing_style with no images (#38) 
https://jira.railsc.ru/browse/PC4-17392
* 2016-05-31 [c48ec88](../../commit/c48ec88) - __(Denis Korobicyn)__ fix: renamed method best_style_for_copy 

# v4.0.3

* 2016-05-31 [d487c7f](../../commit/d487c7f) - __(Dmitry Bochkarev)__ fix: возращаем для Attachemnt#most_existing_style самый крупный (#36) 
https://jira.railsc.ru/browse/SERVICES-1126
* 2016-05-26 [5c330bb](../../commit/5c330bb) - __(Andrew N. Shalaev)__ fix: CI badge in README 
* 2016-05-26 [aad8567](../../commit/aad8567) - __(Andrew N. Shalaev)__ feat: default processing image path 
https://jira.railsc.ru/browse/BPC-8196

# v4.0.2

* 2016-04-27 [63a74e3](../../commit/63a74e3) - __(Dmitry Bochkarev)__ fix: постановка в очередь, при двойном сохранении в транзакции (#34) 
https://jira.railsc.ru/browse/SERVICES-902
https://jira.railsc.ru/browse/PC4-17037?focusedCommentId=97770&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-97770

# v4.0.1

* 2016-04-26 [08400e3](../../commit/08400e3) - __(Dmitry Bochkarev)__ fix: обработка имени файла (#33) 
транслитерируем, удаляем мусор, обрезаем

# v4.0.0

* 2016-04-04 [6f387d8](../../commit/6f387d8) - __(Andrew N. Shalaev)__ fix: format validation and normalize uploading urls 
https://jira.railsc.ru/browse/BPC-7954
* 2016-03-15 [ed100c3](../../commit/ed100c3) - __(Andrew N. Shalaev)__ fix: reset processing flag before destroy image 
https://jira.railsc.ru/browse/BPC-6698

* 2016-03-14 [b5247d3](../../commit/b5247d3) - __(TamarinEA)__ fix: change image status when save with delay processing 
https://jira.railsc.ru/browse/BPC-7717

* 2015-11-13 [c2e2046](../../commit/c2e2046) - __(Andrew N. Shalaev)__ feat: extract position normalization into module and make it optional 
* 2015-11-13 [7d9dc21](../../commit/7d9dc21) - __(Andrew N. Shalaev)__ fix: method to_file returns correct result with file extension 
* 2015-10-27 [7547b56](../../commit/7547b56) - __(Andrew N. Shalaev)__ feat: поддержка thoughtbot/paperclip для rails 3.1 
https://jira.railsc.ru/browse/BPC-6698

# v3.2.0

* 2016-02-18 [e613ce1](../../commit/e613ce1) - __(Pavel Galkin)__ fix image assignment through nested attributes 
Это для https://jira.railsc.ru/browse/CK-49.

# v3.1.1

* 2015-12-09 [c311654](../../commit/c311654) - __(Mikhail Nelaev)__ feature: rake task для очистки мусорных картинок 

# v3.1.0

* 2015-12-02 [5ee2e2b](../../commit/5ee2e2b) - __(Mikhail Nelaev)__ feature: сервис удаления старых картинок 
https://jira.railsc.ru/browse/SERVICES-707

# v3.0.1

* 2015-10-19 [a71ac3a](../../commit/a71ac3a) - __(Zhidkov Denis)__ fix: fixup several bugs in images table upgrade migration 
Including changes:
1) normalize images positions before uniq index creation on images table upgrade;
2) fixup old index deletion conditions;
3) fixup "Don't know how to build task 'images_table:upgrade'" error;
4) change rake task 'images_table:uprade' to be more like original migration, so it (migration) could be marked as passed before release.

* 2015-10-19 [f53ea76](../../commit/f53ea76) - __(Zhidkov Denis)__ fix: temporary hardcode img-attributes validation messages 
* 2015-10-06 [fb41616](../../commit/fb41616) - __(Andrew N. Shalaev)__ fix: shoulda-matchers 3.0 requires ruby 2.0 
* 2015-10-06 [eae4ddb](../../commit/eae4ddb) - __(Andrew N. Shalaev)__ Release 3.0.0 
* 2015-09-29 [30d7129](../../commit/30d7129) - __(Andrew N. Shalaev)__ fix: handle missing params as bad_request 
* 2015-09-17 [7d80341](../../commit/7d80341) - __(kuznecova)__ fix(BPC-6884): починила dnd и триггер при загрузке слишком большого файла 
* 2015-09-14 [219d547](../../commit/219d547) - __(kuznecova)__ fix(BPC-6856): Не отображается превью у только что загруженной картинки 

# v3.0.0-beta

* 2015-07-24 [d6d5dad](../../commit/d6d5dad) - __(Stanislav Gordanov)__ feature: изменение добавления связи для одиночной картинки 
* 2015-08-14 [ee3cd33](../../commit/ee3cd33) - __(kuznecova)__ feature(BPC-6576) Отзывы о товарах: выделение общих шаблонов и вынос общей логики в гем - модуль работы с картинками 

# v3.0.0-alpha.2

* 2015-08-17 [26961e0](../../commit/26961e0) - __(Andrew N. Shalaev)__ feat: хелпер формы для загрузки картинок 
https://jira.railsc.ru/browse/BPC-6623

# v3.0.0-alpha

# v3.0.0

* 2015-09-29 [30d7129](../../commit/30d7129) - __(Andrew N. Shalaev)__ fix: handle missing params as bad_request 
* 2015-09-17 [7d80341](../../commit/7d80341) - __(kuznecova)__ fix(BPC-6884): починила dnd и триггер при загрузке слишком большого файла 
* 2015-09-14 [219d547](../../commit/219d547) - __(kuznecova)__ fix(BPC-6856): Не отображается превью у только что загруженной картинки 
* 2015-07-24 [d6d5dad](../../commit/d6d5dad) - __(Stanislav Gordanov)__ feature: изменение добавления связи для одиночной картинки 
* 2015-08-14 [ee3cd33](../../commit/ee3cd33) - __(kuznecova)__ feature(BPC-6576) Отзывы о товарах: выделение общих шаблонов и вынос общей логики в гем - модуль работы с картинками 
* 2015-08-17 [26961e0](../../commit/26961e0) - __(Andrew N. Shalaev)__ feat: хелпер формы для загрузки картинок 
https://jira.railsc.ru/browse/BPC-6623

* 2015-08-05 [89b59ad](../../commit/89b59ad) - __(Andrew N. Shalaev)__ fix: исправление проблем с фабриками 
Исправлена проблема с фабриками на абстракные модели,
которые предназначены только для тестирования внутри гема

* 2015-08-03 [2dd7312](../../commit/2dd7312) - __(Andrew N. Shalaev)__ feat: rails 4 compatibility 

# v2.0.0

* 2015-07-17 [c000bf3](../../commit/c000bf3) - __(Stanislav Gordanov)__ fix(subjectable): перемещение ActsAsSubjectable module в Concerns module 
* 2015-06-18 [4c2f5e8](../../commit/4c2f5e8) - __(Stanislav Gordanov)__ feature(subject): добавление акта для cвязи субъектов с изображениями (единичная привязка) 
https://jira.railsc.ru/browse/SG-3529

# v1.0.1

* 2015-04-20 [9287c17](../../commit/9287c17) - __(Долганов Сергей)__ fix(specs): stack level too deep 
including globally ActionDispatch::TestProcess broke old tests in some cases

# v1.0.0

* 2015-04-02 [b292703](../../commit/b292703) - __(Andrew N. Shalaev)__ feature(imageable): acts_as_image метод 

# v0.0.2

* 2015-04-02 [c83a68f](../../commit/c83a68f) - __(Andrew N. Shalaev)__ fix(upload): subject_id не обязательный параметр 

# v0.0.1

* 2015-03-27 [1d62268](../../commit/1d62268) - __(Andrew N. Shalaev)__ feature(abstract image): Initial commit 
* 2015-03-24 [80c5cbb](../../commit/80c5cbb) - __(Mamedaliev Kirill)__ Initial commit 
