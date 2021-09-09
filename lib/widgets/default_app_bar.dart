import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';

class DefaultAppBar extends AppBar {
  DefaultAppBar({Widget? title, List<Widget>? actions})
      : super(
          title: title,
          actions: actions,
          iconTheme: IconThemeData(color: AppColors.nightBlue),
          toolbarHeight: Dimens.appBarHeight,
          backgroundColor: Colors.white,
          elevation: 2,
        );
}
