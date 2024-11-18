import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_dto.dart';

class DerniereOffreConsulteeState extends Equatable {
  final OffreDto? offre;

  DerniereOffreConsulteeState({this.offre});

  @override
  List<Object?> get props => [offre];
}
