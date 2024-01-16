import 'package:pass_emploi_app/models/date/interval.dart';
import 'package:pass_emploi_app/models/mon_suivi.dart';

enum Period {
  previous,
  current,
  next;

  bool isCurrent() => this == Period.current;

  bool isPrevious() => this == Period.previous;

  bool isNext() => this == Period.next;
}

class MonSuiviRequestAction {
  final Period period;

  MonSuiviRequestAction(this.period);
}

class MonSuiviLoadingAction {}

class MonSuiviSuccessAction {
  final Interval interval;
  final MonSuivi monSuivi;

  MonSuiviSuccessAction(this.interval, this.monSuivi);
}

class MonSuiviFailureAction {}

class MonSuiviResetAction {}
