import 'package:flutter/material.dart';
import 'package:sm_notice/model/notice.dart';
import 'package:sm_notice/navigation_drawer.dart';
import 'package:sm_notice/scraper/homepage.dart';
import 'package:sm_notice/scraper/inside_text.dart';
import 'package:sm_notice/screen/notice_list.dart';
import 'package:sm_notice/tools/vars.dart';
import 'package:url_launcher/url_launcher.dart';

class SchoolScreen extends StatefulWidget {
  const SchoolScreen({Key? key}) : super(key: key);

  @override
  State<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  bool isLoading = false;
  List<Notice> allNotice = [];
  var selectCmp = Set<String>();

  bool isInSet(String cmpName) {
    return selectCmp.contains(cmpName);
  }

  _addToSet(String cmpName) {
    selectCmp.add(cmpName);
  }

  _removeFromSet(String cmpName) {
    selectCmp.remove(cmpName);
  }

  _getDate() async {
    setState(() {
      isLoading = true;
    });

    for (var nowCmp in selectCmp) {
      List noticeCode =
          await Homepage().getNoticeListCode(Homepage().makeUrl(nowCmp, 30, 0));

      allNotice += Homepage().getAllNotice(noticeCode);
    }

    allNotice.sort((a, b) {
      return b.noticeID.compareTo(a.noticeID);
    });

    //각 공지의 세부 내용 가져오기
    // for (var nowNotice in allNotice) {
    //   var noticeCode = await InsideText().getNoticeTextCode(InsideText()
    //       .makeNoticeTextUrl(
    //           nowNotice.baseReadUrl, nowNotice.noticeID.toString()));
    //   InsideText().updateMainData(nowNotice, noticeCode);
    // }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    //_addToSet("서울캠퍼스");
    _getDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigetionDrawer(),
      appBar: AppBar(
        title: Text("캠퍼스 공지사항 통합페이지"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(flex: 1, child: checkBoxCampus("서울캠퍼스")),
              Expanded(flex: 1, child: checkBoxCampus("천안캠퍼스")),
            ],
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(child: NoticeList(allNotice: allNotice)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return campusCheckBoxAlert();
              });
        },
        icon: Icon(Icons.add),
        label: Text("캠퍼스 선택"),
      ),
    );
  }

  Widget campusCheckBoxAlert() {
    return AlertDialog(
      title: Text("캠퍼스를 선택하세요"),
      content: StatefulBuilder(builder: (__, StateSetter setState) {
        return Container(
          width: 300,
          height: 300,
          child: ListView(
              children: allCampus.keys.map((String key) {
            return CheckboxListTile(
                title: Text(key),
                value: isInSet(key),
                onChanged: (value) {
                  if (value!) {
                    _addToSet(key);
                  } else {
                    _removeFromSet(key);
                  }
                  setState(() {});
                });
          }).toList()),
        );
      }),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              allNotice = [];
              _getDate();
            });
            Navigator.pop(context);
          },
          child: Text("선택완료"),
        ),
      ],
    );
  }

  Widget checkBoxCampus(String key) {
    return CheckboxListTile(
        title: Text(key),
        value: isInSet(key),
        onChanged: (value) {
          if (value!) {
            _addToSet(key);
          } else {
            _removeFromSet(key);
          }
          setState(() {
            _getDate();
          });
        });
  }
}
