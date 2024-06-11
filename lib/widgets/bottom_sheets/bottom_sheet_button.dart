import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class BottomSheetButton extends StatelessWidget {
  const BottomSheetButton({
    required this.icon,
    required this.text,
    required this.onPressed,
    this.withNavigationSuffix = false,
    this.color,
  });
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final bool withNavigationSuffix;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyles.textBaseBold.copyWith(color: color)),
      trailing: withNavigationSuffix ? Icon(AppIcons.chevron_right_rounded) : null,
      onTap: onPressed,
    );
  }
}
