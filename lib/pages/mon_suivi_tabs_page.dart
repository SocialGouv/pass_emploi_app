import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/rendezvous/rendezvous_list_page.dart';
import 'package:pass_emploi_app/pages/user_action_list_page.dart';
import 'package:pass_emploi_app/pages/user_action_pe_list_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_tab_bar.dart';

enum MonSuiviTab { ACTIONS, RENDEZVOUS }

class MonSuiviTabPage extends StatelessWidget {
  final MonSuiviTab initialTab;
  final bool isPoleEmploiLogin;

  MonSuiviTabPage({required this.initialTab, required this.isPoleEmploiLogin}) : super();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialTab == MonSuiviTab.ACTIONS ? 0 : 1,
      length: _getTabTitles().length,
      child: Scaffold(
        backgroundColor: AppColors.grey100,
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
      ),
    );
  }

  List<String> _getTabTitles() =>
      [
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
