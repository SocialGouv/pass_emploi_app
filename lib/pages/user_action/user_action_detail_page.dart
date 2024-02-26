import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/details/user_action_details_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/pages/user_action/action_commentaires_page.dart';
import 'package:pass_emploi_app/pages/user_action/update/update_user_action_form.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action/commentaires/action_commentaire_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_details_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/comment.dart';
import 'package:pass_emploi_app/widgets/confetti_wrapper.dart';
import 'package:pass_emploi_app/widgets/connectivity_widgets.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
import 'package:pass_emploi_app/widgets/loading_overlay.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:pass_emploi_app/widgets/text_with_clickable_links.dart';

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
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.userActionDetails,
      child: ConfettiWrapper(
        builder: (context, confettiController) {
          return StoreConnector<AppState, UserActionDetailsViewModel>(
            onInit: (store) {
              if (widget.source == UserActionStateSource.noSource) {
                store.dispatch(UserActionDetailsRequestAction(widget.userActionId));
              }
              store.dispatch(UserActionUpdateResetAction());
              store.dispatch(UserActionDeleteResetAction());
            },
            converter: (store) => UserActionDetailsViewModel.create(store, widget.source, widget.userActionId),
            builder: (context, viewModel) => _Scaffold(
              body: _Body(viewModel, () => confettiController.play()),
              viewModel: viewModel,
              source: widget.source,
            ),
            onDispose: (store) {
              if (widget.source == UserActionStateSource.noSource) store.dispatch(UserActionDetailsResetAction());
            },
            onDidChange: (previousVm, newVm) => _pageNavigationHandling(newVm),
            distinct: true,
          );
        },
      ),
    );
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
      _popBothUpdateAndDetailsPages();
      showSnackBarWithSuccess(context, Strings.deleteActionSuccess);
    } else if (viewModel.deleteDisplayState == DeleteDisplayState.SHOW_DELETE_ERROR) {
      showSnackBarWithSystemError(context, Strings.deleteActionError);
    }
  }

  void _popBothUpdateAndDetailsPages() {
    Navigator.popUntil(context, (route) => route.settings.name == Navigator.defaultRouteName);
  }

  Widget _successBottomSheet(BuildContext context) {
    return _SuccessBottomSheet();
  }

  void _trackSuccessfulUpdate() {
    PassEmploiMatomoTracker.instance.trackScreen(AnalyticsScreenNames.updateUserAction);
  }
}

class _Scaffold extends StatelessWidget {
  final Widget body;
  final UserActionDetailsViewModel viewModel;
  final UserActionStateSource source;

  const _Scaffold({
    required this.body,
    required this.viewModel,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.actionDetails),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (viewModel.withUnfinishedButton) ...[
              SizedBox(height: Margins.spacing_base),
              _UnfinishedActionButton(viewModel),
            ],
            if (viewModel.withUpdateButton) ...[
              SizedBox(height: Margins.spacing_base),
              _UpdateButton(source, viewModel.id),
            ],
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: body,
    );
  }
}

class _Body extends StatelessWidget {
  final UserActionDetailsViewModel viewModel;
  final VoidCallback onActionDone;

  const _Body(this.viewModel, this.onActionDone);

  @override
  Widget build(BuildContext context) {
    return switch (viewModel.displayState) {
      DisplayState.CONTENT => _Content(viewModel, onActionDone),
      DisplayState.LOADING => Center(child: CircularProgressIndicator()),
      _ => Center(child: Retry(Strings.userActionDetailsError, () => viewModel.onRetry()))
    };
  }
}

class _Content extends StatelessWidget {
  final UserActionDetailsViewModel viewModel;
  final VoidCallback onActionDone;

  const _Content(this.viewModel, this.onActionDone);

