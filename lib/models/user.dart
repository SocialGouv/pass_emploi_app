import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/login_mode.dart';

class User extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final LoginMode loginMode;
  final Accompagnement accompagnement;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.loginMode,
    required this.accompagnement,
  });

  @override
  List<Object?> get props => [id, firstName, lastName, email, loginMode, accompagnement];

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    LoginMode? loginMode,
    Accompagnement? accompagnement,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      loginMode: loginMode ?? this.loginMode,
      accompagnement: accompagnement ?? this.accompagnement,
    );
  }
}
