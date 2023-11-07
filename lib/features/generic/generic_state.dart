import 'package:equatable/equatable.dart';

sealed class State<T> extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotInitializedState<T> extends State<T> {}

class LoadingState<T> extends State<T> {}

class SuccessState<T> extends State<T> {
  final T data;

  SuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class FailureState<T> extends State<T> {}
