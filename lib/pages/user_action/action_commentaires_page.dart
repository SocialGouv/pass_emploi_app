import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/create/action_commentaire_create_actions.dart';
import 'package:pass_emploi_app/models/commentaire.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action/commentaires/action_commentaire_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/comment.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/loading_overlay.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class ActionCommentairesPage extends StatefulWidget {
  final String actionId;
  final String actionTitle;

  ActionCommentairesPage({required this.actionId, required this.actionTitle});

  static MaterialPageRoute<void> materialPageRoute({required String actionId, required String actionTitle}) {
    return MaterialPageRoute(
        builder: (context) => ActionCommentairesPage(actionId: actionId, actionTitle: actionTitle));
  }

  @override
  State<ActionCommentairesPage> createState() => _ActionCommentairesPageState();
}

class _ActionCommentairesPageState extends State<ActionCommentairesPage> {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.actionCommentsPage,
      child: Scaffold(
        appBar: SecondaryAppBar(title: Strings.actionCommentsTitle),
        body: StoreConnector<AppState, ActionCommentairePageViewModel>(
          converter: (store) => ActionCommentairePageViewModel.create(store, widget.actionId),
          builder: (context, viewModel) => _body(context, viewModel),
          onDidChange: (oldViewModel, newViewModel) {
            if (newViewModel.errorOnSend) showSnackBarWithSystemError(context, Strings.sendCommentError);
          },
          onDispose: (store) => store.dispatch(ActionCommentaireCreateResetAction()),
          distinct: true,
        ),
      ),
    );
  }

  Widget _body(BuildContext context, ActionCommentairePageViewModel viewModel) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(Margins.spacing_m, 0, Margins.spacing_m, Margins.spacing_huge),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: Margins.spacing_m),
              _Title(title: widget.actionTitle),
              SizedBox(height: Margins.spacing_xl),
              _CommentsWidget(viewModel),
            ],
          ),
        ),
        _CreateCommentaireWidget(viewModel: viewModel),
        if (_loading(viewModel)) LoadingOverlay(),
      ],
    );
  }

  bool _loading(ActionCommentairePageViewModel viewModel) =>
      viewModel.sendDisplayState == DisplayState.chargement || viewModel.listDisplayState == DisplayState.chargement;
}

class _Title extends StatelessWidget {
  final String title;

  _Title({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyles.textLBold());
  }
}

class _CommentsWidget extends StatelessWidget {
  final ActionCommentairePageViewModel viewModel;

  const _CommentsWidget(this.viewModel);

  @override
  Widget build(BuildContext context) {
    switch (viewModel.listDisplayState) {
      case DisplayState.erreur:
        return Center(child: Retry(Strings.chatError, () => viewModel.onRetry()));
      case DisplayState.contenu:
        return viewModel.comments.isEmpty
            ? Text(Strings.noComments, style: TextStyles.textBaseRegular)
            : _CommentsList(comments: viewModel.comments);
      default:
        return Container();
    }
  }
}

class _CommentsList extends StatelessWidget {
  final List<Commentaire> comments;
  final ScrollController scroll = ScrollController();

  _CommentsList({required this.comments});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => scroll.jumpTo(scroll.position.maxScrollExtent));
    return Expanded(
      child: ListView.separated(
        controller: scroll,
        separatorBuilder: (_, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: SepLine(Margins.spacing_s, Margins.spacing_s),
        ),
        itemCount: comments.length,
        itemBuilder: (context, index) => Comment(comment: comments[index]),
      ),
    );
  }
}

class _CreateCommentaireWidget extends StatefulWidget {
  final ActionCommentairePageViewModel viewModel;

  const _CreateCommentaireWidget({required this.viewModel});

  @override
  State<_CreateCommentaireWidget> createState() => _CreateCommentaireWidgetState();
}

class _CreateCommentaireWidgetState extends State<_CreateCommentaireWidget> {
  late TextEditingController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller = TextEditingController(text: widget.viewModel.draft);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: AppColors.primaryLighten,
        padding: const EdgeInsets.all(Margins.spacing_m),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: BaseTextField(
                controller: _controller,
                autofocus: widget.viewModel.comments.isEmpty && !_loading(),
                enabled: !_loading(),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                maxLines: null,
                hintText: Strings.yourComment,
              ),
            ),
            SizedBox(width: Margins.spacing_s),
            FloatingActionButton(
              backgroundColor: AppColors.primary,
              child: Icon(AppIcons.send_rounded, color: Colors.white),
              onPressed: () {
                if (_controller.value.text.isNotEmpty && !_loading()) {
                  widget.viewModel.onSend(_controller.value.text);
                  PassEmploiMatomoTracker.instance.trackScreen(AnalyticsActionNames.sendComment);
                  _controller.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _loading() =>
      widget.viewModel.sendDisplayState == DisplayState.chargement ||
      widget.viewModel.listDisplayState == DisplayState.chargement;
}
