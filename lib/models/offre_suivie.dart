import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_dto.dart';

class OffreSuivie extends Equatable {
  final OffreDto offreDto;
  final DateTime dateConsultation;

  OffreSuivie({
    required this.offreDto,
    required this.dateConsultation,
  });

  @override
  List<Object?> get props => [offreDto, dateConsultation];

  static OffreSuivie fromJson(Map<String, dynamic> json) {
    return OffreSuivie(
      offreDto: OffreDto.fromJson(json['offre']),
      dateConsultation: DateTime.parse(json['dateConsultation'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "offre": offreDto.toJson(),
      "dateConsultation": dateConsultation.toIso8601String(),
    };
  }
}
