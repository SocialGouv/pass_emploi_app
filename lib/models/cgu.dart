import 'package:equatable/equatable.dart';

class Cgu extends Equatable {
  final DateTime lastUpdate;
  final List<String> changes;

  const Cgu({required this.lastUpdate, required this.changes});

  factory Cgu.fromJson(dynamic json) {
    return Cgu(
      lastUpdate: json['lastUpdate'] as DateTime,
      changes: json['changes'] as List<String>,
    );
  }

  @override
  List<Object?> get props => [lastUpdate, changes];
}
