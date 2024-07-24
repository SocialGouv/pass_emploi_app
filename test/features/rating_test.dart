import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/rating/rating_state.dart';
import 'package:pass_emploi_app/models/details_jeune.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';
import 'package:pass_emploi_app/repositories/rating_repository.dart';

import '../doubles/dio_mock.dart';
import '../doubles/fixtures.dart';
import '../doubles/mocks.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  test("Show rating app when user didn't rate it and use app for a month", () async {
    // Given
    final store = givenState().loggedIn().store((factory) => {
          factory.ratingRepository = RatingRepositorySuccessStub(),
          factory.detailsJeuneRepository = DetailsJeuneRepositorySinceOneMonthStub(),
        });

    final successState = store.onChange.firstWhere((e) => e.ratingState is ShowRatingState);

    // When
    await store.dispatch(LoginSuccessAction(mockUser()));

    // Then
    final successAppState = await successState;
    expect(successAppState.ratingState, isA<ShowRatingState>());
  });

  test("Returns not initialized rating state when user use app for less than a month", () async {
    // Given
    final store = givenState().loggedIn().store((factory) => {
          factory.ratingRepository = RatingRepositoryAlreadyRatedStub(),
          factory.detailsJeuneRepository = DetailsJeuneRepositorySinceLessOneMonthStub(),
        });

    // When
    await store.dispatch(LoginSuccessAction(mockUser()));

    // Then
    expect(store.state.ratingState, isA<RatingNotInitializedState>());
  });

  test("Returns not initialized rating state when user already rate the app before", () async {
    // Given
    final store = givenState().loggedInPoleEmploiUser().store((factory) => {
          factory.ratingRepository = RatingRepositoryAlreadyRatedStub(),
          factory.detailsJeuneRepository = DetailsJeuneRepositorySinceOneMonthStub(),
        });

    // When
    await store.dispatch(LoginSuccessAction(mockUser()));

    // Then
    expect(store.state.ratingState, isA<RatingNotInitializedState>());
  });
}

class RatingRepositorySuccessStub extends RatingRepository {
  RatingRepositorySuccessStub() : super(MockFlutterSecureStorage());

  @override
  Future<bool> shouldShowRating() async {
    return true;
  }
}

class RatingRepositoryAlreadyRatedStub extends RatingRepository {
  RatingRepositoryAlreadyRatedStub() : super(MockFlutterSecureStorage());

  @override
  Future<bool> shouldShowRating() async {
    return false;
  }
}

class DetailsJeuneRepositorySinceLessOneMonthStub extends DetailsJeuneRepository {
  DetailsJeuneRepositorySinceLessOneMonthStub() : super(DioMock());

  @override
  Future<DetailsJeune?> fetch(String userId) async {
    return detailsJeuneSinceLessThanOneMonth();
  }
}

class DetailsJeuneRepositorySinceOneMonthStub extends DetailsJeuneRepository {
  DetailsJeuneRepositorySinceOneMonthStub() : super(DioMock());

  @override
  Future<DetailsJeune?> fetch(String userId) async {
    return detailsJeuneSinceOneMonth();
  }
}
