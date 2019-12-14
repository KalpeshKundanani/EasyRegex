import 'package:easy_regex/pages/cheat_sheet/cheat_sheet_widget.dart';
import 'package:easy_regex/pages/create_regex_widget.dart';
import 'package:easy_regex/pages/test_regex_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EasyRegExApp extends StatefulWidget {
  @override
  _EasyRegExAppState createState() => _EasyRegExAppState();
}

class _EasyRegExAppState extends State<EasyRegExApp> {
  int _pageSelection = 0;

  @override
  Widget build(BuildContext context) {
    _systemSettings();
    final Color accentColor = Color.fromRGBO(245, 130, 37, 1);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: accentColor,
      ),
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Easy RegEx'),
        ),
        body: _appPages.elementAt(_pageSelection).body,
        bottomNavigationBar: BottomNavigationBar(
          items: _appPages
              .map((AppPage page) => page.bottomNavigationBarItem)
              .toList(),
          currentIndex: _pageSelection,
          selectedItemColor: accentColor,
          onTap: (int index) {
            setState(() {
              _pageSelection = index;
            });
          },
        ),
      ),
    );
  }

  void _systemSettings() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Color.fromRGBO(48, 48, 48, 1)));
  }
}

@immutable
class AppPage {
  final BottomNavigationBarItem bottomNavigationBarItem;
  final Widget body;

  const AppPage(this.bottomNavigationBarItem, this.body);
}

List<AppPage> _appPages = <AppPage>[
  AppPage(
    BottomNavigationBarItem(icon: Icon(Icons.edit), title: Text('Create')),
    CreateRegExWidget(),
  ),
  AppPage(
    BottomNavigationBarItem(icon: Icon(Icons.code), title: Text('Test')),
    TestRegExWidget(),
  ),
  AppPage(
    BottomNavigationBarItem(icon: Icon(Icons.list), title: Text('Cheat Sheet')),
    CheatSheetWidget(),
  ),
];
