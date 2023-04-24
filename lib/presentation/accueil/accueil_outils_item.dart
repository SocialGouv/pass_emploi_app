import 'package:pass_emploi_app/models/outil.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_view_model.dart';

class AccueilOutilsItem extends AccueilItem {
  final List<Outil> outils;

  AccueilOutilsItem(this.outils);

  @override
  List<Object?> get props => [outils];
}
