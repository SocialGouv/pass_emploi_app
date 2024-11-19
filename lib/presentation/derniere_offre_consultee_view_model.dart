import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_dto.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/presentation/offre_emploi/offre_emploi_origin_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DerniereOffreConsulteeViewModel extends Equatable {
  final String id;
  final String titre;
  final OffreType type;
  final String? organisation;
  final String? localisation;
  final OffreEmploiOriginViewModel? originViewModel;

  DerniereOffreConsulteeViewModel({
    required this.id,
    required this.titre,
    required this.type,
    required this.organisation,
    this.localisation,
    this.originViewModel,
  });

  static DerniereOffreConsulteeViewModel create(Store<AppState> store) {
    final state = store.state.derniereOffreConsulteeState;
    final offre = state.offre;
    if (offre == null) {
      return DerniereOffreConsulteeViewModel(
        id: "",
        titre: "",
        organisation: "",
        type: OffreType.emploi,
      );
    }

    return DerniereOffreConsulteeViewModel(
      id: switch (offre) {
        final OffreEmploiDto offreDto => offreDto.offreEmploi.id,
        final OffreImmersionDto offreDto => offreDto.immersion.id,
        final OffreServiceCiviqueDto offreDto => offreDto.serviceCivique.id,
      },
      titre: switch (offre) {
        final OffreEmploiDto offreDto => offreDto.offreEmploi.title,
        final OffreImmersionDto offreDto => offreDto.immersion.metier,
        final OffreServiceCiviqueDto offreDto => offreDto.serviceCivique.title,
      },
      organisation: switch (offre) {
        final OffreEmploiDto offreDto => offreDto.offreEmploi.companyName,
        final OffreImmersionDto offreDto => offreDto.immersion.nomEtablissement,
        final OffreServiceCiviqueDto offreDto => offreDto.serviceCivique.companyName,
      },
      type: switch (offre) {
        final OffreEmploiDto offreDto => offreDto.offreEmploi.isAlternance ? OffreType.alternance : OffreType.emploi,
        OffreImmersionDto() => OffreType.immersion,
        OffreServiceCiviqueDto() => OffreType.serviceCivique,
      },
      localisation: switch (offre) {
        final OffreEmploiDto offreDto => offreDto.offreEmploi.location,
        final OffreImmersionDto offreDto => offreDto.immersion.ville,
        final OffreServiceCiviqueDto offreDto => offreDto.serviceCivique.location,
      },
      originViewModel: switch (offre) {
        final OffreEmploiDto offreDto => OffreEmploiOriginViewModel.from(offreDto.offreEmploi.origin),
        _ => null,
      },
    );
  }

  bool get isEmpty => id.isEmpty;

  @override
  List<Object?> get props => [id, titre, type, organisation, localisation, originViewModel];
}
