import 'package:pass_emploi_app/models/cvm/cvm_event.dart';

class CvmAggregator {
  final Set<CvmEvent> _events = {};

  void addEvents(List<CvmEvent> events) => _events.addAll(events);

  void clear() => _events.clear();

  List<CvmEvent> getSortedEvents() => List.from(_events)..sortFromOldestToNewest();
}

extension _ListMessage on List<CvmEvent> {
  void sortFromOldestToNewest() => sort((a, b) => a.date.compareTo(b.date));
}
