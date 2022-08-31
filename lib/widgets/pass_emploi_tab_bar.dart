import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class PassEmploiTabBar extends StatelessWidget {
  final List<String> tabLabels;
  final TabController? controller;

  PassEmploiTabBar({Key? key, required this.tabLabels, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: controller,
              indicatorColor: AppColors.primary,
              indicatorWeight: 4,
              labelStyle: TextStyles.textBaseBold,
              labelColor: AppColors.contentColor,
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: true,
              labelPadding: const EdgeInsets.only(right: 32),
              indicatorPadding: const EdgeInsets.only(right: 32),
              unselectedLabelColor: AppColors.grey800,
              tabs: _tabs(),
            ),
          ),
          SepLine(0, 0, color: AppColors.grey500),
        ],
      ),
    );
  }

  List<Tab> _tabs() {
    return tabLabels.map((e) => Tab(child: Text(e))).toList();
  }
}
