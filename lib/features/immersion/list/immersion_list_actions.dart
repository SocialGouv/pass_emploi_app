import 'package:pass_emploi_app/features/immersion/list/immersion_list_request.dart';
import 'package:pass_emploi_app/models/immersion.dart';

class ImmersionListRequestAction {
  final ImmersionListRequest request;

  ImmersionListRequestAction(this.request);
}

class ImmersionListLoadingAction {}

class ImmersionListSuccessAction {
  final List<Immersion> immersions;

  ImmersionListSuccessAction(this.immersions);
}

class ImmersionListFailureAction {}

class ImmersionListResetAction {}
