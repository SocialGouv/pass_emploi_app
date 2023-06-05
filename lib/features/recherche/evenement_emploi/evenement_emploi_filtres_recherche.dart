import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/evenement_emploi.dart';

class EvenementEmploiFiltresRecherche extends Equatable {
  final EvenementEmploiType? type;
  final List<EvenementEmploiModalite>? modalites;
  final DateTime? dateDebut;
  final DateTime? dateFin;

  EvenementEmploiFiltresRecherche._({
    this.type,
    this.modalites,
    this.dateDebut,
    this.dateFin,
  });

  factory EvenementEmploiFiltresRecherche.withFiltres({
    EvenementEmploiType? type,
    List<EvenementEmploiModalite>? modalites,
    DateTime? dateDebut,
    DateTime? dateFin,
  }) {
    return EvenementEmploiFiltresRecherche._(
      type: type,
      modalites: modalites,
      dateDebut: dateDebut,
      dateFin: dateFin,
    );
  }

  factory EvenementEmploiFiltresRecherche.noFiltre() {
    return EvenementEmploiFiltresRecherche._(
      type: null,
      modalites: null,
      dateDebut: null,
      dateFin: null,
    );
  }

  @override
  List<Object?> get props => [type, modalites, dateDebut, dateFin];
}
