import 'package:flutter/material.dart';
import 'package:sm_notice/model/notice.dart';
import 'package:sm_notice/scraper/major.dart';
import 'package:sm_notice/screen/notice_list.dart';
import 'package:sm_notice/tools/vars.dart';
import 'package:sm_notice/scraper/inside_text.dart';

class MajorScreen extends StatefulWidget {
  const MajorScreen({Key? key}) : super(key: key);

  @override
  State<MajorScreen> createState() => _MajorScreenState();
}

class _MajorScreenState extends State<MajorScreen> {
  bool isLoading = false;
  List<Notice> allNotice = [];
  var selectMajors = Set<String>();

  bool isInSet(String majorName) {
    return selectMajors.contains(majorName);
  }

  _addToSet(String majorName) {
    selectMajors.add(majorName);
  }

  _removeFromSet(String majorName) {
    selectMajors.remove(majorName);
  }

  _getDate() async {
    setState(() {
      isLoading = true;
    });

    for (var nowMajor in selectMajors) {
      List noticeCode =
          await Major().getNoticeListCode(Major().makeUrl(nowMajor, 30, 0));

      allNotice += Major().getAllNotice(noticeCode, nowMajor);
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
    _addToSet("컴퓨터과학전공");
    _getDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Major Notice"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: NoticeList(allNotice: allNotice)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return majorCheckBoxAlert();
              });
        },
        icon: Icon(Icons.add),
        label: Text("Select Majors"),
      ),
    );
  }

  Widget majorCheckBoxAlert() {
    return AlertDialog(
      title: Text("전공을 선택하세요"),
      content: StatefulBuilder(builder: (__, StateSetter setState) {
        return Container(
          width: 300,
          height: 300,
          child: ListView(
              children: allMajors.keys.map((String key) {
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

}
