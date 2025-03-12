import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/service_civique.dart';

sealed class OffreDto extends Equatable {
  static OffreDto fromJson(dynamic json) {
    final String type = json['type'] as String;
    return switch (type) {
      'offre_emploi' => OffreEmploiDto(OffreEmploi.fromJson(json['data'])),
      'immersion' => OffreImmersionDto(Immersion.fromJson(json['data'])),
      'service_civique' => OffreServiceCiviqueDto(ServiceCivique.fromJson(json['data'])),
      _ => throw Exception('Unknown type $type')
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "type": switch (this) {
        OffreEmploiDto() => "offre_emploi",
        OffreImmersionDto() => "immersion",
        OffreServiceCiviqueDto() => "service_civique",
      },
      "data": switch (this) {
        final OffreEmploiDto offre => offre.offreEmploi.toJson(),
        final OffreImmersionDto offre => offre.immersion.toJson(),
        final OffreServiceCiviqueDto offre => offre.serviceCivique.toJson(),
      },
    };
  }

  String get id => switch (this) {
        final OffreEmploiDto offre => offre.offreEmploi.id,
        final OffreImmersionDto offre => offre.immersion.id,
        final OffreServiceCiviqueDto offre => offre.serviceCivique.id,
      };

  String get title => switch (this) {
        final OffreEmploiDto offre => offre.offreEmploi.title,
        final OffreImmersionDto offre => offre.immersion.metier,
        final OffreServiceCiviqueDto offre => offre.serviceCivique.domain ?? "",
      };
}

class OffreEmploiDto extends OffreDto {
  final OffreEmploi offreEmploi;

  OffreEmploiDto(this.offreEmploi);

  @override
  List<Object?> get props => [offreEmploi];
}

class OffreImmersionDto extends OffreDto {
  final Immersion immersion;

  OffreImmersionDto(this.immersion);

  @override
  List<Object?> get props => [immersion];
}

class OffreServiceCiviqueDto extends OffreDto {
  final ServiceCivique serviceCivique;

  OffreServiceCiviqueDto(this.serviceCivique);

  @override
  List<Object?> get props => [serviceCivique];
}
