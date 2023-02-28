import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/profile_button.dart';

class PrimaryAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final bool withProfileButton;

  const PrimaryAppBar({super.key, required this.title, this.backgroundColor, this.withProfileButton = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: toolBarHeight,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        title,
        style: TextStyles.primaryAppBar,
        overflow: TextOverflow.fade,
      ),
      elevation: 0,
      centerTitle: false,
      actions: [
        if (withProfileButton) ...[ProfileButton(), SizedBox(width: Margins.spacing_base)]
      ],
    );
  }

  static const toolBarHeight = 72.0;

  @override
  Size get preferredSize => Size.fromHeight(toolBarHeight);
}

class SecondaryAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;

  const SecondaryAppBar({super.key, required this.title, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: toolBarHeight,
      titleSpacing: 0,
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        title,
        style: TextStyles.secondaryAppBar,
        overflow: TextOverflow.fade,
      ),
    );
  }

  static const toolBarHeight = 64.0;

  @override
  Size get preferredSize => Size.fromHeight(toolBarHeight);
}

class ModeDemoAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.warningLighten,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: Margins.spacing_base, horizontal: Margins.spacing_m),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              AppIcons.info_rounded,
              color: AppColors.warning,
            ),
            SizedBox(width: Margins.spacing_base),
            Expanded(
              child: Text(
                Strings.modeDemoAppBarLabel,
                style: TextStyles.textBaseBoldWithColor(AppColors.warning),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
