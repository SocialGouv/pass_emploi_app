import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/favoris/offre_emploi_favoris_page.dart';
import 'package:pass_emploi_app/pages/offre_favoris_tab_page.dart';
import 'package:pass_emploi_app/pages/saved_search_tab_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/carousel_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_tab_bar.dart';

class FavorisTabsPage extends StatelessWidget {
  final List<String> _favorisTabs = [
    "Mea offres",
    "Mes recherches",
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _favorisTabs.length,
      child: Scaffold(
        backgroundColor: AppColors.grey100,
        appBar: passEmploiAppBar(label: Strings.menuFavoris),
        body: _buildTabBarView(),
      ),
    );
  }

  Widget _buildTabBarView() {
    return Column(
      children: [
        PassEmploiTabBar(tabLabels: _favorisTabs),
        Expanded(
          child: TabBarView(
            children: [
              OffreFavorisTabPage(),
              SavedSearchTabPage(),
            ],
          ),
        ),
      ],
    );
  }
}
