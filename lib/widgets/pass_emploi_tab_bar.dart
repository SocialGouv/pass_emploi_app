import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class PassEmploiTabBar extends StatelessWidget {
  final List<String> tabLabels;
  final TabController? controller;

  PassEmploiTabBar({Key? key, required this.tabLabels, this.controller}) : super(key: key);

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
              controller: controller,
              indicatorColor: Brand.isCej() ? AppColors.primary : AppColors.grey100,
              indicatorWeight: 4,
              labelStyle: TextStyles.textBaseBold,
              labelColor: Brand.isCej() ? AppColors.contentColor : AppColors.grey100,
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: true,
              labelPadding: const EdgeInsets.only(right: 32),
              indicatorPadding: const EdgeInsets.only(right: 32),
              unselectedLabelColor: Brand.isCej() ? AppColors.grey800 : Colors.grey[350],
              tabs: _tabs(),
            ),
          ),
          if (Brand.isCej()) SepLine(0, 0, color: AppColors.grey500),
        ],
      ),
    );
  }

  List<Tab> _tabs() {
    return tabLabels.map((e) => Tab(child: Text(e))).toList();
  }
}
