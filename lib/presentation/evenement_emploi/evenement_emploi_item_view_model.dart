import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class EvenementEmploiItemViewModel extends Equatable {
  final String id;
  final String type;
  final String titre;
  final String dateLabel;
  final String heureLabel;
  final String locationLabel;

  EvenementEmploiItemViewModel({
    required this.id,
    required this.type,
    required this.titre,
    required this.dateLabel,
    required this.heureLabel,
    required this.locationLabel,
  });

  factory EvenementEmploiItemViewModel.create(EvenementEmploi evenement) {
    return EvenementEmploiItemViewModel(
      id: evenement.id,
      type: evenement.type,
      titre: evenement.titre,
      dateLabel: evenement.dateDebut.toDay(),
      heureLabel: '${evenement.dateDebut.toHourWithHSeparator()} - ${evenement.dateFin.toHourWithHSeparator()}',
      locationLabel: '${evenement.codePostal} ${evenement.ville}',
    );
  }

  @override
  List<Object?> get props => [id, type, titre, dateLabel, heureLabel, locationLabel];
}
