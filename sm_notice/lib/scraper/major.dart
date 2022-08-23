import 'package:sm_notice/model/notice.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parse;
import 'package:sm_notice/tools/vars.dart';

class Major {
  String noticeMax = "&articleLimit=";
  String startLocation = "&article.offset=";

  String makeUrl(String majorName, int maxNotice, int startNotice) {
    List<String>? majorCodeList = allMajors[majorName];
    String mainUrl =
        "https://" + majorCodeList![0] + ".smu.ac.kr/" + majorCodeList![1] + "/community/notice.do?srUpperNoticeYn=on";
    String newMax = noticeMax + maxNotice.toString();
    String newStart = startLocation + startNotice.toString();
    return mainUrl + newStart + newMax;
  }

  Future<List> getNoticeListCode(String useUrl) async {
    final response = await http.get(Uri.parse(useUrl));
    final body = response.body;
    final pageHtml = parse.parse(body);
    return pageHtml.getElementsByClassName("board-thumb-wrap")[0].children;
  }

  List<Notice> getAllNotice(List listCode, String majorName) {
    List<Notice> allNotice = [];

    for (var noticeCode in listCode) {
      var realDataCode = noticeCode.children[0];

      bool isTop = false;
      if (realDataCode.className.contains('noti')) {
        isTop = true;
      }

      var campusName = "학과";
      var categoryName = majorName;
      var titleName = "";
      var titleNameCode = realDataCode.children[0].getElementsByTagName("a")[0];
      if (titleNameCode.nodes.length == 1) {
        titleName = titleNameCode.nodes[0]
            .toString()
            .replaceAll("\t", "")
            .replaceAll("\n", "");
      } else {
        titleName = titleNameCode.nodes[2]
            .toString()
            .replaceAll("\t", "")
            .replaceAll("\n", "");
      }

      var noticeIDHref = realDataCode.children[0]
          .getElementsByTagName("a")[0]
          .attributes['href']
          .toString();
      var noticeID = noticeIDHref.split("&")[1].split("=")[1].toString();

      var secendRowDataCode =
          realDataCode.children[1].getElementsByTagName("li");

      var noticeWriter = secendRowDataCode[0]
          .nodes[2]
          .toString()
          .replaceAll("\t", "")
          .replaceAll("\n", "")
          .replaceAll("\"", "");
      var noticeDate = secendRowDataCode[1]
          .nodes[2]
          .toString()
          .replaceAll("\t", "")
          .replaceAll("\n", "")
          .replaceAll("\"", "");

      Notice newNotice = Notice(
          noticeID: int.parse(noticeID),
          title: titleName,
          writer: noticeWriter,
          date: noticeDate,
          isTop: isTop,
          campus: campusName,
          category: categoryName,
          baseReadUrl:
              "https://${allMajors[majorName]![0]}.smu.ac.kr/${allMajors[majorName]![1]}/community/notice.do?mode=view&articleNo=",
          lastUpdateTime: DateTime.now());

      allNotice.add(newNotice);
    }
    return allNotice;
  }
}
