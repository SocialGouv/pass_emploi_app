import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/favori_heart_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/primary_action_button.dart';

import 'favori_state_selector.dart';

class DeleteFavoriButton<T> extends StatelessWidget {
  final String offreId;

  const DeleteFavoriButton({required this.offreId});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FavoriHeartViewModel>(
      builder: (context, vm) {
        return PrimaryActionButton(
          label: Strings.deleteOffreFromFavori,
          onPressed: vm.withLoading ? null : () => vm.update(false),
        );
      },
      converter: (store) => FavoriHeartViewModel<T>.create(
        offreId,
        store,
        context.dependOnInheritedWidgetOfExactType<FavorisStateContext<T>>()!.selectState(store),
      ),
      distinct: true,
      onDidChange: (_, viewModel) {
        if (!viewModel.isFavori) {
          Navigator.pop(context);
        }
      },
    );
  }
}
