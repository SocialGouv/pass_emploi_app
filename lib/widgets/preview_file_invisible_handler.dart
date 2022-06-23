import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_file/open_file.dart';
import 'package:pass_emploi_app/presentation/preview_file_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

class PreviewFileInvisibleHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PreviewFileViewModel>(
      converter: (store) => PreviewFileViewModel.create(store),
      builder: (context, viewModel) => _body(viewModel, context),
      distinct: true,
    );
  }

  Widget _body(PreviewFileViewModel viewModel, BuildContext context) {
    _open(viewModel);
    return SizedBox();
  }

  void _open(PreviewFileViewModel viewModel) async {
    final path = viewModel.path;
    if (path == null) return;

    OpenFile.open(path);

    viewModel.viewClosed();
  }
}
