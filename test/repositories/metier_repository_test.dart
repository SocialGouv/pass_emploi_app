import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/repositories/metier_repository.dart';

main() {
  group("_getMetiers should return ...", () {
    final MetierRepository repository = MetierRepository();

    test("filtered list of metier when user input matches metier libelle", () {
      expect(repository.getMetiers("Dessin BTP et paysage"), _matchesBtpEtPaysageMetier());
    });

    test("filtered list of metier when user input has different cases in the metier name", () {
      expect(repository.getMetiers("dessin btp et paysage"), _matchesBtpEtPaysageMetier());
      expect(repository.getMetiers("DESSIN BTP ET PAYSAGE"), _matchesBtpEtPaysageMetier());
      expect(repository.getMetiers("DeSSin BTP eT paYSAgE"), _matchesBtpEtPaysageMetier());
    });

    test("filtered list of metier when user input not complete", () {
      expect(repository.getMetiers("paysage"), _matchesBtpEtPaysageMetiers());
    });

    test("empty list when user input is empty", () {
      expect(repository.getMetiers(""), []);
    });

    test("empty list when user input contains only one character", () {
      expect(repository.getMetiers("d"), []);
    });

    test("filtered list of metier when user input contains diacritics in the department name", () {
      expect(repository.getMetiers("hôtellerie"), _matchesHotellerieMetiers());
      expect(repository.getMetiers("hotellerie"), _matchesHotellerieMetiers());
    });

    test("filtered list of metier when user input contains spaces in the department name", () {
      expect(repository.getMetiers("Expertise technique couleur en industrie"),
          Metier.values.where((m) => m.codeRome == "H1201"));
      expect(repository.getMetiers("Personnel d attractions"), Metier.values.where((m) => m.codeRome == "G1205"));
      expect(repository.getMetiers("           Chaudronnerie    tôlerie   "),
          Metier.values.where((m) => m.codeRome == "H2902"));
    });
  });
}

Iterable<Metier> _matchesHotellerieMetiers() =>
    Metier.values.where((m) => m.codeRome == "G1502" || m.codeRome == "G1701" || m.codeRome == "G1703");

Iterable<Metier> _matchesBtpEtPaysageMetier() => Metier.values.where((m) => m.codeRome == "F1104");

Iterable<Metier> _matchesBtpEtPaysageMetiers() => Metier.values.where((m) => m.codeRome == "F1104" || m.codeRome == "F1101" || m.codeRome == "F1201");
