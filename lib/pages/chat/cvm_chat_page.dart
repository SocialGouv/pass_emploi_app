import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_actions.dart';
import 'package:pass_emploi_app/features/cvm/cvm_actions.dart';
import 'package:pass_emploi_app/presentation/chat/cvm_chat_item.dart';
import 'package:pass_emploi_app/presentation/chat/cvm_chat_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/a11y/auto_focus.dart';
import 'package:pass_emploi_app/widgets/chat/chat_content.dart';
import 'package:pass_emploi_app/widgets/chat/chat_day_section.dart';
import 'package:pass_emploi_app/widgets/chat/chat_piece_jointe.dart';
import 'package:pass_emploi_app/widgets/chat/chat_scaffold.dart';
import 'package:pass_emploi_app/widgets/chat/chat_text_message.dart';
import 'package:pass_emploi_app/widgets/info_card.dart';
import 'package:redux/redux.dart';

class CvmChatPage extends StatefulWidget {
  @override
  CvmChatPageState createState() => CvmChatPageState();
}

class CvmChatPageState extends State<CvmChatPage> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController? _controller;
  bool _isLoadingMorePast = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final hasReachedTop = _scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9;
      if (hasReachedTop && _isLoadingMorePast == false) {
        _isLoadingMorePast = true;
        StoreProvider.of<AppState>(context).dispatch(CvmLoadMoreAction());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutoFocusA11y(
      child: Tracker(
        tracking: AnalyticsScreenNames.cvmChat,
        child: StoreConnector<AppState, CvmChatPageViewModel>(
          onInit: (store) => store.dispatch(CvmLastJeuneReadingAction()),
          onDispose: _onDispose,
          converter: (store) => CvmChatPageViewModel.create(store),
          builder: _builder,
          onDidChange: (_, __) {
            context.dispatch(CvmLastJeuneReadingAction());
            _isLoadingMorePast = false;
          },
          distinct: true,
        ),
      ),
    );
  }

  Widget _builder(BuildContext context, CvmChatPageViewModel viewModel) {
    _controller = (_controller != null) ? _controller : TextEditingController(text: viewModel.brouillon);
    return ChatScaffold(
      displayState: viewModel.displayState,
      onRetry: viewModel.onRetry,
      title: 'Messagerie', // to distinguish from the other chat page
      content: ChatContent(
        reversedItems: viewModel.items.reversed.toList(),
        controller: _controller!,
        scrollController: _scrollController,
        onSendMessage: viewModel.onSendMessage,
        onSendImage: (_) {},
        onSendFile: (_) {},
        jeunePjEnabled: false,
        itemBuilder: (context, index) {
          final item = viewModel.items.reversed.toList()[index];
          final widget = item.toWidget();
          return widget;
        },
      ),
    );
  }

  void _onDispose(Store<AppState> store) {
    if (_controller != null) store.dispatch(SaveChatBrouillonAction(_controller!.value.text));
  }
}

extension on CvmChatItem {
  Widget toWidget() {
    return switch (this) {
      final CvmDayItem item => ChatDaySection(dayLabel: item.dayLabel),
      final CvmTextMessageItem item => ChatTextMessage(item.toParams()),
      final CvmInformationItem item => InfoCard(message: '${item.title} ${item.description}'),
      final CvmPieceJointeConseillerMessageItem item => ChatPieceJointe(item.toParams()),
    };
  }
}

extension on CvmPieceJointeConseillerMessageItem {
  PieceJointeParams toParams() {
    return PieceJointeTypeUrlParams(
      sender: sender,
      caption: caption,
      filename: fileName,
      fileId: fileId,
      url: url,
      captionColor: null,
    );
  }
}

extension on CvmTextMessageItem {
  ChatTextMessageParams toParams() {
    return ChatTextMessageParams(
      sender: sender,
      content: content,
      caption: caption,
      captionColor: null,
    );
  }
}
