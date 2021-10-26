abstract class ChatItem {}

class DayItem extends ChatItem {
  final String dayLabel;

  DayItem(this.dayLabel);
}

abstract class MessageItem extends ChatItem {
  final String content;
  final String caption;

  MessageItem(this.content, this.caption);
}

class JeuneMessageItem extends MessageItem {
  JeuneMessageItem({required String content, required String caption}) : super(content, caption);
}

class ConseillerMessageItem extends MessageItem {
  ConseillerMessageItem({required String content, required String caption}) : super(content, caption);
}
