import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/pages/user_action/action_commentaires_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_details_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/comment.dart';
import 'package:pass_emploi_app/widgets/date_echeance_in_detail.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/loader.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/text_with_clickable_links.dart';
import 'package:pass_emploi_app/widgets/user_action_status_group.dart';

class UserActionDetailPage extends StatefulWidget {
  final UserActionViewModel actionViewModel;

  UserActionDetailPage._(this.actionViewModel);

  static MaterialPageRoute<void> materialPageRoute(UserActionViewModel actionViewModel) {
    return MaterialPageRoute(builder: (context) => UserActionDetailPage._(actionViewModel));
  }

  @override
  State<UserActionDetailPage> createState() => _ActionDetailPageState();
}

class _ActionDetailPageState extends State<UserActionDetailPage> {
  late UserActionViewModel actionViewModel;
  late UserActionStatus status;

  @override
  void initState() {
    super.initState();
    actionViewModel = widget.actionViewModel;
    status = widget.actionViewModel.status;
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.userActionDetails,
      child: Scaffold(
        appBar: passEmploiAppBar(label: Strings.actionDetails, context: context),
        body: StoreConnector<AppState, UserActionDetailsViewModel>(
          onInit: (store) {
            store.dispatch(UserActionNotUpdatingState());
            store.dispatch(UserActionDeleteResetAction());
          },
          converter: (store) => UserActionDetailsViewModel.create(store, actionViewModel.id),
          builder: (context, detailsViewModel) => _build(context, detailsViewModel),
          onWillChange: (previousVm, newVm) => _bottomSheetHandling(context, newVm),
          distinct: true,
        ),
      ),
    );
  }

  Widget _build(BuildContext context, UserActionDetailsViewModel detailsViewModel) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Margins.spacing_m),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: Margins.spacing_l),
                  _Title(title: actionViewModel.title),
                  SizedBox(height: Margins.spacing_m),
                  _Description(
                    withSubtitle: actionViewModel.withSubtitle,
                    subtitle: actionViewModel.subtitle,
                  ),
                  SizedBox(height: Margins.spacing_base),
                  _Separator(),
                  SizedBox(height: Margins.spacing_m),
                  _Creator(name: actionViewModel.creator),
                  SizedBox(height: Margins.spacing_m),
                  if (detailsViewModel.dateEcheanceViewModel != null) ...[
                    SizedBox(height: Margins.spacing_base),
                    DateEcheanceInDetail(
                      icons: detailsViewModel.dateEcheanceViewModel!.icons,
                      formattedTexts: detailsViewModel.dateEcheanceViewModel!.formattedTexts,
                      textColor: detailsViewModel.dateEcheanceViewModel!.textColor,
                      backgroundColor: detailsViewModel.dateEcheanceViewModel!.backgroundColor,
                    ),
                  ],
                  SizedBox(height: Margins.spacing_xl),
                  _Separator(),
                  SizedBox(height: Margins.spacing_base),
                  _CommentCard(actionId: actionViewModel.id, actionTitle: actionViewModel.title),
                  SizedBox(height: Margins.spacing_l),
                  _Separator(),
                  SizedBox(height: Margins.spacing_base),
                  _changeStatus(),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: PrimaryActionButton(
            onPressed: () => {detailsViewModel.onRefreshStatus(actionViewModel.id, status)},
            label: Strings.refreshActionStatus,
          ),
        ),
        if (actionViewModel.withDeleteOption)
          _DeleteAction(
            viewModel: detailsViewModel,
            onDeleteAction: _onDeleteAction,
          ),
      ],
    );
  }

  void _onDeleteAction(UserActionDetailsViewModel detailsViewModel) {
    if (detailsViewModel.displayState != UserActionDetailsDisplayState.SHOW_LOADING) {
      detailsViewModel.onDelete(actionViewModel.id);
      MatomoTracker.trackScreenWithName(AnalyticsActionNames.deleteUserAction, AnalyticsScreenNames.userActionDetails);
    }
  }

  void _bottomSheetHandling(BuildContext context, UserActionDetailsViewModel viewModel) {
    if (viewModel.displayState == UserActionDetailsDisplayState.SHOW_SUCCESS) {
      showPassEmploiBottomSheet(context: context, builder: _successBottomSheet).then((value) => Navigator.pop(context));
    } else if (viewModel.displayState == UserActionDetailsDisplayState.TO_DISMISS) {
      Navigator.pop(context);
    } else if (viewModel.displayState == UserActionDetailsDisplayState.TO_DISMISS_AFTER_UPDATE) {
      _trackSuccessfulUpdate();
      Navigator.pop(context, UserActionDetailsDisplayState.TO_DISMISS_AFTER_UPDATE);
    } else if (viewModel.displayState == UserActionDetailsDisplayState.TO_DISMISS_AFTER_DELETION) {
      Navigator.pop(context, UserActionDetailsDisplayState.TO_DISMISS_AFTER_DELETION);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Strings.deleteActionSuccess)));
    }
  }

  Widget _changeStatus() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Margins.spacing_base),
          child: Text(Strings.updateStatus, style: TextStyles.textBaseBold),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: Margins.spacing_base),
          child: UserActionStatusGroup(
            status: status,
            update: (newState) => setState(() => status = newState),
          ),
        ),
      ],
    );
  }

  Widget _successBottomSheet(BuildContext context) {
    return _SuccessBottomSheet();
  }

  void _trackSuccessfulUpdate() {
    MatomoTracker.trackScreenWithName(AnalyticsScreenNames.updateUserAction, AnalyticsScreenNames.userActionDetails);
  }
}

