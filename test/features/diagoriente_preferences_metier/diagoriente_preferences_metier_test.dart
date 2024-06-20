import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_actions.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_state.dart';
import 'package:pass_emploi_app/models/diagoriente_urls.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/repositories/diagoriente_metiers_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/diagoriente_urls_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('DiagorientePreferencesMetier', () {
    final sut = StoreSut();

    group("when requesting", () {
      sut.whenDispatchingAction(() => DiagorientePreferencesMetierRequestAction());

      test('should load successfully only if both requests succeed', () {
        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) {
          f.diagorienteMetiersFavorisRepository = DiagorienteMetiersFavorisRepositorySuccessStub();
          f.diagorienteUrlsRepository = DiagorientePreferencesMetierRepositorySuccessStub();
        });

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when url request fail', () {
        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) {
          f.diagorienteMetiersFavorisRepository = DiagorienteMetiersFavorisRepositorySuccessStub();
          f.diagorienteUrlsRepository = DiagorientePreferencesMetierRepositoryErrorStub();
        });

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });

      test('should load then fail when metiers favoris request fail', () {
        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) {
          f.diagorienteMetiersFavorisRepository = DiagorienteMetiersFavorisRepositoryErrorStub();
          f.diagorienteUrlsRepository = DiagorientePreferencesMetierRepositorySuccessStub();
        });

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });

      test('should load then fail when both request fail', () {
        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) {
          f.diagorienteMetiersFavorisRepository = DiagorienteMetiersFavorisRepositoryErrorStub();
          f.diagorienteUrlsRepository = DiagorientePreferencesMetierRepositoryErrorStub();
        });

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() =>
    StateIs<DiagorientePreferencesMetierLoadingState>((state) => state.diagorientePreferencesMetierState);

Matcher _shouldFail() =>
    StateIs<DiagorientePreferencesMetierFailureState>((state) => state.diagorientePreferencesMetierState);

Matcher _shouldSucceed() {
  return StateIs<DiagorientePreferencesMetierSuccessState>(
    (state) => state.diagorientePreferencesMetierState,
    (state) {
      expect(state.urls, mockDiagorienteUrls());
      expect(state.metiersFavoris, mockAutocompleteMetiers());
    },
  );
}

class DiagorientePreferencesMetierRepositorySuccessStub extends DiagorienteUrlsRepository {
  DiagorientePreferencesMetierRepositorySuccessStub() : super(DioMock());

  @override
  Future<DiagorienteUrls?> getUrls(String userId) async => mockDiagorienteUrls();
}

class DiagorientePreferencesMetierRepositoryErrorStub extends DiagorienteUrlsRepository {
  DiagorientePreferencesMetierRepositoryErrorStub() : super(DioMock());

  @override
  Future<DiagorienteUrls?> getUrls(String userId) async => null;
}

class DiagorienteMetiersFavorisRepositorySuccessStub extends DiagorienteMetiersFavorisRepository {
  DiagorienteMetiersFavorisRepositorySuccessStub() : super(DioMock(), DummyPassEmploiCacheManager());

  @override
  Future<List<Metier>?> get(String userId, bool forceNoCache) async {
    return mockAutocompleteMetiers();
  }
}

class DiagorienteMetiersFavorisRepositoryErrorStub extends DiagorienteMetiersFavorisRepository {
  DiagorienteMetiersFavorisRepositoryErrorStub() : super(DioMock(), DummyPassEmploiCacheManager());

  @override
  Future<List<Metier>?> get(String userId, bool forceNoCache) async {
    return null;
  }
}
