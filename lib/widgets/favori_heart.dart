import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/favori_heart_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/secondary_icon_button.dart';

class FavoriHeart extends StatelessWidget {
  final String offreId;
  final bool withBorder;
  final Function()? onFavoriRemoved;

  FavoriHeart({required this.offreId, required this.withBorder, this.onFavoriRemoved}) : super();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FavoriHeartViewModel>(
      converter: (store) => FavoriHeartViewModel.create(offreId, store),
      builder: (context, viewModel) => _buildHeart(context, viewModel),
      distinct: true,
      onDidChange: (_, viewModel) {
        if (viewModel.withError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(Strings.miscellaneousErrorRetry),
            duration: Duration(seconds: 2),
          ));
        }
        if (!viewModel.isFavori) {
          onFavoriRemoved?.call();
        }
      },
    );
  }

  Widget _buildHeart(BuildContext context, FavoriHeartViewModel viewModel) {
    return SecondaryIconButton(
      drawableRes: viewModel.isFavori ? Drawables.icHeartFull : Drawables.icHeart,
      onTap: () {
        viewModel.update(!viewModel.isFavori);
        _sendTracking(viewModel.isFavori);
      },
    );
  }

  void _sendTracking(bool isFavori) {
    MatomoTracker.trackScreenWithName(
        isFavori ? AnalyticsActionNames.offreEmploiAddFavori : AnalyticsActionNames.offreEmploiRemoveFavori,
        AnalyticsScreenNames.favoris);
  }
}
