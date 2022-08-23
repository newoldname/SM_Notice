import 'package:flutter/material.dart';
import 'package:sm_notice/model/notice.dart';
import 'package:url_launcher/url_launcher.dart';

class NormalScreen extends StatefulWidget {
  final List<Notice> noticeList;
  const NormalScreen({Key? key, required this.noticeList}) : super(key: key);

  @override
  State<NormalScreen> createState() => _NormalScreenState();
}

class _NormalScreenState extends State<NormalScreen> {
  
  _launchUrl(String baseUrl, int noticeId) async {
    String realUrl = baseUrl + noticeId.toString();
    if (await canLaunchUrl(Uri.parse(realUrl))) {
      await launchUrl(Uri.parse(realUrl));
    } else {
      throw "Could not launch $realUrl";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.noticeList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              _launchUrl(widget.noticeList[index].baseReadUrl,
                  widget.noticeList[index].noticeID);
            },
            child: Column(
              children: [
                Text(widget.noticeList[index].title),
                Row(
                  children: [
                    widget.noticeList[index].isTop
                        ? Text("Top")
                        : Text("Not Top"),
                    Text(widget.noticeList[index].category),
                    Text(widget.noticeList[index].campus),
                    Text(widget.noticeList[index].writer),
                    Text(widget.noticeList[index].date),
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
