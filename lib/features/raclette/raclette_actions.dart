import 'package:pass_emploi_app/features/raclette/raclette_state.dart';

class RacletteRequestAction {
  final RacletteCritere critere;

  RacletteRequestAction(this.critere);
}

class RacletteLoadingAction {}

class RacletteSuccessAction {
  final bool result;

  RacletteSuccessAction(this.result);
}

class RacletteFailureAction {}

class RacletteResetAction {}
