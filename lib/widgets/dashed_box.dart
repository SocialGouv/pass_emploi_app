import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';

class DashedBox extends StatelessWidget {
  final Widget child;

  DashedBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(Dimens.radius_base),
      color: AppColors.grey800,
      dashPattern: [8, 8],
      child: Padding(
        padding: const EdgeInsets.all(Margins.spacing_m),
        child: child,
      ),
    );
  }
}
