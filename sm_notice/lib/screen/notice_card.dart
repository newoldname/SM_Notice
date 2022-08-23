import 'package:flutter/material.dart';
import 'package:sm_notice/model/notice.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeCard extends StatefulWidget {
  final Notice nowNotice;
  const NoticeCard({Key? key, required this.nowNotice}) : super(key: key);

  @override
  State<NoticeCard> createState() => _NoticeCardState();
}

class _NoticeCardState extends State<NoticeCard> {
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
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Text(
              "😍",
              style: TextStyle(fontSize: 30),
            ),
            title: Text(widget.nowNotice.title),
            subtitle: Text(
              widget.nowNotice.category + " | " + widget.nowNotice.date,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
            dense: true,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  _launchUrl(
                      widget.nowNotice.baseReadUrl, widget.nowNotice.noticeID);
                },
                child: const Text('widgetCard'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({Key? key, required this.nowNotice, required this.onClose})
      : super(key: key);
  final Notice nowNotice;
  final void Function({Never returnValue}) onClose;

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
    return Scaffold(
      body: SizedBox(
        height: 300,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ListTile(
                leading: Text(
                  "😍",
                  style: TextStyle(fontSize: 30),
                ),
                title: Text(this.nowNotice.title),
                subtitle: Text(
                  this.nowNotice.category + " | " + this.nowNotice.date,
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
                dense: true,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        nowNotice.mainText,
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: nowNotice.photoUrl.length,
                        itemBuilder: ((BuildContext context, int index) {
                          return Image.network(nowNotice.photoUrl[index]);
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      _launchUrl(nowNotice.baseReadUrl, nowNotice.noticeID);
                    },
                    child: const Text('ACTION 1'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
