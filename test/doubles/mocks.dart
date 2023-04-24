import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/repositories/favoris/get_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/immersion_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_repository.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';

class MockGetFavorisRepository extends Mock implements GetFavorisRepository {}

class MockServiceCiviqueDetailRepository extends Mock implements ServiceCiviqueDetailRepository {}

class MockImmersionDetailsRepository extends Mock implements ImmersionDetailsRepository {}

class MockOffreEmploiDetailsRepository extends Mock implements OffreEmploiDetailsRepository {}

class MockMatomoTracker extends Mock implements PassEmploiMatomoTracker {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage{}
