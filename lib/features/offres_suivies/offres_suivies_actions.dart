import 'package:pass_emploi_app/models/offre_dto.dart';
import 'package:pass_emploi_app/models/offre_suivie.dart';

class OffresSuiviesWriteAction {
  final OffreDto offreDto;

  OffresSuiviesWriteAction(this.offreDto);
}

class OffresSuiviesDeleteAction {
  final OffreSuivie offreSuivie;

  OffresSuiviesDeleteAction(this.offreSuivie);
}

class OffresSuiviesToStateAction {
  final List<OffreSuivie> offresSuivies;

  OffresSuiviesToStateAction(this.offresSuivies);
}
