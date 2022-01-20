import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pass_emploi_app/pages/search_annonces_page.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/tab_bar.dart';

import 'boite_a_outils_page.dart';

class SolutionsTabPage extends StatelessWidget {
  final List<String> _solutionTabs = [
    Strings.offresTabTitle,
    Strings.boiteAOutilsTabTitle,
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _solutionTabs.length,
      child: Scaffold(
        appBar: passEmploiAppBar(
          label: Strings.solutionsAppBarTitle,
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
              BoiteAOutilsPage(),
            ],
          ),
        ),
      ],
    );
  }
}
