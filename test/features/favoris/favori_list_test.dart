import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_actions.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('Favori List', () {
    final sut = StoreSut();
    final repository = MockGetFavorisRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => FavoriListRequestAction());

      test('should load then succeed when request succeed', () {
        when(() => repository.getFavoris('id')).thenAnswer((_) async => [mockFavori()]);

        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.getFavorisRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        when(() => repository.getFavoris('id')).thenAnswer((_) async => null);

        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.getFavorisRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<FavoriListLoadingState>((state) => state.favoriListState);

Matcher _shouldFail() => StateIs<FavoriListFailureState>((state) => state.favoriListState);

Matcher _shouldSucceed() {
  return StateIs<FavoriListSuccessState>(
    (state) => state.favoriListState,
    (state) => expect(state.results, [mockFavori()]),
  );
}
