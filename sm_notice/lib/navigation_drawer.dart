import 'package:flutter/material.dart';
import 'package:sm_notice/screen/major_screen.dart';

class NavigetionDrawer extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text("Drawer Header"),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () => selectedItem(context, 0),
            ),
            ListTile(
              title: const Text('School'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Major'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void selectedItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context)
            .push(new MaterialPageRoute(builder: ((context) => new MajorScreen())));
    }
  }
}
