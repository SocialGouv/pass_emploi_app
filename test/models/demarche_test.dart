import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/demarche.dart';

void main() {
  test('should transform demarche personnalisee with proper title', () {
    final demarche = Demarche.fromJson({
      "id": "1",
      "codeDemarche": "eyJxdW9pIjoiUTAxIiwiY29tbWVudCI6IkMwMS4wNSJ9",
      "contenu": "Identification de ses compétences avec pole-emploi.fr",
      "dateModification": null,
      "statut": "EN_COURS",
      "dateFin": "2021-12-21T09:00:00.000Z",
      "label": "Mon (nouveau) métier",
      "titre": "Action issue de l’application CEJ",
      "sousTitre": "Par un autre moyen",
      "dateCreation": "2022-05-11T09:04:00.000Z",
      "attributs": [
        {
          "cle": "any",
          "valeur": "J'adore les cornichons",
        }
      ],
      "statutsPossibles": ["ANNULEE", "REALISEE", "A_FAIRE", "EN_COURS"],
      "modifieParConseiller": false,
      "creeeParConseiller": true,
    });
    expect(demarche.titre, "J'adore les cornichons");
  });
}
