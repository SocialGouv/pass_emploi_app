import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

import 'boite_a_outils_page.dart';
import 'offre_emploi_search_page.dart';

class SolutionsTabPage extends StatelessWidget {
  final List<Tab> solutionTabs = <Tab>[
    Tab(child: Text("Offres", style: TextStyles.textMdMedium)),
    Tab(child: Text("Boîte à outils", style: TextStyles.textMdMedium)),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: solutionTabs.length,
      child: Scaffold(
        appBar: FlatDefaultAppBar(
          title: Text("Recherche", style: TextStyles.h3Semi),
          bottom: TabBar(tabs: solutionTabs),
        ),
        body: TabBarView(
          children: [
            OffreEmploiSearchPage(),
            BoiteAOutilsPage(),
          ],
        ),
      ),
    );
  }
}
