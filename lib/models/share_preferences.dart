import 'package:equatable/equatable.dart';

class SharePreferences extends Equatable {
  final bool shareFavoris;

  SharePreferences({required this.shareFavoris});

  factory SharePreferences.fromJson(dynamic json) {
    final favoris = json['partageFavoris'] as bool;
    return SharePreferences(shareFavoris: favoris);
  }

  @override
  List<Object?> get props => [shareFavoris];
}
