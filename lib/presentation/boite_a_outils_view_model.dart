import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/outil.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class BoiteAOutilsViewModel extends Equatable {
  final List<Outil> outils;

  BoiteAOutilsViewModel({
    required this.outils,
  });

  static BoiteAOutilsViewModel create(Store<AppState> store) {
    return BoiteAOutilsViewModel(
      outils: _getOutils(store.state.accompagnement()),
    );
  }

  @override
  List<Object?> get props => [outils];
}

List<Outil> _getOutils(Accompagnement accompagnement) {
  return switch (accompagnement) {
    Accompagnement.cej => [
        Outil.benevolatCej,
        Outil.diagoriente,
        Outil.mesAides1J1S,
        Outil.mentor,
        Outil.formation,
        Outil.evenement,
        Outil.emploiStore,
        Outil.emploiSolidaire,
        Outil.laBonneBoite,
        Outil.alternance,
      ],
    Accompagnement.aij => [
        Outil.benevolatPassEmploi,
        Outil.diagoriente,
        Outil.mesAides1J1S,
        Outil.mentor,
        Outil.formation,
        Outil.evenement,
        Outil.emploiStore,
        Outil.emploiSolidaire,
        Outil.laBonneBoite,
        Outil.alternance,
      ],
    Accompagnement.rsa => [
        Outil.benevolatPassEmploi,
        Outil.mesAides1J1S,
        Outil.emploiStore,
        Outil.emploiSolidaire,
        Outil.laBonneBoite,
      ],
  };
}
