import 'package:flutter/material.dart';
import 'package:flutter_form_helper/form_helper.dart';

/// This is a Custom Form function for SampleForm
///
/// For each field, we use helper.getField(name) to inject the fields in
/// the righ places in the UI
///
Widget customFormBuilder(FormHelper helper, BuildContext context) => Column(
      children: <Widget>[
        Expanded(
          child: Card(
            elevation: 0.25,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  Row(
                    children: <Widget>[
                      Expanded(flex: 3, child: helper.getWidget("name")),
                      Container(width: 16),
                      Expanded(flex: 3, child: helper.getWidget("title")),
                      Container(width: 16),
                      Expanded(child: helper.getWidget("age"))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(child: helper.getWidget("password")),
                      Container(width: 16),
                      Expanded(child: helper.getWidget("repeat_password"))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(child: helper.getWidget("email")),
                      Container(width: 16),
                      Expanded(child: helper.getWidget("url"))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child: Container(
                      width: 320,
                      child: Card(
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text("Gender",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: const <Widget>[
                                    Expanded(
                                        child: Text(
                                      "Male",
                                      textAlign: TextAlign.center,
                                    )),
                                    Expanded(
                                        child: Text(
                                      "Female",
                                      textAlign: TextAlign.center,
                                    )),
                                    Expanded(
                                        child: Text(
                                      "Unspecified",
                                      textAlign: TextAlign.center,
                                    )),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Expanded(child: helper.getWidget("radio1")),
                                    Expanded(child: helper.getWidget("radio2")),
                                    Expanded(child: helper.getWidget("radio3")),
                                  ],
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      const Text("Accept Terms"),
                      helper.getWidget("checkbox")
                    ],
                  )
                ]),
              ),
            ),
          ),
        ),
        helper.getWidget("submit")
      ],
    );
