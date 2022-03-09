import 'package:pass_emploi_app/models/location.dart';

class ImmersionListRequest {
  final String codeRome;
  final Location location;

  ImmersionListRequest(this.codeRome, this.location);
}