  @override
  Widget build(BuildContext context) {
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
                      viewModel.pillule.toActionCardPillule(),
                      SizedBox(height: Margins.spacing_base),
                      _Title(title: viewModel.title),
                      SizedBox(height: Margins.spacing_base),
                      if (viewModel.withFinishedButton) _FinishActionButton(viewModel, onActionDone),
                      SizedBox(height: Margins.spacing_m),
                      _Separator(),
                      SizedBox(height: Margins.spacing_m),
                      Text(Strings.userActionDetailsSection, style: TextStyles.textBaseBold),
                      if (viewModel.withSubtitle) ...[
                        SizedBox(height: Margins.spacing_base),
                        _Description(
                          withSubtitle: viewModel.withSubtitle,
                          subtitle: viewModel.subtitle,
                        ),
                      ],
                      SizedBox(height: Margins.spacing_l),
                      _DateAndCategory(viewModel),
                      SizedBox(height: Margins.spacing_l),
                      Text(viewModel.creationDetails, style: TextStyles.textSRegular(color: AppColors.grey800)),
                      SizedBox(height: Margins.spacing_m),
                      _Separator(),
                      if (viewModel.withComments) ...[
                        SizedBox(height: Margins.spacing_base),
                        _CommentSection(viewModel),
                      ],
                      SizedBox(height: Margins.spacing_x_huge * 2),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_isLoading(viewModel)) LoadingOverlay(),
      ],
    );
  }

  bool _isLoading(UserActionDetailsViewModel viewModel) {
    return viewModel.updateDisplayState == UpdateDisplayState.SHOW_LOADING ||
        viewModel.deleteDisplayState == DeleteDisplayState.SHOW_LOADING;
  }
}

class _FinishActionButton extends StatelessWidget {
  const _FinishActionButton(this.viewModel, this.onActionDone);

  final UserActionDetailsViewModel viewModel;
  final VoidCallback onActionDone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryActionButton(
        label: Strings.completeAction,
        suffix: Icon(AppIcons.celebration_rounded, color: Colors.white),
        onPressed: () {
          onActionDone();
          viewModel.updateStatus(UserActionStatus.DONE);
        },
      ),
    );
  }
}

class _UnfinishedActionButton extends StatelessWidget {
  const _UnfinishedActionButton(this.viewModel);

  final UserActionDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryActionButton(
        label: Strings.unCompleteAction,
        icon: AppIcons.schedule,
        onPressed: () => viewModel.updateStatus(UserActionStatus.IN_PROGRESS),
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
    return ColoredBox(
      color: Colors.white,
      child: Column(
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
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            child: PrimaryActionButton(
              label: Strings.understood,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
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

class _UpdateButton extends StatelessWidget {
  final UserActionStateSource source;
  final String userActionId;

  const _UpdateButton(this.source, this.userActionId);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SecondaryButton(
        label: Strings.updateUserAction,
        onPressed: () => Navigator.push(context, UpdateUserActionForm.route(source, userActionId)),
      ),
    );
  }
}

class _CommentSection extends StatelessWidget {
  const _CommentSection(this.viewModel);

  final UserActionDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.withOfflineBehavior) {
      return _UnavailableCommentsOffline();
    } else {
      return _CommentCard(actionId: viewModel.id, actionTitle: viewModel.title);
    }
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
      children: [
        Expanded(
          child: _section(
            sectionIcon: AppIcons.event,
            sectionTitle: Strings.userActionDate,
            value: viewModel.date,
          ),
        ),
        Expanded(
          child: _section(
            sectionIcon: Icons.account_tree_rounded,
            sectionTitle: Strings.userActionCategory,
            value: viewModel.category,
          ),
        ),
      ],
    );
  }

  Widget _section({required IconData sectionIcon, required String sectionTitle, required String value}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: Margins.spacing_xs / 2),
          child: Icon(sectionIcon, color: AppColors.grey500, size: Dimens.icon_size_base),
        ),
        SizedBox(width: Margins.spacing_xs),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sectionTitle, style: TextStyles.textSRegular(color: AppColors.grey700)),
            SizedBox(height: Margins.spacing_xs),
            Text(value, style: TextStyles.textSBold)
          ],
        )
      ],
    );
    // return Column(
    //   mainAxisSize: MainAxisSize.min,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Row(
    //       children: [
    //         Icon(sectionIcon, color: AppColors.grey500, size: Dimens.icon_size_base),
    //         SizedBox(width: Margins.spacing_xs),
    //         Text(sectionTitle, style: TextStyles.textSRegular(color: AppColors.grey700)),
    //       ],
    //     ),
    //     SizedBox(height: Margins.spacing_xs),
    //     Text(value, style: TextStyles.textSBold)
    //   ],
    // );
  }
}
