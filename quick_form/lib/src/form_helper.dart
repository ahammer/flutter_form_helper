import 'package:flutter/material.dart';
import '../quick_form.dart';

/// The types of fields we support
enum FieldType {
  /// Text Fields
  text,

  /// Radio Buttons
  radio,

  /// Checkboxes
  checkbox
}

/// Metadata to define a field
class Field {
  /// Build a FieldSpec
  const Field(
      {@required this.name, // Name of this field
      this.validators = const [], // A list of validators
      this.mandatory = false, // Is this field mandatory?
      this.obscureText = false, // Password Field
      this.value = "", // Default Value
      this.group, // Group (for Radio)
      this.type = FieldType.text, // FieldType (text/radio/checkbox)
      this.label // Label to be displayed as hint
      });

  /// The name of this field
  final String name;

  /// The group (for RadioGroups)
  final String group;

  /// The type of the field
  final FieldType type;

  /// The label for this field (name is default)
  final String label;

  /// Is the field Required
  final bool mandatory;

  /// Should this field be masked if possible?
  final bool obscureText;

  /// The value of this field
  final String value;

  /// The Validator for this field
  /// Null if OK
  /// Text if Error
  final List<Validator> validators;
}

/// Specifies a Form
class FormHelper extends ChangeNotifier {
  /// Construct a FormHelper
  factory FormHelper(
          {List<Field> spec,
          FormResultsCallback onChanged,
          FormResultsCallback onSubmitted}) =>
      FormHelper._(
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          controllers: spec.fold(
              <String, TextEditingController>{},
              (p, v) => <String, TextEditingController>{}
                ..addAll(p)
                ..putIfAbsent(v.name, () => TextEditingController())),
          focusNodes: spec.fold(
              <String, FocusNode>{},
              (p, v) => <String, FocusNode>{}
                ..addAll(p)
                ..putIfAbsent(v.name, () => FocusNode())),
          fields: spec);

  /// Private Constructor - Init from Factory
  FormHelper._(
      {@required this.fields,
      @required this.controllers,
      @required this.focusNodes,
      this.onChanged,
      this.onSubmitted,
      this.allowWithErrors = false});

  /// Called when the form is changed
  final FormResultsCallback onChanged;

  /// Called when the form is submitted
  final FormResultsCallback onSubmitted;

  /// Allow callbacks when there is errors present
  /// (missing fields or validation errors)
  final bool allowWithErrors;

  /// All the fields
  final List<Field> fields;

  /// All the controllers
  final Map<String, TextEditingController> controllers;

  /// All the focus nodes
  final Map<String, FocusNode> focusNodes;

  /// All the values
  final Map<String, String> values = {};

  /// A count of validation errors
  int get validationErrors => fields.fold(
      0,
      (sum, field) =>
          compositeValidator(field.validators, this, getValue(field.name)) ==
                  null
              ? sum
              : sum + 1);

  /// A count of how many fields are still required
  int get stillRequired => fields.fold(
      0,
      (sum, field) => field.mandatory
          ? values[field.name]?.isEmpty ?? false ? sum + 1 : sum
          : sum);

  /// Returns auto-generated submission button text
  /// It'll indicate errors with the form
  String get submissionButtonText {
    if (stillRequired > 0) {
      return "$stillRequired fields remaining";
    }

    if (validationErrors > 0) {
      return "$validationErrors field doesn't validate";
    }
    return "Submit Form";
  }

  /// Dispose this form
  @override
  void dispose() {
    this
      ..controllers.forEach((key, value) => value.dispose())
      ..focusNodes.forEach((key, value) => value.dispose());
    super.dispose();
  }

  /// Build the form
  Widget buildForm(BuildContext context,
          {FormUiBuilder builder = scrollableSimpleForm}) =>
      builder(this, context);

  /// Get's the Widget for a name
  /// "submit" is a special case
  Widget getWidget(String name) {
    if (name == "submit") {
      return RaisedButton(
          key: const Key("submit"),
          onPressed: submitForm,
          child: Text(submissionButtonText));
    }

    switch (_getFieldSpec(name).type) {
      case FieldType.text:
        return _TextField._(formHelper: this, name: name);
      case FieldType.radio:
        return _RadioButton(formHelper: this, name: name);
      case FieldType.checkbox:
        return _CheckBox(formHelper: this, name: name);
    }

    return const Text("Uknown Type");
  }

  /// Call this when you want to "Submit" the form
  ///
  /// It'll redirect you to required fields or to fix errors
  /// before submitting
  void submitForm() {
    if (allowWithErrors && onSubmitted != null) {
      onSubmitted(values);
      return;
    }

    if (stillRequired > 0) {
      _focusOnFirstRemaining();
      return;
    }
    if (validationErrors > 0) {
      _focusOnFirstError();
      return;
    }

    if (onSubmitted != null) {
      onSubmitted(values);
    }
    notifyListeners();
  }

  /// Focus on the first remaining mandatory field
  /// Used when user taps "submit" without completing the form
  void _focusOnFirstRemaining() {
    final field = fields.firstWhere(
        (field) => field.mandatory && (getValue(field.name)?.isEmpty ?? true));
    if (field != null) {
      _getFocusNode(field.name).requestFocus();
    }
  }

  /// Focus on the first error in the form
  /// Used when user taps "submit" with errors detected in input
  void _focusOnFirstError() {
    final field = fields.firstWhere((field) =>
        compositeValidator(field.validators, this, getValue(field.name)) !=
        null);
    if (field != null) {
      _getFocusNode(field.name).requestFocus();
    }
  }

