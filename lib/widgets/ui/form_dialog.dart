import 'package:flash_it/widgets/ui/custom_text_field.dart';
import 'package:flutter/material.dart';

class FormDialog extends StatefulWidget {
  final Widget child;
  final Function operation;
  final dynamic existingValue;
  final int parentID, field1, field2;
  final Map<String, dynamic> formData;
  final String title, formKey1, formKey2, fieldHint1, fieldHint2;
  final String primaryKey, foreignKey, buttonText;

  FormDialog({
    Key key,
    @required this.operation,
    @required this.parentID,
    @required this.formData,
    @required this.title,
    @required this.buttonText,
    @required this.formKey1,
    @required this.formKey2,
    @required this.fieldHint1,
    @required this.fieldHint2,
    @required this.field1,
    @required this.field2,
    this.existingValue,
    this.primaryKey,
    this.foreignKey,
    this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode1 = FocusNode(), _focusNode2 = FocusNode();

  @override
  Widget build(BuildContext context) => AlertDialog(
        key: Key('_CardFormDialogState AlertDialog'),
        title: Text(widget.title),
        content: Container(
          key: Key('_CardFormDialogState Container'),
          height: 200,
          child: Form(
            key: _formKey,
            autovalidate: true,
            child: ListView(
              children: <Widget>[
                CustomTextField(
                  formKey: widget.formKey1,
                  fieldHint: widget.fieldHint1,
                  focusNode: _focusNode1,
                  formData: widget.formData,
                  initialValue:
                      widget.existingValue?.getAttribute(widget.field1),
                  maxLength: 25,
                  nextFocusNode: _focusNode2,
                ),
                CustomTextField(
                  formKey: widget.formKey2,
                  fieldHint: widget.fieldHint2,
                  focusNode: _focusNode2,
                  formData: widget.formData,
                  initialValue:
                      widget.existingValue?.getAttribute(widget.field2),
                  maxLength: 50,
                  nextFocusNode: null,
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(child: Text('Cancel'), onPressed: _handleCancel),
          RaisedButton(
            child: Text(
              widget.buttonText,
              style: Theme.of(context).textTheme.body2,
            ),
            onPressed: _handleDone,
            color: Theme.of(context).primaryColor,
          ),
        ],
      );

  void _handleDone() {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();

    if (widget.foreignKey != null)
      widget.formData[widget.foreignKey] = widget.parentID;

    if (widget.existingValue != null && widget.primaryKey != null)
      widget.formData[widget.primaryKey] = widget.existingValue.getAttribute(0);

    if (widget.existingValue != null)
      widget.operation(widget.formData, widget.existingValue.toMap());
    else
      widget.operation(widget.formData);

    Navigator.pop(context);
  }

  void _handleCancel() => Navigator.pop(context);
}
