import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/rating_repository.dart';

import '../doubles/spies.dart';

void main() {
  final RatingRepository repository = RatingRepository(FlutterSecureStorageSpy());

  test("Show rating if user didn't rate it yet", () async {
    // When
    final show = await repository.shouldShowRating();

    // Then
    expect(show, isTrue);
  });


  test("Doesn't show rating if user already rated it", () async {
    // Given
    repository.setRatingDone();

    // When
    final show = await repository.shouldShowRating();

    // Then
    expect(show, isFalse);
  });
}
