import 'package:pass_emploi_app/models/date/interval.dart';
import 'package:pass_emploi_app/models/mon_suivi.dart';

enum MonSuiviPeriod {
  previous,
  current,
  next;

  bool get isCurrent => this == MonSuiviPeriod.current;
}

class MonSuiviRequestAction {
  final MonSuiviPeriod period;

  MonSuiviRequestAction(this.period);
}

class MonSuiviLoadingAction {}

class MonSuiviSuccessAction {
  final MonSuiviPeriod period;
  final Interval interval;
  final MonSuivi monSuivi;

  MonSuiviSuccessAction(this.period, this.interval, this.monSuivi);
}

class MonSuiviFailureAction {}

class MonSuiviResetAction {}
