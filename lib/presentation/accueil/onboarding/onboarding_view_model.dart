import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_actions.dart';
import 'package:pass_emploi_app/presentation/onboarding/onboarding_bottom_sheet.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class OnboardingViewModel extends Equatable {
  final String illustration;
  final String title;
  final String body;
  final Function() onGotIt;

  OnboardingViewModel({
    required this.illustration,
    required this.title,
    required this.body,
    required this.onGotIt,
  });

  factory OnboardingViewModel.create(Store<AppState> store, OnboardingSource source) {
    final state = store.state.loginState;
    final user = state is LoginSuccessState ? state.user : null;
    final isPe = user?.loginMode.isPe() == true;
    return OnboardingViewModel(
      illustration: _illustration(source),
      title: _title(source),
      body: _body(isPe, source),
      onGotIt: _onGotIt(store, source),
    );
  }

  @override
  List<Object?> get props => [illustration, title, body, onGotIt];
}

// TODO: tests ?
String _illustration(OnboardingSource source) {
  return switch (source) {
    OnboardingSource.monSuivi => Drawables.onboardingMonSuiviIllustration,
    OnboardingSource.chat => Drawables.onboardingChatIllustration,
    OnboardingSource.reherche => Drawables.onboardingRechercheIllustration,
    OnboardingSource.evenements => Drawables.onboardingEvenementsIllustration,
  };
}

String _title(OnboardingSource source) {
  return switch (source) {
    OnboardingSource.monSuivi => Strings.onboardingMonSuiviTitle,
    OnboardingSource.chat => Strings.onboardingChatTitle,
    OnboardingSource.reherche => Strings.onboardingRechercheTitle,
    OnboardingSource.evenements => Strings.onboardingEvenementsTitle,
  };
}

String _body(bool isPe, OnboardingSource source) {
  return switch (source) {
    OnboardingSource.monSuivi => isPe ? Strings.onboardingMonSuiviBodyPe : Strings.onboardingMonSuiviBodyCej,
    OnboardingSource.chat => Strings.onboardingChatBody,
    OnboardingSource.reherche => isPe ? Strings.onboardingRechercheBodyPe : Strings.onboardingRechercheBodyCej,
    OnboardingSource.evenements => Strings.onboardingEvenementsBody,
  };
}

void Function() _onGotIt(Store<AppState> store, OnboardingSource source) {
  return switch (source) {
    OnboardingSource.monSuivi => () => store.dispatch(OnboardingMonSuiviSaveAction()),
    OnboardingSource.chat => () => store.dispatch(OnboardingChatSaveAction()),
    OnboardingSource.reherche => () => store.dispatch(OnboardingRechercheSaveAction()),
    OnboardingSource.evenements => () => store.dispatch(OnboardingEvenementsSaveAction()),
  };
}
