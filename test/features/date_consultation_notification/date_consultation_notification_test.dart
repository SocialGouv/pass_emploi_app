import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/date_consultation_notification/date_consultation_notification_actions.dart';
import 'package:pass_emploi_app/features/date_consultation_notification/date_consultation_notification_state.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('DateConsultationNotification', () {
    final sut = StoreSut();
    final repository = MockDateConsultationNotificationRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => DateConsultationNotificationRequestAction());

      test('should load date', () {
        when(() => repository.get()).thenAnswer((_) async => DateTime.utc(2022, 1, 1));

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.dateConsultationNotificationRepository = repository});

        sut.thenExpectAtSomePoint(_shouldSucceed());
      });
    });

    group("when writing date", () {
      sut.whenDispatchingAction(() => DateConsultationNotificationWriteAction(DateTime.utc(2022, 1, 1)));

      test('should write date', () {
        when(() => repository.save(any())).thenAnswer((_) async {});

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.dateConsultationNotificationRepository = repository});

        sut.thenExpectAtSomePoint(_shouldSucceed());
      });
    });
  });
}

Matcher _shouldSucceed() {
  return StateIs<DateConsultationNotificationState>(
    (state) => state.dateConsultationNotificationState,
    (state) {
      expect(state.date, DateTime.utc(2022, 1, 1));
    },
  );
}
