import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';

class NotificationsBottomSheet extends StatelessWidget {
  const NotificationsBottomSheet({super.key});

  static void show(BuildContext context) {
    showPassEmploiBottomSheet(
      context: context,
      builder: (context) => const NotificationsBottomSheet(),
    ).then((_) {
      if (context.mounted) {
        return StoreProvider.of<AppState>(context).dispatch(OnboardingPushNotificationPermissionRequestAction());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWrapper(
      hideTitle: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: Margins.spacing_m),
            Image.asset(
              Drawables.notificationsIllustration,
              height: 120,
            ),
            SizedBox(height: Margins.spacing_m),
            Text(
              Strings.notificationsBottomSheetTitle,
              style: TextStyles.textMBold,
            ),
            SizedBox(height: Margins.spacing_m),
            Text(
              Strings.notificationsBottomSheetcontent,
              style: TextStyles.textBaseRegular,
            ),
            SizedBox(height: Margins.spacing_l),
            PrimaryActionButton(
              label: Strings.notificationsBottomSheetButton,
              onPressed: () => Navigator.of(context).pop(),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
