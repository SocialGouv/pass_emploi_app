import 'package:equatable/equatable.dart';

abstract class State<T> extends Equatable {
  State();

  factory State.loading() = _LoadingState;

  factory State.success(T t) = _SuccessState;

  factory State.failure() = _FailureState;

  factory State.notInitialized() = _NotInitializedState;

  bool isLoading() => this is _LoadingState<T>;

  bool isSuccess() => this is _SuccessState<T>;

  bool isFailure() => this is _FailureState<T>;

  bool isNotInitialized() => this is _NotInitializedState<T>;

  T getDataOrThrow() => (this as _SuccessState<T>).data;

  @override
  List<Object?> get props => [];
}

class _LoadingState<T> extends State<T> {}

class _SuccessState<T> extends State<T> {
  final T data;

  _SuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class _FailureState<T> extends State<T> {}

class _NotInitializedState<T> extends State<T> {}
