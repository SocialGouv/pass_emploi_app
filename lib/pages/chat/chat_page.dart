import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_actions.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/presentation/chat/chat_item.dart';
import 'package:pass_emploi_app/presentation/chat/chat_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/a11y/auto_focus.dart';
import 'package:pass_emploi_app/widgets/apparition_animation.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/chat_message_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/onboarding/onboarding_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/chat/chat_content.dart';
import 'package:pass_emploi_app/widgets/chat/chat_day_section.dart';
import 'package:pass_emploi_app/widgets/chat/chat_deleted_message.dart';
import 'package:pass_emploi_app/widgets/chat/chat_image_piece_jointe.dart';
import 'package:pass_emploi_app/widgets/chat/chat_local_file.dart';
import 'package:pass_emploi_app/widgets/chat/chat_local_image.dart';
import 'package:pass_emploi_app/widgets/chat/chat_piece_jointe.dart';
import 'package:pass_emploi_app/widgets/chat/chat_scaffold.dart';
import 'package:pass_emploi_app/widgets/chat/chat_text_message.dart';
import 'package:pass_emploi_app/widgets/chat/partage_message.dart';
import 'package:pass_emploi_app/widgets/info_card.dart';
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
  bool _onboardingShown = false;

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
    return AutoFocusA11y(
      child: Tracker(
        tracking: AnalyticsScreenNames.chat,
        child: StoreConnector<AppState, ChatPageViewModel>(
          onInit: (store) {
            store.dispatch(LastMessageSeenAction());
            store.dispatch(SubscribeToChatAction());
          },
          onDispose: _onDispose,
          converter: (store) => ChatPageViewModel.create(store),
          builder: _builder,
          onDidChange: (_, newVm) {
            StoreProvider.of<AppState>(context).dispatch(LastMessageSeenAction());
            _animateMessage = true;
            _isLoadingMorePast = false;
            _handleOnboarding(newVm);
          },
          distinct: true,
        ),
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
        messageImportant: viewModel.messageImportant,
        onSendMessage: viewModel.onSendMessage,
        onSendImage: viewModel.onSendImage,
        onSendFile: viewModel.onSendFile,
        jeunePjEnabled: viewModel.jeunePjEnabled,
        itemBuilder: (context, index) {
          final item = viewModel.items.reversed.toList()[index];
          final widget = item.toWidget(context);

          if (index == 0 && _animateMessage && item.shouldAnimate) {
            return ApparitionAnimation(
              key: ValueKey(item.messageId),
              child: SizedBox(
                width: double.infinity,
                child: widget,
              ),
            );
          } else if (index == 0) {
            return AutoFocusA11y(
              child: Semantics(
                label: Strings.chatA11yLastMessage,
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

  void _handleOnboarding(ChatPageViewModel viewModel) {
    if (viewModel.shouldShowOnboarding && !_onboardingShown) {
      _onboardingShown = true;
      OnboardingBottomSheet.show(context, source: OnboardingSource.chat);
    }
  }
}

extension on ChatItem {
  Widget toWidget(BuildContext context) {
    return GestureDetector(
      onLongPress: _vibrate(
        () => switch (this) {
          final TextMessageItem item => ChatMessageBottomSheet.show(context, item),
          final PieceJointeMessageItem item => ChatMessageBottomSheet.show(context, item),
          final PieceJointeImageItem item => ChatMessageBottomSheet.show(context, item),
          final PartageMessageItem item => ChatMessageBottomSheet.show(context, item),
          LocalImageMessageItem() => null,
          LocalFileMessageItem() => null,
          DeletedMessageItem() => null,
          InformationItem() => null,
          DayItem() => null,
        },
      ),
      child: switch (this) {
        final DayItem item => ChatDaySection(dayLabel: item.dayLabel),
        final TextMessageItem item => ChatTextMessage(item.toParams()),
        final InformationItem item => InfoCard(message: '${item.title} ${item.description}'),
        final DeletedMessageItem item => DeletedMessage(item),
        final PieceJointeMessageItem item => ChatPieceJointe(item.toParams()),
        final PieceJointeImageItem item => ChatImagePieceJointe(item),
        final LocalImageMessageItem item => ChatLocalImage(item),
        final LocalFileMessageItem item => ChatLocalFile(item),
        final PartageMessageItem item => PartageMessage(item),
      },
    );
  }
}

extension on PieceJointeMessageItem {
  PieceJointeParams toParams() {
    return PieceJointeTypeIdParams(
      sender: sender,
      fileId: pieceJointeId,
      filename: filename,
      caption: caption,
      content: message,
      captionColor: captionColor,
    );
  }
}

extension on TextMessageItem {
  ChatTextMessageParams toParams() {
    return ChatTextMessageParams(
      sender: sender,
      content: content,
      caption: caption,
      captionColor: captionColor,
    );
  }
}

// Inspired for Feedback.wrapForLongPress(), except it does make device vibrate whatever its platform is
GestureLongPressCallback? _vibrate(GestureLongPressCallback? callback) {
  if (callback == null) return null;
  return () {
    HapticFeedback.selectionClick();
    callback();
  };
}
