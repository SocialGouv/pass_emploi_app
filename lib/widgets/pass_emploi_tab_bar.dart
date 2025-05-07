import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/onboarding/onboarding_showcase.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class PassEmploiTabBar extends StatefulWidget {
  final List<String> tabLabels;
  final TabController? controller;

  PassEmploiTabBar({super.key, required this.tabLabels, this.controller});

  @override
  State<PassEmploiTabBar> createState() => _PassEmploiTabBarState();
}

class _PassEmploiTabBarState extends State<PassEmploiTabBar> {
  // needed to show onboarding after navigation
  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        setState(() {
          mayShowOnboarding = true;
        });
      },
    );
    super.initState();
  }

  bool mayShowOnboarding = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
      color: Brand.isCej() ? Colors.transparent : AppColors.primary,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: widget.controller,
              indicatorColor: Brand.isCej() ? AppColors.primary : AppColors.grey100,
              indicatorWeight: 4,
              labelStyle: TextStyles.textBaseBold,
              labelColor: Brand.isCej() ? AppColors.contentColor : AppColors.grey100,
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: true,
              labelPadding: const EdgeInsets.only(right: 32),
              indicatorPadding: const EdgeInsets.only(right: 32),
              unselectedLabelColor: Brand.isCej() ? AppColors.grey800 : Colors.grey[350],
              tabAlignment: TabAlignment.start,
              tabs: _tabs(),
            ),
          ),
          if (Brand.isCej()) SepLine(0, 0, color: AppColors.grey500),
        ],
      ),
    );
  }

  List<Widget> _tabs() {
    return widget.tabLabels.map(
      (e) {
        final tab = Tab(
          child: Text(e),
        );

        if (e == Strings.accueilOutilsSection && mayShowOnboarding) {
          return OnboardingShowcase(
            bottom: true,
            source: ShowcaseSource.outils,
            child: tab,
          );
        }
        return tab;
      },
    ).toList();
  }
}
