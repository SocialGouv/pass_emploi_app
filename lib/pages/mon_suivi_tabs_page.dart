import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pass_emploi_app/pages/rendezvous_list_page.dart';
import 'package:pass_emploi_app/pages/user_action_list_page.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_tab_bar.dart';
import 'package:pass_emploi_app/widgets/unavailable_content.dart';

enum MonSuiviTab { ACTIONS, RENDEZVOUS }

class MonSuiviTabPage extends StatelessWidget {
  final MonSuiviTab initialTab;
  final bool showContent;

  MonSuiviTabPage({required this.initialTab, required this.showContent}) : super();

  final List<String> _monSuiviTabs = [
    Strings.actionsTabTitle,
    Strings.rendezvousTabTitle,
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialTab == MonSuiviTab.ACTIONS ? 0 : 1,
      length: _monSuiviTabs.length,
      child: Scaffold(
        appBar: passEmploiAppBar(
          label: Strings.monSuiviAppBarTitle,
        ),
        body: _getBody(),
      ),
    );
  }

  Widget _setTabContent() {
    if (showContent)
      return TabBarView(
        children: [
          UserActionListPage(),
          RendezvousListPage(),
        ],
      );
    else
      return TabBarView(
        children: [
          UnavailableContent(contentType: ContentType.ACTIONS),
          UnavailableContent(contentType: ContentType.RENDEZVOUS),
        ],
      );
  }

  _getBody() {
    return Column(
      children: [
        PassEmploiTabBar(
          tabLabels: _monSuiviTabs,
        ),
        Expanded(child: _setTabContent()),
      ],
    );
  }
}
