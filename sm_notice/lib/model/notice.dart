class Notice {
  final int noticeID;
  final String title;
  final String writer;
  final String date;
  final bool isTop;
  final String campus;
  final String category;
  final String baseReadUrl;

  Notice(
      {required this.noticeID,
      required this.title,
      required this.writer,
      required this.date,
      required this.isTop,
      required this.campus,
      required this.category,
      required this.baseReadUrl});
}
