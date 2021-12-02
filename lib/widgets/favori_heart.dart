import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/favori_heart_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';

class FavoriHeart extends StatelessWidget {
  final String offreId;
  final bool withBorder;

  FavoriHeart({required this.offreId, required this.withBorder}) : super();

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
      },
    );
  }

  Widget _buildHeart(BuildContext context, FavoriHeartViewModel viewModel) {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        shape: withBorder ? CircleBorder(side: BorderSide(color: AppColors.nightBlue)) : null,
        child: InkWell(
          onTap: () => viewModel.update(!viewModel.isFavori),
          child: SizedBox(
            width: 48,
            height: 48,
            child: viewModel.isFavori
                ? Icon(Icons.favorite_rounded, color: AppColors.nightBlue, size: 18)
                : Icon(Icons.favorite_border_rounded, color: AppColors.nightBlue, size: 18),
          ),
        ),
      ),
    );
  }
}
