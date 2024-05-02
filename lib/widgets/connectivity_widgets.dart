import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/connectivity/connectivity_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class ConnectivityContainer extends StatelessWidget {
  final Widget child;

  const ConnectivityContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ConnectivityViewModel>(
      converter: (store) => ConnectivityViewModel.create(store),
      builder: _builder,
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, ConnectivityViewModel viewModel) {
    return Column(
      children: [
        Expanded(child: child),
        if (!viewModel.isOnline) ConnectivityBandeau(),
      ],
    );
  }
}

class ConnectivityBandeau extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.disabled,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Margins.spacing_xs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(AppIcons.connectivity_off, color: Colors.white, size: Dimens.icon_size_base),
            SizedBox(width: Margins.spacing_s),
            Text(Strings.notConnected, style: TextStyles.textSRegular(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
