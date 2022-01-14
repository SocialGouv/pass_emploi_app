import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pass_emploi_app/pages/rendezvous_list_page.dart';
import 'package:pass_emploi_app/pages/user_action_list_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/unavailable_content.dart';

enum MonSuiviTab { ACTIONS, RENDEZVOUS }

class MonSuiviTabPage extends StatelessWidget {
  final MonSuiviTab initialTab;
  final bool showContent;

  MonSuiviTabPage({required this.initialTab, required this.showContent}) : super();

  final List<Tab> monSuiviTabs = <Tab>[
    Tab(
        child: Text(
      Strings.actionsTabTitle,
      textAlign: TextAlign.left,
    )),
    Tab(child: Text(Strings.rendezvousTabTitle, textAlign: TextAlign.left)),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialTab == MonSuiviTab.ACTIONS ? 0 : 1,
      length: monSuiviTabs.length,
      child: Scaffold(
        appBar: passEmploiAppBar(
          label: Strings.monSuiviAppBarTitle,
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            indicatorWeight: 5,
            labelStyle: TextStyles.textBaseBold,
            labelColor: AppColors.contentColor,
            unselectedLabelColor: AppColors.neutralColor,
            tabs: monSuiviTabs,
          ),
        ),
        body: _setTabContent(),
      ),
    );
  }

  TabBarView _setTabContent() {
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
}
