import 'package:pass_emploi_app/models/rendezvous.dart';

extension RendezvousExtensions on Rendezvous {
  String takeTypeLabelOrPrecision() {
    return (type.code == RendezvousTypeCode.AUTRE && precision != null) ? precision! : type.label;
  }
}
