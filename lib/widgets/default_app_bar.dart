import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/profile_button.dart';

class SecondaryAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  const SecondaryAppBar({super.key, required this.title, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      elevation: 0,
      centerTitle: false,
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        title,
        style: TextStyles.secondaryAppBar,
        overflow: TextOverflow.fade,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(64.0);
}

class ModeDemoAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      elevation: 0,
      backgroundColor: AppColors.warningLighten,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: Margins.spacing_base, horizontal: Margins.spacing_m),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SvgPicture.asset(
              Drawables.icInfo,
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

class PrimaryAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final bool withProfileButton;
  const PrimaryAppBar({super.key, required this.title, this.backgroundColor, this.withProfileButton = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        title,
        style: TextStyles.primaryAppBar,
        overflow: TextOverflow.fade,
      ),
      elevation: 0,
      centerTitle: false,
      actions: [if (withProfileButton) ProfileButton()],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(72.0);
}
