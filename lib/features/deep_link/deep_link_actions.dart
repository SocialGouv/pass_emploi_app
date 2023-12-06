import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/deep_link.dart';

class HandleDeepLinkAction extends Equatable {
  final DeepLink deepLink;

  HandleDeepLinkAction(this.deepLink);

  @override
  List<Object?> get props => [deepLink];
}

class ResetDeeplinkAction {}
