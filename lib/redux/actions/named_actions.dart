import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/redux/requests/immersion_request.dart';
import 'package:pass_emploi_app/redux/requests/rendezvous_request.dart';

import 'actions.dart';

typedef ImmersionAction = Action<ImmersionRequest, List<Immersion>>;

typedef RendezvousAction = Action<RendezvousRequest, List<Rendezvous>>;
