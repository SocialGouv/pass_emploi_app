import 'package:equatable/equatable.dart';

abstract class AccueilState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AccueilNotInitializedState extends AccueilState {}

class AccueilLoadingState extends AccueilState {}

class AccueilFailureState extends AccueilState {}

class AccueilSuccessState extends AccueilState {
  final bool result;

  AccueilSuccessState(this.result);

  @override
  List<Object?> get props => [result];
}
