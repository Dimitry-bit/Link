import 'package:flutter/material.dart';

class OutlinedTextButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final Color? color;

  const OutlinedTextButton({
    required this.onPressed,
    required this.text,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textStyle = theme.textTheme.bodyMedium?.copyWith(color: color);

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        side: BorderSide(
          width: 1.0,
          color: color ?? colorScheme.primary,
        ),
      ),
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}
