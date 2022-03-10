import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/location.dart';

class ImmersionListRequestAction {
  final String codeRome;
  final Location location;
  final String? title;

  ImmersionListRequestAction(this.codeRome, this.location, [this.title]);
}

class ImmersionListLoadingAction {}

class ImmersionListSuccessAction {
  final List<Immersion> immersions;

  ImmersionListSuccessAction(this.immersions);
}

class ImmersionListFailureAction {}

class ImmersionListResetAction {}
