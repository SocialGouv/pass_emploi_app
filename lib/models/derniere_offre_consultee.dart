import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/service_civique.dart';

sealed class DerniereOffreConsultee extends Equatable {
  static DerniereOffreConsultee fromJson(dynamic json) {
    final String type = json['type'] as String;
    switch (type) {
      case 'offre_emploi':
        return DerniereRechercheOffreEmploi(OffreEmploi.fromJson(json['data']));
      case 'immersion':
        return DerniereRechercheImmersion(Immersion.fromJson(json['data']));
      case 'service_civique':
        return DerniereRechercheServiceCivique(ServiceCivique.fromJson(json['data']));
      default:
        throw Exception('Unknown type $type');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "type": switch (this) {
        DerniereRechercheOffreEmploi() => "offre_emploi",
        DerniereRechercheImmersion() => "immersion",
        DerniereRechercheServiceCivique() => "service_civique",
      },
      "data": switch (this) {
        final DerniereRechercheOffreEmploi offre => offre.offreEmploi.toJson(),
        final DerniereRechercheImmersion offre => offre.immersion.toJson(),
        final DerniereRechercheServiceCivique offre => offre.serviceCivique.toJson(),
      },
    };
  }
}

class DerniereRechercheOffreEmploi extends DerniereOffreConsultee {
  final OffreEmploi offreEmploi;

  DerniereRechercheOffreEmploi(this.offreEmploi);

  @override
  List<Object?> get props => [offreEmploi];
}

class DerniereRechercheImmersion extends DerniereOffreConsultee {
  final Immersion immersion;

  DerniereRechercheImmersion(this.immersion);

  @override
  List<Object?> get props => [immersion];
}

class DerniereRechercheServiceCivique extends DerniereOffreConsultee {
  final ServiceCivique serviceCivique;

  DerniereRechercheServiceCivique(this.serviceCivique);

  @override
  List<Object?> get props => [serviceCivique];
}
