// ignore_for_file: must_be_immutable
// La variable _currentTab est utilisée pour ne pas tracker plusieurs fois un même changement d'onglet
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/agenda_page.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_list_page.dart';
import 'package:pass_emploi_app/pages/rendezvous/rendezvous_list_page.dart';
import 'package:pass_emploi_app/pages/user_action/user_action_list_page.dart';
import 'package:pass_emploi_app/presentation/mon_suivi_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_tab_bar.dart';

class MonSuiviTabPage extends StatefulWidget {
  final MonSuiviViewModel viewModel;

  MonSuiviTabPage({required this.viewModel}) : super();

  @override
  State<MonSuiviTabPage> createState() => _MonSuiviTabPageState();
}

class _MonSuiviTabPageState extends State<MonSuiviTabPage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  late int _currentTab;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      vsync: this,
      length: widget.viewModel.tabs.length,
      initialIndex: widget.viewModel.initialIndex(),
    );
    _currentTab = widget.viewModel.initialIndex();
    _trackTabIfNeeded(context);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: store.state.demoState ? passEmploiAppBar(label: null, context: context) : null,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: false,
                snap: true,
                floating: true,
                expandedHeight: 40.0,
                backgroundColor: AppColors.grey100,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(Strings.monSuiviAppBarTitle, style: TextStyles.textAppBar),
                  centerTitle: true,
                ),
              ),
            ];
          },
          body: _getBody(),
        ),
      ),
    );
  }

  void _trackTabIfNeeded(BuildContext context) {
    tabController.addListener(() {
      if (tabController.index != _currentTab) {
        setState(() => _currentTab = tabController.index);
        _currentTab = tabController.index;
        if (tabController.index == widget.viewModel.indexOfTab(MonSuiviTab.ACTIONS) ||
            tabController.index == widget.viewModel.indexOfTab(MonSuiviTab.DEMARCHE)) {
          context.trackEvent(EventType.ACTION_LISTE);
        }
      }
    });
  }

  Widget _setTabContent() {
    return TabBarView(
      controller: tabController,
      children: widget.viewModel.tabs.map((tab) {
        switch (tab) {
          case MonSuiviTab.AGENDA:
            return AgendaPage(() => tabController.animateTo(1));
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

  Widget _getBody() {
    return Column(
      children: [
        PassEmploiTabBar(
          controller: tabController,
          tabLabels: widget.viewModel.tabTitles(),
        ),
        Expanded(child: _setTabContent()),
      ],
    );
  }
}
