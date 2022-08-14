import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sm_notice/model/notice.dart';
import 'package:sm_notice/scraper/major.dart';
import 'package:sm_notice/screen/notice_card.dart';
import 'package:sm_notice/tools/vars.dart';
import 'package:url_launcher/url_launcher.dart';

class MajorScreen extends StatefulWidget {
  const MajorScreen({Key? key}) : super(key: key);

  @override
  State<MajorScreen> createState() => _MajorScreenState();
}

class _MajorScreenState extends State<MajorScreen> {
  String majorName = "hi";
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
          await Major().getNoticeListCode(Major().makeUrl(nowMajor, 100, 0));

      allNotice += Major().getAllNotice(noticeCode, nowMajor);
    }

    allNotice.sort((a, b) {
      return b.noticeID.compareTo(a.noticeID);
    });

    setState(() {
      isLoading = false;
    });
  }

  _launchUrl(String baseUrl, int noticeId) async {
    String realUrl = baseUrl + noticeId.toString();
    if (await canLaunchUrl(Uri.parse(realUrl))) {
      await launchUrl(Uri.parse(realUrl));
    } else {
      throw "Could not launch $realUrl";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addToSet("휴먼지능정보공학전공");
    _getDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Major Notice"),
      ),
      body: Column(
        children: [
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: allNotice.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            _launchUrl(allNotice[index].baseReadUrl,
                                allNotice[index].noticeID);
                          },
                          child: Column(
                            children: [
                              NoticeCard(nowNotice: allNotice[index]),

                              // Text(allNotice[index].title),
                              // Row(
                              //   children: [
                              //     allNotice[index].isTop
                              //         ? Text("Top")
                              //         : Text("Not Top"),
                              //     Text(allNotice[index].category),
                              //     Text(allNotice[index].campus),
                              //     Text(allNotice[index].writer),
                              //     Text(allNotice[index].date),
                              //   ],
                              // ),
                              // Divider(
                              //   color: Colors.blue,
                              //   thickness: 5.0,
                              // ),


                            ],
                          ),
                        );
                      }),
                )
        ],
      ),
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
