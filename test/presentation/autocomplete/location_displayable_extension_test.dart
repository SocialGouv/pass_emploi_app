import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/autocomplete/location_displayable_extension.dart';

void main() {
  final commune = Location(
    libelle: 'libelle',
    code: 'code',
    codePostal: 'codePostal',
    type: LocationType.COMMUNE,
    latitude: 0,
    longitude: 0,
  );

  final departement = Location(
    libelle: 'libelle',
    code: 'code',
    codePostal: 'codePostal',
    type: LocationType.DEPARTMENT,
    latitude: 0,
    longitude: 0,
  );

  group('displayableCode', () {
    test('when location is of type COMMUNE should use code postal', () {
      expect(commune.displayableCode(), '(codePostal)');
    });

    test('when location is of type DEPARTMENT should use code', () {
      expect(departement.displayableCode(), '(code)');
    });
  });

  group('displayableLabel', () {
    test('when location is of type COMMUNE should use code postal', () {
      expect(commune.displayableLabel(), 'libelle (codePostal)');
    });

    test('when location is of type DEPARTMENT should use code', () {
      expect(departement.displayableLabel(), 'libelle (code)');
    });
  });
}
