import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/date_consultation_notification/date_consultation_notification_actions.dart';
import 'package:pass_emploi_app/features/in_app_notifications/in_app_notifications_actions.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/notifications_center/notifications_center_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_complement.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/illustration/empty_state_placeholder.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
import 'package:pass_emploi_app/widgets/in_app_feedback.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

class NotificationCenter extends StatelessWidget {
  const NotificationCenter({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const NotificationCenter(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.centreNotification,
      child: Scaffold(
        backgroundColor: AppColors.grey100,
        appBar: SecondaryAppBar(title: Strings.notificationsCenterTitle),
        body: StoreConnector<AppState, NotificationsCenterViewModel>(
          onInit: (store) => store.dispatch(InAppNotificationsRequestAction()),
          converter: (store) => NotificationsCenterViewModel.create(store),
          builder: (context, viewModel) => _DisplayState(viewModel),
          onDispose: (store) => store.dispatch(DateConsultationNotificationWriteAction(DateTime.now())),
        ),
      ),
    );
  }
}

class _DisplayState extends StatelessWidget {
  const _DisplayState(this.viewModel);
  final NotificationsCenterViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return switch (viewModel.displayState) {
      DisplayState.CONTENT => _Body(viewModel: viewModel),
      DisplayState.LOADING => const Center(child: CircularProgressIndicator()),
      DisplayState.FAILURE => Retry(Strings.notificationsCenterError, () => viewModel.retry()),
      DisplayState.EMPTY => _Empty(),
    };
  }
}

class _Body extends StatelessWidget {
  final NotificationsCenterViewModel viewModel;

  const _Body({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.notifications.length + 1,
      padding: const EdgeInsets.all(Margins.spacing_base),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Margins.spacing_m),
            child: InAppFeedback(
              feature: "centre-notif",
              label: Strings.feedbackCentreNotification,
              backgroundColor: Colors.white,
            ),
          );
        }
        final notification = viewModel.notifications[index - 1];
        return Padding(
          padding: const EdgeInsets.only(bottom: Margins.spacing_m),
          child: _NotificationTile(notification: notification),
        );
      },
    );
  }
}

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmptyStatePlaceholder(
      illustration: Illustration.grey(AppIcons.notifications_outlined),
      title: Strings.notificationsCenterEmptyTitle,
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});
  final NotificationViewModel notification;

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      pillule: notification.isNew ? CardPillule.newNotification() : null,
      title: notification.title,
      subtitle: notification.description,
      complements: [CardComplement.date(text: notification.date)],
      onTap: notification.onPressed,
    );
  }
}
