import 'package:equatable/equatable.dart';

class FavoriDto extends Equatable {
  final String id;
  final DateTime? datePostulation;

  FavoriDto(this.id, {this.datePostulation});

  @override
  List<Object?> get props => [id];

  static FavoriDto fromJson(Map<String, dynamic> json) {
    return FavoriDto(
      json["id"] as String,
      datePostulation: json["dateCandidature"] != null ? DateTime.parse(json["dateCandidature"] as String) : null,
    );
  }
}

abstract class FavorisRepository<T> {
  Future<Set<FavoriDto>?> getFavorisId(String userId);

  Future<bool> postFavori(String userId, T favori, {bool postulated = false});

  Future<bool> deleteFavori(String userId, String favoriId);
}
