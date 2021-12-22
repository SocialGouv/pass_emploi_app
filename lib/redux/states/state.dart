import 'package:equatable/equatable.dart';

abstract class State<T> extends Equatable {
  State._();

  factory State.loading() = LoadingState;

  factory State.success(T t) = SuccessState;

  factory State.failure() = FailureState;

  factory State.notInitialized() = NotInitializedState;

  @override
  List<Object?> get props => [];

  bool isLoading() => this is LoadingState<T>;

  bool isSuccess() => this is SuccessState<T>;

  bool isFailure() => this is FailureState<T>;

  bool isNotInitialized() => this is NotInitializedState<T>;
}

class LoadingState<T> extends State<T> {
  LoadingState() : super._();
}

class SuccessState<T> extends State<T> {
  final T data;

  SuccessState(this.data) : super._();

  @override
  List<Object?> get props => [data];
}

class FailureState<T> extends State<T> {
  FailureState() : super._();
}

class NotInitializedState<T> extends State<T> {
  NotInitializedState() : super._();
}
