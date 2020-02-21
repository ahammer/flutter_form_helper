import 'package:quick_form/src/validators.dart';
import 'package:flutter_test/flutter_test.dart';

/// Field Validator Tests
///
/// These validators don't need a FormHelper,
/// hence the nulls
///
/// The form helper is used when a Validator needs to access another field
/// these are all basic validations.

void main() {
  test("Test Length Validator", () {
    expect(lengthValidator(null, "Hello"), isNull);
    expect(lengthValidator(null, "He"), isNotNull);
    expect(lengthValidator(null, "Hello", minLength: 10), isNotNull);
    expect(lengthValidator(null, "HelloEllo", minLength: 10), isNotNull);
    expect(lengthValidator(null, "HelloHello", minLength: 10), isNull);
  });

  test("Space Count Validator Test", () {
    expect(spaceCountValidator(null, "hello"), isNull);
    expect(spaceCountValidator(null, "hello world"), isNotNull);
    expect(spaceCountValidator(null, "hello world", count: 1), isNull);
  });

  test("Test Email Validator", () {
    expect(emailValidator(null, "not-a-email"), isNotNull);
    expect(emailValidator(null, "is@email.com"), isNull);
  });

  test("Test Url Validator", () {
    expect(urlValidator(null, "not-a-url"), isNotNull);
    expect(urlValidator(null, "http://www.google.com"), isNull);
    expect(urlValidator(null, "https://www.google.com"), isNull);
  });

  test("Test Double Validator", () {
    expect(doubleValidator(null, "hello"), isNotNull);
    expect(doubleValidator(null, "24.5"), isNull);
    expect(doubleValidator(null, "-22"), isNull);
  });

  test("Test Int Validator", () {
    expect(intValidator(null, "not-a-int"), isNotNull);
    expect(intValidator(null, "24"), isNull);
    expect(intValidator(null, "24.232"), isNotNull);
  });
}
