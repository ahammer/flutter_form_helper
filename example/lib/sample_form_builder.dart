import 'package:flutter/material.dart';
import 'package:flutter_form_helper/form_helper.dart';

Widget customForm(FormHelper helper) => Column(
      children: <Widget>[
        Expanded(
          child: Card(
            elevation: 0.25,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [ Text("Form goes here")]),
              ),
            ),
          ),
        ),
        helper.getWidget("submit")
      ],
    );
