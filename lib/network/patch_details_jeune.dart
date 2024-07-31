import 'package:pass_emploi_app/network/json_serializable.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class PatchDetailsJeune implements JsonSerializable {
  final DateTime dateSignatureCgu;

  PatchDetailsJeune(this.dateSignatureCgu);

  @override
  Map<String, dynamic> toJson() => {
        "dateSignatureCGU": dateSignatureCgu.toIso8601WithOffsetDateTime(),
      };
}