class _Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: AppColors.primaryLighten);
  }
}

class _SuccessBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      userActionBottomSheetHeader(context, title: ""),
      SvgPicture.asset(Drawables.icCongratulations),
      Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          Strings.congratulationsActionUpdated,
          style: TextStyles.textBaseBold,
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          Strings.conseillerNotifiedActionUpdated,
          style: TextStyles.textBaseRegular,
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        child: PrimaryActionButton(
          label: Strings.understood,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    ]);
  }
}

class _Title extends StatelessWidget {
  final String title;

  _Title({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyles.textLBold());
  }
}

class _Description extends StatelessWidget {
  final bool withSubtitle;
  final String subtitle;

  _Description({required this.withSubtitle, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    if (withSubtitle) {
      return TextWithClickableLinks(subtitle, style: TextStyles.textSRegular());
    } else {
      return SizedBox(height: Margins.spacing_s);
    }
  }
}

class _Creator extends StatelessWidget {
  final String name;

  _Creator({required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(Strings.actionCreatedBy, style: TextStyles.textBaseBold),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(name, style: TextStyles.textSBold),
          ),
        ),
      ],
    );
  }
}

class _DeleteAction extends StatelessWidget {
  final UserActionDetailsViewModel viewModel;
  final Function(UserActionDetailsViewModel) onDeleteAction;

  _DeleteAction({required this.viewModel, required this.onDeleteAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, Margins.spacing_base, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryActionButton(
            onPressed: () => onDeleteAction(viewModel),
            label: Strings.deleteAction,
            textColor: AppColors.warning,
            fontSize: FontSizes.normal,
            backgroundColor: AppColors.warningLighten,
            disabledBackgroundColor: AppColors.warningLight,
            rippleColor: AppColors.warningLight,
            withShadow: false,
          ),
          if (viewModel.displayState == UserActionDetailsDisplayState.SHOW_DELETE_ERROR)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                Strings.deleteActionError,
                textAlign: TextAlign.center,
                style: TextStyles.textSRegular(color: AppColors.warning),
              ),
            ),
        ],
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  final String actionId;
  final String actionTitle;

  _CommentCard({required this.actionId, required this.actionTitle});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ActionCommentaireViewModel>(
      onInit: (store) => store.dispatch(ActionCommentaireListRequestAction(actionId)),
      converter: (store) => ActionCommentaireViewModel.create(store, actionId),
      builder: (context, viewModel) => _build(context, viewModel),
      distinct: true,
    );
  }

  Widget _build(BuildContext context, ActionCommentaireViewModel viewModel) {
    switch (viewModel.displayState) {
      case DisplayState.CONTENT:
        return _content(context, viewModel, actionTitle);
      case DisplayState.FAILURE:
        return Center(child: Retry(Strings.miscellaneousErrorRetry, () => viewModel.onRetry()));
      default:
        return loader();
    }
  }

  Widget _content(BuildContext context, ActionCommentaireViewModel viewModel, String actionTitle) {
    final commentsNumber = viewModel.comments.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.lastComment, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_base),
        if (viewModel.lastComment != null) Comment(comment: viewModel.lastComment!),
        if (viewModel.lastComment == null) Text(Strings.noComments, style: TextStyles.textBaseRegular),
        SizedBox(height: Margins.spacing_xl),
        SecondaryButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ActionCommentairesPage(actionTitle, viewModel.comments)),
          ),
          label: commentsNumber < 1 ? Strings.addComment : Strings.seeNComments(commentsNumber.toString()),
        ),
      ],
    );
  }
}
