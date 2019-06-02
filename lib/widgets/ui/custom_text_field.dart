import 'package:flash_it/widgets/helper/ensure-visible.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final FocusNode focusNode;
  final String initialValue, fieldHint, formKey;
  final int maxLength;
  final FocusNode nextFocusNode;
  final Map<String, dynamic> formData;
  final bool obscureText;

  CustomTextField({
    this.obscureText = false,
    this.focusNode,
    this.maxLength,
    this.initialValue,
    this.nextFocusNode,
    this.fieldHint,
    this.formData,
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: EnsureVisibleWhenFocused(
        focusNode: focusNode,
        child: TextFormField(
          obscureText: obscureText,
          cursorColor: Theme.of(context).primaryColor,
          focusNode: focusNode,
          autofocus: false,
          decoration: _buildInputDecorations(context),
          initialValue: initialValue,
          validator: _validate,
          onSaved: _onSaved,
          maxLength: maxLength,
          maxLengthEnforced: true,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.sentences,
          autocorrect: true,
          textInputAction: getTextInputAction(),
          maxLines: null,
          onFieldSubmitted: (String value) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          },
          style: Theme.of(context).textTheme.subhead,
        ),
      ),
    );
  }

  TextInputAction getTextInputAction() =>
      nextFocusNode == null ? TextInputAction.done : TextInputAction.next;

  String _validate(String value) {
    if (value.contains("'")) return "Can not contain ' character";
  }

  _onSaved(String value) {
    formData[formKey] = value.length > 0 ? value : null;
  }

  InputDecoration _buildInputDecorations(BuildContext context) {
    return InputDecoration(
      labelText: formKey[0].toUpperCase() + formKey.substring(1),
      labelStyle: Theme.of(context).textTheme.subhead.copyWith(
            color: Theme.of(context).primaryColor,
          ),
      helperText: fieldHint,
      alignLabelWithHint: true,
    );
  }
}
