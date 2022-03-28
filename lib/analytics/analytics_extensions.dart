import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';

extension StatelessWidgetAnalyticsExtension on StatelessWidget {
  Future<T?> pushAndTrackBack<T>(BuildContext context, Route<T> route, String name) {
    return Navigator.push(context, route).then((value) {
      MatomoTracker.trackScreenWithName(name, "");
      return value;
    });
  }
}

extension StatefulWidgetAnalyticsExtension on StatefulWidget {
  Future<T?> pushAndTrackBack<T>(BuildContext context, Route<T> route, String name) {
    return Navigator.push(context, route).then((value) {
      MatomoTracker.trackScreenWithName(name, "");
      return value;
    });
  }
}
