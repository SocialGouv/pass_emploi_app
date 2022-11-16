import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/boite_a_outils_page.dart';
import 'package:pass_emploi_app/pages/event_list_page.dart';
import 'package:pass_emploi_app/pages/search_annonces_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_tab_bar.dart';

class SolutionsTabPage extends StatelessWidget {
  final List<String> _solutionTabs = [
    Strings.offresTabTitle,
    Strings.eventsTabTitle,
    Strings.boiteAOutilsTabTitle,
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _solutionTabs.length,
      child: Scaffold(
        backgroundColor: AppColors.grey100,
        appBar: passEmploiAppBar(
          label: Strings.solutionsAppBarTitle,
          context: context
        ),
        body: _buildTabBarView(),
      ),
    );
  }

  Widget _buildTabBarView() {
    return Column(
      children: [
        PassEmploiTabBar(tabLabels: _solutionTabs),
        Expanded(
          child: TabBarView(
            children: [
              SearchAnnoncesPage(),
              EventListPage(),
              BoiteAOutilsPage(),
            ],
          ),
        ),
      ],
    );
  }
}
