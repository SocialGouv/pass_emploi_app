import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/partage_activite/partage_activite_actions.dart';
import 'package:pass_emploi_app/features/partage_activite/partage_activites_state.dart';
import 'package:pass_emploi_app/models/partage_activite.dart';
import 'package:pass_emploi_app/repositories/partage_activite_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/dummies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("PartageActivite should be fetched and displayed when screen loads", () async {
    // Given

    final store = givenState()
        .loggedInMiloUser()
        .store((factory) => {factory.partageActiviteRepository = PartageActiviteRepositorySuccessStub()});

    final displayedLoading = store.onChange.any((e) => e.partageActiviteState is PartageActiviteLoadingState);
    final successState = store.onChange.firstWhere((e) => e.partageActiviteState is PartageActiviteSuccessState);

    // When
    store.dispatch(PartageActiviteRequestAction());

    // Then
    expect(await displayedLoading, true);
    final appState = await successState;
    expect((appState.partageActiviteState as PartageActiviteSuccessState).preferences.partageFavoris, true);
  });

  test("PartageActivite should be loaded and error displayed when repository returns null", () async {
    // Given
    final store = givenState()
        .loggedInMiloUser()
        .store((factory) => {factory.partageActiviteRepository = PartageActiviteRepositoryFailureStub()});

    final displayedLoading = store.onChange.any((e) => e.partageActiviteState is PartageActiviteLoadingState);
    final displayedError = store.onChange.any((e) => e.partageActiviteState is PartageActiviteFailureState);

    // When
    store.dispatch(PartageActiviteRequestAction());

    // Then
    expect(await displayedLoading, true);
    expect(await displayedError, true);
  });
}

class PartageActiviteRepositorySuccessStub extends PartageActiviteRepository {
  PartageActiviteRepositorySuccessStub() : super(DioMock(), DummyPassEmploiCacheManager());

  @override
  Future<PartageActivite?> getPartageActivite(String userId) async {
    return PartageActivite(partageFavoris: true);
  }
}

class PartageActiviteRepositoryFailureStub extends PartageActiviteRepository {
  PartageActiviteRepositoryFailureStub() : super(DioMock(), DummyPassEmploiCacheManager());

  @override
  Future<PartageActivite?> getPartageActivite(String userId) async {
    return null;
  }
}