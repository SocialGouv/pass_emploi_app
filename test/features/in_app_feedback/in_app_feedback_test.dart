import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/in_app_feedback/in_app_feedback_actions.dart';
import 'package:pass_emploi_app/features/in_app_feedback/in_app_feedback_state.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('InAppFeedback', () {
    final sut = StoreSut();
    final repository = MockInAppFeedbackRepository();

    group("when requesting for feature", () {
      sut.whenDispatchingAction(() => InAppFeedbackRequestAction('feature-1'));

      test('and feedback activated', () {
        when(() => repository.isFeedbackActivated('feature-1')).thenAnswer((_) async => true);

        sut.givenStore = givenState().store((f) => {f.inAppFeedbackRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([
          _expectedResult('feature-1', null),
          _expectedResult('feature-1', true),
        ]);
      });

      test('and feedback not activated', () {
        when(() => repository.isFeedbackActivated('feature-1')).thenAnswer((_) async => false);

        sut.givenStore = givenState().store((f) => {f.inAppFeedbackRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([
          _expectedResult('feature-1', null),
          _expectedResult('feature-1', false),
        ]);
      });
    });

    group("when dismissing for feature", () {
      sut.whenDispatchingAction(() => InAppFeedbackDismissAction('feature-1'));

      test('should update state and call repository', () {
        when(() => repository.dismissFeedback('feature-1')).thenAnswer((_) async {});

        sut.givenStore = givenState()
            .copyWith(inAppFeedbackState: InAppFeedbackState(feedbackActivationForFeatures: {'feature-1': true}))
            .store((f) => {f.inAppFeedbackRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_expectedResult('feature-1', false)]);
        verify(() => repository.dismissFeedback('feature-1')).called(1);
      });
    });
  });
}

Matcher _expectedResult(String feature, bool? expected) {
  return StateIs<InAppFeedbackState>(
    (state) => state.inAppFeedbackState,
    (state) => expect(state.feedbackActivationForFeatures[feature], expected),
  );
}
