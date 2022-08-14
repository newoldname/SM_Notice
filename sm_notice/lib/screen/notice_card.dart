import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sm_notice/model/notice.dart';

class NoticeCard extends StatefulWidget {
  final Notice nowNotice;
  const NoticeCard({Key? key, required this.nowNotice}) : super(key: key);

  @override
  State<NoticeCard> createState() => _NoticeCardState();
}

class _NoticeCardState extends State<NoticeCard> {
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  // Perform some action
                },
                child: const Text('ACTION 1'),
              ),
              TextButton(
                onPressed: () {
                  // Perform some action
                },
                child: const Text('ACTION 2'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
