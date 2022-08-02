import 'package:equatable/equatable.dart';

class PartageActivite extends Equatable {
  final bool partageFavoris;

  PartageActivite({required this.partageFavoris});

  factory PartageActivite.fromJson(dynamic json) {
    final favoris = json['partageFavoris'] as bool;
    return PartageActivite(partageFavoris: favoris);
  }

  @override
  List<Object?> get props => [partageFavoris];
}
