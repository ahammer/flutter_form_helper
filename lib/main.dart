import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_helper/form_helper.dart';

final kScaffoldKey = GlobalKey();

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
        home: Scaffold(
            key: kScaffoldKey,
            body: const SafeArea(
                child: FormBuilder(
                    form: testFormFields, onFormSubmitted: resultsCallback))),
      );
}

const testFormFields = <FieldSpec>[
  FieldSpec(
      name: "RequiredField", mandatory: true, validators: [lengthValidator]),
  FieldSpec(
      name: "OptionalField", mandatory: false, validators: [lengthValidator]),
  FieldSpec(name: "IntegerField", mandatory: true, validators: [intValidator]),
  FieldSpec(
      name: "radio1",
      group: "RadioGroup1",
      value: "true",
      type: FieldType.Radio),
  FieldSpec(
      name: "radio2",
      group: "RadioGroup1",
      value: "false",
      type: FieldType.Radio),
  FieldSpec(name: "checkbox", value: "checked", type: FieldType.Checkbox)
];

/// We are going to send the results here
void resultsCallback(Map<String, String> results) => showDialog(
    context: kScaffoldKey.currentContext,
    builder: (context) => Padding(
          padding: const EdgeInsets.all(64.0),
          child: Card(child: Text(results.keys.fold("", (previousValue, element) => "$previousValue$element = ${results[element]}\n"))),
        ));
