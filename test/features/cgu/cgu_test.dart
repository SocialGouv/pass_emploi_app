import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/cgu/cgu_actions.dart';
import 'package:pass_emploi_app/features/cgu/cgu_state.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/cgu.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('CGU', () {
    final sut = StoreSut();
    late MockDetailsJeuneRepository detailsJeuneRepository;
    late MockRemoteConfigRepository remoteConfigRepository;

    setUp(() {
      detailsJeuneRepository = MockDetailsJeuneRepository();
      remoteConfigRepository = MockRemoteConfigRepository();
    });

    group("on logged in", () {
      sut.whenDispatchingAction(() => LoginSuccessAction(mockUser(id: 'id-bénéficiaire')));

      test('should not accept CGU when already accepted', () {
        final detailsJeune = mockDetailsJeune(dateSignatureCgu: DateTime(2025));
        final cgu = Cgu(lastUpdate: DateTime(2024), changes: []);

        when(() => detailsJeuneRepository.get('id-bénéficiaire')).thenAnswer((_) async => detailsJeune);
        when(() => remoteConfigRepository.getCgu()).thenReturn(cgu);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {
                  f.detailsJeuneRepository = detailsJeuneRepository,
                  f.remoteConfigRepository = remoteConfigRepository,
                });

        sut.thenExpectChangingStatesThroughOrder([_shouldNotAcceptCgu()]);
      });

      test('should accept CGU when available but never accepted', () {
        final detailsJeune = mockDetailsJeune(dateSignatureCgu: null);
        final cgu = Cgu(lastUpdate: DateTime(2024), changes: []);

        when(() => detailsJeuneRepository.get('id-bénéficiaire')).thenAnswer((_) async => detailsJeune);
        when(() => remoteConfigRepository.getCgu()).thenReturn(cgu);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {
                  f.detailsJeuneRepository = detailsJeuneRepository,
                  f.remoteConfigRepository = remoteConfigRepository,
                });

        sut.thenExpectChangingStatesThroughOrder([_shouldAcceptCgu()]);
      });

      test('should accept CGU when updated since accepted', () {
        final detailsJeune = mockDetailsJeune(dateSignatureCgu: DateTime(2023));
        final cgu = Cgu(lastUpdate: DateTime(2024), changes: []);

        when(() => detailsJeuneRepository.get('id-bénéficiaire')).thenAnswer((_) async => detailsJeune);
        when(() => remoteConfigRepository.getCgu()).thenReturn(cgu);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {
                  f.detailsJeuneRepository = detailsJeuneRepository,
                  f.remoteConfigRepository = remoteConfigRepository,
                });

        sut.thenExpectChangingStatesThroughOrder([_shouldAcceptUpdatedCgu(cgu)]);
      });
    });

    group("on CGU accepted", () {
      sut.whenDispatchingAction(() => CguAcceptedAction(DateTime(2024)));

      test('should call repository and update state if successful', () async {
        when(() => detailsJeuneRepository.patch('id', DateTime(2024))).thenAnswer((_) async => true);

        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {
                  f.detailsJeuneRepository = detailsJeuneRepository,
                });

        await sut.thenExpectChangingStatesThroughOrder([_shouldHaveAcceptedCgu()]);

        verify(() => detailsJeuneRepository.patch('id', DateTime(2024))).called(1);
      });

      test('should call repository and keep current state if unsuccessful', () async {
        when(() => detailsJeuneRepository.patch('id', DateTime(2024))).thenAnswer((_) async => false);

        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {
                  f.detailsJeuneRepository = detailsJeuneRepository,
                });

        await sut.thenExpectNever(_shouldHaveAcceptedCgu());

        verify(() => detailsJeuneRepository.patch('id', DateTime(2024))).called(1);
      });
    });

    group("on CGU refused", () {
      sut.whenDispatchingAction(() => CguRefusedAction());

      test('should logout user', () async {
        sut.givenStore = givenState() //
            .loggedIn()
            .store();

        sut.thenExpectChangingStatesThroughOrder([_shouldLogout()]);
      });
    });
  });
}

Matcher _shouldAcceptCgu() => StateIs<CguNeverAcceptedState>((state) => state.cguState);

Matcher _shouldHaveAcceptedCgu() => StateIs<CguAlreadyAcceptedState>((state) => state.cguState);

Matcher _shouldNotAcceptCgu() => StateIs<CguAlreadyAcceptedState>((state) => state.cguState);

Matcher _shouldAcceptUpdatedCgu(Cgu expectedCgu) {
  return StateIs<CguUpdateRequiredState>(
    (state) => state.cguState,
    (state) {
      expect(state.updatedCgu, expectedCgu);
    },
  );
}

Matcher _shouldLogout() => StateIs<LoginNotInitializedState>((state) => state.loginState);
