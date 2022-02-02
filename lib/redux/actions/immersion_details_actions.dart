import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';

class ImmersionDetailsIncompleteDataAction extends ImmersionDetailsAction {
  final Immersion immersion;

  ImmersionDetailsIncompleteDataAction(this.immersion);
}
