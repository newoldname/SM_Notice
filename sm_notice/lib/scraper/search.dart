import 'package:sm_notice/tools/vars.dart';

class Search {
  String pageUrl =
      "https://www.smu.ac.kr/lounge/notice/notice.do?srUpperNoticeYn=on";
  String selectCampus = "&srCampus=";
  String noticeMax = "&articleLimit=";
  String startLocation = "&article.offset=";
  String searchName = "&srSearchKey=&srSearchVal=";

  String makeCamSearchUrl(
    String campusName, String searchKey, int maxNotice, int startNotice) {
    String? campusCode = allCampus[campusName];
    String newCampus = selectCampus + campusCode!;
    String newMax = noticeMax + maxNotice.toString();
    String newStart = startLocation + startNotice.toString();
    String newSearch = searchName + searchKey;
    return pageUrl + newStart + newMax + newCampus + newSearch;
  }

  String makeMajorSearchUrl(String majorName, String searchKey, int maxNotice, int startNotice) {
    List<String>? majorCodeList = allMajors[majorName];
    String mainUrl =
        "https://" + majorCodeList![0] + ".smu.ac.kr/" + majorCodeList![1] + "/community/notice.do?srUpperNoticeYn=on";
    String newMax = noticeMax + maxNotice.toString();
    String newStart = startLocation + startNotice.toString();
    String newSearch = searchName + searchKey;
    return mainUrl + newStart + newMax + newSearch;
  }
}
