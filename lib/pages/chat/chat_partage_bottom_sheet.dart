import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/chat/chat_partage_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class ChatPartageBottomSheet extends StatefulWidget {
  final ChatPartageSource source;

  ChatPartageBottomSheet._({required this.source});

  @override
  ChatPartageBottomSheetState createState() => ChatPartageBottomSheetState();

  static Future<void> show(BuildContext context, ChatPartageSource source) {
    return showPassEmploiBottomSheet(
      context: context,
      builder: (context) => ChatPartageBottomSheet._(source: source),
    );
  }
}

class ChatPartageBottomSheetState extends State<ChatPartageBottomSheet> {
  TextEditingController? _controller;

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.emploiPartagePage,
      child: StoreConnector<AppState, ChatPartagePageViewModel>(
        converter: (store) => ChatPartagePageViewModel.fromSource(store, widget.source),
        builder: _builder,
        onWillChange: _onWillChange,
        distinct: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _builder(BuildContext context, ChatPartagePageViewModel viewModel) {
    _controller ??= TextEditingController(text: viewModel.defaultMessage);
    return BottomSheetWrapper(
      title: viewModel.pageTitle,
      body: _Body(viewModel, _controller),
    );
  }

  void _onWillChange(ChatPartagePageViewModel? _, ChatPartagePageViewModel viewModel) {
    switch (viewModel.snackbarState) {
      case DisplayState.CONTENT:
        PassEmploiMatomoTracker.instance.trackScreen(viewModel.snackbarSuccessTracking);
        showSnackBarWithSuccess(context, viewModel.snackbarSuccessText);
        viewModel.snackbarDisplayed();
        Navigator.pop(context);
        break;
      case DisplayState.FAILURE:
        showSnackBarWithSystemError(context);
        viewModel.snackbarDisplayed();
        break;
      case DisplayState.EMPTY:
      case DisplayState.LOADING:
        break;
    }
  }
}

class _Body extends StatelessWidget {
  final ChatPartagePageViewModel _viewModel;
  final TextEditingController? _controller;

  const _Body(this._viewModel, this._controller);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(_viewModel.willShareTitle, style: TextStyles.textBaseBold),
          SizedBox(height: Margins.spacing_base),
          _Offre(_viewModel),
          SizedBox(height: Margins.spacing_l),
          Text(Strings.messagePourConseiller, style: TextStyles.textBaseMedium),
          SizedBox(height: Margins.spacing_base),
          _TextField(_controller),
          SizedBox(height: Margins.spacing_l),
          _InfoPartage(_viewModel),
          SizedBox(height: Margins.spacing_l),
          _PartageButton(_viewModel, _controller),
        ],
      ),
    );
  }
}

class _Offre extends StatelessWidget {
  final ChatPartagePageViewModel _viewModel;

  const _Offre(this._viewModel);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey100, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(Dimens.radius_base)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Margins.spacing_base),
        child: Text(_viewModel.shareableTitle, style: TextStyles.textBaseBold),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController? _controller;

  const _TextField(this._controller);

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      maxLines: null,
      controller: _controller,
    );
  }
}

class _InfoPartage extends StatelessWidget {
  final ChatPartagePageViewModel _viewModel;

  const _InfoPartage(this._viewModel);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLighten,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.radius_base)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Margins.spacing_m),
        child: Text(
          _viewModel.information,
          style: TextStyles.textBaseBoldWithColor(AppColors.primary),
        ),
      ),
    );
  }
}

class _PartageButton extends StatelessWidget {
  final ChatPartagePageViewModel _viewModel;
  final TextEditingController? _controller;

  const _PartageButton(this._viewModel, this._controller);

  @override
  Widget build(BuildContext context) {
    return switch (_viewModel.snackbarState) {
      DisplayState.LOADING => Center(child: CircularProgressIndicator()),
      _ => PrimaryActionButton(
          label: _viewModel.shareButtonTitle,
          onPressed: () => _viewModel.onShare(_controller?.text ?? ''),
        )
    };
  }
}
