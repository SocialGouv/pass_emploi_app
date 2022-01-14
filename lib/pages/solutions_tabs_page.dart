import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pass_emploi_app/pages/search_annonces_page.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

import 'boite_a_outils_page.dart';

class SolutionsTabPage extends StatelessWidget {
  final List<Tab> solutionTabs = <Tab>[
    Tab(child: Text(Strings.offresTabTitle, style: TextStyles.textMdMedium)),
    Tab(child: Text(Strings.boiteAOutilsTabTitle, style: TextStyles.textMdMedium)),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: solutionTabs.length,
      child: Scaffold(
        appBar: passEmploiAppBar(
          label: Strings.solutionsAppBarTitle,
          bottom: TabBar(tabs: solutionTabs),
        ),
        body: TabBarView(
          children: [
            SearchAnnoncesPage(),
            BoiteAOutilsPage(),
          ],
        ),
      ),
    );
  }
}
