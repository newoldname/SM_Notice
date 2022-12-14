import 'package:flutter/material.dart';
import 'package:sm_notice/navigation_drawer.dart';
import 'package:sm_notice/screen/search_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final String title = 'SM Notice APP';

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: title,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => SearchScreen();
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: NavigationDrawer(),
//       appBar: AppBar(title: Text("Notice App")),
//       body: MajorScreen(),
      
//     );
//   }
// }
