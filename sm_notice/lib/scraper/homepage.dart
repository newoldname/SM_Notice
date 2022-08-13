import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:sm_notice/model/notice.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parse;

class homepage {
  String pageUrl =
      "https://www.smu.ac.kr/lounge/notice/notice.do?srUpperNoticeYn=on";
  String selectCampus = "&srCampus=";
  String noticeMax = "&articleLimit=";
  String startLocation = "&article.offset=";

  String makeUrl(String campus, int maxNotice, int startNotice) {
    String newCampus = selectCampus + campus;
    String newMax = noticeMax + maxNotice.toString();
    String newStart = startLocation + startNotice.toString();
    return pageUrl + newStart + newMax + newCampus;
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

      //학교 공지 첫 줄의 내용들(캠퍼스, 카테고리, 공지 제목)
      var firstRowDataCode =
          realDataCode.children[0].getElementsByTagName("td");

      var campusName =
          firstRowDataCode[1].getElementsByClassName("cmp")[0].innerHtml;
      var categoryName =
          firstRowDataCode[1].getElementsByClassName("cate")[0].innerHtml;
      var titleName = firstRowDataCode[2]
          .getElementsByTagName("a")[0]
          .innerHtml
          .replaceAll("\t", "")
          .replaceAll("\n", "");

      var secendRowDataCode =
          realDataCode.children[1].getElementsByTagName("li");
      var noticeID = secendRowDataCode[0]
          .nodes[2]
          .toString()
          .replaceAll("\t", "")
          .replaceAll("\n", "")
          .replaceAll("\"", "");
      var noticeWriter = secendRowDataCode[1]
          .nodes[2]
          .toString()
          .replaceAll("\t", "")
          .replaceAll("\n", "")
          .replaceAll("\"", "");
      var noticeDate = secendRowDataCode[2]
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
              "https://www.smu.ac.kr/lounge/notice/notice.do?mode=view&articleNo=");

      allNotice.add(newNotice);
    }
    return allNotice;
  }
}
