import 'package:flutter/material.dart';
import '../form_helper.dart';

/// Builds a form
///
///
/// By default you can just provide it a form spec
/// It'll wire it all up for you
///
/// Optionally you can provide uiBuilder to build a specific form UI
///
class FormBuilder extends StatefulWidget {
  /// Construct a form
  ///
  /// form = List of fields
  /// uiBuilder = builds the ui
  const FormBuilder(
      {@required this.form, Key key, this.uiBuilder = scrollableSimpleForm})
      : super(key: key);

  /// The list of fields in order of focus/drawing
  final List<FieldSpec> form;

  /// A builder for the UI, scrollable SimpleForm to start
  final FormUiBuilder uiBuilder;

  @override
  _FormBuilderState createState() => _FormBuilderState();
}

class _FormBuilderState extends State<FormBuilder> {
  FormHelper helper;

  @override
  void initState() {
    helper = FormHelper(widget.form)..addListener(_refresh);
    super.initState();
  }

  @override
  void dispose() {
    helper
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) =>
      helper.buildForm(builder: widget.uiBuilder);
}

/// A builder for a default, simple, scrollable form
Widget scrollableSimpleForm(FormHelper helper, Map<String, Widget> widgets) =>
    Column(
      children: <Widget>[
        Expanded(
          child: Card(
            elevation: 0.25,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: helper.fields.map((f) {
                      if (f.type != FieldType.Text) {
                        return Row(children: <Widget>[Text(f.value), widgets[f.name]]);
                      } else {
                        return widgets[f.name];
                      }
                    }).toList()),
              ),
            ),
          ),
        ),
        RaisedButton(
            child: Text(helper.submissionButtonText),
            onPressed: helper.onFormSubmit),
      ],
    );
