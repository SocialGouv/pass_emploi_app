import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class UpdateUserActionViewModel extends Equatable {
  final String id;
  final DateTime date;
  final String title;
  final String subtitle;
  final UserActionReferentielType? type;

  UpdateUserActionViewModel._({
    required this.id,
    required this.date,
    required this.title,
    required this.subtitle,
    required this.type,
  });

  factory UpdateUserActionViewModel.create(Store<AppState> store, UserActionStateSource source, String userActionId) {
    final userAction = _getAction(store, source, userActionId);
    return UpdateUserActionViewModel._(
      id: userAction.id,
      date: userAction.dateEcheance,
      title: userAction.content,
      subtitle: userAction.comment,
      type: userAction.type,
    );
  }

  @override
  List<Object?> get props => [
        id,
        date,
        title,
        subtitle,
        type,
      ];
}

UserAction _getAction(Store<AppState> store, UserActionStateSource stateSource, String actionId) {
  switch (stateSource) {
    case UserActionStateSource.agenda:
      final state = store.state.agendaState as AgendaSuccessState;
      return state.agenda.actions.firstWhere((e) => e.id == actionId);
    case UserActionStateSource.list:
      final state = store.state.userActionListState as UserActionListSuccessState;
      return state.userActions.firstWhere((e) => e.id == actionId);
  }
}
