import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/analytics_extensions.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_actions.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action_pe/user_action_pe_list_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/cards/campagne_card.dart';
import 'package:pass_emploi_app/widgets/cards/user_action_pe_card.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/empty_pole_emploi_content.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

import 'campagne/campagne_details_page.dart';

class UserActionPEListPage extends TraceableStatelessWidget {
  final ScrollController _scrollController = ScrollController();

  UserActionPEListPage() : super(name: AnalyticsScreenNames.userActionList);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserActionPEListPageViewModel>(
      onInit: (store) => store.dispatch(UserActionPEListRequestAction()),
      builder: (context, viewModel) => _scaffold(context, viewModel),
      converter: (store) => UserActionPEListPageViewModel.create(store),
      distinct: true,
      onDispose: (store) => store.dispatch(UserActionPEListResetAction()),
    );
  }

  Widget _scaffold(BuildContext context, UserActionPEListPageViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: DefaultAnimatedSwitcher(child: _animatedBody(context, viewModel)),
    );
  }

  Widget _animatedBody(BuildContext context, UserActionPEListPageViewModel viewModel) {
    switch (viewModel.displayState) {
      case DisplayState.CONTENT:
        return  _userActionsList(context, viewModel);
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

  Widget _userActionsList(BuildContext context, UserActionPEListPageViewModel viewModel) {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(Margins.spacing_base),
      itemCount: viewModel.items.length,
      itemBuilder: (context, i) => _listItem(context, viewModel.items[i], viewModel),
      separatorBuilder: (context, i) => _listSeparator(),
    );
  }

  Container _listSeparator() => Container(height: Margins.spacing_base);

  Widget _listItem(BuildContext context, UserActionPEListItem item, UserActionPEListPageViewModel viewModel) {
    if (item is UserActionPECampagneItemViewModel) {
      return _CampagneCard(title: item.titre, description: item.description);
    } else {
      return UserActionPECard(viewModel: (item as UserActionPEListItemViewModel).viewModel);
    }
  }
}

class _CampagneCard extends StatelessWidget{
  final String title;
  final String description;

  _CampagneCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
   return CampagneCard(
     onTap: () {
       pushAndTrackBack(
           context, CampagneDetailsPage.materialPageRoute(), AnalyticsScreenNames.evaluationDetails);
     },
     titre: title,
     description: description,
   );
  }
}
