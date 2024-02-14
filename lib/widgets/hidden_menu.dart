import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/mode_demo/explication_page_mode_demo.dart';
import 'package:pass_emploi_app/presentation/device_info_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

// ignore: must_be_immutable
class HiddenMenuGesture extends StatelessWidget {
  int _numberOfClicks = 0;

  final Widget child;

  HiddenMenuGesture({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onClick(context),
      child: child,
    );
  }

  void _onClick(BuildContext context) {
    if (_numberOfClicks == 2) {
      _numberOfClicks = 0;
      _showHiddenMenu(context);
    } else {
      _numberOfClicks = _numberOfClicks + 1;
    }
  }

  void _showHiddenMenu(BuildContext context) {
    showModalBottomSheet<void>(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (context) => _HiddenMenu(),
    );
  }
}

class _HiddenMenu extends StatelessWidget {
  const _HiddenMenu();

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Margins.spacing_l, horizontal: Margins.spacing_l),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PrimaryActionButton(
                label: Strings.passerEnDemo,
                onPressed: () {
                  Navigator.of(context).pop();
                  _showDemo(context);
                },
              ),
              SizedBox(height: Margins.spacing_base),
              PrimaryActionButton(
                label: Strings.supportInformation,
                onPressed: () {
                  Navigator.of(context).pop();
                  _showDeviceInfos(context);
                },
              ),
              SizedBox(height: Margins.spacing_base),
              SecondaryButton(
                label: Strings.close,
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        ),
      ),
    ]);
  }

  void _showDemo(BuildContext context) {
    Navigator.push(context, ExplicationModeDemoPage.materialPageRoute());
  }

  void _showDeviceInfos(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => _DeviceInfo(),
    );
  }
}

class _DeviceInfo extends StatelessWidget {
  const _DeviceInfo();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DeviceInfoViewModel>(
      converter: (store) => DeviceInfoViewModel.fromStore(store),
      builder: (context, viewModel) => _DeviceInfoDialog(viewModel),
      distinct: true,
    );
  }
}

class _DeviceInfoDialog extends StatelessWidget {
  final DeviceInfoViewModel viewModel;

  _DeviceInfoDialog(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Device Infos'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('InstallationID', style: TextStyles.textBaseBold),
            Row(
              children: [
                Expanded(child: Text(viewModel.installationId)),
                IconButton(
                  icon: Icon(
                    Icons.copy,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: viewModel.installationId));
                    Navigator.of(context).pop();
                    showSnackBarWithInformation(context, Strings.copie);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(Strings.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
