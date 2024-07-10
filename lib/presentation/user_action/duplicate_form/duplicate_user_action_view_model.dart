import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_create_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_store_extension.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DuplicateUserActionViewModel extends Equatable {
  final String id;
  final DateTime date;
  final String title;
  final String description;
  final UserActionReferentielType? type;
  final UserActionCreateDisplayState displayState;
  final void Function(DateTime date, String title, String? description, UserActionReferentielType? type) duplicate;

  DuplicateUserActionViewModel._({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
    required this.type,
    required this.displayState,
    required this.duplicate,
  });

  factory DuplicateUserActionViewModel.create(
    Store<AppState> store,
    UserActionStateSource source,
    String userActionId,
  ) {
    final userAction = store.getAction(source, userActionId);

    if (userAction == null) return DuplicateUserActionViewModel.empty();

    return DuplicateUserActionViewModel._(
      id: userAction.id,
      date: userAction.dateEcheance,
      title: userAction.content,
      description: userAction.comment,
      type: userAction.type,
      displayState: _displayState(store.state.userActionCreateState),
      duplicate: (date, title, description, type) => store.dispatch(
        UserActionCreateRequestAction(
          UserActionCreateRequest(
            title,
            description,
            date,
            false,
            userAction.status,
            type ?? UserActionReferentielType.emploi,
            true,
          ),
        ),
      ),
    );
  }

  factory DuplicateUserActionViewModel.empty() {
    return DuplicateUserActionViewModel._(
      id: "",
      date: DateTime.now(),
      title: "",
      description: "",
      type: null,
      displayState: DisplayContent(),
      duplicate: (a, b, c, d) {},
    );
  }

  @override
  List<Object?> get props => [id, date, title, description, type, displayState];

  bool get showLoading => displayState.isLoading;
}

UserActionCreateDisplayState _displayState(UserActionCreateState state) {
  return switch (state) {
    UserActionCreateNotInitializedState() => DisplayContent(),
    UserActionCreateLoadingState() => DisplayLoading(),
    UserActionCreateSuccessState() => ShowConfirmationPage(state.userActionCreatedId),
    UserActionCreateFailureState() => DismissWithFailure(),
  };
}
