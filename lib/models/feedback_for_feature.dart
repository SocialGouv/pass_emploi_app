class FeedbackForFeature {
  final int displayAfter;
  final DateTime until;

  FeedbackForFeature(this.displayAfter, this.until);

  factory FeedbackForFeature.fromJson(dynamic json) {
    return FeedbackForFeature(
      json['displayAfter'] as int,
      DateTime.parse(json['until'] as String),
    );
  }
}
