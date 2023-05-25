import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

const _rendezvousId = 'rendezvousID';
final _expectedRendezvous = mockRendezvous();

void main() {
  group('Rendezvous details', () {
    final sut = StoreSut();

    group("when requesting rendezvous", () {
      sut.when(() => RendezvousDetailsRequestAction(_rendezvousId));

      test('should load then succeed when request succeed', () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.rendezvousRepository = RendezvousRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.rendezvousRepository = RendezvousRepositoryErrorStub()});

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

class RendezvousRepositorySuccessStub extends RendezvousRepository {
  RendezvousRepositorySuccessStub() : super(DioMock());

  @override
  Future<Rendezvous?> getRendezvous(String userId, String rendezvousId) async {
    return userId == 'id' && rendezvousId == _rendezvousId ? _expectedRendezvous : null;
  }
}

class RendezvousRepositoryErrorStub extends RendezvousRepository {
  RendezvousRepositoryErrorStub() : super(DioMock());

  @override
  Future<Rendezvous?> getRendezvous(String userId, String rendezvousId) async {
    return null;
  }
}
