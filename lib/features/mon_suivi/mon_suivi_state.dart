import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/date/interval.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/models/mon_suivi.dart';
import 'package:pass_emploi_app/models/user_action.dart';

sealed class MonSuiviState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MonSuiviNotInitializedState extends MonSuiviState {}

class MonSuiviLoadingState extends MonSuiviState {}

class MonSuiviFailureState extends MonSuiviState {}

class MonSuiviSuccessState extends MonSuiviState {
  final Interval interval;
  final MonSuivi monSuivi;

  MonSuiviSuccessState(this.interval, this.monSuivi);

  @override
  List<Object?> get props => [interval, monSuivi];

  MonSuiviSuccessState withUpdatedActions(List<UserAction> actions) {
    return MonSuiviSuccessState(
      interval,
      MonSuivi(
        actions: actions,
        rendezvous: monSuivi.rendezvous,
        sessionsMilo: monSuivi.sessionsMilo,
        errorOnSessionMiloRetrieval: monSuivi.errorOnSessionMiloRetrieval,
        demarches: [],
        dateDerniereMiseAJourPoleEmploi: null,
      ),
    );
  }

  MonSuiviSuccessState withUpdatedDemarches(List<Demarche> demarches) {
    return MonSuiviSuccessState(
      interval,
      MonSuivi(
        demarches: demarches,
        rendezvous: monSuivi.rendezvous,
        dateDerniereMiseAJourPoleEmploi: monSuivi.dateDerniereMiseAJourPoleEmploi,
        sessionsMilo: [],
        actions: [],
        errorOnSessionMiloRetrieval: false,
      ),
    );
  }
}
