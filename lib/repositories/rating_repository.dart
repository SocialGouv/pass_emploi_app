import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RatingRepository {
  final FlutterSecureStorage _preferences;

  RatingRepository(this._preferences);

  Future<void> setRatingDone() async {
    await _preferences.write(key: 'ratingDone', value: 'rated');
  }

  Future<bool> shouldShowRating() async {
    // call
    final String? tutorialRead = await _preferences.read(key: 'ratingDone');
    return tutorialRead == null;
  }
}
