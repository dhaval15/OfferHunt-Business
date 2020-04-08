import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:offerhuntbusiness/colors.dart';

class TextField extends StatelessWidget {
  final String attribute, label;
  final List<FormFieldValidator> validators;
  final borderRadius = 0.0;

  final int  maxLines;

  const TextField({this.attribute, this.label, this.validators,this.maxLines=1});

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      attribute: attribute,
      validators: validators,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        /*focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            borderSide: BorderSide(width: 2, color: brandColor)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            borderSide: BorderSide(width: 1)),*/
      ),
    );
  }
}
