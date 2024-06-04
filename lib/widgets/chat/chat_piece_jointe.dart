import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';
import 'package:pass_emploi_app/presentation/chat/piece_jointe_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/chat/chat_message_container.dart';

sealed class PieceJointeParams {
  final Sender sender;
  final String? content;
  final String caption;
  final String filename;
  final String fileId;

  PieceJointeParams({
    required this.sender,
    required this.content,
    required this.caption,
    required this.filename,
    required this.fileId,
  });
}

class PieceJointeTypeIdParams extends PieceJointeParams {
  PieceJointeTypeIdParams({
    required super.sender,
    super.content,
    required super.caption,
    required super.filename,
    required super.fileId,
  });
}

class PieceJointeTypeUrlParams extends PieceJointeParams {
  final String url;

  PieceJointeTypeUrlParams({
    required super.sender,
    required super.caption,
    required super.filename,
    required super.fileId,
    required this.url,
  }) : super(content: null);
}

class ChatPieceJointe extends StatelessWidget {
  final PieceJointeParams params;

  const ChatPieceJointe(this.params);

  @override
  Widget build(BuildContext context) {
    return ChatMessageContainer(
      content: Padding(
        padding: const EdgeInsets.all(Margins.spacing_s),
        child: Column(
          crossAxisAlignment: params.sender.isJeune ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (params.content != null) ...[
              SelectableText(params.content!, style: TextStyles.textSRegular()),
              SizedBox(height: Margins.spacing_s),
            ],
            _PieceJointeName(params.filename, params.sender),
            SizedBox(height: Margins.spacing_base),
            _DownloadButton(params),
          ],
        ),
      ),
      isPj: true,
      isMyMessage: params.sender.isJeune,
      caption: params.caption,
      captionColor: null,
    );
  }
}

class _PieceJointeName extends StatelessWidget {
  final String filename;
  final Sender sender;

  const _PieceJointeName(this.filename, this.sender);

  @override
  Widget build(BuildContext context) {
    return Text(
      filename,
      style: TextStyles.textSBoldWithColor(sender.isJeune ? Colors.white : AppColors.contentColor),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  final PieceJointeParams params;

  const _DownloadButton(this.params);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PieceJointeViewModel>(
      converter: (store) => PieceJointeViewModel.create(store, PieceJointeDownloadButtonSource(sender: params.sender)),
      builder: (context, viewModel) => _Body(viewModel: viewModel, params: params),
      distinct: true,
    );
  }
}

class _Body extends StatelessWidget {
  final PieceJointeViewModel viewModel;
  final PieceJointeParams params;

  const _Body({required this.viewModel, required this.params});

  @override
  Widget build(BuildContext context) {
    return switch (viewModel.displayState(params.fileId)) {
      DisplayState.LOADING => Center(child: CircularProgressIndicator()),
      DisplayState.EMPTY => FileWasDeleted(),
      _ => _Button(viewModel: viewModel, params: params),
    };
  }
}

class _Button extends StatelessWidget {
  final PieceJointeViewModel viewModel;
  final PieceJointeParams params;

  const _Button({required this.viewModel, required this.params});

  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      label: viewModel.displayState(params.fileId) == DisplayState.FAILURE ? Strings.retry : Strings.open,
      icon: AppIcons.download_rounded,
      onPressed: () => switch (params) {
        final PieceJointeTypeIdParams params => viewModel.onDownloadTypeId(params.fileId, params.filename),
        final PieceJointeTypeUrlParams params => viewModel.onDownloadTypeUrl(
            params.url,
            params.fileId,
            params.filename,
          ),
      },
      heightPadding: 2,
    );
  }
}

class FileWasDeleted extends StatelessWidget {
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
