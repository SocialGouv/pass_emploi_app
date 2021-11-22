import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';

class DefaultAppBar extends AppBar {
  DefaultAppBar({Widget? title, List<Widget>? actions, bool? centerTitle})
      : super(
          title: title,
          actions: actions,
          centerTitle: centerTitle,
          iconTheme: IconThemeData(color: AppColors.nightBlue),
          toolbarHeight: Dimens.appBarHeight,
          backgroundColor: Colors.white,
          elevation: 2,
        );
}

class FlatDefaultAppBar extends AppBar {
  FlatDefaultAppBar({Widget? title, Widget? leading, List<Widget>? actions, bool? centerTitle})
      : super(
          title: title,
          centerTitle: centerTitle,
          actions: actions,
          iconTheme: IconThemeData(color: AppColors.nightBlue),
          toolbarHeight: Dimens.flatAppBarHeight,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: leading
        );
}