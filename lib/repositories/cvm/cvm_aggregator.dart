import 'package:pass_emploi_app/models/chat/cvm_message.dart';

class CvmAggregator {
  final Set<CvmMessage> _events = {};

  void addEvents(List<CvmMessage> events) => _events.addAll(events);

  void clear() => _events.clear();

  List<CvmMessage> getSortedEvents() => List.from(_events)..sortFromOldestToNewest();
}

extension _ListMessage on List<CvmMessage> {
  void sortFromOldestToNewest() => sort((a, b) => a.date.compareTo(b.date));
}
