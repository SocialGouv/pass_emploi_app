import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/rendezvous/rendezvous_list_page.dart';
import 'package:pass_emploi_app/pages/user_action_list_page.dart';
import 'package:pass_emploi_app/pages/user_action_pe_list_page.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_tab_bar.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

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
        body: CustomScrollView(
          slivers: [
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
            SliverPersistentHeader(
              pinned: true,
              delegate: PersistentHeader(widget: _getBody()),
            ),
          ],
        ),
      ),
    );
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

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;

  PersistentHeader({required this.widget});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.84,
      child: Card(
        margin: EdgeInsets.all(0),
        color: Colors.white,
        child: Center(child: widget),
      ),
    );
  }

  @override
  double get maxExtent => 2000;

  @override
  double get minExtent => 300.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
