import 'package:flutter/material.dart';
import 'package:link/components/outlined_text_button.dart';
import 'package:link/components/outlined_text_field.dart';
import 'package:link/components/rectangle_elevated_button.dart';

class MaterialDataGridHeader extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(String)? onSearchChanged;
  final String? searchLabelText;
  final String? searchHintText;
  final String firstButtonText;
  final String secondButtonText;
  final void Function() onPressFirst;
  final void Function() onPressSecond;

  const MaterialDataGridHeader({
    required this.searchController,
    required this.onPressFirst,
    required this.onPressSecond,
    this.searchLabelText = 'Search',
    this.searchHintText,
    this.onSearchChanged,
    this.firstButtonText = 'DELETE',
    this.secondButtonText = 'Add',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 300,
          height: 55,
          child: OutlinedTextFieldForm(
            controller: searchController,
            labelText: searchLabelText,
            hintText: searchHintText,
            maxLines: 1,
            onChanged: onSearchChanged,
          ),
        ),
        const Expanded(child: SizedBox()),
        OutlinedTextButton(
          text: firstButtonText,
          color: Colors.red,
          onPressed: onPressFirst,
        ),
        const SizedBox(width: 16.0),
        RectangleElevatedButton(
          text: secondButtonText,
          onPressed: onPressSecond,
        ),
      ],
    );
  }
}
