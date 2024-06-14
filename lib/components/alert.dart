import 'package:flutter/material.dart';

enum AlertTypes {
  error,
  warning,
  info,
  success,
}

const Map<AlertTypes, Color> _alertColorMap = {
  AlertTypes.error: Colors.red,
  AlertTypes.warning: Colors.orange,
  AlertTypes.info: Colors.blue,
  AlertTypes.success: Colors.green,
};

const Map<AlertTypes, IconData> _alertIconMap = {
  AlertTypes.error: Icons.error,
  AlertTypes.warning: Icons.warning,
  AlertTypes.info: Icons.info,
  AlertTypes.success: Icons.check_circle,
};

SnackBar alertSnackBar(BuildContext context, String description, AlertTypes type) {
  final theme = Theme.of(context);
  final style = theme.textTheme.bodyMedium!.copyWith(color: Colors.white);
  final Color alertColor = _alertColorMap[type]!;
  final IconData alertIcon = _alertIconMap[type]!;

  return SnackBar(
    behavior: SnackBarBehavior.floating,
    width: 600,
    backgroundColor: alertColor,
    content: Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(alertIcon, color: Colors.white),
        ),
        Text(description, style: style),
      ],
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4.0),
    ),
  );
}
