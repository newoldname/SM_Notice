import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sm_notice/model/notice.dart';
import 'package:sm_notice/scraper/homepage.dart';
import 'package:sm_notice/scraper/major.dart';
import 'package:sm_notice/scraper/search.dart';
import 'package:sm_notice/screen/notice_list.dart';
import 'package:sm_notice/tools/vars.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = false;
  List<Notice> allNotice = [];
  final TextEditingController _textController = new TextEditingController();
  String searchString = "";

  var selectCmp = Set<String>();
  var selectMajors = Set<String>();

  bool isInCamSet(String cmpName) {
    return selectCmp.contains(cmpName);
  }

  _addToCamSet(String cmpName) {
    selectCmp.add(cmpName);
  }

  _removeFromCamSet(String cmpName) {
    selectCmp.remove(cmpName);
  }

  bool isInMajorSet(String cmpName) {
    return selectMajors.contains(cmpName);
  }

  _addToMajorSet(String cmpName) {
    selectMajors.add(cmpName);
  }

  _removeFromMajorSet(String cmpName) {
    selectMajors.remove(cmpName);
  }

  void _getDate() async {
    setState(() {
      isLoading = true;
    });

    allNotice = [];
    for (var nowCmp in selectCmp) {
      List noticeCode = await Homepage().getNoticeListCode(
          Search().makeCamSearchUrl(nowCmp, searchString, 30, 0));

      allNotice += Homepage().getAllNotice(noticeCode);
    }

    for (var nowMajor in selectMajors) {
      List noticeCode = await Major().getNoticeListCode(
          Search().makeMajorSearchUrl(nowMajor, searchString, 30, 0));

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

  void searchText() {
    if (_textController.text.isEmpty) {
      final snackBar = SnackBar(
        content: const Text('검색창을 비워두지 마세요ㅠ'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      searchString = _textController.text;
      _getDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("상명대 통합검색"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(
            child: Column(
              children: [
                Text("상명대 통합검색 이미지 넣는 곳"),
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: TextField(
                        controller: _textController,
                        keyboardType: TextInputType.text,
                        onSubmitted: (value) {
                          searchText();
                        },
                        decoration: InputDecoration(
                            labelText: "통합검색",
                            hintText: "검색어를 입력하세요",
                            border: OutlineInputBorder(),
                            icon: Padding(
                              padding: EdgeInsets.only(left: 13),
                              child: Icon(Icons.search),
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          searchText();
                        },
                        child: Text("검색"),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: checkBoxCampus("서울캠퍼스")
                    ),
                    Expanded(
                      flex: 1,
                      child: checkBoxCampus("천안캠퍼스")
                    ),
                    Expanded(
                      flex: 1,
                      child: FloatingActionButton.extended(
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
                    )
                  ],
                ),
                Dialog(),
                selectMajors.isEmpty?Text("")
                :Text("아래 전공을 포함해 공지를 검색합니다\n" + selectMajors.toString()),
              ],
            ),
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : NoticeList(allNotice: allNotice),
        ],
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
            return checkBoxMajor(key, setState);
          }).toList()),
        );
      }),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
            });
            Navigator.pop(context);
          },
          child: Text("선택완료"),
        ),
      ],
    );
  }

  Widget checkBoxMajor(String key, StateSetter setState) {
    return CheckboxListTile(
        title: Text(key),
        value: isInMajorSet(key),
        onChanged: (value) {
          if (value!) {
            _addToMajorSet(key);
          } else {
            _removeFromMajorSet(key);
          }
          setState(() {});
        });
  }

  Widget checkBoxCampus(String key) {
    return CheckboxListTile(
        title: Text(key),
        value: isInCamSet(key),
        onChanged: (value) {
          if (value!) {
            _addToCamSet(key);
          } else {
            _removeFromCamSet(key);
          }
          setState(() {});
        });
  }
}
