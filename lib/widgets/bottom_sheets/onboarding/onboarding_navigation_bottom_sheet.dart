import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';

class OnboardingNavigationBottomSheet extends StatelessWidget {
  const OnboardingNavigationBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const OnboardingNavigationBottomSheet(),
      isDismissible: false,
      enableDrag: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWrapper(
      padding: EdgeInsets.zero,
      hideTitle: true,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                Drawables.illustrationNavigationBottomSheet,
                fit: BoxFit.fitWidth,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: Margins.spacing_xl),
                    Text(
                      Strings.onboardingNavigationTitle,
                      style: TextStyles.textMBold,
                    ),
                    SizedBox(height: Margins.spacing_m),
                    Text(
                      Strings.onboardingNavigationBody,
                      style: TextStyles.textBaseRegular,
                    ),
                  ],
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _FakeNavBar(),
          ),
        ],
      ),
    );
  }
}

class _FakeNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
        padding: EdgeInsets.only(
          bottom: mediaQuery.padding.bottom + Margins.spacing_s,
          left: Margins.spacing_xs,
          right: Margins.spacing_xs,
        ),
        child: Row(
          children: [
            _CustomMenuItem(
              defaultIcon: AppIcons.home_outlined,
              label: Strings.menuAccueil,
            ),
            _CustomMenuItem(
              isAnimated: true,
              onTap: () => _goToMonSuivi(context),
              defaultIcon: AppIcons.bolt_rounded,
              label: Strings.menuMonSuivi,
            ),
            _CustomMenuItem(
              defaultIcon: AppIcons.chat_outlined,
              label: Strings.menuChat,
            ),
            _CustomMenuItem(
              defaultIcon: AppIcons.pageview_outlined,
              label: Strings.menuSolutions,
            ),
            _CustomMenuItem(
              defaultIcon: AppIcons.today_outlined,
              label: Strings.menuEvenements,
            ),
          ],
        ));
  }

  void _goToMonSuivi(BuildContext context) {
    Navigator.of(context).pop();
    StoreProvider.of<AppState>(context).dispatch(
      HandleDeepLinkAction(
        AgendaDeepLink(),
        DeepLinkOrigin.inAppNavigation,
      ),
    );
  }
}

class _CustomMenuItem extends StatelessWidget {
  const _CustomMenuItem({required this.defaultIcon, required this.label, this.isAnimated = false, this.onTap});

  final bool isAnimated;
  final IconData defaultIcon;
  final String label;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final contentColor = isAnimated ? AppColors.primary : AppColors.grey500;
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Semantics(
            label: label,
            child: InkWell(
              onTap: onTap,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(defaultIcon, color: contentColor),
                  SizedBox(height: Margins.spacing_s),
                  Text(
                    label,
                    style: isAnimated
                        ? TextStyles.textXsBold(color: contentColor)
                        : TextStyles.textXsRegular(color: contentColor),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
          if (isAnimated) _AnimatedCircle(),
        ],
      ),
    );
  }
}

class _AnimatedCircle extends StatefulWidget {
  @override
  State<_AnimatedCircle> createState() => __AnimatedCircleState();
}

class __AnimatedCircleState extends State<_AnimatedCircle> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationDurations.verySlow,
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0,
      height: 0,
      child: OverflowBox(
        maxWidth: 80,
        maxHeight: 80,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: 1 + _animation.value * 0.2,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [AppColors.primary.withOpacity(0.0), AppColors.primary.withOpacity(0.5)],
                    stops: [0.8, 1],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
