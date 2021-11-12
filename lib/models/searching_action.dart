
class SearchingAction {
  final String keyWord;
  final String department;

  SearchingAction({
    required this.keyWord,
    required this.department,
  });

  factory SearchingAction.fromJson(dynamic json) {
    return SearchingAction(
      keyWord: json['keyWord'] as String,
      department: json['department'] as String,
    );
  }
}