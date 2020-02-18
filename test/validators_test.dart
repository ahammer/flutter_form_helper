import 'package:flutter_form_helper/src/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Test Length Validator", (){
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
}