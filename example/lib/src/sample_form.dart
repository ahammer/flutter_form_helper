import 'package:flutter_form_helper/form_helper.dart';

/// This is the Sample Form used on the main() page
const sampleForm = <FieldSpec>[
  FieldSpec(
      name: "name", 
      label: "Name",
      mandatory: true, 
      validators: [lengthValidator]),

  FieldSpec(
      name: "title",
      label: "Title", 
      mandatory: false),

  FieldSpec(
      name: "password", 
      label: "Password", 
      mandatory: false,
      obscureText: true
      ),

      
  FieldSpec(
      name: "repeat_password", 
      label: "Repeat Password", 
      mandatory: false,
      obscureText: true
      ),

  FieldSpec(
      name: "email", 
      label: "Email", 
      mandatory: false, 
      validators:[emailValidator]),

  FieldSpec(
      name: "url", 
      label: "Url", 
      mandatory: false, 
      validators: [urlValidator]),

  FieldSpec(
    name: "age", 
    label: "Age", 
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

