import 'dart:io';

import 'package:pass_emploi_app/models/cvm/cvm_event.dart';

class CvmAggregator {
  final List<CvmEvent> _events = [];

  void addEvents(List<CvmEvent> events) {
    if (Platform.isIOS) {
      _events.addAll([
        ..._events.whereEventIdNotIn(events),
        ...events,
      ]);
    } else {
      _events.addAll(events);
    }
    _events.sortFromOldestToNewest();
  }

  List<CvmEvent> getEvents() => List.from(_events);

  void reset() => _events.clear();
}

extension _IterableMessage on Iterable<CvmEvent> {
  Iterable<CvmEvent> whereEventIdNotIn(Iterable<CvmEvent> events) => where((element) => !events.containsId(element.id));

  bool containsId(String id) => any((element) => element.id == id);
}

extension _ListMessage on List<CvmEvent> {
  void sortFromOldestToNewest() => sort((a, b) => a.date.compareTo(b.date));
}
