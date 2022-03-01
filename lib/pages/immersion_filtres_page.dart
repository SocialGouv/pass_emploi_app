import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';

class ImmersionFiltresPage extends TraceableStatelessWidget {
  const ImmersionFiltresPage() : super(name: AnalyticsScreenNames.immersionFiltres);

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (_) => ImmersionFiltresPage());
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
