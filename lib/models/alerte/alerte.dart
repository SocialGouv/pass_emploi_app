import 'package:pass_emploi_app/models/location.dart';

abstract class Alerte {
  String getId();

  String getTitle();

  Location? getLocation();
}
