import 'package:equatable/equatable.dart';

class DateConsultationOffreState extends Equatable {
  final Map<String, DateTime> offreIdToDateConsultation;

  DateConsultationOffreState({this.offreIdToDateConsultation = const {}});

  @override
  List<Object?> get props => [offreIdToDateConsultation];
}
