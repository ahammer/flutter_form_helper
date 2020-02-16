import 'package:flutter/material.dart';
import 'package:flutter_form_helper/form_helper.dart';

void main() => runApp(FormTestApp());

class FormTestApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Form Demo',
      home: Scaffold(body: SafeArea(child:FormBuilder(form:testFormFields))),
    );
  }
}

const testFormFields = <FieldSpec>[
  FieldSpec(name: "required", mandatory: true, validators: [lengthValidator]),
  FieldSpec(name: "optional", mandatory: false, validators: [lengthValidator]),
  FieldSpec(name: "number", mandatory: true, validators: [intValidator]),
  


];