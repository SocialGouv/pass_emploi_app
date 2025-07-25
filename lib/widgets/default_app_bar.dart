import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/pages/notifications_center/notifications_center_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/accessibility_utils.dart';
import 'package:pass_emploi_app/widgets/a11y/auto_focus.dart';
import 'package:pass_emploi_app/widgets/buttons/tertiary_icon_button.dart';
import 'package:pass_emploi_app/widgets/profile_button.dart';

class PrimarySliverAppbar extends StatelessWidget {
  final String title;
  final bool withNewNotifications;
  const PrimarySliverAppbar({required this.title, required this.withNewNotifications});

  static double expandedHeight = 90.0;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(builder: (context, constraints) {
      return SliverAppBar(
        surfaceTintColor: Colors.transparent,
        expandedHeight: expandedHeight,
        floating: false,
        pinned: true,
        automaticallyImplyLeading: false,
        elevation: 0.2,
        backgroundColor: Brand.isCej() ? AppColors.primary : AppColors.primaryDarkenStrong,
        flexibleSpace: AutoFocusA11y(
          child: ClipRRect(
            child: FlexibleSpaceBar(
              titlePadding: EdgeInsetsDirectional.only(
                start: 0,
                bottom: Margins.spacing_base,
              ),
              expandedTitleScale: FontSizes.xl / FontSizes.huge,
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: Margins.spacing_base),
                child: Row(
                  children: [
                    Expanded(
                      child: Tooltip(
                        message: title,
                        excludeFromSemantics: true,
                        child: AutoFocusA11y(
                          child: Text(
                            title,
                            style: TextStyles.primaryAppBar
                                .copyWith(fontSize: A11yUtils.withTextScale(context) ? FontSizes.semi : FontSizes.huge)
                                .copyWith(color: AppColors.grey100),
                          ),
                        ),
                      ),
                    ),
                    _CentreNotif(withNewNotifications),
                    SizedBox(width: Margins.spacing_s),
                    ProfileButton(isDarkColor: Brand.isCej()),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _CentreNotif extends StatelessWidget {
  const _CentreNotif(
    this.withNewNotifications,
  );

  final bool withNewNotifications;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TertiaryIconButton(
          icon: AppIcons.notifications_outlined,
          tooltip: Strings.notificationsCenterTooltip,
          iconColor: Colors.white,
          onTap: () => Navigator.of(context).push(NotificationCenter.route()),
        ),
        if (withNewNotifications)
          Positioned(
            right: Margins.spacing_s,
            top: Margins.spacing_s,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool canPop;
  final IconButton? actionButton;
  final bool withProfileButton;
  final bool withAutofocusA11y;

  const PrimaryAppBar({
    super.key,
    required this.title,
    this.canPop = false,
    this.actionButton,
    this.withProfileButton = true,
    this.withAutofocusA11y = false,
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
        focusable: withAutofocusA11y,
        child: Tooltip(
          message: title,
          excludeFromSemantics: true,
          child: AutoFocusA11y(
            enabled: withAutofocusA11y,
            child: Text(
              title,
              style: TextStyles.primaryAppBar.copyWith(color: Brand.isCej() ? AppColors.primary : AppColors.grey100),
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ),
      elevation: 0,
      centerTitle: false,
      actions: [
        if (actionButton != null) ...[
          actionButton!,
          SizedBox(width: Margins.spacing_base),
        ],
        if (withProfileButton) ...[
          ProfileButton(isDarkColor: Brand.isCej()),
          SizedBox(width: Margins.spacing_base),
        ],
      ],
    );
  }

  static const toolBarHeight = 64.0;

  @override
  Size get preferredSize => Size.fromHeight(toolBarHeight);
}

class SecondaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final Widget? leading;
  final List<Widget>? actions;

  const SecondaryAppBar({super.key, required this.title, this.backgroundColor, this.leading, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: toolBarHeight,
      titleSpacing: 0,
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: leading,
      actions: actions,
      backgroundColor: backgroundColor ?? Colors.white,
      title: Semantics(
        header: true,
        child: Tooltip(
          message: title,
          excludeFromSemantics: true,
          child: Text(
            title,
            style: TextStyles.secondaryAppBar,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  static const toolBarHeight = 56.0;

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
