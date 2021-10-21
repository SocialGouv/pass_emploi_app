import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/ui/strings.dart';

class UserActionViewModel {
  final String id;
  final String content;
  final String comment;
  final bool withComment;
  final UserActionStatus status;
  final DateTime lastUpdate;
  final String creator;

  UserActionViewModel({
    required this.id,
    required this.content,
    required this.comment,
    required this.withComment,
    required this.status,
    required this.lastUpdate,
    required this.creator,
  });

  factory UserActionViewModel.create(UserAction userAction) {
    return UserActionViewModel(
      id: userAction.id,
      content: userAction.content,
      comment: userAction.comment,
      withComment: userAction.comment.isNotEmpty,
      status: userAction.status,
      lastUpdate: userAction.lastUpdate,
      creator: _displayName(userAction.creator),
    );
  }
}

_displayName(UserActionCreator creator) {
  if (creator is ConseillerActionCreator) {
    return creator.name;
  } else {
    return Strings.you;
  }
}
