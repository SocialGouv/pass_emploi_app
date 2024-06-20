import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/tracking/tracking_evenement_engagement_action.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  late MockEvenementEngagementRepository repository;

  setUp(() {
    repository = MockEvenementEngagementRepository();
    when(
      () => repository.send(
        userId: "id",
        event: EvenementEngagement.MESSAGE_ENVOYE,
        loginMode: LoginMode.MILO,
        brand: Brand.cej,
      ),
    ).thenAnswer((_) async => true);
  });

  test("Tracking event action should call repository", () async {
    // Given
    final store = givenState().loggedIn().store((f) => {f.evenementEngagementRepository = repository});
    when(
      () => repository.send(
        userId: "id",
        event: EvenementEngagement.MESSAGE_ENVOYE,
        loginMode: LoginMode.MILO,
        brand: Brand.cej,
      ),
    ).thenAnswer((_) async => true);

    // When
    store.dispatch(TrackingEvenementEngagementAction(EvenementEngagement.MESSAGE_ENVOYE));

    // Then
    verify(
      () => repository.send(
        userId: "id",
        event: EvenementEngagement.MESSAGE_ENVOYE,
        loginMode: LoginMode.MILO,
        brand: Brand.cej,
      ),
    ).called(1);
  });

  test("Tracking event action should call repository with proper brand", () async {
    // Given
    final store =
        givenPassEmploiState().loggedInPoleEmploiUser().store((f) => {f.evenementEngagementRepository = repository});
    when(
      () => repository.send(
        userId: "id",
        event: EvenementEngagement.MESSAGE_ENVOYE,
        loginMode: LoginMode.POLE_EMPLOI,
        brand: Brand.passEmploi,
      ),
    ).thenAnswer((_) async => true);

    // When
    store.dispatch(TrackingEvenementEngagementAction(EvenementEngagement.MESSAGE_ENVOYE));

    // Then
    verify(
      () => repository.send(
        userId: "id",
        event: EvenementEngagement.MESSAGE_ENVOYE,
        loginMode: LoginMode.POLE_EMPLOI,
        brand: Brand.passEmploi,
      ),
    ).called(1);
  });

  test("Tracking event action not should call repository on demo mode", () async {
    // Given
    final store = givenState().loggedIn().withDemoMode().store((f) => {f.evenementEngagementRepository = repository});

    // When
    store.dispatch(TrackingEvenementEngagementAction(EvenementEngagement.MESSAGE_ENVOYE));

    // Then
    verifyNever(
      () => repository.send(
        userId: "id",
        event: EvenementEngagement.MESSAGE_ENVOYE,
        loginMode: LoginMode.MILO,
        brand: Brand.cej,
      ),
    );
  });
}
