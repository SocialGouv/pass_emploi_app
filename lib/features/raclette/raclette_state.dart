import 'package:equatable/equatable.dart';

enum RacletteStatus {
  nouvelleRecherche,
  loading,
  failure,
  success,
  loadingMore,
}

class RacletteCritere extends Equatable {
  final String motCle;

  RacletteCritere(this.motCle);

  @override
  List<Object?> get props => [motCle];
}

class RacletteState extends Equatable {
  final RacletteStatus status;
  final RacletteCritere? critere;
  final List<String>? result;

  RacletteState({
    required this.status,
    required this.critere,
    required this.result,
  });

  @override
  List<Object?> get props => [status, critere, result];

  RacletteState copyWith({
    RacletteStatus? status,
    RacletteCritere? Function()? critere,
    List<String>? Function()? result,
  }) {
    return RacletteState(
      status: status ?? this.status,
      critere: critere != null ? critere() : this.critere,
      result: result != null ? result() : this.result,
    );
  }
}
