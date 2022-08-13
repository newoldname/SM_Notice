import 'package:flutter/material.dart';
import 'screen/school_notice_screen.dart';
//import './util/weather_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text("Notice App")),
      body: SchoolNoticeScreen(),
      drawer: Drawer(
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
              onTap: () {},
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
    ));
  }
}
