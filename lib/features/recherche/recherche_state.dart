import 'package:equatable/equatable.dart';

enum RechercheStatus {
  newSearch,
  loading,
  failure,
  success;
}

class RechercheState<Request, Result> extends Equatable {
  final RechercheStatus status;
  final Request? request;
  final List<Result>? results;
  final bool canLoadMore;

  RechercheState({
    required this.status,
    required this.request,
    required this.results,
    required this.canLoadMore,
  });

  factory RechercheState.initial() {
    return RechercheState(
      status: RechercheStatus.newSearch,
      request: null,
      results: null,
      canLoadMore: false,
    );
  }

  RechercheState<Request, Result> copyWith({
    RechercheStatus? status,
    Request? Function()? request,
    List<Result>? Function()? results,
    bool? canLoadMore,
  }) {
    return RechercheState(
      status: status ?? this.status,
      request: request != null ? request() : this.request,
      results: results != null ? results() : this.results,
      canLoadMore: canLoadMore ?? this.canLoadMore,
    );
  }

  @override
  List<Object?> get props => [status, request, results, canLoadMore];
}
