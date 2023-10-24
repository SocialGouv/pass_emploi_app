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

class ConnectivityBandeau extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ConnectivityViewModel>(
      converter: (store) => ConnectivityViewModel.create(store),
      builder: (context, viewModel) => viewModel.isConnected ? SizedBox.shrink() : _Bandeau(),
      distinct: true,
    );
  }
}

class _Bandeau extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.disabled,
      child: Padding(
        padding: const EdgeInsets.all(Margins.spacing_xs),
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
