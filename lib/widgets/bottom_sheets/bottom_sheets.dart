import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

Future<T?> showPassEmploiBottomSheet<T>({required BuildContext context, required WidgetBuilder builder}) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    isScrollControlled: true,
    builder: builder,
  );
}

Padding userActionBottomSheetHeader(BuildContext context, {required String title}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 22),
    child: Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: TextStyles.textBaseBold),
        ),
        Positioned(
          right: 8,
          child: IconButton(
            padding: const EdgeInsets.all(0),
            iconSize: Dimens.icon_size_m,
            onPressed: () => Navigator.pop(context),
            tooltip: Strings.close,
            icon: Icon(
              AppIcons.close_rounded,
              color: AppColors.contentColor,
            ),
          ),
        ),
      ],
    ),
  );
}

EdgeInsets bottomSheetContentPadding() {
  return const EdgeInsets.symmetric(horizontal: Margins.spacing_base, vertical: Margins.spacing_m);
}
