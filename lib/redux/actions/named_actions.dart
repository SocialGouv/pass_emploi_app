import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/requests/immersion_request.dart';

import 'actions.dart';

typedef LoginAction = Action<void, User>;

typedef RendezvousAction = Action<void, List<Rendezvous>>;

typedef OffreEmploiDetailsAction = Action<String, OffreEmploiDetails>;

typedef ImmersionAction = Action<ImmersionRequest, List<Immersion>>;
