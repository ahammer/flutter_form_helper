import 'package:flutter/widgets.dart';

import '../form_helper.dart';

/// Form UI Builder
/// 
/// Define functions like this to build a form and access the FormHelper
/// to get the widgets
typedef FormUiBuilder = Widget Function(
    FormHelper helper, 
    BuildContext context);

/// Form Results Callback
///
/// This function is used to return the results of the form to the callbacks
typedef FormResultsCallback = Function(Map<String, String> results);

///
/// This is a Validator.
///
/// The General philosphy is as follows
/// - helper gives access to all fields in form
/// - input is the current fields value
/// - return a String with an error when failing validation
/// - return defaultOutput on validation pass (null if not provided).
///
/// We pass the output through so the validators can fold them together
/// to an output.
///
/// e.g. permitBlank can clear a length validation error put before it
/// so a field can be blank, but require X characters if you do type.
typedef Validator = String Function(FormHelper helper, String input,
    {String defaultOutput});
