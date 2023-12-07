import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/models/deep_link.dart';

class DeepLinkState extends Equatable {
  final DateTime deepLinkOpenedAt;

  DeepLinkState() : deepLinkOpenedAt = clock.now();

  factory DeepLinkState.notInitialized() => NotInitializedDeepLinkState();
  factory DeepLinkState.handle(DeepLink deepLink, DeepLinkOrigin origin) => HandleDeepLinkState(deepLink, origin);
  factory DeepLinkState.used() => UsedDeepLinkState();

  @override
  List<Object?> get props => [deepLinkOpenedAt];
}

class UsedDeepLinkState extends DeepLinkState {}

class HandleDeepLinkState extends DeepLinkState {
  final DeepLink deepLink;
  final DeepLinkOrigin origin;

  HandleDeepLinkState(this.deepLink, this.origin);

  @override
  List<Object?> get props => [deepLink, origin];
}

class NotInitializedDeepLinkState extends DeepLinkState {}
