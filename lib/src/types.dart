import 'package:flutter/widgets.dart';

import '../form_helper.dart';

typedef FormUiBuilder = Widget Function(
    FormHelper helper, BuildContext context);
typedef FormResultsCallback = Function(Map<String, String> results);
