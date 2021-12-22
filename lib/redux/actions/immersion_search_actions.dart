import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/location.dart';

abstract class ImmersionSearchAction {}

class SearchImmersionAction extends ImmersionSearchAction {
  final String codeRome;
  final Location location;

  SearchImmersionAction(this.codeRome, this.location);
}

class ImmersionSearchLoadingAction extends ImmersionSearchAction {}

class ImmersionSearchSuccessAction extends ImmersionSearchAction {
  final List<Immersion> immersions;

  ImmersionSearchSuccessAction(this.immersions);
}

class ImmersionSearchFailureAction extends ImmersionSearchAction {}

class ImmersionSearchResetResultsAction extends ImmersionSearchAction {}
