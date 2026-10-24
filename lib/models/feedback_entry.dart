class FeedbackEntry {
  final String programId;
  final int rating; // 1-5
  final String category;
  final String email;
  final String comment;
  final DateTime submittedAt;

  const FeedbackEntry({
    required this.programId,
    required this.rating,
    required this.category,
    required this.email,
    required this.comment,
    required this.submittedAt,
  });
}
