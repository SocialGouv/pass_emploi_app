import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/contact_immersion/contact_immersion_actions.dart';
import 'package:pass_emploi_app/features/contact_immersion/contact_immersion_state.dart';
import 'package:pass_emploi_app/models/requests/contact_immersion_request.dart';
import 'package:pass_emploi_app/repositories/contact_immersion_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('ContactImmersion', () {
    final sut = StoreSut();

    group("when requesting", () {
      sut.when(
        () => ContactImmersionRequestAction(
          ContactImmersionRequest(
            mockImmersionDetails(),
            "Philippe",
            "Flopflip",
            "philippe.flopflip@magiciens.com",
            "Bonjour, j'aimerai faire une immersion dans votre salon de magie.",
          ),
        ),
      );

      test('should load then succeed when request succeed', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.contactImmersionRepository = ContactImmersionRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.contactImmersionRepository = ContactImmersionRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<ContactImmersionLoadingState>((state) => state.contactImmersionState);

Matcher _shouldFail() => StateIs<ContactImmersionFailureState>((state) => state.contactImmersionState);

Matcher _shouldSucceed() {
  return StateIs<ContactImmersionSuccessState>(
    (state) => state.contactImmersionState,
  );
}

class ContactImmersionRepositorySuccessStub extends ContactImmersionRepository {
  ContactImmersionRepositorySuccessStub() : super(DioMock());

  @override
  Future<bool?> post(details) async {
    return true;
  }
}

class ContactImmersionRepositoryErrorStub extends ContactImmersionRepository {
  ContactImmersionRepositoryErrorStub() : super(DioMock());

  @override
  Future<bool?> post(details) async {
    return null;
  }
}
