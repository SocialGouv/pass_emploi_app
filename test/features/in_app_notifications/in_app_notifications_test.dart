import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/in_app_notifications/in_app_notifications_actions.dart';
import 'package:pass_emploi_app/features/in_app_notifications/in_app_notifications_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('InAppNotifications', () {
    final sut = StoreSut();
    final repository = MockInAppNotificationsRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => InAppNotificationsRequestAction());

      test('should load then succeed when request succeeds', () {
        when(() => repository.get("")).thenAnswer((_) async => [mockInAppNotification()]);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.inAppNotificationsRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fails', () {
        when(() => repository.get("")).thenAnswer((_) async => null);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.inAppNotificationsRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<InAppNotificationsLoadingState>((state) => state.inAppNotificationsState);

Matcher _shouldFail() => StateIs<InAppNotificationsFailureState>((state) => state.inAppNotificationsState);

Matcher _shouldSucceed() {
  return StateIs<InAppNotificationsSuccessState>(
    (state) => state.inAppNotificationsState,
    (state) {
      expect(state.result, [mockInAppNotification()]);
    },
  );
}
