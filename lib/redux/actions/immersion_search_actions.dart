import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/redux/actions/actions.dart';

class SearchImmersionAction extends RequestAction<List<Immersion>> {
  final String codeRome;
  final Location location;

  SearchImmersionAction(this.codeRome, this.location);
}
