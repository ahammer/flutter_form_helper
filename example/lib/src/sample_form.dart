import 'package:flutter_form_helper/form_helper.dart';

/// This is the Sample Form used on the main() page
const sampleForm = <Field>[
  Field(
      name: "name",
      label: "Name",
      mandatory: true,
      validators: [lengthValidator]),


  Field(
    name: "title", 
    label: "Title", 
    mandatory: false),


  Field(
      name: "password", 
      label: "Password", 
      mandatory: false, 
      obscureText: true),


  Field(
      name: "repeat_password",
      label: "Repeat Password",
      validators: [repeatPasswordValidator],
      mandatory: false,
      obscureText: true),


  Field(
      name: "email",
      label: "Email",
      mandatory: false,
      validators: [emailValidator]),


  Field(
      name: "url", 
      label: "Url", 
      mandatory: false, 
      validators: [urlValidator]),


  Field(
      name: "age", 
      label: "Age", 
      mandatory: true, 
      validators: [intValidator]),


  Field(
      name: "radio1", 
      group: "Pronoun", 
      value: "He", 
      type: FieldType.radio),


  Field(
      name: "radio2", 
      group: "Pronoun", 
      value: "She", 
      type: FieldType.radio),


  Field(
      name: "radio3",
      group: "Pronoun",
      value: "Unspecified",
      type: FieldType.radio),


  Field(
    name: "checkbox", 
    value: "checked", 
    type: FieldType.checkbox)
];

/// Validator for repeat_password
/// Checks to see if it matches "password"
String repeatPasswordValidator(FormHelper helper, String input,
    {String defaultOutput}) {
  final password = helper.getValue("password");
  if (password != input) {
    return "Password do not match";
  } else {
    return defaultOutput;
  }
}
