typedef validator = String Function(String input, {String defaultOutput});

///
/// Validators
///
/// These are used to validate the input as it's typed and show error messages
///
/// When it's OK, you should pass through the "defaultOutput" as that may
/// be another error

///
/// Composes a list of validators
///
/// They'll apply in order, only one will pass it's output through
String compositeValidator(List<validator> validators, String input) =>
    input != null && input.isNotEmpty
        ? validators.fold(null, (output, v) => v(input, defaultOutput: output))
        : null;

/// Validate a form is a certain length
///
String lengthValidator(String input,
        {int minLength = 3, int maxLength = 100000, String defaultOutput}) =>
    input == null || (input.length < minLength || input.length > maxLength)
        ? "$minLength Characters or more Required"
        : defaultOutput;

/// Does not like when no spaces are available
String spaceCountValidator(String input,
        {String defaultOutput,
        int count = 0,
        String message = "No Spaces Allowed"}) =>
    input != null && " ".allMatches(input).length == count
        ? message
        : defaultOutput;

/// Validates an email
String emailValidator(String input, {String defaultOutput}) =>
    input == null || !_emailPattern.hasMatch(input)
        ? "Please enter a email"
        : defaultOutput;

/// Validates an email
String urlValidator(String input, {String defaultOutput}) =>
    input == null || !_urlPattern.hasMatch(input)
        ? "Please enter a URL"
        : defaultOutput;

/// Validates that the value parses to double
String doubleValidator(String input, {String defaultOutput}) {
  try {
    double.parse(input);
  } on Exception {
    return "Enter a valid number";
  }
  return defaultOutput;
}

/// Validates that the value parses to an int
String intValidator(String input, {String defaultOutput}) {
  try {
    double.parse(input);
  } on Exception {
    return "Enter a valid integer";
  }
  return defaultOutput;
}

final _urlPattern =
    RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
final _emailPattern = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
