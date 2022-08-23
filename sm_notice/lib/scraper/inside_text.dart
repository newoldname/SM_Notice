import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parse;
import 'package:sm_notice/model/notice.dart';

class InsideText {
  // 1. 정확한 링크 만들기
  String makeNoticeTextUrl(String baseUrl, String noticeId) {
    return baseUrl + noticeId;
  }

  //2. 페이지 내용 가져오기
  Future<List> getNoticeTextCode(String useUrl) async {
    final response = await http.get(Uri.parse(useUrl));
    final body = response.body;
    final pageHtml = parse.parse(body);
    return pageHtml.getElementsByClassName("board-view-box")[0].children;
  }

  String makeDownloadUrl(String baseUrl, String hrefUrl) {
    var noticeUrl = baseUrl.split("?")[0];
    return noticeUrl + hrefUrl;
  }

  String makeViewerUrl(String baseUrl, String hrefUrl) {
    var urlList = baseUrl.split("/");
    var domainUrl = "http://${urlList[2]}";
    return domainUrl + hrefUrl;
  }

  //3. 내용 찾아서 밖으로 내보내기
  void updateMainData(Notice nowNotice, List nowCode) {
    //file Update START
    List<String> tmpfileName = [];
    List<String> tmpfileUrl = [];
    List<String> tmpfileViewerUrl = [];

    int textIndex = 2;

    if (nowCode.length == 3) {
      List fileCodes = nowCode[1].children;
      for (var fileCode in fileCodes) {
        tmpfileName.add(fileCode.children[0].innerHtml
            .replaceAll("\t", "")
            .replaceAll("\n", ""));
        tmpfileUrl.add(makeDownloadUrl(nowNotice.baseReadUrl,
            fileCode.children[0].attributes['href'].toString()));

        //var abcde = fileCode.getElementsByClassName("flexerLink");

        if (fileCode.getElementsByClassName("flexerLink").length == 1) {
          tmpfileViewerUrl.add(makeViewerUrl(nowNotice.baseReadUrl,
              fileCode.children[1].attributes['href'].toString()));
        } else {
          tmpfileViewerUrl.add("None");
        }
      }
    } else {
      textIndex = 1;
    }
    nowNotice.setFileData(tmpfileName, tmpfileUrl, tmpfileViewerUrl);
    //file update END

    //mainData(Text + img etc..) START
    String tmpMainText = "";
    List<String> tmpPhotoUrl = [];

    var textCodes = nowCode[textIndex].children[0].children[0];
    for (var textCode in textCodes.children) {
      if (tmpMainText.length > 150) {
        break;
      }
      if (textCode.children.length > 0 &&
          textCode.children[0].localName == "img") {
        tmpPhotoUrl.add(makeViewerUrl(
            nowNotice.baseReadUrl, textCode.children[0].attributes["src"]));
      } else {
        tmpMainText += textCode.innerHtml;
      }
    }

    nowNotice.setPhotoUrl(tmpPhotoUrl);
    nowNotice.setMainText(tmpMainText);
  }
}
