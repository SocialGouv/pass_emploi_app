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
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimens.radius_l),
        topRight: Radius.circular(Dimens.radius_l),
      ),
    ),
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: builder(context),
    ),
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
        child: Row(
          children: [
            _CloseButton(),
            if (title != null)
              Expanded(
                child: Text(
                  title!,
                  style: TextStyles.textBaseBold,
                  textAlign: TextAlign.center,
                ),
              ),
            IgnorePointer(
              child: Opacity(
                opacity: 0,
                child: _CloseButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: Dimens.icon_size_m,
      child: OverflowBox(
        // to avoid extra padding
        maxHeight: 40,
        maxWidth: 40,
        child: IconButton(
          iconSize: Dimens.icon_size_m,
          onPressed: () => Navigator.pop(context),
          tooltip: Strings.closeDialog,
          icon: Icon(
            AppIcons.close_rounded,
            color: AppColors.contentColor,
            size: Dimens.icon_size_m,
          ),
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
    this.maxHeightFactor = 0.9,
    this.padding,
    this.hideTitle = false,
  });

  final double maxHeightFactor;
  final String? title;
  final Widget body;
  final EdgeInsets? padding;
  final bool hideTitle;

  @override
  Widget build(BuildContext context) {
    final padding = this.padding ?? EdgeInsets.symmetric(horizontal: Margins.spacing_m);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * maxHeightFactor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.radius_l),
        child: Material(
          color: Colors.white,
          child: Padding(
            padding: padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hideTitle == false) BottomSheetHeader(title: title),
                Flexible(child: body),
                SizedBox(height: Margins.spacing_base),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
