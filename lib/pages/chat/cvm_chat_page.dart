import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_actions.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/cvm/cvm_actions.dart';
import 'package:pass_emploi_app/presentation/chat/cvm_chat_item.dart';
import 'package:pass_emploi_app/presentation/chat/cvm_chat_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/widgets/chat/chat_content.dart';
import 'package:pass_emploi_app/widgets/chat/chat_day_section.dart';
import 'package:pass_emploi_app/widgets/chat/chat_information.dart';
import 'package:pass_emploi_app/widgets/chat/chat_scaffold.dart';
import 'package:pass_emploi_app/widgets/chat/cvm/cvm_chat_text_message.dart';
import 'package:redux/redux.dart';

class CvmChatPage extends StatefulWidget {
  static MaterialPageRoute<void> materialPageRoute() => MaterialPageRoute(builder: (context) => CvmChatPage());

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
    return Tracker(
      tracking: AnalyticsScreenNames.cvmChat,
      child: StoreConnector<AppState, CvmChatPageViewModel>(
        onInit: (store) => store.dispatch(CvmRequestAction()),
        onDispose: _onDispose,
        converter: CvmChatPageViewModel.create,
        builder: _builder,
        onDidChange: (_, __) => _isLoadingMorePast = false,
        distinct: true,
      ),
    );
  }

  Widget _builder(BuildContext context, CvmChatPageViewModel viewModel) {
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

extension on CvmChatItem {
  Widget toWidget() {
    return switch (this) {
      final DayItem item => ChatDaySection(dayLabel: item.dayLabel),
      final TextMessageItem item => CvmChatTextMessage(item),
      final InformationItem item => ChatInformation(item.title, item.description),
      PieceJointeConseillerMessageItem() => SizedBox.shrink(),
    };
  }
}
