import 'dart:io';

import 'package:christian_picker_image/christian_picker_image.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart' hide TextField;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_selector_formfield/image_selector_formfield.dart';
import 'package:offerhuntbusiness/colors.dart';
import 'package:offerhuntbusiness/mixins.dart';
import '../../views/views.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:crop/crop.dart';
import 'package:intl/intl.dart' as intl;

class EmailField extends StatelessWidget {
  final String label, attribute;

  const EmailField({this.label = 'Email Address', this.attribute = 'e'});

  @override
  Widget build(BuildContext context) {
    return TextField(
      label: label,
      attribute: attribute,
      validators: [
        FormBuilderValidators.email(errorText: 'Invlid ${label.toLowerCase()}'),
        FormBuilderValidators.minLength(1,
            errorText: '$label should not be empty')
      ],
    );
  }
}

class PhoneField extends StatelessWidget {
  final String label, attribute;

  const PhoneField({this.label = 'Contact No', this.attribute = 'c'});

  @override
  Widget build(BuildContext context) {
    return TextField(
      label: label,
      attribute: attribute,
      validators: [
        //Todo
      ],
    );
  }
}

class AddressField extends StatelessWidget {
  final String label, attribute;

  const AddressField({
    this.label = 'Address',
    this.attribute = 'a',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      label: label,
      attribute: attribute,
      maxLines: 4,
      validators: [
        FormBuilderValidators.minLength(10,
            errorText: '$label must be longer than 10 letters'),
        FormBuilderValidators.maxLength(200,
            errorText: '$label must be shorter than 200 letters'),
      ],
    );
  }
}

class StringField extends StatelessWidget {
  final String label, attribute;
  final int minLength, maxLength, maxLines;

  const StringField({
    this.label = 'String',
    this.attribute = 's',
    this.maxLines,
    this.minLength = 1,
    this.maxLength = 10,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      label: label,
      maxLines: maxLines,
      attribute: attribute,
      validators: [
        FormBuilderValidators.minLength(minLength,
            errorText: '$label must be longer than $minLength letters'),
        FormBuilderValidators.maxLength(maxLength,
            errorText: '$label must be shorter than $maxLength letters'),
      ],
    );
  }
}

class DiscountField extends StatelessWidget {
  final String label, attribute;
  final num min, max;

  const DiscountField({
    this.label = 'Discount',
    this.attribute = 'p',
    this.min = 0,
    this.max = 100,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderSlider(
      attribute: attribute,
      min: min,
      max: max,
      initialValue: min,
      decoration: InputDecoration(
        labelText: label,
        suffix: Text('%'),
      ),
    );
  }
}

class DateField extends StatelessWidget {
  final String attribute, label;
  final DateTime firstDate, lastDate;

  const DateField({
    this.label,
    this.attribute = 'r',
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderDateRangePicker(
      attribute: attribute,
      firstDate: firstDate,
      lastDate: lastDate,
      format: intl.DateFormat('dd-mm-yyyy'),
      decoration: InputDecoration(labelText: label),
    );
  }
}

class ImageField extends StatefulWidget {
  const ImageField({Key key}) : super(key: key);

  @override
  OfferImageFieldState createState() => OfferImageFieldState();
}

class ImageFieldState extends State<ImageField>
    with ScreenUtilStateMixin<ImageField> {
  File image;

  void _loadImage() async {
    final files = await ChristianPickerImage.pickImages(
        maxImages: 1, enableGestures: true);
    if (files != null)
      image = await ImageCropper.cropImage(
          sourcePath: files[0].absolute.path,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: brandColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
    if (image != null) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = ss(192, 192);
    return GestureDetector(
      onTap: _loadImage,
      child: DottedBorder(
        child: Container(
          width: size.width,
          height: size.height,
          child: image != null
              ? Image.file(image, height: size.height, width: size.width)
              : Container(
                  width: size.width,
                  height: size.height,
                  child: Center(
                      child: Text('Click here to upload a photo to shop logo')),
                ),
        ),
      ),
    );
  }
}

class OfferImageField extends StatefulWidget {
  final List<CropAspectRatio> ratios = [
    CropAspectRatio(ratioX: 7, ratioY: 3),
    CropAspectRatio(ratioX: 8, ratioY: 3),
    CropAspectRatio(ratioX: 8, ratioY: 4),
    CropAspectRatio(ratioX: 8, ratioY: 5),
    CropAspectRatio(ratioX: 9, ratioY: 5),
  ];

  OfferImageField({Key key}) : super(key: key);

  @override
  OfferImageFieldState createState() => OfferImageFieldState();
}

class OfferImageFieldState extends State<OfferImageField>
    with ScreenUtilStateMixin<OfferImageField> {
  File image;

  void _loadImage() async {
    final files = await ChristianPickerImage.pickImages(
        maxImages: 1, enableGestures: true);
    if (files != null)
      image = await ImageCropper.cropImage(
          sourcePath: files[0].absolute.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.ratio4x3,
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: brandColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
    if (image != null) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = ss(400, 200);
    return GestureDetector(
      onTap: _loadImage,
      child: DottedBorder(
        child: Container(
          width: image == null ? size.width : null,
          height: image == null ? size.height : null,
          child: image != null
              ? Image.file(image, width: size.width, fit: BoxFit.fitWidth)
              : Container(
                  width: size.width,
                  height: size.height,
                  child: Center(
                      child: Text('Click here to upload a photo to shop logo')),
                ),
        ),
      ),
    );
  }
}

class CategoryField extends StatelessWidget with ScreenUtilMixin {
  final List<String> categories;
  final String attribute;

  const CategoryField({this.categories, this.attribute = 'z'});

  @override
  Widget build(BuildContext context) {
    return FormBuilderFilterChip(
      attribute: attribute,
      spacing: sw(4),
      decoration: InputDecoration(border: InputBorder.none),
      options: categories
          .map((e) => FormBuilderFieldOption(
                child: Text(e),
                value: e,
              ))
          .toList(),
    );
  }
}
