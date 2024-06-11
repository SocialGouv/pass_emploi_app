import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_form_page.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';

class DuplicateUserActionConfirmationPage extends StatelessWidget {
  final String userActionId;
  final UserActionStateSource source;

  const DuplicateUserActionConfirmationPage({
    super.key,
    required this.userActionId,
    required this.source,
  });

  static Route<CreateActionFormResult> route(String userActionId, UserActionStateSource source) {
    return MaterialPageRoute<CreateActionFormResult>(
      fullscreenDialog: true,
      builder: (_) => DuplicateUserActionConfirmationPage(
        userActionId: userActionId,
        source: source,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SecondaryAppBar(title: Strings.duplicateUserActionConfirmationTitle, backgroundColor: Colors.white),
      floatingActionButton: _Buttons(
        onGoActionDetail: () => Navigator.pop(context, NavigateToUserActionDetails(userActionId, source)),
        onClose: () => Navigator.pop(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Margins.spacing_xl),
            Center(
              child: SizedBox(
                height: 130,
                width: 130,
                child: Illustration.green(AppIcons.check_rounded),
              ),
            ),
            SizedBox(height: Margins.spacing_xl),
            Text(
              Strings.duplicateUserActionConfirmationTitle,
              style: TextStyles.textMBold,
            ),
            SizedBox(height: Margins.spacing_xx_huge),
          ],
        ),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons({required this.onGoActionDetail, required this.onClose});

  final void Function() onGoActionDetail;
  final void Function() onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryActionButton(
            label: Strings.userActionConfirmationSeeDetailButton,
            onPressed: onGoActionDetail,
          ),
          const SizedBox(height: Margins.spacing_base),
          SecondaryButton(
            label: Strings.close,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
