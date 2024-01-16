import 'package:equatable/equatable.dart';

class Interval extends Equatable {
  final DateTime debut;
  final DateTime fin;

  Interval(this.debut, this.fin);

  @override
  List<Object?> get props => [debut, fin];
}
