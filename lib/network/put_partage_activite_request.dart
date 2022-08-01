import 'package:pass_emploi_app/network/json_serializable.dart';

class PutPartageActiviteRequest implements JsonSerializable {
  final bool favoris;

  PutPartageActiviteRequest({required this.favoris});

  @override
  Map<String, dynamic> toJson() => {"partageFavoris": favoris};
}
