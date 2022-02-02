import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/repositories/metier_repository.dart';

String _sanitizeString(String str) {
  return _removeDiacritics(str).replaceAll(RegExp("[-'` ]"), "").trim().toUpperCase();
}

String _removeDiacritics(String str) {
  var withDia = 'ÀÁÂÃÄàáâäÒÓÔÕÕÖòóôõöÈÉÊËèéêëÇçÌÍÎÏìíîïÙÚÛÜùúûü';
  var withoutDia = 'AAAAAaaaaOOOOOOoooooEEEEeeeeCcIIIIiiiiUUUUuuuu';

  for (int i = 0; i < withDia.length; i++) {
    str = str.replaceAll(withDia[i], withoutDia[i]);
  }

  return str;
}

main() {
  group("_getMetiers should return ...", () {
    final MetierRepository repository = MetierRepository();

    test("filtered list of metier when user input matches metier libelle", () {
      matchesBtpEtPaysageMetier(repository.getMetiers("Dessin BTP et paysage"));
    });

    test("filtered list of metier when user input has different cases in the metier name", () {
      matchesBtpEtPaysageMetier(repository.getMetiers("dessin btp et paysage"));
      matchesBtpEtPaysageMetier(repository.getMetiers("DESSIN BTP ET PAYSAGE"));
      matchesBtpEtPaysageMetier(repository.getMetiers("DeSSin BTP eT paYSAgE"));
    });

    test("filtered list of metier when user input not complete", () {
      expect(repository.getMetiers("paysage").length, 6);
    });

    test("empty list when user input is empty", () {
      expect(repository.getMetiers(""), []);
    });

    test("empty list when user input contains only one character", () {
      expect(repository.getMetiers("d"), []);
    });

    test("filtered list of metier when user input contains diacritics in the department name", () {
      expect(repository.getMetiers("hôtellerie").length,28);
      expect(repository.getMetiers("hotellerie").length,28);
    });

    test("filtered list of metier when user input contains spaces in the department name", () {
      expect(repository.getMetiers("Expertise technique couleur en industrie").length, 1);
      expect(repository.getMetiers("Expertise technique couleur en industrie").first.codeRome, "H1201");

      expect(repository.getMetiers("Personnel d attractions").length, 1);
      expect(repository.getMetiers("Personnel d attractions").first.codeRome, "G1205");

      expect(repository.getMetiers("           Chaudronnerie    tôlerie   ").length, 2);
      expect(repository.getMetiers("           Chaudronnerie    tôlerie   ").first.codeRome, "H2902");
    });
  });
}

void matchesBtpEtPaysageMetier(Iterable<Metier> value) {
  expect(value.length, 1);
  expect(value.first.codeRome, "F1104");
}

Iterable<Metier> _matchesHotellerieMetiers() =>
    Metier.values.where((m) => ["G1502", "G1701", "G1703"].contains(m.codeRome));

Iterable<Metier> _matchesBtpEtPaysageMetier() => Metier.values.where((m) => m.codeRome == "F1104");

Iterable<Metier> _matchesBtpEtPaysageMetiers() =>
    Metier.values.where((m) => ["F1104", "F1101", "F1201"].contains(m.codeRome));
