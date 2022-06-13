import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/share_sheet_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:share_plus/share_plus.dart';

class ShareSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ShareSheetViewModel>(
      converter: (store) => ShareSheetViewModel.create(store),
      builder: (context, viewModel) => _body(viewModel, context),
      distinct: true,
    );
  }

  Widget _body(ShareSheetViewModel viewModel, BuildContext context) {
    _share(viewModel);
    return SizedBox();
  }

  _share(ShareSheetViewModel viewModel) async {
    final path = viewModel.path;
    if (path == null) return;

    await Share.shareFilesWithResult([path]);
    viewModel.shareSheetClosed();
  }
}
