class FeedbackForFeature {
  final int displayAfter;
  final DateTime until;
  final bool commentaireEnabled;
  final bool dismissable;

  FeedbackForFeature(this.displayAfter, this.until, this.commentaireEnabled, this.dismissable);

  factory FeedbackForFeature.fromJson(dynamic json) {
    return FeedbackForFeature(
      json['displayAfter'] as int,
      DateTime.parse(json['until'] as String),
      json['commentaireEnabled'] as bool? ?? false,
      json['dismissable'] as bool? ?? true,
    );
  }
}
