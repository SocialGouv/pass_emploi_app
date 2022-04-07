import 'package:equatable/equatable.dart';

abstract class ChatItem extends Equatable {}
//TODO US-508 gerer le nouveau type de msg

class DayItem extends ChatItem {
  final String dayLabel;

  DayItem(this.dayLabel);

  @override
  List<Object?> get props => [dayLabel];
}

abstract class MessageItem extends ChatItem {
  final String content;
  final String caption;

  MessageItem(this.content, this.caption);

  @override
  List<Object?> get props => [content, caption];
}

class JeuneMessageItem extends MessageItem {
  JeuneMessageItem({required String content, required String caption}) : super(content, caption);
}

class ConseillerMessageItem extends MessageItem {
  ConseillerMessageItem({required String content, required String caption}) : super(content, caption);
}
