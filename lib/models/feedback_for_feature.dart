class FeedbackForFeature {
  final int displayAfter;
  final DateTime until;
  final bool commentaireEnabled;

  FeedbackForFeature(this.displayAfter, this.until, this.commentaireEnabled);

  factory FeedbackForFeature.fromJson(dynamic json) {
    return FeedbackForFeature(
      json['displayAfter'] as int,
      DateTime.parse(json['until'] as String),
      json['commentaireEnabled'] as bool? ?? false,
    );
  }
}
