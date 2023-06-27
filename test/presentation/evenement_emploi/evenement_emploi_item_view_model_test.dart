import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi.dart';
import 'package:pass_emploi_app/presentation/evenement_emploi/evenement_emploi_item_view_model.dart';

void main() {
  test('create from evenement emploi', () {
    // Given
    final evenement = EvenementEmploi(
      id: 'id',
      type: 'Atelier',
      titre: 'Titre',
      ville: 'Dijon',
      codePostal: '21000',
      dateDebut: DateTime(2021, 1, 20, 10, 0),
      dateFin: DateTime(2021, 1, 20, 12, 30),
      modalites: [],
    );

    // When
    final viewModel = EvenementEmploiItemViewModel.create(evenement);

    // Then
    expect(
      viewModel,
      EvenementEmploiItemViewModel(
        id: 'id',
        type: 'Atelier',
        titre: 'Titre',
        locationLabel: '21000 Dijon',
        dateLabel: '20 janvier 2021',
        heureLabel: '10h - 12h30',
      ),
    );
  });
}
