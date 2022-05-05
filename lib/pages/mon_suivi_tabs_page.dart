// ignore_for_file: must_be_immutable
// La variable _currentTab est utilisée pour ne pas tracker plusieurs fois un même changement d'onglet
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/rendezvous/rendezvous_list_page.dart';
import 'package:pass_emploi_app/pages/user_action_list_page.dart';
import 'package:pass_emploi_app/pages/user_action_pe_list_page.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_tab_bar.dart';

enum MonSuiviTab { ACTIONS, RENDEZVOUS }

const int _indexOfMesActionsTab = 0;

class MonSuiviTabPage extends StatelessWidget {
  final MonSuiviTab initialTab;
  final bool isPoleEmploiLogin;
  late int _currentTab;

  MonSuiviTabPage({required this.initialTab, required this.isPoleEmploiLogin}) : super();

  @override
  Widget build(BuildContext context) {
    _currentTab = initialTab == MonSuiviTab.ACTIONS ? 0 : 1;
    final store = StoreProvider.of<AppState>(context);
    return DefaultTabController(
      initialIndex: initialTab == MonSuiviTab.ACTIONS ? 0 : 1,
      length: _getTabTitles().length,
      child: Builder(builder: (context) {
        _trackTabIfNeeded(context);
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
      }),
    );
  }

  void _trackTabIfNeeded(BuildContext context) {
    final tabController = DefaultTabController.of(context);
    tabController?.addListener(() {
      if (tabController.index != _currentTab) {
        _currentTab = tabController.index;
        if (tabController.index == _indexOfMesActionsTab) {
          context.trackEvent(EventType.ACTION_LISTE);
        }
      }
    });
  }

  List<String> _getTabTitles() => [
        isPoleEmploiLogin ? Strings.demarcheTabTitle : Strings.actionsTabTitle,
        Strings.rendezvousTabTitle,
      ];

  Widget _setTabContent() {
    return TabBarView(
      children: [
        isPoleEmploiLogin ? UserActionPEListPage() : UserActionListPage(),
        RendezvousListPage(),
      ],
    );
  }

  Widget _getBody() {
    return Column(
      children: [
        PassEmploiTabBar(
          tabLabels: _getTabTitles(),
        ),
        Expanded(child: _setTabContent()),
      ],
    );
  }
}
