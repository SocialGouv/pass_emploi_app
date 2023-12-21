import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_actions.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_step1_page.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_detail_page.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_list_loading.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_state_source.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/demarche_card.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/empty_page.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
import 'package:pass_emploi_app/widgets/refresh_indicator_ext.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

class DemarcheListPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(
      builder: (context) => DemarcheListPage(fullScreen: true),
    );
  }

  final bool fullScreen;
  final ScrollController _scrollController = ScrollController();

  DemarcheListPage({this.fullScreen = false});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DemarcheListPageViewModel>(
      onInit: (store) => store.dispatch(DemarcheListRequestAction()),
      builder: (context, viewModel) => _scaffold(context, viewModel),
      converter: (store) => DemarcheListPageViewModel.create(store),
      onDispose: (store) => store.dispatch(DemarcheListResetAction()),
      distinct: true,
    );
  }

  Widget _scaffold(BuildContext context, DemarcheListPageViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: fullScreen ? SecondaryAppBar(title: "Démarches") : null,
      body: Stack(
        children: [
          DefaultAnimatedSwitcher(child: _body(context, viewModel)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(padding: const EdgeInsets.only(bottom: 24), child: _AddDemarcheButton()),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, DemarcheListPageViewModel viewModel) {
    return switch (viewModel.displayState) {
      DisplayState.chargement => DemarcheListLoading(),
      DisplayState.contenu => _demarchesListView(context, viewModel),
      DisplayState.vide => _emptyPage(context, viewModel),
      DisplayState.erreur => _Error(viewModel: viewModel),
    };
  }

  Widget _demarchesListView(BuildContext context, DemarcheListPageViewModel viewModel) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => viewModel.onRetry(),
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(Margins.spacing_base),
        itemCount: viewModel.demarcheListItems.length,
        itemBuilder: (context, i) => _demarcheCard(context, viewModel.demarcheListItems[i], viewModel),
        separatorBuilder: (context, i) => Container(height: Margins.spacing_base),
      ),
    );
  }

  Widget _demarcheCard(BuildContext context, DemarcheListItem item, DemarcheListPageViewModel viewModel) {
    final id = item.demarcheId;
    return DemarcheCard(
      demarcheId: id,
      stateSource: DemarcheStateSource.demarcheList,
      onTap: () {
        context.trackEvent(EventType.ACTION_DETAIL);
        Navigator.push(context, DemarcheDetailPage.materialPageRoute(id, DemarcheStateSource.demarcheList));
      },
    );
  }

  Widget _emptyPage(BuildContext context, DemarcheListPageViewModel viewModel) {
    return RefreshIndicatorAddingScrollview(
      onRefresh: () async => viewModel.onRetry(),
      child: Empty(
        title: Strings.demarchesToDo,
        subtitle: Strings.emptyContentSubtitle(Strings.demarche),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  final DemarcheListPageViewModel viewModel;

  const _Error({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox.square(dimension: 130, child: Illustration.orange(AppIcons.construction)),
          SizedBox(height: Margins.spacing_base),
          Retry(
            Strings.demarchesError,
            () => viewModel.onRetry(),
          )
        ],
      ),
    );
  }
}

class _AddDemarcheButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: PrimaryActionButton(
        icon: AppIcons.add_rounded,
        label: Strings.addADemarche,
        onPressed: () => Navigator.push(context, CreateDemarcheStep1Page.materialPageRoute()),
      ),
    );
  }
}
