import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/simple_confirmation_page.dart';
import 'package:pass_emploi_app/presentation/offre_suivie_bottom_sheet_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';

class OffreSuivieBottomSheet extends StatelessWidget {
  const OffreSuivieBottomSheet({super.key, required this.offreId});
  final String offreId;

  static Future<void> show(BuildContext context, String offreId) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => OffreSuivieBottomSheet(offreId: offreId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreSuivieBottomSheetViewModel>(
      converter: (store) => OffreSuivieBottomSheetViewModel.create(store, offreId),
      builder: (context, viewModel) {
        return _DisposeWrapper(
          onDispose: viewModel.onCloseBottomSheet,
          child: BottomSheetWrapper(
            title: Strings.offreSuivieBottomSheetTitle,
            maxHeightFactor: 0.7,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: Margins.spacing_base),
                  _Option(
                    icon: AppIcons.check_circle_rounded,
                    label: Strings.offreSuivieOuiPostule,
                    onPressed: () {
                      viewModel.onPostule();
                      Navigator.of(context).pop();
                      Navigator.of(context).push(SimpleConfirmationPage.postuler());
                    },
                  ),
                  _Option(
                    icon: AppIcons.bookmark,
                    label: Strings.offreSuiviePasEncore,
                    onPressed: () {
                      viewModel.onInteresse();
                      Navigator.of(context).pop();
                      Navigator.of(context).push(SimpleConfirmationPage.favoris());
                    },
                  ),
                  _Option(
                    icon: AppIcons.delete,
                    label: Strings.offreSuivieNonPasInteresse,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(height: Margins.spacing_base),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({required this.icon, required this.label, required this.onPressed});
  final IconData icon;
  final String label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    const color = AppColors.contentColor;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.radius_base)),
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyles.textBaseBold.copyWith(color: color)),
      onTap: onPressed,
    );
  }
}

class _DisposeWrapper extends StatefulWidget {
  const _DisposeWrapper({required this.onDispose, required this.child});
  final void Function() onDispose;
  final Widget child;

  @override
  State<_DisposeWrapper> createState() => __DisposeWrapperState();
}

class __DisposeWrapperState extends State<_DisposeWrapper> {
  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
