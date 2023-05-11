import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/preview_file/preview_file_actions.dart';
import 'package:pass_emploi_app/features/chat/preview_file/preview_file_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class PreviewFileViewModel extends Equatable {
  final String? path;
  final Function() viewClosed;

  PreviewFileViewModel({required this.path, required this.viewClosed});

  factory PreviewFileViewModel.create(Store<AppState> store) {
    final previewFileState = store.state.previewFileState;
    return PreviewFileViewModel(
      path: (previewFileState is PreviewFileSuccessState) ? previewFileState.path : null,
      viewClosed: () => store.dispatch(PreviewFileCloseAction()),
    );
  }

  @override
  List<Object?> get props => [path];
}
