import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sm_notice/model/notice.dart';
import 'package:sm_notice/scraper/major.dart';
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
  var majorList = ["hi", "cs", "smubiz"];

  getDate() async {
    setState(() {
      isLoading = true;
    });
    List noticeCode =
        await Major().getNoticeListCode(Major().makeUrl(majorName, 100, 0));

    allNotice = Major().getAllNotice(noticeCode);
    isLoading = false;

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
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Major Notice"),
      ),
      body: Column(
        children: [
          DropdownButton(
            value: majorName,
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            items: majorList.map((String item) {
              return DropdownMenuItem<String>(
                child: Text('$item'),
                value: item,
              );
            }).toList(),
            onChanged: (dynamic value) {
              setState(() {
                majorName = value;
                getDate();
              });
            },
          ),
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
                            Text(allNotice[index].title),
                            Row(
                              children: [
                                allNotice[index].isTop
                                    ? Text("Top")
                                    : Text("Not Top"),
                                Text(allNotice[index].category),
                                Text(allNotice[index].campus),
                                Text(allNotice[index].writer),
                                Text(allNotice[index].date),
                              ],
                            ),
                            Divider(
                              color: Colors.blue,
                              thickness: 5.0,
                            ),
                          ],
                        ),
                      );
                    }),
              )
        ],
      ),
    );
  }
}
