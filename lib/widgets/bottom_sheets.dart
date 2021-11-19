import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

Future<T?> showUserActionBottomSheet<T>({required BuildContext context, required WidgetBuilder builder}) {
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
        Text(title, style: TextStyles.textMdMedium),
        Positioned(
          right: 8,
          child: IconButton(
            padding: const EdgeInsets.all(0),
            iconSize: 48,
            onPressed: () => Navigator.pop(context),
            tooltip: Strings.close,
            icon: SvgPicture.asset("assets/ic_close.svg"),
          ),
        ),
      ],
    ),
  );
}

Container userActionBottomSheetSeparator() => Container(height: 1, color: AppColors.bluePurpleAlpha20);

EdgeInsets userActionBottomSheetContentPadding() => const EdgeInsets.fromLTRB(16, 24, 16, 24);