import 'package:pass_emploi_app/models/date/interval.dart';
import 'package:pass_emploi_app/models/mon_suivi.dart';

enum Period {
  previous,
  current,
  next;

  bool get isCurrent => this == Period.current;
}

class MonSuiviRequestAction {
  final Period period;

  MonSuiviRequestAction(this.period);
}

class MonSuiviLoadingAction {}

class MonSuiviSuccessAction {
  final Period period;
  final Interval interval;
  final MonSuivi monSuivi;

  MonSuiviSuccessAction(this.period, this.interval, this.monSuivi);
}

class MonSuiviFailureAction {}

class MonSuiviResetAction {}
