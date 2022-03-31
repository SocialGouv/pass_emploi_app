import 'package:equatable/equatable.dart';

class MonConseillerInfo extends Equatable {
  final String sinceDate;
  final String firstname;
  final String lastname;

  MonConseillerInfo({required this.sinceDate, required this.firstname, required this.lastname});

  @override
  List<Object> get props => [sinceDate, firstname, lastname];
}