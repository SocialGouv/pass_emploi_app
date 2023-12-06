import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/deep_link.dart';

class DeepLinkState extends Equatable {
  final DateTime deepLinkOpenedAt;

  DeepLinkState() : deepLinkOpenedAt = clock.now();

  factory DeepLinkState.notInitialized() => NotInitializedDeepLinkState();
  factory DeepLinkState.handle(DeepLink deepLink) => HandleDeepLinkState(deepLink);
  factory DeepLinkState.used() => UsedDeepLinkState();

  @override
  List<Object?> get props => [deepLinkOpenedAt];
}

class UsedDeepLinkState extends DeepLinkState {}

class HandleDeepLinkState extends DeepLinkState {
  final DeepLink deepLink;

  HandleDeepLinkState(this.deepLink);

  @override
  List<Object?> get props => [deepLink];
}

class NotInitializedDeepLinkState extends DeepLinkState {}
