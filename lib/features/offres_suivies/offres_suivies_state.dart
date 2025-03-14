import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_suivie.dart';

class OffresSuiviesState extends Equatable {
  final List<OffreSuivie> offresSuivies;
  final OffreSuivie? confirmationOffre;

  OffresSuiviesState({this.offresSuivies = const [], this.confirmationOffre});

  @override
  List<Object?> get props => [offresSuivies];
}

extension OffresSuiviesStateExt on OffresSuiviesState {
  bool isPresent(String offreId) => offresSuivies.any((offreSuivie) => offreSuivie.offreDto.id == offreId);
  OffreSuivie? getOffre(String offreId) =>
      offresSuivies.firstWhereOrNull((offreSuivie) => offreSuivie.offreDto.id == offreId);
}
