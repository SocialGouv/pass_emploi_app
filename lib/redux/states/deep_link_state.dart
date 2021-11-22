enum DeepLink { ROUTE_TO_RENDEZVOUS, ROUTE_TO_CHAT, ROUTE_TO_ACTION, NOT_SET }

class DeepLinkState {
  final DeepLink deepLink;
  final DateTime deepLinkOpenedAt;

  DeepLinkState(this.deepLink, this.deepLinkOpenedAt);

  static DeepLinkState notInitialized() => DeepLinkState(DeepLink.NOT_SET, DateTime.now());
}
