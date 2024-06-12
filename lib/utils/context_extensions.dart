import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/tracking/tracking_evenement_engagement_action.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

extension EvenementEngagementExtension on BuildContext {
  void trackEvenementEngagement(EvenementEngagement evenementEngagement) {
    dispatch(TrackingEvenementEngagementAction(evenementEngagement));
  }
}

extension StoreExtension on BuildContext {
  void dispatch(dynamic action) => StoreProvider.of<AppState>(this).dispatch(action);
}
