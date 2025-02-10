import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/repositories/remote_campagne_accueil_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/mocks.dart';
import '../doubles/spies.dart';

void main() {
  late FlutterSecureStorageSpy mockFlutterSecureStorage;
  late MockRemoteConfigRepository remoteConfigRepository;
  late RemoteCampagneAccueilRepository remoteCampagneAccueilRepository;

  setUp(() {
    mockFlutterSecureStorage = FlutterSecureStorageSpy();
    remoteConfigRepository = MockRemoteConfigRepository();
    remoteCampagneAccueilRepository = RemoteCampagneAccueilRepository(
      remoteConfigRepository,
      mockFlutterSecureStorage,
    );
  });

  group('RemoteCampagneAccueilRepository', () {
    group('getCampagnes', () {
      test('should show campagnes dismissed campagnes is null', () async {
        // Given
        when(() => remoteConfigRepository.campagnesAccueil()).thenReturn([
          mockRemoteCampagneAccueil(),
        ]);

        // When
        final campagnes = await remoteCampagneAccueilRepository.getCampagnes();

        // Then
        expect(campagnes, [mockRemoteCampagneAccueil()]);
      });

      test('should not show dismissed campagnes', () async {
        // Given
        final map = {"1": DateTime.now().millisecondsSinceEpoch};
        await mockFlutterSecureStorage.write(key: 'campagne-accueil', value: jsonEncode(map));
        when(() => remoteConfigRepository.campagnesAccueil()).thenReturn([
          mockRemoteCampagneAccueil(id: "1"),
          mockRemoteCampagneAccueil(id: "2"),
        ]);

        // When
        final campagnes = await remoteCampagneAccueilRepository.getCampagnes();

        // Then
        expect(campagnes, [mockRemoteCampagneAccueil(id: "2")]);
      });
    });

    group('dismissCampagne', () {
      test('should dismiss campagne', () async {
        // Given
        final map = {"1": DateTime(2024).millisecondsSinceEpoch};
        await mockFlutterSecureStorage.write(key: 'campagne-accueil', value: jsonEncode(map));

        // When
        await remoteCampagneAccueilRepository.dismissCampagne("3");

        // Then
        final result = await remoteCampagneAccueilRepository.getDismissedCampagnes();
        expect(result.containsKey("1"), true);
        expect(result.containsKey("3"), true);
      });
    });
  });
}
