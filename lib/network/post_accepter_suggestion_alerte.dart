import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/network/json_serializable.dart';

class PostAccepterSuggestionAlerte implements JsonSerializable {
  final Location? location;
  final double? rayon;

  PostAccepterSuggestionAlerte({this.location, this.rayon});

  @override
  Map<String, dynamic> toJson() => {
        if (location != null) "location": location?.toJson(),
        if (rayon != null) "rayon": rayon,
      };
}
