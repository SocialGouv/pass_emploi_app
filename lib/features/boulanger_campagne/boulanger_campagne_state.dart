import 'package:equatable/equatable.dart';

class BoulangerCampagneState extends Equatable {
  final bool result;

  BoulangerCampagneState({this.result = false});

  @override
  List<Object?> get props => [result];
}
