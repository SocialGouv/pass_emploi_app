import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/redux/requests/immersion_request.dart';

class ImmersionListRequestAction {
  final ImmersionRequest request;

  ImmersionListRequestAction(this.request);
}

class ImmersionListLoadingAction {}

class ImmersionListSuccessAction {
  final List<Immersion> immersions;

  ImmersionListSuccessAction(this.immersions);
}

class ImmersionListFailureAction {}

class ImmersionListResetAction {}
