import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';

class UserActionUpdateRequest extends Equatable {
  final UserActionStatus status;
  final String contenu;
  final String? description;
  final DateTime dateEcheance;
  final DateTime? dateFin;
  final UserActionReferentielType? type;

  UserActionUpdateRequest({
    required this.status,
    required this.contenu,
    required this.description,
    required this.dateEcheance,
    this.dateFin,
    required this.type,
  });

  @override
  List<Object?> get props => [
        status,
        contenu,
        description,
        dateEcheance,
        dateFin,
        type,
      ];
}
