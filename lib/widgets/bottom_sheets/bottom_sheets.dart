import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/media_sizes.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

Future<T?> showPassEmploiBottomSheet<T>({required BuildContext context, required WidgetBuilder builder}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimens.radius_l),
        topRight: Radius.circular(Dimens.radius_l),
      ),
    ),
    isScrollControlled: true,
    builder: builder,
  );
}

class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({super.key, this.title, this.padding});

  final String? title;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Container(
        padding: padding ?? EdgeInsets.only(top: Margins.spacing_base),
        color: Colors.white,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            if (title != null) Text(title!, style: TextStyles.textBaseBold),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: SizedBox.square(
                dimension: Dimens.icon_size_m,
                child: OverflowBox(
                  // to avoid extra padding
                  maxHeight: 40,
                  maxWidth: 40,
                  child: IconButton(
                    iconSize: Dimens.icon_size_m,
                    onPressed: () => Navigator.pop(context),
                    tooltip: Strings.close,
                    icon: Icon(
                      AppIcons.close_rounded,
                      color: AppColors.contentColor,
                      size: Dimens.icon_size_m,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSheetWrapper extends StatelessWidget {
  const BottomSheetWrapper({
    super.key,
    this.title,
    required this.body,
    this.heightFactor = 0.9,
    this.padding,
    this.hideTitle = false,
  });

  final double heightFactor;
  final String? title;
  final Widget body;
  final EdgeInsets? padding;
  final bool hideTitle;

  static double smallHeightFactor(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height < MediaSizes.height_xs) return 0.4;
    if (height < MediaSizes.height_m) return 0.35;
    return 0.3;
  }

  @override
  Widget build(BuildContext context) {
    final padding = this.padding ?? EdgeInsets.symmetric(horizontal: Margins.spacing_m);
    return FractionallySizedBox(
      heightFactor: heightFactor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.radius_l),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: padding,
            child: Column(
              children: [
                if (hideTitle == false) BottomSheetHeader(title: title),
                Expanded(child: body),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
