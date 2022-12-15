import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/boite_a_outils_page.dart';
import 'package:pass_emploi_app/pages/event_list_page.dart';
import 'package:pass_emploi_app/pages/search_annonces_page.dart';
import 'package:pass_emploi_app/presentation/solutions_tabs_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_tab_bar.dart';

class SolutionsTabPage extends StatelessWidget {
  final SolutionsTab? initialTab;

  SolutionsTabPage(this.initialTab);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SolutionsTabPageViewModel>(
      builder: (context, viewModel) => _Body(viewModel, initialTab),
      converter: (store) => SolutionsTabPageViewModel.create(store),
      distinct: true,
    );
  }
}

class _Body extends StatelessWidget {
  final SolutionsTabPageViewModel viewModel;
  final SolutionsTab? initialTab;

  _Body(this.viewModel, this.initialTab);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: viewModel.tabs._index(initialTab),
      length: viewModel.tabs.length,
      child: Scaffold(
        backgroundColor: AppColors.grey100,
        appBar: passEmploiAppBar(label: Strings.solutionsAppBarTitle, context: context),
        body: Column(
          children: [
            PassEmploiTabBar(tabLabels: viewModel.tabs.titles()),
            Expanded(
              child: TabBarView(
                children: viewModel.tabs._pages(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension _Tabs on List<SolutionsTab> {
  int _index(SolutionsTab? tab) {
    if (tab == null) return 0;
    final index = indexOf(tab);
    return index >= 0 ? index : 0;
  }

  List<Widget> _pages() {
    return map((tab) {
      switch (tab) {
        case SolutionsTab.offres:
          return SearchAnnoncesPage();
        case SolutionsTab.events:
          return EventListPage();
        case SolutionsTab.outils:
          return BoiteAOutilsPage();
      }
    }).toList();
  }
}
