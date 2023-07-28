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

class BottomSheetHeader extends StatelessWidget implements PreferredSizeWidget {
  const BottomSheetHeader({super.key, required this.title, this.padding});
  final String title;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Padding(
        padding: padding ?? EdgeInsets.symmetric(vertical: Margins.spacing_base),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Text(title, style: TextStyles.textBaseBold),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: IconButton(
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
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class BottomSheetWrapper extends StatelessWidget {
  const BottomSheetWrapper({super.key, required this.title, required this.body, this.heightFactor = 0.9});
  final double heightFactor;
  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: heightFactor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.radius_l),
        child: Scaffold(
          appBar: BottomSheetHeader(title: title),
          body: Padding(
            padding:
                EdgeInsets.only(left: Margins.spacing_base, right: Margins.spacing_base, bottom: Margins.spacing_base),
            child: body,
          ),
        ),
      ),
    );
  }
}
