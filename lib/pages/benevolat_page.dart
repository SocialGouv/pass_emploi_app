import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class BenevolatPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() => MaterialPageRoute(builder: (context) => BenevolatPage());

  @override
  Widget build(BuildContext context) {
    return Tracker(
        tracking: AnalyticsScreenNames.benevolat,
        child: Scaffold(
          appBar: SecondaryAppBar(title: Strings.benevolatTitle),
        ));
  }
}
