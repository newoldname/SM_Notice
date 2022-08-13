import 'package:flutter/material.dart';
import 'package:sm_notice/navigation_drawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final String title = 'SM Notice APP';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
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
  Widget build(BuildContext context) => Scaffold(
        drawer: NavigetionDrawer(),
        // endDrawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text(MyApp.title),
        ),
        body: Text(""),
      );
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
