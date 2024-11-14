import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/derniere_offre_consultee.dart';

class DerniereOffreConsulteeState extends Equatable {
  final DerniereOffreConsultee? offre;

  DerniereOffreConsulteeState({this.offre});

  @override
  List<Object?> get props => [offre];
}
