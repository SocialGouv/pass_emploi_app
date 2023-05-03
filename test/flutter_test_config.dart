import 'dart:async';

import 'package:intl/date_symbol_data_local.dart';
import 'package:pass_emploi_app/models/brand.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  Brand.setBrand(Brand.cej);
  await initializeDateFormatting();
  await testMain();
}
