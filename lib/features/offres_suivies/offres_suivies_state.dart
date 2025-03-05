import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_suivie.dart';

class OffresSuiviesState extends Equatable {
  final List<OffreSuivie> offresSuivies;

  OffresSuiviesState({this.offresSuivies = const []});

  @override
  List<Object?> get props => [offresSuivies];
}
