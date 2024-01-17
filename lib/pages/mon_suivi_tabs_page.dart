// ignore_for_file: must_be_immutable
// La variable _currentTab est utilisée pour ne pas tracker plusieurs fois un même changement d'onglet
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/agenda_page.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_list_page.dart';
import 'package:pass_emploi_app/pages/rendezvous/rendezvous_list_page.dart';
import 'package:pass_emploi_app/pages/user_action/user_action_list_page.dart';
import 'package:pass_emploi_app/presentation/mon_suivi_tabs_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/connectivity_widgets.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_tab_bar.dart';

class MonSuiviTabPage extends StatefulWidget {
  final MonSuiviTab? initialTab;

  MonSuiviTabPage([this.initialTab]) : super();

  @override
  State<MonSuiviTabPage> createState() => _MonSuiviTabPageState();
}

class _MonSuiviTabPageState extends State<MonSuiviTabPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int? _currentTab;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.monSuivi,
      child: StoreConnector<AppState, MonSuiviTabsViewModel>(
        converter: (store) => MonSuiviTabsViewModel.create(store, widget.initialTab),
        builder: (context, viewModel) => _builder(viewModel),
        distinct: true,
      ),
    );
  }

  Widget _builder(MonSuiviTabsViewModel viewModel) {
    _initializeTabController(viewModel);
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: PrimaryAppBar(title: Strings.monSuiviAppBarTitle),
      body: ConnectivityContainer(child: _getBody(viewModel)),
    );
  }

  void _initializeTabController(MonSuiviTabsViewModel viewModel) {
    if (_tabController == null) {
      _tabController = TabController(
        vsync: this,
        length: viewModel.tabs.length,
        initialIndex: viewModel.initialTabIndex,
      );
      _currentTab = viewModel.initialTabIndex;
      _trackTabIfNeeded(viewModel);
    }
  }

  void _trackTabIfNeeded(MonSuiviTabsViewModel viewModel) {
    if (_tabController == null) return;
    _tabController!.addListener(() {
      if (_tabController!.index != _currentTab) {
        setState(() => _currentTab = _tabController!.index);
        _currentTab = _tabController!.index;
        if (_tabController!.index == viewModel.tabs.indexOf(MonSuiviTab.ACTIONS) ||
            _tabController!.index == viewModel.tabs.indexOf(MonSuiviTab.DEMARCHE)) {
          context.trackEvent(EventType.ACTION_LISTE);
        }
      }
    });
  }

  Widget _setTabContent(MonSuiviTabsViewModel viewModel) {
    return TabBarView(
      controller: _tabController,
      children: viewModel.tabs.map((tab) {
        switch (tab) {
          case MonSuiviTab.AGENDA:
            return AgendaPage(() => _tabController?.animateTo(1));
          case MonSuiviTab.ACTIONS:
            return UserActionListPage();
          case MonSuiviTab.DEMARCHE:
            return DemarcheListPage();
          case MonSuiviTab.RENDEZVOUS:
            return RendezvousListPage();
        }
      }).toList(),
    );
  }

  Widget _getBody(MonSuiviTabsViewModel viewModel) {
    return Column(
      children: [
        PassEmploiTabBar(
          controller: _tabController,
          tabLabels: viewModel.tabTitles,
        ),
        Expanded(child: _setTabContent(viewModel)),
      ],
    );
  }
}
