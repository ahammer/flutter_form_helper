import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_helper/form_helper.dart';
import 'sample_form.dart';

/// A key to the Scaffold Root
/// Allows me to wire up dialogs easily
final GlobalKey _scaffoldKey = GlobalKey();

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(FormTestApp());
}

/// This is the demo app for the Flutter Form Widget
class FormTestApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _FormTestAppState createState() => _FormTestAppState();
}

class _FormTestAppState extends State<FormTestApp>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Form Demo',
        home: Scaffold(
            key: _scaffoldKey,
            body: SafeArea(
                child: Column(
              children: <Widget>[
                TabBar(
                  labelColor: Theme.of(context).colorScheme.primary,
                  controller: controller,
                  tabs: const <Widget>[
                    Tab(text: "Simple"),
                    Tab(text: "Custom")
                  ],
                ),
                Expanded(
                    child: FormBuilder(
                        form: sampleForm, onFormSubmitted: resultsCallback)),
              ],
            ))),
      );
}

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
