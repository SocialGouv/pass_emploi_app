import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/repositories/metier_repository.dart';

main() {
  group("_getMetiers should return ...", () {
    final MetierRepository repository = MetierRepository();

    test("filtered list of metier when user input matches metier libelle", () async {
      matchesBtpEtPaysageMetier(await repository.getMetiers("Dessin BTP et paysage"));
    });

    test("filtered list of metier when user input has different cases in the metier name", () async {
      matchesBtpEtPaysageMetier(await repository.getMetiers("dessin btp et paysage"));
      matchesBtpEtPaysageMetier(await repository.getMetiers("DESSIN BTP ET PAYSAGE"));
      matchesBtpEtPaysageMetier(await repository.getMetiers("DeSSin BTP eT paYSAgE"));
    });

    test("filtered list of metier when user input not complete", () async {
      expect((await repository.getMetiers("paysage")).length, 6);
    });

    test("empty list when user input is empty", () async {
      expect(await repository.getMetiers(""), []);
    });

    test("empty list when user input contains only one character", () async {
      expect(await repository.getMetiers("d"), []);
    });

    test("filtered list of metier when user input contains diacritics in the department name", () async {
      expect((await repository.getMetiers("hôtellerie")).length, 28);
      expect((await repository.getMetiers("hotellerie")).length, 28);
    });

    test("filtered list of metier when user input contains spaces in the department name", () async {
      expect((await repository.getMetiers("Expertise technique couleur en industrie")).length, 1);
      expect((await repository.getMetiers("Expertise technique couleur en industrie")).first.codeRome, "H1201");

      expect((await repository.getMetiers("Personnel d attractions")).length, 1);
      expect((await repository.getMetiers("Personnel d attractions")).first.codeRome, "G1205");

      expect((await repository.getMetiers("           Chaudronnerie    tôlerie   ")).length, 2);
      expect((await repository.getMetiers("           Chaudronnerie    tôlerie   ")).first.codeRome, "H2902");
    });
  });
}

void matchesBtpEtPaysageMetier(Iterable<Metier> value) {
  expect(value.length, 1);
  expect(value.first.codeRome, "F1104");
}
