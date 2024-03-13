import 'package:async/async.dart';
import 'package:flutter_test/flutter_test.dart';

/// Inspired by implementation of `neverEmits` from `flutter_test` package.
StreamMatcher emitsAtLeastOnce(Object? matcher) {
  final streamMatcher = emits(matcher);
  return StreamMatcher((queue) async {
    var events = 0;
    var matched = false;
    await queue.withTransaction((copy) async {
      while (await copy.hasNext) {
        matched = await _tryMatch(copy, streamMatcher);
        if (matched) return true;

        events++;

        try {
          await copy.next;
        } catch (_) {
          //Ignore errors events.
        }
      }

      matched = await _tryMatch(copy, streamMatcher);
      return matched;
    });

    if (matched) return null;
    return "after $events " '${streamMatcher.description}';
  }, 'at least once ${streamMatcher.description}');
}

Future<bool> _tryMatch(StreamQueue<dynamic> queue, StreamMatcher matcher) {
  return queue.withTransaction((copy) async {
    try {
      final match = (await matcher.matchQueue(copy)) == null;
      return match;
    } catch (_) {
      return false;
    }
  });
}
