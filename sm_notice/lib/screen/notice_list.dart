import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sm_notice/model/notice.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeList extends StatefulWidget {
  final List<Notice> allNotice;
  const NoticeList({Key? key, required this.allNotice}) : super(key: key);

  @override
  State<NoticeList> createState() => _NoticeListState();
}

class _NoticeListState extends State<NoticeList> {
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
      itemCount: widget.allNotice.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              leading: Text(
                "😍",
                style: TextStyle(fontSize: 30),
              ),
              title: Text(widget.allNotice[index].title),
              subtitle: Text(
                widget.allNotice[index].campus +
                    " | " +
                    widget.allNotice[index].category +
                    " | " +
                    widget.allNotice[index].date,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
              dense: true,
            ),
            ButtonBar(
              alignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    _launchUrl(widget.allNotice[index].baseReadUrl,
                        widget.allNotice[index].noticeID);
                  },
                  child: const Text('Expasion Panel'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // return ExpansionPanelList(
  //   expandedHeaderPadding: EdgeInsets.symmetric(vertical: 5),
  //   elevation: 3,
  //   expansionCallback: (int index, bool isExpanded) {
  //     setState(() {
  //       widget.allNotice[index].isExpanded = !isExpanded;
  //     });
  //   },
  //   children: widget.allNotice.map<ExpansionPanel>((Notice nowNotice) {
  //     return ExpansionPanel(
  //       isExpanded: nowNotice.isExpanded,
  //       canTapOnHeader: true,
  //       headerBuilder: (context, isExpanded) {
  //         return Column(
  //           children: [
  //             ListTile(
  //               leading: Text(
  //                 "😍",
  //                 style: TextStyle(fontSize: 30),
  //               ),
  //               title: Text(nowNotice.title),
  //               subtitle: Text(
  //                 nowNotice.campus +
  //                     " | " +
  //                     nowNotice.category +
  //                     " | " +
  //                     nowNotice.date,
  //                 style: TextStyle(color: Colors.black.withOpacity(0.6)),
  //               ),
  //               dense: true,
  //             ),
  //             ButtonBar(
  //               alignment: MainAxisAlignment.start,
  //               children: [
  //                 TextButton(
  //                   onPressed: () {
  //                     _launchUrl(nowNotice.baseReadUrl, nowNotice.noticeID);
  //                   },
  //                   child: const Text('Expasion Panel'),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         );
  //       },
  //       body: Column(
  //         children: [
  //           Html(
  //             data: nowNotice.mainText,
  //           ),
  //         ],
  //       ),
  //     );
  //   }).toList(),
  // );

}
