import 'package:pass_emploi_app/models/location.dart';

extension LocationDisplayableExtension on Location {
  String displayableLabel() => '$libelle ${displayableCode()}';

  String displayableCode() {
    switch (type) {
      case LocationType.COMMUNE:
        return '($codePostal)';
      case LocationType.DEPARTMENT:
        return '($code)';
    }
  }
}
