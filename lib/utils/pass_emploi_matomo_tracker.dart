import 'dart:async';

import 'package:matomo_tracker/matomo_tracker.dart';

class PassEmploiMatomoTracker {
  static const String pageLogPrefix = '#page#';
  static const String eventLogPrefix = '#event#';
  static const String outLinkLogPrefix = '#outlink#';

  final MatomoTracker _decorated = MatomoTracker.instance;
  final Map<String, String> _dimensions = {};
  Function(String)? onTrackScreen;

  static final instance = PassEmploiMatomoTracker._internal();

  PassEmploiMatomoTracker._internal();

  Future<void> initialize({required int siteId, required String url}) {
    return _decorated.initialize(
      siteId: siteId,
      url: url,
      dispatchSettings: DispatchSettings.persistent(onLoad: DispatchSettings.takeAll),
    );
  }

  Future<void> setOptOut({required bool optOut}) => _decorated.setOptOut(optOut: optOut);

  void setDimension(String dimensionKey, String dimensionValue) {
    _dimensions['dimension$dimensionKey'] = Uri.encodeComponent(dimensionValue);
  }

  void trackScreen(String widgetName) {
    if (!_decorated.initialized) return;
    _decorated.trackPageViewWithName(
      actionName: widgetName,
      path: widgetName,
      dimensions: _dimensions,
    );
    onTrackScreen?.call('$pageLogPrefix $widgetName');
  }

  void trackEvent({required String eventCategory, required String action, String? eventName, int? eventValue}) {
    if (!_decorated.initialized) return;
    _decorated.trackEvent(
      eventInfo: EventInfo(
        category: eventCategory,
        action: action,
        name: eventName,
        value: eventValue,
      ),
      dimensions: _dimensions,
    );
    onTrackScreen?.call("$eventLogPrefix - category: $eventCategory \n- action:  $action");
  }

  void trackOutlink(String link) {
    if (!_decorated.initialized) return;
    _decorated.trackOutlink(link: link, dimensions: _dimensions);
    onTrackScreen?.call('$outLinkLogPrefix $link');
  }
}

enum OffreSuiviTrackingSource { accueil, offreDetail, bottomSheet }

enum OffreSuiviTrackingOption { interesse, postule, notInterrested, affiche }

extension PassEmploiMatomoTrackerExt on PassEmploiMatomoTracker {
  void trackCandidature({
    required OffreSuiviTrackingSource source,
    required OffreSuiviTrackingOption event,
  }) {
    trackEvent(
      eventCategory: 'Candidature',
      action: source.name,
      eventName: event.name,
    );
  }
}
