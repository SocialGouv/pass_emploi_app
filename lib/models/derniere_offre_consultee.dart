import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/service_civique.dart';

sealed class DerniereOffreConsultee extends Equatable {
  static DerniereOffreConsultee fromJson(dynamic json) {
    final String type = json['type'] as String;
    switch (type) {
      case 'offre_emploi':
        return DerniereOffreEmploiConsultee(OffreEmploi.fromJson(json['data']));
      case 'immersion':
        return DerniereOffreImmersionConsultee(Immersion.fromJson(json['data']));
      case 'service_civique':
        return DerniereOffreServiceCiviqueConsultee(ServiceCivique.fromJson(json['data']));
      default:
        throw Exception('Unknown type $type');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "type": switch (this) {
        DerniereOffreEmploiConsultee() => "offre_emploi",
        DerniereOffreImmersionConsultee() => "immersion",
        DerniereOffreServiceCiviqueConsultee() => "service_civique",
      },
      "data": switch (this) {
        final DerniereOffreEmploiConsultee offre => offre.offreEmploi.toJson(),
        final DerniereOffreImmersionConsultee offre => offre.immersion.toJson(),
        final DerniereOffreServiceCiviqueConsultee offre => offre.serviceCivique.toJson(),
      },
    };
  }
}

class DerniereOffreEmploiConsultee extends DerniereOffreConsultee {
  final OffreEmploi offreEmploi;

  DerniereOffreEmploiConsultee(this.offreEmploi);

  @override
  List<Object?> get props => [offreEmploi];
}

class DerniereOffreImmersionConsultee extends DerniereOffreConsultee {
  final Immersion immersion;

  DerniereOffreImmersionConsultee(this.immersion);

  @override
  List<Object?> get props => [immersion];
}

class DerniereOffreServiceCiviqueConsultee extends DerniereOffreConsultee {
  final ServiceCivique serviceCivique;

  DerniereOffreServiceCiviqueConsultee(this.serviceCivique);

  @override
  List<Object?> get props => [serviceCivique];
}
