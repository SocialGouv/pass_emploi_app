import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/favori/list_v2/favori_list_v2_actions.dart';
import 'package:pass_emploi_app/features/favori/list_v2/favori_list_v2_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('Favori List V2', () {
    final sut = StoreSut();
    final repository = MockGetFavorisRepository();

    group("when requesting", () {
      sut.when(() => FavoriListV2RequestAction());

      test('should load then succeed when request succeed', () {
        when(() => repository.getFavoris('id')).thenAnswer((_) async => [mockFavori()]);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.getFavorisRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        when(() => repository.getFavoris('id')).thenAnswer((_) async => null);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.getFavorisRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<FavoriListV2LoadingState>((state) => state.favoriListV2State);

Matcher _shouldFail() => StateIs<FavoriListV2FailureState>((state) => state.favoriListV2State);

Matcher _shouldSucceed() {
  return StateIs<FavoriListV2SuccessState>(
    (state) => state.favoriListV2State,
    (state) => expect(state.results, [mockFavori()]),
  );
}
