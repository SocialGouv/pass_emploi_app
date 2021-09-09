import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/configuration/app_version_checker.dart';

void main() {
  final checker = AppVersionChecker();

  test('shouldForceUpdate', () {
    expect(checker.shouldForceUpdate(currentVersion: null, minimumVersion: null), false);
    expect(checker.shouldForceUpdate(currentVersion: '1.0.0', minimumVersion: null), false);
    expect(checker.shouldForceUpdate(currentVersion: null, minimumVersion: '1.0.0'), false);
    expect(checker.shouldForceUpdate(currentVersion: '', minimumVersion: ''), false);
    expect(checker.shouldForceUpdate(currentVersion: 'badFormat', minimumVersion: 'badFormat'), false);
    expect(checker.shouldForceUpdate(currentVersion: '1.0', minimumVersion: '2.0'), false);
    expect(checker.shouldForceUpdate(currentVersion: '1.0.0', minimumVersion: '2.0'), false);
    expect(checker.shouldForceUpdate(currentVersion: '1.0', minimumVersion: '2.0.0'), false);

    expect(checker.shouldForceUpdate(currentVersion: '1.0.0', minimumVersion: '1.0.0'), false);
    expect(checker.shouldForceUpdate(currentVersion: '2.0.0', minimumVersion: '1.0.0'), false);
    expect(checker.shouldForceUpdate(currentVersion: '1.0.1', minimumVersion: '1.0.0'), false);
    expect(checker.shouldForceUpdate(currentVersion: '1.1.0', minimumVersion: '1.0.0'), false);
    expect(checker.shouldForceUpdate(currentVersion: '1.1.1', minimumVersion: '1.0.0'), false);
    expect(checker.shouldForceUpdate(currentVersion: '0.0.0', minimumVersion: '1.0.0'), true);
    expect(checker.shouldForceUpdate(currentVersion: '0.0.1', minimumVersion: '1.0.0'), true);
    expect(checker.shouldForceUpdate(currentVersion: '0.1.1', minimumVersion: '1.0.0'), true);
    expect(checker.shouldForceUpdate(currentVersion: '0.999.999', minimumVersion: '1.0.0'), true);
    expect(checker.shouldForceUpdate(currentVersion: '999.999.999', minimumVersion: '999.999.1000'), true);

    expect(checker.shouldForceUpdate(currentVersion: '3.1.1', minimumVersion: '1.2.0'), false);
    expect(checker.shouldForceUpdate(currentVersion: '3.1.1', minimumVersion: '1.1.2'), false);
    expect(checker.shouldForceUpdate(currentVersion: '1.4.1', minimumVersion: '1.1.3'), false);
  });
}
