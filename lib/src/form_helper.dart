import 'package:flutter/material.dart';
import '../form_helper.dart';

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
class FieldSpec {
  /// Build a FieldSpec
  const FieldSpec(
      {@required this.name,
      this.validators = const [],
      this.mandatory = false,
      this.value = "",
      this.group,
      this.type = FieldType.text,
      this.label});

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

  /// The value of this field
  final String value;

  /// The Validator for this field
  /// Null if OK
  /// Text if Error
  final List<validator> validators;
}

/// Specifies a Form
class FormHelper extends ChangeNotifier {
  /// Construct a FormHelper
  factory FormHelper(
          {List<FieldSpec> spec,
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
  final List<FieldSpec> fields;

  /// All the controllers
  final Map<String, TextEditingController> controllers;

  /// All the focus nodes
  final Map<String, FocusNode> focusNodes;

  /// All the values
  final Map<String, String> values = {};

  /// Gets a field spec
  FieldSpec _getFieldSpec(String name) =>
      fields.firstWhere((element) => element.name == name);

  /// Gets a field spec
  int _getFieldSpecIndex(FieldSpec fieldSpec) => fields.indexOf(fieldSpec);

  /// Get a focus node for a named field
  FocusNode _getFocusNode(String name) => focusNodes[name];

  /// Get a text editting controller for a name
  TextEditingController _getTextEditingController(String name) =>
      controllers[name];

  /// A count of validation errors
  int get validationErrors => fields.fold(
      0,
      (sum, field) =>
          compositeValidator(field.validators, _getValue(field.name)) == null
              ? sum
              : sum + 1);

  /// A count of how many fields are still required
  int get stillRequired => fields.fold(
      0,
      (sum, field) => field.mandatory
          ? _getTextEditingController(field.name).text.isEmpty ? sum + 1 : sum
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

  /// Focus on the first remaining mandatory field
  /// Used when user taps "submit" without completing the form
  void _focusOnFirstRemaining() {
    final field = fields.firstWhere(
        (field) => field.mandatory && _getValue(field.name).isEmpty);
    if (field != null) {
      _getFocusNode(field.name).requestFocus();
    }
  }

  /// Focus on the first error in the form
  /// Used when user taps "submit" with errors detected in input
  void _focusOnFirstError() {
    final field = fields.firstWhere((field) =>
        compositeValidator(field.validators, _getValue(field.name)) != null);
    if (field != null) {
      _getFocusNode(field.name).requestFocus();
    }
  }

  /// Dispose this form
  @override
  void dispose() {
    this
      ..controllers.forEach((key, value) => value.dispose())
      ..focusNodes.forEach((key, value) => value.dispose());
    super.dispose();
  }

  /// Called every time a value is changed
  void _onChange(String name, String value) {
    values[name] = value;
    if (onChanged != null) {
      /// Todo allow errors
      onChanged(values);
    }
    notifyListeners();
  }

  /// Build the form
  Widget buildForm({FormUiBuilder builder = scrollableSimpleForm}) =>
      builder(this);

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

  /// Call this when you want to "Submit" the form
  ///
  /// It'll redirect you to required fields or to fix errors
  /// before submitting
  void submitForm() {
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

  /// Gets the current value for a field
  /// Maybe not needed anymore
  String _getValue(String name) {
    final field = _getFieldSpec(name);
    switch (field.type) {
      case FieldType.text:
        return _getTextEditingController(name).text;
      case FieldType.radio:
        if (!values.containsKey(field.group)) {
          return _getRadioDefaultValue(field.group);
        }
        return values[field.group];
      case FieldType.checkbox:
        return "";
    }
    return "";
  }

  String _getRadioDefaultValue(String group) =>
      fields.firstWhere((element) => element.group == group).value;

  void _applyRadioValue(String name, String value) =>
      _onChange(_getFieldSpec(name).group, value);

  void _toggleCheckbox(String name) {
    if (values.containsKey(name)) {
      values.remove(name);
    } else {
      values[name] = _getFieldSpec(name).value;
    }
    notifyListeners();
  }

  bool _isChecked(String name) => values.containsKey(name);

  /// Get's the Widget for a name
  /// "submit" is a special case
  Widget getWidget(String name) {
    if (name == "submit") {
      return RaisedButton(
          onPressed: submitForm, child: Text(submissionButtonText));
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
        onChanged: (value) => formHelper._onChange(name, value),
        onFieldSubmitted: (value) => formHelper._onSubmit(name),
        focusNode: formHelper._getFocusNode(name),
        controller: formHelper._getTextEditingController(name),
        decoration: InputDecoration(
            labelText: fieldSpec.mandatory ? "* $label" : label,
            errorText: compositeValidator(fieldSpec.validators,
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
      groupValue: formHelper._getFieldSpec(name).value,
      value: formHelper._getValue(name),
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
      focusNode: formHelper._getFocusNode(name),
      value: formHelper._isChecked(name),
      onChanged: (value) => formHelper._toggleCheckbox(name));
}
