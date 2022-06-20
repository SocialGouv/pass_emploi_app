import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/analytics_extensions.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_actions.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_personnalisee_page.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_detail_page.dart';
import 'package:pass_emploi_app/pages/campagne/campagne_details_page.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/campagne_card.dart';
import 'package:pass_emploi_app/widgets/cards/demarche_card.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/empty_pole_emploi_content.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

class DemarcheListPage extends TraceableStatelessWidget {
  final ScrollController _scrollController = ScrollController();

  DemarcheListPage() : super(name: AnalyticsScreenNames.userActionList);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DemarcheListPageViewModel>(
      onInit: (store) => store.dispatch(DemarcheListRequestAction()),
      builder: (context, viewModel) => _scaffold(context, viewModel),
      converter: (store) => DemarcheListPageViewModel.create(store),
      distinct: true,
      onDispose: (store) => store.dispatch(DemarcheListResetAction()),
    );
  }

  Widget _scaffold(BuildContext context, DemarcheListPageViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: DefaultAnimatedSwitcher(child: _animatedBody(context, viewModel)),
    );
  }

  Widget _animatedBody(BuildContext context, DemarcheListPageViewModel viewModel) {
    switch (viewModel.displayState) {
      case DisplayState.CONTENT:
        return _userActionsList(context, viewModel);
      case DisplayState.LOADING:
        return _loader();
      case DisplayState.EMPTY:
        return _empty();
      case DisplayState.FAILURE:
        return Center(child: Retry(Strings.actionsError, () => viewModel.onRetry()));
    }
  }

  Widget _loader() => Center(child: CircularProgressIndicator());

  Widget _empty() => EmptyPoleEmploiContent();

  Widget _userActionsList(BuildContext context, DemarcheListPageViewModel viewModel) {
    return Stack(
      children: [
        ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.all(Margins.spacing_base),
          itemCount: viewModel.items.length,
          itemBuilder: (context, i) => _listItem(context, viewModel.items[i], viewModel),
          separatorBuilder: (context, i) => _listSeparator(),
        ),
        _AddDemarcheButton(),
      ],
    );
  }

  Container _listSeparator() => Container(height: Margins.spacing_base);

  Widget _listItem(BuildContext context, DemarcheListItem item, DemarcheListPageViewModel viewModel) {
    if (item is DemarcheCampagneItemViewModel) {
      return _CampagneCard(title: item.titre, description: item.description);
    } else {
      final viewModel = (item as DemarcheListItemViewModel).viewModel;
      return DemarcheCard(
        viewModel: viewModel,
        onTap: () => pushAndTrackBack(
          context,
          DemarcheDetailPage.materialPageRoute(viewModel.id),
          AnalyticsScreenNames.userActionList,
        ),
      );
    }
  }
}

class _CampagneCard extends StatelessWidget {
  final String title;
  final String description;

  _CampagneCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return CampagneCard(
      onTap: () {
        pushAndTrackBack(context, CampagneDetailsPage.materialPageRoute(), AnalyticsScreenNames.evaluationDetails);
      },
      titre: title,
      description: description,
    );
  }
}

class _AddDemarcheButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: PrimaryActionButton(
          drawableRes: Drawables.icAdd,
          label: Strings.addADemarche,
          onPressed: () {
            pushAndTrackBack(context, CreateDemarchePersonnaliseePage.materialPageRoute(), AnalyticsScreenNames.userActionList);
          },
        ),
      ),
    );
  }
}
