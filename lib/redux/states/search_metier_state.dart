import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/metier.dart';

class SearchMetierState extends Equatable {
  final List<Metier> metiers;

  SearchMetierState(this.metiers);

  @override
  List<Object?> get props => [metiers];
}
