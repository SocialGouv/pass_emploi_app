enum DeepLink { ROUTE_TO_RENDEZVOUS, ROUTE_TO_CHAT, ROUTE_TO_ACTION, NOT_SET, SAVED_SEARCH_RESULTS }

class DeepLinkState {
  final DeepLink deepLink;
  final DateTime deepLinkOpenedAt;
  final String? dataId;

  DeepLinkState(this.deepLink, this.deepLinkOpenedAt, [this.dataId]);

  factory DeepLinkState.notInitialized() => DeepLinkState(DeepLink.NOT_SET, DateTime.now());
}
