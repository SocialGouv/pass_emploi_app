import 'package:equatable/equatable.dart';

class Preferences extends Equatable {
  final bool partageFavoris;

  Preferences({required this.partageFavoris});

  factory Preferences.fromJson(dynamic json) {
    final favoris = json['partageFavoris'] as bool;
    return Preferences(partageFavoris: favoris);
  }

  @override
  List<Object?> get props => [partageFavoris];
}
