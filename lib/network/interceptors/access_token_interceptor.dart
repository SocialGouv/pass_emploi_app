import 'package:http_interceptor/http_interceptor.dart';
import 'package:pass_emploi_app/auth/auth_access_token_retriever.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/repositories/auth/pole_emploi/pole_emploi_token_repository.dart';

class AccessTokenInterceptor implements InterceptorContract {
  final AuthAccessTokenRetriever _accessTokenRetriever;
  final PoleEmploiTokenRepository _poleEmploiTokenRepository;
  final ModeDemoRepository _demoRepository;

  AccessTokenInterceptor(this._accessTokenRetriever, this._poleEmploiTokenRepository, this._demoRepository);

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    if (_demoRepository.getModeDemo()) {
      return data;
    }
    data.headers["Authorization"] = "Bearer ${await _accessTokenRetriever.accessToken()}";
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async => data;
}
