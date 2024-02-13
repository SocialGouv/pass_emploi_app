import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/profil/conseiller_profil_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/profil/profil_card.dart';

class MonConseillerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ConseillerProfilePageViewModel>(
      converter: (store) => ConseillerProfilePageViewModel.create(store),
      builder: (BuildContext context, ConseillerProfilePageViewModel vm) => _build(context, vm),
      distinct: true,
    );
  }

  Widget _build(BuildContext context, ConseillerProfilePageViewModel vm) {
    final displayState = vm.displayState;
    if (displayState == DisplayState.CONTENT) {
      return _contentCard(vm.sinceDate, vm.name);
    } else if (displayState == DisplayState.LOADING) {
      return _loading();
    }
    return Container();
  }

  Widget _loading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: CircularProgressIndicator()),
        SizedBox(height: Margins.spacing_m),
      ],
    );
  }

  Widget _contentCard(String sinceDate, String name) {
    return Semantics(
      header: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfilCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(Strings.yourConseiller, style: TextStyles.textMBold),
                SizedBox(height: Margins.spacing_m),
                Text(sinceDate, style: TextStyles.textBaseRegular),
                SizedBox(height: Margins.spacing_s),
                Text(
                  name,
                  style: TextStyles.textBaseBold.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Margins.spacing_m),
        ],
      ),
    );
  }
}
