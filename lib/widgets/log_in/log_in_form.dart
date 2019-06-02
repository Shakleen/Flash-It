import 'package:flash_it/widgets/ui/custom_text_field.dart';
import 'package:flutter/material.dart';

class LogInForm extends StatelessWidget {
  final FocusNode userNameFocusNode, passwordFocusNode;
  final Map<String, dynamic> formData;
  final GlobalKey<FormState> formKey;

  LogInForm({
    Key key,
    @required this.userNameFocusNode,
    @required this.passwordFocusNode,
    @required this.formData,
    @required this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 120, left: 20, right: 20),
        height: MediaQuery.of(context).size.height * 0.4,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomTextField(
                formKey: 'username',
                fieldHint: 'Example: abc@gmail.com',
                focusNode: userNameFocusNode,
                formData: formData,
                initialValue: 'abc@gmail.com',
                maxLength: 25,
                nextFocusNode: passwordFocusNode,
              ),
              CustomTextField(
                formKey: 'password',
                fieldHint: '',
                focusNode: passwordFocusNode,
                formData: formData,
                initialValue: 'abcdef',
                maxLength: 50,
                nextFocusNode: null,
                obscureText: true,
              ),
            ],
          ),
        ),
      );
}
