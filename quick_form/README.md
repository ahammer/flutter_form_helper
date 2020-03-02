# Flutter Form Helper
Creates simple forms very quickly.

The goal was to just define the fields in the form and have it wire up the focus nodes, validation, callbacks and give you a Map with the form data. It's created for basic forms and prototyping use, but I will be using it in my own projects and will add features as I go.


## Example
- Main with 3 Forms and Tabs
- OnChange and OnSubmit wired up

| Basic | Custom | Simple |
| ------ | ------ | ----- |
| ![Basic Form](https://raw.githubusercontent.com/ahammer/flutter_form_helper/master/example/screenshots/1.png) | ![Custom Form](https://raw.githubusercontent.com/ahammer/flutter_form_helper/master/example/screenshots/2.png) | ![Simple Form](https://raw.githubusercontent.com/ahammer/flutter_form_helper/master/example/screenshots/3.png) |


## Reading Results

  Register onFormSubmitted and onFormChanged callbacks that will send a Map<String, String> for you to work with. Required fields and Validations must pass for these callbacks to be triggered. However you can disable validations from FormBuilder if necessary to trigger these methods every time they are pressed.

## Form Spec

The form is defined as a list of <Field> objects. They specify the type and validators used by the field. This list can be fed to FormBuilder to build the form.

Example: https://github.com/ahammer/flutter_form_helper/blob/master/example/lib/src/sample_form.dart

    const Field(
          {@required this.name,         // Name of this field
          this.validators = const [],   // A list of validators
          this.mandatory = false,       // Is this field mandatory?
          this.obscureText = false,     // Password Field
          this.value = "",              // Default Value
          this.group,                   // Group (for Radio)
          this.type = FieldType.text,   // FieldType (text/radio/checkbox)
          this.label                    // Label to be displayed as hint
          });


## Building your form

Extension Syntax
              
                  sampleForm.buildSimpleForm(                      
                      onFormSubmitted: resultsCallback,
                      onFormChanged: (map) => setChangedString(map.toString()),
                      uiBuilder: customFormBuilder),
                      

Widget Syntax

                  FormBuilder(
                      uiBuilder: customFormBuilder
                      form: sampleForm,
                      onFormSubmitted: resultsCallback,
                      onFormChanged: (map) => setChangedString(map.toString())),


Or inline from a list of field names.
     
     ["Name", "Title", "Address"].buildSimpleForm(
                      onFormSubmitted: resultsCallback,
                      onFormChanged: onChanged)

You can provide a UI Builder, or use the Built in one that will just build a form in a scrollable view with a bottom below.

To build a Custom Form layout, provide a UI Builder which can use helper.getWidget(name) to add the widgets where you want and customize the layout however you want. E.g. Use "submit" name to create a submit button. E.g. helper.getWidget("submit")

Example: https://github.com/ahammer/flutter_form_helper/blob/master/example/lib/src/custom_form_builder.dart

