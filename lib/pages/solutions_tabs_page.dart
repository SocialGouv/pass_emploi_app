import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

import 'boite_a_outils_page.dart';
import 'search_annonces_page.dart';

class SearchTabPage extends StatelessWidget {
  final List<Tab> searchTabs = <Tab>[
    Tab(child: Text(Strings.annoncesTabTitle, style: TextStyles.textMdMedium)),
    Tab(child: Text(Strings.boiteAOutilsTabTitle, style: TextStyles.textMdMedium)),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: searchTabs.length,
      child: Scaffold(
        appBar: FlatDefaultAppBar(
          title: Text(Strings.searchAppBarTitle, style: TextStyles.h3Semi),
          bottom: TabBar(tabs: searchTabs),
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
