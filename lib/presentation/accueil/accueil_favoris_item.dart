import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_view_model.dart';

class AccueilFavorisItem extends AccueilItem {
  final List<Favori> favoris;

  AccueilFavorisItem(this.favoris);

  @override
  List<Object?> get props => [favoris];
}