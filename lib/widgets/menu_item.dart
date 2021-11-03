import 'package:flutter/material.dart';
import 'package:pass_emploi_app/widgets/selected_menu_item.dart';
import 'package:pass_emploi_app/widgets/unselected_menu_item.dart';

class MenuItem extends BottomNavigationBarItem {
  final String drawableRes;
  final String label;

  MenuItem({required this.drawableRes, required this.label})
      : super(
          icon: UnselectedMenuItem(drawableRes: drawableRes, label: label),
          activeIcon: SelectedMenuItem(drawableRes: drawableRes, label: label),
          label: label,
        );
}
