import 'package:pass_emploi_app/models/user_action.dart';

class UserActionViewModel {
  final String id;
  final String content;
  final String comment;
  final bool withComment;
  final UserActionStatus status;
  final DateTime lastUpdate;

  UserActionViewModel({
    required this.id,
    required this.content,
    required this.comment,
    required this.withComment,
    required this.status,
    required this.lastUpdate,
  });

  factory UserActionViewModel.create(UserAction userAction) {
    return UserActionViewModel(
      id: userAction.id,
      content: userAction.content,
      comment: userAction.comment,
      withComment: userAction.comment.isNotEmpty,
      status: userAction.status,
      lastUpdate: userAction.lastUpdate,
    );
  }
}