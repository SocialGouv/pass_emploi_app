import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pass_emploi_app/pages/search_annonces_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

import 'boite_a_outils_page.dart';

class SolutionsTabPage extends StatelessWidget {
  final List<Tab> solutionTabs = <Tab>[
    Tab(child: Text(Strings.offresTabTitle)),
    Tab(child: Text(Strings.boiteAOutilsTabTitle)),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: solutionTabs.length,
      child: Scaffold(
        backgroundColor: AppColors.grey100,
        appBar: passEmploiAppBar(
          label: Strings.solutionsAppBarTitle,
          bottom: TabBar(
              tabs: solutionTabs,
              indicatorColor: AppColors.primary,
              indicatorWeight: 5,
              labelStyle: TextStyles.textBaseBold,
              labelColor: AppColors.contentColor,
              unselectedLabelColor: AppColors.grey800),
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
