import 'package:flutter/widgets.dart';

import '../form_helper.dart';




typedef FormUiBuilder = Widget Function(FormHelper helper);
typedef FormResultsCallback = Function(Map<String, String> results);
