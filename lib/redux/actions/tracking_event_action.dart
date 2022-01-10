import 'package:pass_emploi_app/network/post_tracking_event_request.dart';

abstract class TrackingEventAction {}

class RequestTrackingEventAction extends TrackingEventAction {
  final EventType event;

  RequestTrackingEventAction(this.event);
}

class TrackingEventWithSuccessAction extends TrackingEventAction {}

class TrackingEventFailed extends TrackingEventAction {}