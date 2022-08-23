class Notice {
  final int noticeID;
  final String title;
  final String writer;
  final String date;
  final bool isTop;
  final String campus;
  final String category;
  final String baseReadUrl;
  final DateTime lastUpdateTime;

  //공지 내부 데이터
  String mainText = "Loading...";
  List<String> fileName = [];
  List<String> fileUrl = [];
  List<String> fileViewerUrl = [];
  List<String> photoUrl = [];

  //일부 위젯을 위한 변수들
  bool isExpanded = false;

  Notice(
      {required this.noticeID,
      required this.title,
      required this.writer,
      required this.date,
      required this.isTop,
      required this.campus,
      required this.category,
      required this.baseReadUrl,
      required this.lastUpdateTime});

  void setFileData(List<String> tmpFileName, List<String> tmpFileUrl,
      List<String> tmpFileViewerUrl) {
    fileName = tmpFileName;
    fileUrl = tmpFileUrl;
    fileViewerUrl = tmpFileViewerUrl;
  }

  void setPhotoUrl(List<String> tmpPhotoUrl) {
    photoUrl = tmpPhotoUrl;
  }

  void setMainText(String tmpText) {
    mainText = tmpText;
  }
}
