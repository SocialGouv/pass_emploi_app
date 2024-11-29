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
      outils: _getOutils(store.state.accompagnement(), store.state.featureFlipState.featureFlip.withCje),
    );
  }

  @override
  List<Object?> get props => [outils];
}

List<Outil> _getOutils(Accompagnement accompagnement, bool withCje) {
  return switch (accompagnement) {
    Accompagnement.cej => [
        Outil.laBonneAlternance,
        if (withCje) Outil.cje,
        Outil.mesAidesFt,
        Outil.benevolatCej,
        Outil.formation,
        Outil.mentor,
        Outil.evenement,
        Outil.emploiStore,
        Outil.emploiSolidaire,
        Outil.laBonneBoite,
        Outil.alternance,
        Outil.diagoriente,
        Outil.mesAides1J1S,
      ],
    Accompagnement.aij => [
        Outil.laBonneAlternance,
        Outil.mesAidesFt,
        Outil.benevolatPassEmploi,
        Outil.formation,
        Outil.mentor,
        Outil.evenement,
        Outil.emploiStore,
        Outil.emploiSolidaire,
        Outil.laBonneBoite,
        Outil.alternance,
        Outil.diagoriente,
        Outil.mesAides1J1S,
      ],
    Accompagnement.rsaFranceTravail || Accompagnement.rsaConseilsDepartementaux => [
        Outil.mesAidesFt,
        Outil.benevolatPassEmploi,
        Outil.emploiStore,
        Outil.emploiSolidaire,
        Outil.laBonneBoite,
        Outil.mesAides1J1S,
      ],
  };
}
