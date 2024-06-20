import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/tracking/tracking_evenement_engagement_action.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  late MockEvenementEngagementRepository repository;
  final user = mockUser();

  setUp(() {
    repository = MockEvenementEngagementRepository();
    registerFallbackValue(user);
  });

  test("Tracking event action should call repository", () async {
    // Given
    final store = givenState()
        .copyWith(loginState: LoginSuccessState(user))
        .store((f) => {f.evenementEngagementRepository = repository});
    when(() => repository.send(user: user, event: EvenementEngagement.MESSAGE_ENVOYE)).thenAnswer((_) async => true);

    // When
    store.dispatch(TrackingEvenementEngagementAction(EvenementEngagement.MESSAGE_ENVOYE));

    // Then
    verify(() => repository.send(user: user, event: EvenementEngagement.MESSAGE_ENVOYE)).called(1);
  });

  test("Tracking event action not should call repository on demo mode", () async {
    // Given
    final store = givenState().loggedIn().withDemoMode().store((f) => {f.evenementEngagementRepository = repository});

    // When
    store.dispatch(TrackingEvenementEngagementAction(EvenementEngagement.MESSAGE_ENVOYE));

    // Then
    verifyNever(
      () => repository.send(
        user: any(named: 'user'),
        event: EvenementEngagement.MESSAGE_ENVOYE,
      ),
    );
  });
}
