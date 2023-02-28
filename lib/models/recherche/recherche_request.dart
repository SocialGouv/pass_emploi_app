import 'package:equatable/equatable.dart';

class RechercheRequest<Criteres extends Equatable, Filtres extends Equatable> extends Equatable {
  final Criteres criteres;
  final Filtres filtres;
  final int page;

  RechercheRequest(this.criteres, this.filtres, this.page);

  RechercheRequest<Criteres, Filtres> copyWith({
    Criteres? criteres,
    Filtres? filtres,
    int? page,
  }) {
    return RechercheRequest(criteres ?? this.criteres, filtres ?? this.filtres, page ?? this.page);
  }

  @override
  List<Object?> get props => [criteres, filtres, page];
}
