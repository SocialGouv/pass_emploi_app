import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/network/json_serializable.dart';

class PostAccepterSuggestionAlerte implements JsonSerializable {
  final Location location;
  final double rayon;

  PostAccepterSuggestionAlerte({required this.location, required this.rayon});

  @override
  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "rayon": rayon,
      };
}
