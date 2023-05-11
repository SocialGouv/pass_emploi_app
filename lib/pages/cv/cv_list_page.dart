import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class CvListPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() => MaterialPageRoute(builder: (context) => CvListPage());

  const CvListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.cvListPage,
      child: Scaffold(
        appBar: SecondaryAppBar(title: Strings.cvListPageTitle),
      ),
    );
  }
}
