import 'dart:io';

import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/features/mode_demo/mode_demo_client.dart';

import '../network/cache_interceptor_test.dart';

class MockModeDemoClient extends ModeDemoClient {
  MockModeDemoClient() : super(_DummyModeDemoRepository(), StubSuccessHttpClient());

  @override
  Stream<List<int>> readFileBytes(String fileName) => File("assets/mode_demo/" + fileName + ".json").openRead();
}

class _DummyModeDemoRepository extends ModeDemoRepository {
  @override
  bool getModeDemo() {
    return true;
  }
}
