
import 'package:pass_emploi_app/presentation/accueil/accueil_view_model.dart';

class AccueilEvenementsItem extends AccueilItem {
  final List<String> evenementIds;

  AccueilEvenementsItem(this.evenementIds);

  @override
  List<Object?> get props => [evenementIds];
}