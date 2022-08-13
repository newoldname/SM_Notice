import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:sm_notice/model/notice.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parse;

class Major {

  String noticeMax = "&articleLimit=";
  String startLocation = "&article.offset=";

  String makeUrl(String majorName, int maxNotice, int startNotice) {
    String mainUrl = "https://" +
        majorName +
        ".smu.ac.kr/" +
        majorName +
        "/community/notice.do?srUpperNoticeYn=on";
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

  List<Notice> getAllNotice(List listCode) {
    List<Notice> allNotice = [];

    for (var noticeCode in listCode) {
      var realDataCode = noticeCode.children[0];

      bool isTop = false;
      if (realDataCode.className.contains('noti')) {
        isTop = true;
      }

      var campusName = "서울";
      var categoryName = "컴퓨터과학과";
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

      // .nodes[2]
      // .toString()
      // .replaceAll("\t", "")
      // .replaceAll("\n", "")
      // .replaceAll("\"", "");

      var secendRowDataCode =
          realDataCode.children[1].getElementsByTagName("li");

      //!!!!

      //!!!!

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
              "https://cs.smu.ac.kr/cs/community/notice.do?mode=view&articleNo=");

      allNotice.add(newNotice);
    }
    return allNotice;
  }
}
