import 'package:pass_emploi_app/models/user.dart';

class PostUserRequest {
  final User user;

  PostUserRequest({required this.user});

  Map<String, dynamic> toJson() {
    return {
      'id': user.id,
      'firstName': user.firstName,
      'lastName': user.lastName,
    };
  }
}
