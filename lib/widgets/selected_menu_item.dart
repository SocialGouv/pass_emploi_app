import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/widgets/unselected_menu_item.dart';

class SelectedMenuItem extends StatelessWidget {
  final String drawableRes;
  final String label;

  const SelectedMenuItem({required this.drawableRes, required this.label}) : super();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        UnselectedMenuItem(drawableRes: drawableRes, label: label),
        Positioned(
          bottom: -6,
          child: Center(child: SvgPicture.asset(Drawables.icMenuSelectedBullet)),
        ),
      ],
    );
  }
}
