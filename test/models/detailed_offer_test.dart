import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/detailed_offer.dart';

import '../doubles/fixtures.dart';
import '../utils/test_assets.dart';

main() {
  test('DetailedOffer.fromJson when complete data should deserialize data correctly', () {
    // Given
    final String detailedOfferString = loadTestAssets("detailed_offer.json");
    final detailedOfferJson = json.decode(detailedOfferString);
    //When - Then
    expect(DetailedOffer.fromJson(detailedOfferJson), mockedDetailedOffer());
  });
}