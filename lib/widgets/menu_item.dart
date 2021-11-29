import 'package:flutter/material.dart';

import 'default_menu_item.dart';

class MenuItem extends BottomNavigationBarItem {
  final String drawableRes;
  final String label;
  final bool withBadge;

  MenuItem({required this.drawableRes, required this.label, this.withBadge = false})
      : super(
          icon: DefaultMenuItem(drawableRes: drawableRes, label: label, isActive: false, withBadge: withBadge),
          activeIcon: DefaultMenuItem(drawableRes: drawableRes, label: label, isActive: true, withBadge: false),
          label: label,
        );
}
