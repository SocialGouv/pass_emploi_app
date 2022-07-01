import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class PartageOffrePage extends TraceableStatelessWidget {
  PartageOffrePage._() : super(name: AnalyticsScreenNames.emploiPartagePage);

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) {
      return PartageOffrePage._();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _scaffold(_body(context), context);
  }

  Scaffold _scaffold(Widget body, BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(label: Strings.partageOffreNavTitle, context: context, withBackButton: true),
      body: body,
    );
  }

  Widget _body(BuildContext context) {
    return Text("Hey");
  }
}
