import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/chat/chat_item.dart';
import 'package:pass_emploi_app/presentation/chat/piece_jointe_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/chat/chat_message_container.dart';

class ChatPieceJointe extends StatelessWidget {
  final PieceJointeConseillerMessageItem item;

  const ChatPieceJointe(this.item) : super();

  @override
  Widget build(BuildContext context) {
    return ChatMessageContainer(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(item.message, style: TextStyles.textSRegular()),
          SizedBox(height: 14),
          _PieceJointeName(item.filename),
          SizedBox(height: 20),
          _DownloadButton(item: item),
        ],
      ),
      isMyMessage: false,
      caption: item.caption,
      captionColor: null,
    );
  }
}

class _PieceJointeName extends StatelessWidget {
  final String filename;

  const _PieceJointeName(this.filename) : super();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Icon(
            AppIcons.attach_file_rounded,
            color: AppColors.primary,
          ),
        ),
        Flexible(
          child: Text(
            filename,
            style: TextStyles.textSBoldWithColor(Colors.black),
          ),
        ),
      ],
    );
  }
}

class _DownloadButton extends StatefulWidget {
  final PieceJointeConseillerMessageItem item;

  const _DownloadButton({required this.item}) : super();

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PieceJointeViewModel>(
      converter: (store) => PieceJointeViewModel.create(store),
      builder: (context, viewModel) => _body(viewModel),
      distinct: true,
    );
  }

  Widget _body(PieceJointeViewModel viewModel) {
    return switch (viewModel.displayState(widget.item.pieceJointeId)) {
      DisplayState.LOADING => Center(child: CircularProgressIndicator()),
      DisplayState.EMPTY => _FileWasDeleted(),
      _ => _downloadButton(viewModel)
    };
  }

  Widget _downloadButton(PieceJointeViewModel viewModel) {
    return Center(
      child: PrimaryActionButton(
        label: viewModel.displayState(widget.item.pieceJointeId) == DisplayState.FAILURE ? Strings.retry : Strings.open,
        icon: AppIcons.download_rounded,
        onPressed: () => viewModel.onClick(widget.item),
        heightPadding: 2,
      ),
    );
  }
}

class _FileWasDeleted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Icon(AppIcons.error_rounded, color: AppColors.warning),
        ),
        Flexible(
          child: Text(
            Strings.fileNotAvailableTitle,
            style: TextStyles.textBaseMediumWithColor(AppColors.warning),
          ),
        ),
      ],
    );
  }
}
