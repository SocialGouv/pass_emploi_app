import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/chat_partage_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class ChatPartagePage extends StatefulWidget {
  final ChatPartageSource source;

  ChatPartagePage._({required this.source});

  @override
  _ChatPartagePageState createState() => _ChatPartagePageState();

  static MaterialPageRoute<void> materialPageRoute(ChatPartageSource source) {
    return MaterialPageRoute(builder: (context) {
      return ChatPartagePage._(source: source);
    });
  }
}

class _ChatPartagePageState extends State<ChatPartagePage> {
  late TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.emploiPartagePage,
      child: StoreConnector<AppState, ChatPartagePageViewModel>(
        converter: (store) => ChatPartagePageViewModel.fromSource(store, widget.source),
        builder: (context, viewModel) => _scaffold(context, viewModel),
        onWillChange: (_, viewModel) => _displaySnackBar(viewModel),
        distinct: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Scaffold _scaffold(BuildContext context, ChatPartagePageViewModel viewModel) {
    _controller = TextEditingController(text: viewModel.defaultMessage);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(
        label: viewModel.pageTitle,
        context: context,
        withBackButton: true,
      ),
      body: _body(context, viewModel),
    );
  }

  Widget _body(BuildContext context, ChatPartagePageViewModel viewModel) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(viewModel.willShareTitle, style: TextStyles.textBaseBold),
            SizedBox(height: Margins.spacing_base),
            _offre(viewModel),
            SizedBox(height: Margins.spacing_l),
            Text(Strings.messagePourConseiller, style: TextStyles.textBaseMedium),
            SizedBox(height: Margins.spacing_base),
            _textField(),
            SizedBox(height: Margins.spacing_l),
            _infoPartage(viewModel),
            SizedBox(height: Margins.spacing_l),
            _shareButton(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _offre(ChatPartagePageViewModel viewModel) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey100, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(viewModel.shareableTitle, style: TextStyles.textBaseBold),
      ),
    );
  }

  Widget _textField() {
    return TextField(
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.contentColor, width: 1.0),
        ),
      ),
      maxLines: null,
      controller: _controller,
    );
  }

  Widget _infoPartage(ChatPartagePageViewModel viewModel) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLighten,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          viewModel.information,
          style: TextStyles.textBaseBoldWithColor(AppColors.primary),
        ),
      ),
    );
  }

  Widget _shareButton(BuildContext context, ChatPartagePageViewModel viewModel) {
    if (viewModel.snackbarState == DisplayState.LOADING) {
      return Center(child: CircularProgressIndicator(color: AppColors.nightBlue));
    } else {
      return PrimaryActionButton(
        label: viewModel.shareButtonTitle,
        onPressed: () => viewModel.onShare(_controller.text),
      );
    }
  }
  // todo vm snackbar
  void _displaySnackBar(ChatPartagePageViewModel viewModel) {
    switch (viewModel.snackbarState) {
      case DisplayState.EMPTY:
      case DisplayState.LOADING:
        return;
      case DisplayState.CONTENT:
        MatomoTracker.trackScreenWithName(viewModel.snackbarSuccessTracking, "");
        showSuccessfulSnackBar(context, viewModel.snackbarSuccessText);
        viewModel.snackbarDisplayed();
        Navigator.pop(context);
        return;
      case DisplayState.FAILURE:
        showFailedSnackBar(context, Strings.miscellaneousErrorRetry);
        viewModel.snackbarDisplayed();
        return;
    }
  }
}
