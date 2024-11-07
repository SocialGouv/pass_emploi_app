import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_actions.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/onboarding/onboarding_bottom_sheet.dart';
import 'package:redux/redux.dart';

class OnboardingViewModel extends Equatable {
  final String illustration;
  final String title;
  final String body;
  final String primaryButtonText;
  final bool canClose;
  final Function() onPrimaryButton;
  final Function()? onClose;

  OnboardingViewModel({
    required this.illustration,
    required this.title,
    required this.body,
    required this.primaryButtonText,
    required this.canClose,
    required this.onPrimaryButton,
    this.onClose,
  });

  factory OnboardingViewModel.create(Store<AppState> store, OnboardingSource source) {
    final state = store.state.loginState;
    final user = state is LoginSuccessState ? state.user : null;
    final isPe = user?.loginMode.isPe() == true;
    return OnboardingViewModel(
      illustration: _illustration(source),
      title: _title(source),
      body: _body(isPe, source),
      primaryButtonText: _primaryButtonText(source),
      canClose: _canClose(source),
      onPrimaryButton: _onGotIt(store, source),
      onClose: _onClose(store, source),
    );
  }

  @override
  List<Object?> get props => [
        illustration,
        title,
        body,
        primaryButtonText,
        canClose,
      ];
}

String _illustration(OnboardingSource source) {
  return switch (source) {
    OnboardingSource.monSuivi => Drawables.onboardingMonSuiviIllustration,
    OnboardingSource.chat => Drawables.onboardingChatIllustration,
    OnboardingSource.reherche => Drawables.onboardingRechercheIllustration,
    OnboardingSource.evenements => Drawables.onboardingEvenementsIllustration,
    OnboardingSource.offresEnregistrees => Drawables.onboardingOffreEnregistreeIllustration,
  };
}

String _title(OnboardingSource source) {
  return switch (source) {
    OnboardingSource.monSuivi => Strings.onboardingMonSuiviTitle,
    OnboardingSource.chat => Strings.onboardingChatTitle,
    OnboardingSource.reherche => Strings.onboardingRechercheTitle,
    OnboardingSource.evenements => Strings.onboardingEvenementsTitle,
    OnboardingSource.offresEnregistrees => Strings.onboardingOffreEnregistreeTitle,
  };
}

String _body(bool isPe, OnboardingSource source) {
  return switch (source) {
    OnboardingSource.monSuivi => isPe ? Strings.onboardingMonSuiviBodyPe : Strings.onboardingMonSuiviBodyCej,
    OnboardingSource.chat => Strings.onboardingChatBody,
    OnboardingSource.reherche => isPe ? Strings.onboardingRechercheBodyPe : Strings.onboardingRechercheBodyCej,
    OnboardingSource.evenements => Strings.onboardingEvenementsBody,
    OnboardingSource.offresEnregistrees => Strings.onboardingOffreEnregistreeBody,
  };
}

String _primaryButtonText(OnboardingSource source) {
  return switch (source) {
    OnboardingSource.offresEnregistrees => Strings.discover,
    _ => Strings.gotIt,
  };
}

bool _canClose(OnboardingSource source) {
  return switch (source) {
    OnboardingSource.offresEnregistrees => true,
    _ => false,
  };
}

void Function() _onGotIt(Store<AppState> store, OnboardingSource source) {
  return switch (source) {
    OnboardingSource.monSuivi => () => store.dispatch(OnboardingMonSuiviSaveAction()),
    OnboardingSource.chat => () => store.dispatch(OnboardingChatSaveAction()),
    OnboardingSource.reherche => () => store.dispatch(OnboardingRechercheSaveAction()),
    OnboardingSource.evenements => () => store.dispatch(OnboardingEvenementsSaveAction()),
    OnboardingSource.offresEnregistrees => () {
        store.dispatch(OnboardingOffreEnregistreeSaveAction());
        store.dispatch(
          HandleDeepLinkAction(
            OffresEnregistreesDeepLink(),
            DeepLinkOrigin.inAppNavigation,
          ),
        );
      },
  };
}

Function()? _onClose(Store<AppState> store, OnboardingSource source) {
  return switch (source) {
    OnboardingSource.offresEnregistrees => () => store.dispatch(OnboardingOffreEnregistreeSaveAction()),
    _ => null,
  };
}
