import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_actions.dart';
import 'package:pass_emploi_app/presentation/chat/chat_item.dart';
import 'package:pass_emploi_app/presentation/chat/piece_jointe_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

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
    return switch (viewModel.displayState.call(item.pieceJointeId)) {
      DisplayState.CONTENT => _Content(viewModel.imagePath?.call(item.pieceJointeId)),
      DisplayState.LOADING => _Loading(),
      DisplayState.FAILURE => _Failure(),
      DisplayState.EMPTY => _Unavailable(),
    };
  }
}

class _Content extends StatelessWidget {
  const _Content(this.imagePath);
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) return _Failure();
    return Image.file(File(imagePath!));
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _Failure extends StatelessWidget {
  const _Failure();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _Unavailable extends StatelessWidget {
  const _Unavailable();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
