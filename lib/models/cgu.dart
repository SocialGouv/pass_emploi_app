import 'package:equatable/equatable.dart';

class Cgu extends Equatable {
  final DateTime lastUpdate;
  final List<String> changes;

  const Cgu({required this.lastUpdate, required this.changes});

  factory Cgu.fromJson(dynamic json) {
    return Cgu(
      lastUpdate: DateTime.parse(json['lastUpdate'] as String),
      changes: (json['changes'] as List<dynamic>).cast<String>(),
    );
  }

  @override
  List<Object?> get props => [lastUpdate, changes];
}
