import 'package:flutter/material.dart';
import 'package:quick_form/form_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Basic Form Helper Test", () {
    Map<String, String> results;
    FormHelper(
        spec: [const Field(name: "test")], onSubmitted: (map) => results = map)
      ..onChange("test", "value")
      ..submitForm();

    expect(results, isNotNull);
    expect(results["test"], equals("value"));
  });

  test("Basic Form Helper Test with LengthValidator", () {
    /// Test Validation Fail
    Map<String, String> results;
    FormHelper(spec: [
      const Field(name: "test", validators: [lengthValidator])
    ], onSubmitted: (map) => results = map)
      ..onChange("test", "va")
      ..submitForm();

    expect(results, isNull);

    /// Test validation Pass
    FormHelper(spec: [
      const Field(name: "test", validators: [lengthValidator])
    ], onSubmitted: (map) => results = map)
      ..onChange("test", "value")
      ..submitForm();

    //Try again with a correct length, expect callback to work
    expect(results, isNotNull);
    expect(results["test"], equals("value"));
  });

  testWidgets("Integration Test of the Flutter Form", (tester) async {
    Map<String, String> onChangedMap, onSubmittedMap;
    await tester.pumpWidget(
      MaterialApp(
        home: FormBuilder(
          form: sampleForm,
          onFormChanged: (map) => onChangedMap = map,
          onFormSubmitted: (map) => onSubmittedMap = map,
        ),
      ),
    );

    expect(find.text("Title"), findsOneWidget);
    expect(find.text("Url"), findsOneWidget);
    expect(find.byKey(const ValueKey("age")), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey("title")), "Test Title");
    await tester.enterText(find.byKey(const ValueKey("age")), "34");
    await tester.tap(find.byKey(const ValueKey("submit")));

    expect(onSubmittedMap["age"], equals("34"));

    
  });
}

/// This is the Sample Form used on the main() page
const sampleForm = <Field>[
  Field(
      name: "name",
      label: "Name",
      mandatory: true,
      validators: [lengthValidator]),
  Field(name: "title", label: "Title", mandatory: false),
  Field(
      name: "email",
      label: "Email",
      mandatory: false,
      validators: [emailValidator]),
  Field(
      name: "url", label: "Url", mandatory: false, validators: [urlValidator]),
  Field(name: "age", label: "Age", mandatory: true, validators: [intValidator]),
  Field(name: "radio1", group: "Pronoun", value: "He", type: FieldType.radio),
  Field(name: "radio2", group: "Pronoun", value: "She", type: FieldType.radio),
  Field(
      name: "radio3",
      group: "Pronoun",
      value: "Unspecified",
      type: FieldType.radio),
  Field(name: "checkbox", value: "checked", type: FieldType.checkbox)
];
