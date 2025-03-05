import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/offre_dto.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_suivie.dart';

import '../doubles/fixtures.dart';

void main() {
  test('OffreSuivie should be equal', () {
    final OffreSuivie offreSuivie = OffreSuivie(
      offreDto: OffreEmploiDto(mockOffreEmploi(origin: PartenaireOrigin(name: 'Indeed', logoUrl: 'url'))),
      dateConsultation: DateTime.now(),
    );

    expect(offreSuivie, offreSuivie);
  });
}
