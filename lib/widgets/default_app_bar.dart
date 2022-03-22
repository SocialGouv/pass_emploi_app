import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class DefaultAppBar extends AppBar {
  DefaultAppBar({Widget? title, List<Widget>? actions, bool? centerTitle})
      : super(
          title: title,
          actions: actions,
          centerTitle: centerTitle,
          iconTheme: IconThemeData(color: AppColors.contentColor),
          toolbarHeight: Dimens.appBarHeight,
          backgroundColor: Colors.transparent,
          elevation: 2,
        );
}

class FlatDefaultAppBar extends AppBar {
  FlatDefaultAppBar({
    Widget? title,
    Widget? leading,
    PreferredSizeWidget? bottom,
    List<Widget>? actions,
    bool? centerTitle = true,
    Color? backgroundColor,
  }) : super(
          title: title,
          centerTitle: centerTitle,
          actions: actions,
          iconTheme: IconThemeData(color: AppColors.contentColor),
          toolbarHeight: Dimens.flatAppBarHeight,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: leading,
          bottom: bottom,
        );
}

FlatDefaultAppBar passEmploiAppBar({required String label, bool withBackButton = false}) {
  return FlatDefaultAppBar(
    title: Text(label, style: TextStyles.textAppBar),
    leading: withBackButton ? _appBarLeading : null,
  );
}

Widget _appBarLeading = Builder(
  builder: (BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        Drawables.icChevronLeft,
        color: AppColors.contentColor,
        height: Margins.spacing_xl,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  },
);
