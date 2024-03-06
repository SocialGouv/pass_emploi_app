import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_actions.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/presentation/chat/chat_item.dart';
import 'package:pass_emploi_app/presentation/chat/chat_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/widgets/apparition_animation.dart';
import 'package:pass_emploi_app/widgets/chat/chat_content.dart';
import 'package:pass_emploi_app/widgets/chat/chat_day_section.dart';
import 'package:pass_emploi_app/widgets/chat/chat_information.dart';
import 'package:pass_emploi_app/widgets/chat/chat_piece_jointe.dart';
import 'package:pass_emploi_app/widgets/chat/chat_scaffold.dart';
import 'package:pass_emploi_app/widgets/chat/chat_text_message.dart';
import 'package:pass_emploi_app/widgets/chat/partage_message.dart';
import 'package:redux/redux.dart';

class ChatPage extends StatefulWidget {
  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  TextEditingController? _controller;
  bool _animateMessage = false;
  bool _isLoadingMorePast = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(() {
      final hasReachedTop = _scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9;
      if (hasReachedTop && _isLoadingMorePast == false) {
        _isLoadingMorePast = true;
        StoreProvider.of<AppState>(context).dispatch(ChatRequestMorePastAction());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      StoreProvider.of<AppState>(context).dispatch(UnsubscribeFromChatAction());
    }
    if (state == AppLifecycleState.resumed) {
      StoreProvider.of<AppState>(context).dispatch(SubscribeToChatAction());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.chat,
      child: StoreConnector<AppState, ChatPageViewModel>(
        onInit: (store) {
          store.dispatch(LastMessageSeenAction());
          store.dispatch(SubscribeToChatAction());
        },
        onDispose: _onDispose,
        converter: ChatPageViewModel.create,
        builder: _builder,
        onDidChange: (_, __) {
          StoreProvider.of<AppState>(context).dispatch(LastMessageSeenAction());
          _animateMessage = true;
          _isLoadingMorePast = false;
        },
        distinct: true,
      ),
    );
  }

  Widget _builder(BuildContext context, ChatPageViewModel viewModel) {
    _controller = (_controller != null) ? _controller : TextEditingController(text: viewModel.brouillon);
    return ChatScaffold(
      displayState: viewModel.displayState,
      onRetry: viewModel.onRetry,
      content: ChatContent(
        reversedItems: viewModel.items.reversed.toList(),
        controller: _controller!,
        scrollController: _scrollController,
        onSendMessage: viewModel.onSendMessage,
        itemBuilder: (context, index) {
          final item = viewModel.items.reversed.toList()[index];
          final widget = item.toWidget();

          if (index == 0 && _animateMessage && item.shouldAnimate) {
            return ApparitionAnimation(
              key: ValueKey(item.messageId),
              child: SizedBox(
                width: double.infinity,
                child: widget,
              ),
            );
          }
          return widget;
        },
      ),
    );
  }

  void _onDispose(Store<AppState> store) {
    store.dispatch(UnsubscribeFromChatAction());
    if (_controller != null) store.dispatch(SaveChatBrouillonAction(_controller!.value.text));
  }
}

extension on ChatItem {
  Widget toWidget() {
    return switch (this) {
      final DayItem item => ChatDaySection(dayLabel: item.dayLabel),
      final TextMessageItem item => ChatTextMessage(item),
      final InformationItem item => ChatInformation(item.title, item.description),
      final PieceJointeConseillerMessageItem item => ChatPieceJointe(item),
      final PartageMessageItem item => PartageMessage(item),
    };
  }
}
