import 'package:flutter/widgets.dart';
import 'package:pass_emploi_app/pages/demarche/duplicate_demarche_page.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheet_button.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';

class DemarcheDetailsBottomSheet extends StatelessWidget {
  const DemarcheDetailsBottomSheet({required this.demarcheId});
  final String demarcheId;

  static Future<void> show(BuildContext context, String demarcheId) {
    return showPassEmploiBottomSheet(
      context: context,
      builder: (context) => DemarcheDetailsBottomSheet(demarcheId: demarcheId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWrapper(
      title: Strings.demarcheBottomSheetTitle,
      maxHeightFactor: 0.6,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Margins.spacing_base),
            _DuplicateButton(demarcheId),
          ],
        ),
      ),
    );
  }
}

class _DuplicateButton extends StatelessWidget {
  const _DuplicateButton(this.demarcheId);

  final String demarcheId;

  @override
  Widget build(BuildContext context) {
    return BottomSheetButton(
      icon: AppIcons.content_copy_rounded,
      text: Strings.duplicate,
      onPressed: () {
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.push(context, DuplicateDemarchePage.route(demarcheId));
        }
      },
      withNavigationSuffix: true,
    );
  }
}
