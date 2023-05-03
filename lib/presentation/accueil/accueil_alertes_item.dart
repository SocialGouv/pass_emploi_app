import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_view_model.dart';

class AccueilAlertesItem extends AccueilItem {
  final List<SavedSearch> savedSearches;

  AccueilAlertesItem(this.savedSearches);

  @override
  List<Object?> get props => [savedSearches];
}
