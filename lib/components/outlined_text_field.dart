import 'package:flutter/material.dart';

class OutlinedTextFieldForm extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final bool? alignLabelWithHint;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const OutlinedTextFieldForm({
    required this.controller,
    this.labelText,
    this.hintText,
    this.alignLabelWithHint,
    this.minLines,
    this.maxLines,
    this.keyboardType,
    this.validator,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
        hintText: hintText,
        alignLabelWithHint: alignLabelWithHint,
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
