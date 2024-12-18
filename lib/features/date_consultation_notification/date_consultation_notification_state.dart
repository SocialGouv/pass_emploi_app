import 'package:equatable/equatable.dart';

class DateConsultationNotificationState extends Equatable {
  DateConsultationNotificationState({this.date});
  final DateTime? date;

  @override
  List<Object?> get props => [date];
}
