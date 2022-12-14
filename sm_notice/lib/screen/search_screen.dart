import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sm_notice/model/notice.dart';
import 'package:sm_notice/navigation_drawer.dart';
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

    //??? ????????? ?????? ?????? ????????????
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
        content: const Text('???????????? ???????????? ????????????'),
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
      drawer: NavigetionDrawer(),
      appBar: AppBar(
        title: Text("????????? ???????????? ????????????"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text("????????? ???????????? ????????? ?????? ???"),
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
                            labelText: "????????????",
                            hintText: "???????????? ???????????????",
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
                        child: Text("??????"),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: checkBoxCampus("???????????????")),
                    Expanded(flex: 1, child: checkBoxCampus("???????????????")),
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
                        label: Text("?????? ??????"),
                      ),
                    )
                  ],
                ),
                selectMajors.isEmpty
                    ? Text("")
                    : Text("?????? ????????? ????????? ????????? ???????????????\n" + selectMajors.toString()),
              ],
            ),
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(child: NoticeList(allNotice: allNotice)),
        ],
      ),
    );
  }

  Widget majorCheckBoxAlert() {
    return AlertDialog(
      title: Text("????????? ???????????????"),
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
              searchText();
            });
            Navigator.pop(context);
          },
          child: Text("????????????"),
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
          setState(() {
            searchText();
          });
        });
  }
}
