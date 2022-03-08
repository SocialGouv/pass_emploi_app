import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/tracking/tracking_event_action.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';

extension TrackingExtension on BuildContext {
  void trackEvent(EventType eventType) {
    StoreProvider.of<AppState>(this).dispatch(TrackingEventAction(eventType));
  }
}
