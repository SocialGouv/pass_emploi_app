import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/offres_suivies/offres_suivies_state.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/models/offre_suivie.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class PostulerConfirmationViewModel extends Equatable {
  const PostulerConfirmationViewModel({
    required this.onCreateActionOrDemarcheLabel,
    required this.wishToCreateActionOrDemarche,
    required this.useDemarche,
    required this.onCreateActionOrDemarche,
  });

  final String onCreateActionOrDemarcheLabel;
  final String wishToCreateActionOrDemarche;
  final bool useDemarche;
  final void Function() onCreateActionOrDemarche;

  factory PostulerConfirmationViewModel.create(Store<AppState> store, String offreId) {
    final offreSuivie = store.state.offresSuiviesState.getOffre(offreId);

    return PostulerConfirmationViewModel(
      onCreateActionOrDemarcheLabel: store.state.isMiloLoginMode() ? Strings.addAction : Strings.addDemarche,
      wishToCreateActionOrDemarche:
          store.state.isMiloLoginMode() ? Strings.wishToCreateAction : Strings.wishToCreateDemarche,
      useDemarche: !store.state.isMiloLoginMode(),
      onCreateActionOrDemarche: () => _onCreateActionOrDemarche(store, offreSuivie),
    );
  }

  @override
  List<Object?> get props => [
        onCreateActionOrDemarcheLabel,
        wishToCreateActionOrDemarche,
        useDemarche,
        onCreateActionOrDemarche,
      ];
}

void _onCreateActionOrDemarche(Store<AppState> store, OffreSuivie? offreSuivie) {
  if (store.state.isMiloLoginMode()) {
    store.dispatch(
      UserActionCreateRequestAction(
        UserActionCreateRequest(
          Strings.candidature,
          Strings.jaiPostuleA(offreSuivie?.offreDto.title ?? "", offreSuivie?.offreDto.companyName ?? ""),
          DateTime.now(),
          false,
          UserActionStatus.DONE,
          UserActionReferentielType.emploi,
          false,
        ),
      ),
    );
  } else {
    store.dispatch(
      CreateDemarcheRequestAction(
        codeQuoi: "Q14",
        codePourquoi: "P03",
        codeComment: null,
        dateEcheance: DateTime.now(),
        estDuplicata: false,
      ),
    );
  }
}
