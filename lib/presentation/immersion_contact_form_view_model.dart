import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/contact_immersion/contact_immersion_actions.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/requests/contact_immersion_request.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class ImmersionContactFormViewModel extends Equatable {
  final String userEmailInitialValue;
  final String userFirstNameInitialValue;
  final String userLastNameInitialValue;
  final String messageInitialValue;
  final Function(ImmersionContactUserInput) onFormSubmitted;

  ImmersionContactFormViewModel._({
    required this.userEmailInitialValue,
    required this.userFirstNameInitialValue,
    required this.userLastNameInitialValue,
    required this.messageInitialValue,
    required this.onFormSubmitted,
  });

  factory ImmersionContactFormViewModel.create(Store<AppState> store) {
    final state = store.state;
    final user = (state.loginState as LoginSuccessState).user;
    return ImmersionContactFormViewModel._(
      userEmailInitialValue: user.email ?? "",
      userFirstNameInitialValue: user.firstName,
      userLastNameInitialValue: user.lastName,
      messageInitialValue: Strings.immersitionContactFormMessageDefault,
      onFormSubmitted: (userInput) => store.dispatch(
        ContactImmersionRequestAction(
          ContactImmersionRequest(
            (state.immersionDetailsState as ImmersionDetailsSuccessState).immersion,
            userInput,
          ),
        ),
      ),
    );
  }

  @override
  List<Object?> get props => [
        userEmailInitialValue,
        userFirstNameInitialValue,
        userLastNameInitialValue,
        messageInitialValue,
      ];
}

class ImmersionContactUserInput extends Equatable {
  final String email;
  final String firstName;
  final String lastName;
  final String message;

  ImmersionContactUserInput({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.message,
  });

  @override
  List<Object?> get props => [email, firstName, lastName, message];
}
