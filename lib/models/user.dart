import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/login_mode.dart';

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

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    LoginMode? loginMode,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      loginMode: loginMode ?? this.loginMode,
    );
  }
}