  /// Gets a field spec
  Field _getFieldSpec(String name) =>
      fields.firstWhere((element) => element.name == name);

  /// Gets a field spec
  int _getFieldSpecIndex(Field fieldSpec) => fields.indexOf(fieldSpec);

  /// Get a focus node for a named field
  FocusNode _getFocusNode(String name) => focusNodes[name];

  /// Get a text editting controller for a name
  TextEditingController _getTextEditingController(String name) =>
      controllers[name];

  /// Called every time a value is changed
  void onChange(String name, String value) {
    values[name] = value;
    if (onChanged != null) {
      /// Todo allow errors
      if (allowWithErrors || (validationErrors == 0 && stillRequired == 0)) {
        onChanged(values);
      }
    }
    notifyListeners();
  }

  void _onSubmit(String name) {
    final spec = _getFieldSpec(name);
    final idx = _getFieldSpecIndex(spec);
    if (spec.type == FieldType.text) {
      values[name] = _getTextEditingController(name).text;
    }

    if (idx + 1 < fields.length) {
      final nextField = fields[idx + 1];
      _getFocusNode(nextField.name).requestFocus();
    } else {
      _getFocusNode(name).unfocus();
    }
  }

  /// Gets the current value for a field by name
  /// Radio buttons get value by Group name
  /// and default to a value = to the first option listed
  String getValue(String name) {
    final field = _getFieldSpec(name);

    if (field.type == FieldType.radio) {
      if (values.containsKey(field.group)) {
        return values[field.group];
      } else {
        return _getRadioDefaultValue(field.group);
      }
    }

    return values[field.name];
  }

  String _getRadioDefaultValue(String group) =>
      fields.firstWhere((element) => element.group == group).value;

  void _applyRadioValue(String name, String value) =>
      onChange(_getFieldSpec(name).group, value);

  void _toggleCheckbox(String name) {
    if (values.containsKey(name)) {
      values.remove(name);
    } else {
      values[name] = _getFieldSpec(name).value;
    }
    notifyListeners();
  }

  bool _isChecked(String name) => values.containsKey(name);
}

/// Field Bindings for the helper
///
/// When you call getWidget(String name) on FormHelper
/// one of these following widgets will be put in it's place
///
class _TextField extends StatelessWidget {
  /// Construct a text form helper
  const _TextField._({@required this.formHelper, @required this.name, Key key})
      : super(key: key);

  /// The Form Helper
  final FormHelper formHelper;

  /// The name of the field
  final String name;

  @override
  Widget build(BuildContext context) {
    final fieldSpec = formHelper._getFieldSpec(name);
    final label = fieldSpec.label ?? name;

    return TextFormField(
        key: Key(name),
        obscureText: fieldSpec.obscureText,
        onChanged: (value) => formHelper.onChange(name, value),
        onFieldSubmitted: (value) => formHelper._onSubmit(name),
        focusNode: formHelper._getFocusNode(name),
        controller: formHelper._getTextEditingController(name),
        decoration: InputDecoration(
            labelText: fieldSpec.mandatory ? "* $label" : label,
            errorText: compositeValidator(fieldSpec.validators, formHelper,
                formHelper._getTextEditingController(name).text)));
  }
}

class _RadioButton extends StatelessWidget {
  const _RadioButton({Key key, this.formHelper, this.name}) : super(key: key);

  /// The Form Helper
  final FormHelper formHelper;

  /// The name of the field
  final String name;

  @override
  Widget build(BuildContext context) => Radio<String>(
      key: Key(name),
      groupValue: formHelper._getFieldSpec(name).value,
      value: formHelper.getValue(name),
      focusNode: formHelper._getFocusNode(name),
      onChanged: (value) => formHelper._applyRadioValue(
          name, formHelper._getFieldSpec(name).value));
}

class _CheckBox extends StatelessWidget {
  const _CheckBox({Key key, this.formHelper, this.name}) : super(key: key);

  /// The Form Helper
  final FormHelper formHelper;

  /// The name of the field
  final String name;

  @override
  Widget build(BuildContext context) => Checkbox(
      key: Key(name),
      focusNode: formHelper._getFocusNode(name),
      value: formHelper._isChecked(name),
      onChanged: (value) => formHelper._toggleCheckbox(name));
}

/// Extensions on List<String> to help with building the ultimate simple form
extension FormHelperStringListExtension on List<String> {
  /// Build Simple Form. It's got fields, none are required, none are validated
  ///
  /// ["title","name","email"].buildSimpleForm();
  Widget buildSimpleForm(
          {FormUiBuilder uiBuilder = scrollableSimpleForm,
          FormResultsCallback onFormChanged,
          FormResultsCallback onFormSubmitted}) =>
      FormBuilder(
          onFormChanged: onFormChanged,
          onFormSubmitted: onFormSubmitted,
          form: map((string) => Field(name: string)).toList());
}

/// Extensions on List<Field> to help with building the ultimate simple form

extension FormHelperFieldListExtension on List<Field> {
  /// Extension Syntax for building out of a List<Field>
  Widget buildSimpleForm(
          {FormUiBuilder uiBuilder = scrollableSimpleForm,
          FormResultsCallback onFormChanged,
          FormResultsCallback onFormSubmitted}) =>
      FormBuilder(
          uiBuilder: uiBuilder,
          onFormChanged: onFormChanged,
          onFormSubmitted: onFormSubmitted,
          form: this);
}
