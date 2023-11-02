import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';

class UserActionPendingCreationRepository {
  static const _key = 'user_action_pending_creations';
  final FlutterSecureStorage _preferences;

  UserActionPendingCreationRepository(this._preferences);

  Future<void> save(UserActionCreateRequest request) async {
    final pendingCreations = await load();
    await _save([...pendingCreations, request]);
  }

  Future<List<UserActionCreateRequest>> load() async {
    final pendingCreationsJson = await _preferences.read(key: _key);
    if (pendingCreationsJson == null) return [];
    return (jsonDecode(pendingCreationsJson) as List).map((e) => UserActionCreateRequest.fromJson(e)).toList();
  }

  Future<int> getPendingActionCount() async {
    return (await load()).length;
  }

  Future<void> delete(UserActionCreateRequest request) async {
    final List<UserActionCreateRequest> pendingCreations = await load();
    pendingCreations.remove(request);
    await _save(pendingCreations);
  }

  Future<void> _save(List<UserActionCreateRequest> requests) async {
    await _preferences.write(key: _key, value: jsonEncode(requests));
  }
}
