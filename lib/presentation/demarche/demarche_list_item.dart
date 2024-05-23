import 'package:equatable/equatable.dart';

sealed class DemarcheListItem extends Equatable {
  @override
  List<Object?> get props => [];
}

class IdItem extends DemarcheListItem {
  final String demarcheId;

  IdItem(this.demarcheId);

  @override
  List<Object?> get props => [demarcheId];
}

class DemarcheNotUpToDateItem extends DemarcheListItem {}
