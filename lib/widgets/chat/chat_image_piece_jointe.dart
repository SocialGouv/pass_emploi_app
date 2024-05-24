import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_actions.dart';
import 'package:pass_emploi_app/presentation/chat/chat_item.dart';
import 'package:pass_emploi_app/presentation/chat/piece_jointe_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/widgets/chat/chat_message_container.dart';
import 'package:pass_emploi_app/widgets/chat/chat_piece_jointe.dart';

class ChatImagePieceJointe extends StatelessWidget {
  const ChatImagePieceJointe(this.item);
  final PieceJointeImageItem item;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PieceJointeViewModel>(
      onInit: (store) {
        store.dispatch(PieceJointeFromIdRequestAction(item.pieceJointeId, item.pieceJointeName, isImage: true));
      },
      converter: (store) => PieceJointeViewModel.create(store),
      builder: (context, viewModel) => _Body(item: item, viewModel: viewModel),
      distinct: true,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.item, required this.viewModel});
  final PieceJointeImageItem item;
  final PieceJointeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ChatMessageContainer(
      content: switch (viewModel.displayState.call(item.pieceJointeId)) {
        DisplayState.CONTENT => _Content(viewModel.imagePath?.call(item.pieceJointeId)),
        DisplayState.LOADING => _Loading(),
        DisplayState.FAILURE => _Failure(),
        DisplayState.EMPTY => _Failure(),
      },
      isPj: true,
      isMyMessage: true,
      caption: item.caption,
      captionColor: null,
    );
  }
}

class _Content extends StatelessWidget {
  const _Content(this.imagePath);
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) return _Failure();
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.radius_base),
      child: Image.file(File(imagePath!)),
    );
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(Margins.spacing_base),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(AppIcons.image_outlined, color: AppColors.grey100, size: Dimens.icon_size_l),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class _Failure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Margins.spacing_s),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Dimens.radius_base)),
      child: FileWasDeleted(),
    );
  }
}
