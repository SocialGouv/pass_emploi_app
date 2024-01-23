import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/user_action/details/user_action_details_actions.dart';
import 'package:pass_emploi_app/features/user_action/details/user_action_details_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

final _expectedAction = mockUserAction();

void main() {
  group('UserActionDetails', () {
    final sut = StoreSut();
    final repository = MockUserActionRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => UserActionDetailsRequestAction('actionId'));

      test('should load then succeed when request succeeds', () {
        when(() => repository.getUserAction('actionId')).thenAnswer((_) async => _expectedAction);

        sut.givenStore = givenState() //
            .store((f) => {f.userActionRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fails', () {
        when(() => repository.getUserAction('actionId')).thenAnswer((_) async => null);

        sut.givenStore = givenState() //
            .store((f) => {f.userActionRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<UserActionDetailsLoadingState>((state) => state.userActionDetailsState);

Matcher _shouldFail() => StateIs<UserActionDetailsFailureState>((state) => state.userActionDetailsState);

Matcher _shouldSucceed() {
  return StateIs<UserActionDetailsSuccessState>(
    (state) => state.userActionDetailsState,
    (state) => expect(state.result, _expectedAction),
  );
}
