import 'package:pass_emploi_app/presentation/accueil/accueil_view_model.dart';

class AccueilProchainRendezvousItem extends AccueilItem {
  final String rendezVousId;

  AccueilProchainRendezvousItem(this.rendezVousId);

  @override
  List<Object?> get props => [rendezVousId];
}