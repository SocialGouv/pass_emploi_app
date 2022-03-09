import 'package:pass_emploi_app/models/location.dart';

class ImmersionListRequest {
  final String codeRome;
  final Location location;
  final String? title;

  ImmersionListRequest(this.codeRome, this.location, [this.title]);
}
