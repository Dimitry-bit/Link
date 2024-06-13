import 'package:flutter/material.dart';

class SidebarDestination extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool? selected;
  final void Function()? onTap;

  const SidebarDestination({
    required this.label,
    this.selected,
    this.icon,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.bodyMedium;

    return ListTile(
      title: Text(label, style: labelStyle),
      leading: (icon != null) ? Icon(icon) : null,
      selected: selected ?? false,
      onTap: onTap,
    );
  }
}
