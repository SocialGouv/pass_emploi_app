import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

const _rendezvousId = 'rendezvousID';
final _expectedRendezvous = mockRendezvous();

void main() {
  group('Rendezvous details', () {
    final sut = StoreSut();
    final repository = MockRendezvousRepository();

    group("when requesting rendezvous for a Milo user", () {
      sut.whenDispatchingAction(() => RendezvousDetailsRequestAction(_rendezvousId));

      test('should load then succeed when request succeed', () {
        when(() => repository.getRendezvousMilo('id', _rendezvousId)).thenAnswer((_) async => _expectedRendezvous);

        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.rendezvousRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        when(() => repository.getRendezvousMilo('id', _rendezvousId)).thenAnswer((_) async => null);

        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.rendezvousRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<RendezvousDetailsState>((state) => state.rendezvousDetailsState);

Matcher _shouldFail() => StateIs<RendezvousDetailsState>((state) => state.rendezvousDetailsState);

Matcher _shouldSucceed() {
  return StateIs<RendezvousDetailsSuccessState>(
    (state) => state.rendezvousDetailsState,
    (state) => expect(state.rendezvous, _expectedRendezvous),
  );
}
