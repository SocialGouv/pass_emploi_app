import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/tracking/tracking_evenement_engagement_action.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

extension TrackingExtension on BuildContext {
  void trackEvent(EvenementEngagement eventType) => dispatch(TrackingEvenementEngagementAction(eventType));
}

extension StoreExtension on BuildContext {
  void dispatch(dynamic action) => StoreProvider.of<AppState>(this).dispatch(action);
}
