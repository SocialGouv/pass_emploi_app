import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/generic/generic_actions.dart';
import 'package:pass_emploi_app/features/generic/generic_state.dart';
import 'package:pass_emploi_app/models/details_jeune.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('Details jeune', () {
    final sut = StoreSut();

    group("when requesting", () {
      sut.when(() => RequestAction<NoRequest, DetailsJeune>(NoRequest()));

      test('should load then succeed when request succeeds', () {
        sut.givenStore = givenState() //
            .loggedInMiloUser()
            .store((f) => {f.detailsJeuneRepository = DetailsJeuneRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fails', () {
        sut.givenStore = givenState() //
            .loggedInMiloUser()
            .store((f) => {f.detailsJeuneRepository = DetailsJeuneRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

class DetailsJeuneRepositorySuccessStub extends DetailsJeuneRepository {
  DetailsJeuneRepositorySuccessStub() : super(DioMock());

  @override
  Future<DetailsJeune?> fetch(String userId) async {
    return detailsJeune();
  }
}

class DetailsJeuneRepositoryErrorStub extends DetailsJeuneRepository {
  DetailsJeuneRepositoryErrorStub() : super(DioMock());

  @override
  Future<DetailsJeune?> fetch(String userId) async {
    return null;
  }
}

Matcher _shouldLoad() => StateIs<LoadingState<DetailsJeune>>((state) => state.detailsJeuneState);

Matcher _shouldFail() => StateIs<FailureState<DetailsJeune>>((state) => state.detailsJeuneState);

Matcher _shouldSucceed() => StateIs<SuccessState<DetailsJeune>>(
      (state) => state.detailsJeuneState,
      (state) => expect(state.data, detailsJeune()),
    );
