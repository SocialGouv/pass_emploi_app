abstract class ChatItem {}

class DayItem extends ChatItem {
  final String dayLabel;

  DayItem(this.dayLabel);
}

abstract class MessageItem extends ChatItem {
  final String content;
  final String hourLabel;

  MessageItem(this.content, this.hourLabel);
}

class JeuneMessageItem extends MessageItem {
  JeuneMessageItem(String content, String hour) : super(content, hour);
}

class ConseillerMessageItem extends MessageItem {
  ConseillerMessageItem(String content, String hour) : super(content, hour);
}
