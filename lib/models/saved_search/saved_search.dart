import 'package:pass_emploi_app/models/location.dart';

abstract class SavedSearch {
  String getId();

  String getTitle();

  Location? getLocation();
}
