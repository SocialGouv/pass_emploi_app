import 'package:equatable/equatable.dart';

enum ImmersionContactMode { MAIL, PHONE, IN_PERSON, UNKNOWN }

class ImmersionContact extends Equatable {
  final String firstName;
  final String lastName;
  final String phone;
  final String mail;
  final String role;
  final ImmersionContactMode mode;

  ImmersionContact({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.mail,
    required this.role,
    required this.mode,
  });

  factory ImmersionContact.fromJson(dynamic json) {
    return ImmersionContact(
      firstName: json['prenom'] ?? '',
      lastName: json['nom'] ?? '',
      phone: json['telephone'] ?? '',
      mail: json['email'] ?? '',
      role: json['role'] ?? '',
      mode: _getContractMode(json['modeDeContact']),
    );
  }

  @override
  List<Object?> get props => [lastName, firstName, phone, mail, role, mode];
}

ImmersionContactMode _getContractMode(String json) {
  if (json == 'EMAIL') return ImmersionContactMode.MAIL;
  if (json == 'PHONE') return ImmersionContactMode.PHONE;
  if (json == 'IN_PERSON') return ImmersionContactMode.IN_PERSON;
  return ImmersionContactMode.UNKNOWN;
}
