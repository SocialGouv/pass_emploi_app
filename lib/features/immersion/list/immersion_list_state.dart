import 'package:pass_emploi_app/models/immersion.dart';
//TODO(1418): à supprimer ?
abstract class ImmersionListState {}

class ImmersionListNotInitializedState extends ImmersionListState {}

class ImmersionListLoadingState extends ImmersionListState {}

class ImmersionListSuccessState extends ImmersionListState {
  final List<Immersion> immersions;

  ImmersionListSuccessState(this.immersions);
}

class ImmersionListFailureState extends ImmersionListState {}
