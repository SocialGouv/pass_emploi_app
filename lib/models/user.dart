import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';

class User extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final LoginMode loginMode;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.loginMode,
  });

  @override
  List<Object?> get props => [id, firstName, lastName, email, loginMode];
}
