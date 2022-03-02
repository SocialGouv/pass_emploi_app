import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/redux/requests/immersion_request.dart';

import 'actions.dart';

typedef OffreEmploiDetailsAction = Action<String, OffreEmploiDetails>;

typedef ImmersionAction = Action<ImmersionRequest, List<Immersion>>;

typedef ImmersionDetailsAction = Action<String, ImmersionDetails>;
