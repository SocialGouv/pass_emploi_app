import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/deep_link.dart';

enum DeepLinkOrigin {
  inAppNavigation,
  pushNotification;

  bool get isInAppNavigation => this == DeepLinkOrigin.inAppNavigation;
}

class HandleDeepLinkAction extends Equatable {
  final DeepLink deepLink;
  final DeepLinkOrigin origin;

  HandleDeepLinkAction(this.deepLink, this.origin);

  @override
  List<Object?> get props => [deepLink, origin];
}

class ResetDeeplinkAction {}
