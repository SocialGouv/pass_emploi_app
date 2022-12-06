import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/presentation/favori_heart_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/favori_heart.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';

class DeleteFavoriButton<T> extends StatelessWidget {
  final String offreId;
  final OffrePage from;

  const DeleteFavoriButton({required this.offreId, required this.from});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FavoriHeartViewModel<T>>(
      builder: (context, vm) {
        return PrimaryActionButton(
          label: Strings.deleteOffreFromFavori,
          onPressed: vm.withLoading
              ? null
              : () {
                  vm.update(false);
                  _tracking();
                },
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

  void _tracking() {
    final widgetName = FavoriHeartAnalyticsHelper().getAnalyticsWidgetName(from, false);
    final eventName = FavoriHeartAnalyticsHelper().getAnalyticsEventName(from);
    if (widgetName != null && eventName != null) {
      PassEmploiMatomoTracker.instance.trackScreenWithName(widgetName: widgetName, eventName: eventName);
    }
  }
}
