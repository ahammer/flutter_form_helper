import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_helper/form_helper.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(FormTestApp());
}

/// This is the demo app for the Flutter Form Widget
class FormTestApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Flutter Form Demo',
      home: Scaffold(body: SafeArea(child:FormBuilder(form:testFormFields))),
    );
}

const testFormFields = <FieldSpec>[
  FieldSpec(name: "required", mandatory: true, validators: [lengthValidator]),
  FieldSpec(name: "optional", mandatory: false, validators: [lengthValidator]),
  FieldSpec(name: "number", mandatory: true, validators: [intValidator]),
  FieldSpec(name: "radio1",group:"boolean", value: "true", type: FieldType.Radio),
  FieldSpec(name: "radio2",group:"boolean", value: "false", type: FieldType.Radio),
  FieldSpec(name: "checkbox", value: "checked", type: FieldType.Checkbox)
]; 