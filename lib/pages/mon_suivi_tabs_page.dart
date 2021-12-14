import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pass_emploi_app/pages/rendezvous_list_page.dart';
import 'package:pass_emploi_app/pages/user_action_list_page.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class MonSuiviTabPage extends StatelessWidget {
  final List<Tab> monSuiviTabs = <Tab>[
    Tab(child: Text(Strings.actionsTabTitle, style: TextStyles.textMdMedium)),
    Tab(child: Text(Strings.rendezvousTabTitle, style: TextStyles.textMdMedium)),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: monSuiviTabs.length,
      child: Scaffold(
        appBar: FlatDefaultAppBar(
          title: Text(Strings.monSuiviAppBarTitle, style: TextStyles.h3Semi),
          bottom: TabBar(tabs: monSuiviTabs),
        ),
        body: TabBarView(
          children: [
            UserActionListPage(),
            RendezvousListPage(),
          ],
        ),
      ),
    );
  }
}
