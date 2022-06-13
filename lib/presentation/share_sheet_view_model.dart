import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/share_file/share_file_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ShareSheetViewModel extends Equatable {
  final String? path;

  ShareSheetViewModel({required this.path});

  factory ShareSheetViewModel.create(Store<AppState> store) {
    final shareFileState = store.state.shareFileState;

    return ShareSheetViewModel(
      path: (shareFileState is ShareFileSuccessState) ? shareFileState.path : null,
    );
  }

  @override
  List<Object?> get props => [path];
}