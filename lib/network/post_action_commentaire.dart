import 'package:pass_emploi_app/network/json_serializable.dart';

class PostSendCommentaire implements JsonSerializable {
  final String comment;

  PostSendCommentaire(this.comment);

  @override
  Map<String, dynamic> toJson() => {"commentaire": comment};
}
