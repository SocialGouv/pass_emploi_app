// ignore_for_file: must_be_immutable
// La variable _currentTab est utilisée pour ne pas tracker plusieurs fois un même changement d'onglet
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/agenda_page.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_list_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/connectivity_widgets.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_tab_bar.dart';

const int indexOfDemarchesTab = 1;

class MonSuiviTabPage extends StatefulWidget {
  @override
  State<MonSuiviTabPage> createState() => _MonSuiviTabPageState();
}

class _MonSuiviTabPageState extends State<MonSuiviTabPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _currentTab;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {
      if (_tabController.index != _currentTab) {
        _currentTab = _tabController.index;
        if (_tabController.index == indexOfDemarchesTab) {
          context.trackEvent(EventType.ACTION_LISTE);
        }
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentTab = _tabController.index;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.monSuivi,
      child: Scaffold(
        backgroundColor: AppColors.grey100,
        appBar: PrimaryAppBar(title: Strings.monSuiviAppBarTitle),
        body: ConnectivityContainer(
          child: Column(
            children: [
              PassEmploiTabBar(
                controller: _tabController,
                tabLabels: [
                  Strings.agendaTabTitle,
                  Strings.demarcheTabTitle,
                  "Rendez-vous",
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    AgendaPage(() => _tabController.animateTo(1)),
                    DemarcheListPage(),
                    SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
