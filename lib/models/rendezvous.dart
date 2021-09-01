import 'package:pass_emploi_app/utils/string_extensions.dart';

class Rendezvous {
  final String id;
  final DateTime date;
  final String title;
  final String subtitle;
  final String comment;
  final String duration;
  final String modality;

  Rendezvous({
    required this.id,
    required this.date,
    required this.title,
    required this.subtitle,
    required this.comment,
    required this.duration,
    required this.modality,
  });

  factory Rendezvous.fromJson(dynamic json) {
    return Rendezvous(
      id: json['id'] as String,
      date: (json['date'] as String).toDateTime(),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      comment: json['comment'] as String,
      duration: json['duration'] as String,
      modality: json['modality'] as String,
    );
  }
}
