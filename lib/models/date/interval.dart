import 'package:equatable/equatable.dart';

class Interval extends Equatable {
  final DateTime debut;
  final DateTime fin;

  Interval(this.debut, this.fin);

  @override
  List<Object?> get props => [debut, fin];

  Interval toPrevious4Weeks() {
    return Interval(
      debut.subtract(Duration(days: 7 * 4)),
      debut.subtract(Duration(milliseconds: 1)),
    );
  }

  Interval toNext4Weeks() {
    return Interval(
      fin.add(Duration(milliseconds: 1)),
      fin.add(Duration(days: 7 * 4)),
    );
  }
}
