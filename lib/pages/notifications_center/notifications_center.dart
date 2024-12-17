import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/in_app_notifications/in_app_notifications_actions.dart';
import 'package:pass_emploi_app/presentation/notifications_center/notifications_center_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class NotificationCenter extends StatelessWidget {
  const NotificationCenter({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const NotificationCenter(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: SecondaryAppBar(title: Strings.notificationsCenterTitle),
      body: StoreConnector<AppState, NotificationsCenterViewModel>(
        onInit: (store) => store.dispatch(InAppNotificationsRequestAction()),
        converter: (store) => NotificationsCenterViewModel.create(store),
        builder: (context, viewModel) {
          return Placeholder();
        },
        distinct: true,
      ),
    );
  }
}
