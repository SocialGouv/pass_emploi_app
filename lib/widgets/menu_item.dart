import 'package:flutter/material.dart';
import 'package:pass_emploi_app/widgets/default_menu_item.dart';

class MenuItem extends BottomNavigationBarItem {
  final IconData defaultIcon;
  final IconData inactiveIcon;
  final bool withBadge;

  MenuItem({
    required this.defaultIcon,
    required this.inactiveIcon,
    required String label,
    this.withBadge = false,
    Widget Function(Widget child)? iconWrapper,
  }) : super(
          icon: iconWrapper != null
              ? iconWrapper(DefaultMenuItem(
                  icon: inactiveIcon,
                  label: label,
                  isActive: false,
                  withBadge: withBadge,
                ))
              : DefaultMenuItem(
                  icon: inactiveIcon,
                  label: label,
                  isActive: false,
                  withBadge: withBadge,
                ),
          activeIcon: iconWrapper != null
              ? iconWrapper(DefaultMenuItem(
                  icon: defaultIcon,
                  label: label,
                  isActive: true,
                  withBadge: false,
                ))
              : DefaultMenuItem(
                  icon: defaultIcon,
                  label: label,
                  isActive: true,
                  withBadge: false,
                ),
          label: label,
          tooltip: label,
        );
}
