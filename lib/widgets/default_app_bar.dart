import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/profile_button.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool withProfileButton;
  final bool canPop;

  const PrimaryAppBar({
    super.key,
    required this.title,
    this.withProfileButton = true,
    this.canPop = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = Brand.isCej() ? Colors.black : AppColors.grey100;
    return AppBar(
      toolbarHeight: toolBarHeight,
      leading: canPop ? BackButton(color: iconColor) : null,
      scrolledUnderElevation: 0,
      backgroundColor: Brand.isCej() ? AppColors.grey100 : AppColors.primary,
      title: Semantics(
        header: true,
        child: Text(
          title,
          style: TextStyles.primaryAppBar.copyWith(color: Brand.isCej() ? AppColors.primary : AppColors.grey100),
          overflow: TextOverflow.fade,
        ),
      ),
      elevation: 0,
      centerTitle: false,
      actions: [
        if (withProfileButton) ...[ProfileButton(isDarkColor: Brand.isCej()), SizedBox(width: Margins.spacing_base)]
      ],
    );
  }

  static const toolBarHeight = 72.0;

  @override
  Size get preferredSize => Size.fromHeight(toolBarHeight);
}

class SecondaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final Widget? leading;

  const SecondaryAppBar({super.key, required this.title, this.backgroundColor, this.leading});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: toolBarHeight,
      titleSpacing: 0,
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      leading: leading,
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      title: Semantics(
        header: true,
        child: Text(
          title,
          style: TextStyles.secondaryAppBar,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }

  static const toolBarHeight = 64.0;

  @override
  Size get preferredSize => Size.fromHeight(toolBarHeight);
}

class ModeDemoAppBar extends StatelessWidget implements PreferredSizeWidget {
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
