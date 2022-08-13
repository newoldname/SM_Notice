import 'package:flutter/material.dart';
import 'package:sm_notice/model/notice.dart';
import 'package:sm_notice/scraper/homepage.dart';
import 'package:url_launcher/url_launcher.dart';

class SchoolScreen extends StatefulWidget {
  const SchoolScreen({Key? key}) : super(key: key);

  @override
  State<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  List<Notice> allNotice = [];
  bool isLoading = false;

  getDate() async {
    setState(() {
      isLoading = true;
    });
    List noticeCode =
        await homepage().getNoticeListCode(homepage().makeUrl("smu", 100, 0));

    allNotice = homepage().getAllNotice(noticeCode);
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
    super.initState();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: allNotice.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  _launchUrl(
                      allNotice[index].baseReadUrl, allNotice[index].noticeID);
                },
                child: Column(
                  children: [
                    Text(allNotice[index].title),
                    Row(
                      children: [
                        allNotice[index].isTop ? Text("Top") : Text("Not Top"),
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
            });
  }
}
