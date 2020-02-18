import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'form_helper.dart';

/// A key to the Scaffold Root
/// Allows me to wire up dialogs easily
final GlobalKey _scaffoldKey = GlobalKey();

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
            key: _scaffoldKey,
            body: const SafeArea(
                child: FormBuilder(
                    form: testFormFields, onFormSubmitted: resultsCallback))),
      );
}

/// This is the Sample Form used on the main() page
const testFormFields = <FieldSpec>[
  FieldSpec(
      name: "Name", 
      mandatory: true, 
      validators: [lengthValidator]),

  FieldSpec(
      name: "Title", 
      mandatory: false),

  FieldSpec(
      name: "Email", 
      mandatory: false, 
      validators:[emailValidator]),

  FieldSpec(
      name: "Url", 
      mandatory: false, 
      validators: [urlValidator]),

  FieldSpec(
    name: "Age", 
    mandatory: true, 
    validators: [intValidator]),

  FieldSpec(
      name: "radio1",
      group: "Pronoun",
      value: "He",
      type: FieldType.radio),

  FieldSpec(
      name: "radio2",
      group: "Pronoun",
      value: "She",
      type: FieldType.radio),

  FieldSpec(
      name: "radio3",
      group: "Pronoun",
      value: "Unspecified",
      type: FieldType.radio),
            
  FieldSpec(
    name: "checkbox", 
    value: "checked", 
    type: FieldType.checkbox)
];

/// We are going to send the results here
void resultsCallback(Map<String, String> results) => showDialog<void>(
    context: _scaffoldKey.currentContext,
    builder: (context) => Padding(
          padding: const EdgeInsets.all(64),
          child: Card(
              child: Text(results.keys.fold(
                  "",
                  (previousValue, element) =>
                      "$previousValue$element = ${results[element]}\n"))),
        ));
