import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';

extension TraceableStatelessWidgetExtension on TraceableStatelessWidget {
  Future<T?> pushAndTrackBack<T>(BuildContext context, Route<T> route) {
    return Navigator.push(context, route).then((value) {
      MatomoTracker.trackScreenWithName(name, "");
      return value;
    });
  }
}

extension TraceableStatefulWidgetExtension on TraceableStatefulWidget {
  Future<T?> pushAndTrackBack<T>(BuildContext context, Route<T> route) {
    return Navigator.push(context, route).then((value) {
      MatomoTracker.trackScreenWithName(name, "");
      return value;
    });
  }
}
