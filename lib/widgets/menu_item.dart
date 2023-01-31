import 'package:flutter/material.dart';
import 'package:pass_emploi_app/widgets/default_menu_item.dart';

class MenuItem extends BottomNavigationBarItem {
  final String drawableRes;
  final String inactiveDrawableRes;
  final bool withBadge;

  MenuItem({
    required this.drawableRes,
    required this.inactiveDrawableRes,
    required String label,
    this.withBadge = false,
  }) : super(
          icon: DefaultMenuItem(drawableRes: inactiveDrawableRes, label: label, isActive: false, withBadge: withBadge),
          activeIcon: DefaultMenuItem(drawableRes: drawableRes, label: label, isActive: true, withBadge: false),
          label: label,
        );
}
