import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/diagoriente_urls.dart';

abstract class DiagorienteUrlsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DiagorienteUrlsNotInitializedState extends DiagorienteUrlsState {}

class DiagorienteUrlsLoadingState extends DiagorienteUrlsState {}

class DiagorienteUrlsFailureState extends DiagorienteUrlsState {}

class DiagorienteUrlsSuccessState extends DiagorienteUrlsState {
  final DiagorienteUrls result;

  DiagorienteUrlsSuccessState(this.result);

  @override
  List<Object?> get props => [result];
}
