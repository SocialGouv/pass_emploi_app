import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/pages/user_action/action_commentaires_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action/commentaires/action_commentaire_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_details_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';
import 'package:pass_emploi_app/widgets/comment.dart';
import 'package:pass_emploi_app/widgets/confetti_wrapper.dart';
import 'package:pass_emploi_app/widgets/connectivity_widgets.dart';
import 'package:pass_emploi_app/widgets/date_echeance_in_detail.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
import 'package:pass_emploi_app/widgets/loading_overlay.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:pass_emploi_app/widgets/text_with_clickable_links.dart';
import 'package:pass_emploi_app/widgets/user_action_status_group.dart';

class UserActionDetailPage extends StatefulWidget {
  final String userActionId;
  final UserActionStateSource source;

  UserActionDetailPage._(this.userActionId, this.source);

  static MaterialPageRoute<void> materialPageRoute(String userActionId, UserActionStateSource source) {
    return MaterialPageRoute(builder: (context) => UserActionDetailPage._(userActionId, source));
  }

  @override
  State<UserActionDetailPage> createState() => _ActionDetailPageState();
}

class _ActionDetailPageState extends State<UserActionDetailPage> {
  UserActionStatus? newStatus;

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.userActionDetails,
      child: ConfettiWrapper(
        builder: (context, confettiController) {
          return Scaffold(
            appBar: SecondaryAppBar(title: Strings.actionDetails),
            body: StoreConnector<AppState, UserActionDetailsViewModel>(
              onInit: (store) {
                store.dispatch(UserActionUpdateResetAction());
                store.dispatch(UserActionDeleteResetAction());
              },
              converter: (store) => UserActionDetailsViewModel.create(store, widget.source, widget.userActionId),
              builder: (context, viewModel) => _build(context, viewModel, () => confettiController.play()),
              onDidChange: (previousVm, newVm) => _pageNavigationHandling(newVm),
              distinct: true,
            ),
          );
        },
      ),
    );
  }

  Widget _build(BuildContext context, UserActionDetailsViewModel viewModel, VoidCallback onActionDone) {
    _initializeNewStatus(viewModel);
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (viewModel.withOfflineBehavior) ConnectivityBandeau(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Margins.spacing_m),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (viewModel.pillule != null) ...[
                        _StatusPillule(pilluleType: viewModel.pillule!),
                        SizedBox(height: Margins.spacing_base),
                      ],
                      _Title(title: viewModel.title),
                      SizedBox(height: Margins.spacing_base),
                      if (viewModel.withFinishedButton) _FinishActionButton(viewModel),
                      SizedBox(height: Margins.spacing_m),
                      _Separator(),
                      SizedBox(height: Margins.spacing_m),
                      Text(Strings.userActionDetailsSection, style: TextStyles.textBaseBold),
                      SizedBox(height: Margins.spacing_base),
                      _Description(
                        withSubtitle: viewModel.withSubtitle,
                        subtitle: viewModel.subtitle,
                      ),
                      SizedBox(height: Margins.spacing_l),
                      _DateAndCategory(viewModel),
                      SizedBox(height: Margins.spacing_l),

                      // ------------------->  <-------------------
                      _Separator(),
                      SizedBox(height: Margins.spacing_m),
                      _Creator(name: viewModel.creator),
                      SizedBox(height: Margins.spacing_m),
                      if (viewModel.dateEcheanceViewModel != null) ...[
                        SizedBox(height: Margins.spacing_base),
                        DateEcheanceInDetail(
                          icons: viewModel.dateEcheanceViewModel!.icons,
                          formattedTexts: viewModel.dateEcheanceViewModel!.formattedTexts,
                          textColor: viewModel.dateEcheanceViewModel!.textColor,
                          backgroundColor: viewModel.dateEcheanceViewModel!.backgroundColor,
                        ),
                      ],
                      SizedBox(height: Margins.spacing_xl),
                      _Separator(),
                      SizedBox(height: Margins.spacing_base),
                      if (viewModel.withOfflineBehavior) _UnavailableCommentsOffline(),
                      if (!viewModel.withOfflineBehavior)
                        _CommentCard(actionId: viewModel.id, actionTitle: viewModel.title),
                      SizedBox(height: Margins.spacing_l),
                      _Separator(),
                      SizedBox(height: Margins.spacing_base),
                      _changeStatus(onActionDone, viewModel.withOfflineBehavior),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: PrimaryActionButton(
                onPressed: (viewModel.status != newStatus && !viewModel.withOfflineBehavior)
                    ? () => viewModel.onRefreshStatus(viewModel.id, newStatus!)
                    : null,
                label: Strings.refreshActionStatus,
              ),
            ),
            if (viewModel.withDeleteOption)
              _DeleteAction(
                viewModel: viewModel,
                onDeleteAction: _onDeleteAction,
              ),
          ],
        ),
        if (_isLoading(viewModel)) LoadingOverlay(),
      ],
    );
  }

  void _initializeNewStatus(UserActionDetailsViewModel viewModel) {
    newStatus ??= viewModel.status;
  }

  bool _isLoading(UserActionDetailsViewModel viewModel) {
    return viewModel.updateDisplayState == UpdateDisplayState.SHOW_LOADING ||
        viewModel.deleteDisplayState == DeleteDisplayState.SHOW_LOADING;
  }

  void _onDeleteAction(UserActionDetailsViewModel viewModel) {
    if (viewModel.deleteDisplayState != DeleteDisplayState.SHOW_LOADING) {
      viewModel.onDelete(viewModel.id);
      PassEmploiMatomoTracker.instance.trackScreen(AnalyticsActionNames.deleteUserAction);
    }
  }

  void _pageNavigationHandling(UserActionDetailsViewModel viewModel) {
    if (viewModel.updateDisplayState == UpdateDisplayState.SHOW_UPDATE_ERROR) {
      showSnackBarWithSystemError(context, Strings.updateStatusError);
      viewModel.resetUpdateStatus();
    } else if (viewModel.updateDisplayState == UpdateDisplayState.SHOW_SUCCESS) {
      showPassEmploiBottomSheet(context: context, builder: _successBottomSheet).then((value) => Navigator.pop(context));
    } else if (viewModel.updateDisplayState == UpdateDisplayState.TO_DISMISS_AFTER_UPDATE) {
      _trackSuccessfulUpdate();
      Navigator.pop(context, UpdateDisplayState.TO_DISMISS_AFTER_UPDATE);
    } else if (viewModel.deleteDisplayState == DeleteDisplayState.TO_DISMISS_AFTER_DELETION) {
      Navigator.pop(context, DeleteDisplayState.TO_DISMISS_AFTER_DELETION);
      showSnackBarWithSuccess(context, Strings.deleteActionSuccess);
    }
  }

  Widget _changeStatus(VoidCallback onActionDone, bool withOfflineBehavior) {
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
            status: newStatus!,
            onActionDone: onActionDone,
            isEnabled: !withOfflineBehavior,
            update: (status) {
              setState(() {
                newStatus = status;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _successBottomSheet(BuildContext context) {
    return _SuccessBottomSheet();
  }

  void _trackSuccessfulUpdate() {
    PassEmploiMatomoTracker.instance.trackScreen(AnalyticsScreenNames.updateUserAction);
  }
}

class _StatusPillule extends StatelessWidget {
  const _StatusPillule({required this.pilluleType});
  final CardPilluleType pilluleType;

  @override
  Widget build(BuildContext context) {
    return pilluleType.toCardPillule();
  }
}

class _FinishActionButton extends StatelessWidget {
  const _FinishActionButton(this.viewModel);
  final UserActionDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryActionButton(
        label: Strings.completeAction,
        suffix: Icon(AppIcons.celebration_rounded, color: Colors.white),
        onPressed: () => viewModel.updateStatus(UserActionStatus.DONE),
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: AppColors.primaryLighten);
  }
}

class _SuccessBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BottomSheetHeader(title: "", padding: EdgeInsets.all(Margins.spacing_m)),
        Center(
          child: SizedBox(
            height: 100,
            width: 100,
            child: Illustration.green(AppIcons.check_rounded),
          ),
        ),
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
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  _Title({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyles.textMBold);
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
            onPressed: viewModel.withOfflineBehavior ? null : () => onDeleteAction(viewModel),
            label: Strings.deleteAction,
            textColor: AppColors.warning,
            fontSize: FontSizes.normal,
            backgroundColor: AppColors.warningLighten,
            disabledBackgroundColor: AppColors.warningLighten,
            rippleColor: AppColors.warningLighten,
            withShadow: false,
          ),
          if (viewModel.deleteDisplayState == DeleteDisplayState.SHOW_DELETE_ERROR)
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
        return _content(context, viewModel, actionId, actionTitle);
      case DisplayState.FAILURE:
        return Center(child: Retry(Strings.miscellaneousErrorRetry, () => viewModel.onRetry()));
      default:
        return Center(child: CircularProgressIndicator());
    }
  }

  Widget _content(BuildContext context, ActionCommentaireViewModel viewModel, String actionId, String actionTitle) {
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
          onPressed: () => _onCommentClick(context, actionId, actionTitle),
          label: commentsNumber < 1 ? Strings.addComment : Strings.seeNComments(commentsNumber.toString()),
        ),
      ],
    );
  }

  void _onCommentClick(BuildContext context, String actionId, String actionTitle) {
    PassEmploiMatomoTracker.instance.trackScreen(AnalyticsActionNames.accessToActionComments);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ActionCommentairesPage(actionId: actionId, actionTitle: actionTitle)),
    );
  }
}

class _UnavailableCommentsOffline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.lastComment, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_base),
        Text(Strings.commentsUnavailableOffline, style: TextStyles.textBaseRegular),
      ],
    );
  }
}

class _DateAndCategory extends StatelessWidget {
  const _DateAndCategory(this.viewModel);
  final UserActionDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _section(
          sectionIcon: AppIcons.event,
          sectionTitle: Strings.userActionDate,
          value: viewModel.date,
        ),
        _section(
          sectionIcon: Icons.account_tree_rounded,
          sectionTitle: Strings.userActionCategory,
          value: viewModel.category,
        ),
      ],
    );
  }

  Widget _section({required IconData sectionIcon, required String sectionTitle, required String value}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(sectionIcon, color: AppColors.grey500, size: Dimens.icon_size_base),
            SizedBox(width: Margins.spacing_xs),
            Text(sectionTitle, style: TextStyles.textSRegular(color: AppColors.grey700)),
          ],
        ),
        SizedBox(height: Margins.spacing_xs),
        Text(value, style: TextStyles.textSBold)
      ],
    );
  }
}
