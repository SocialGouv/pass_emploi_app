import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pass_emploi_app/presentation/preview_file_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

class PreviewFileInvisibleHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PreviewFileViewModel>(
      converter: (store) => PreviewFileViewModel.create(store),
      builder: (context, viewModel) => _body(viewModel, context),
      onDidChange: (previousViewModel, viewModel) => _open(viewModel),
      distinct: true,
    );
  }

  Widget _body(PreviewFileViewModel viewModel, BuildContext context) {
    return SizedBox();
  }

  void _open(PreviewFileViewModel viewModel) async {
    final path = viewModel.path;
    if (path == null) return;

    OpenFilex.open(path);

    viewModel.viewClosed();
  }
}
