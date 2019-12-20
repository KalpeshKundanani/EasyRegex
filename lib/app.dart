import 'package:easy_regex/pages/cheat_sheet/cheat_sheet_widget.dart';
import 'package:easy_regex/pages/create_regex/create_regex_widget.dart';
import 'package:easy_regex/pages/test_regex/test_regex_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';

final Color _accentColor = Color.fromRGBO(245, 130, 37, 1);

class EasyRegExApp extends StatefulWidget {
  @override
  _EasyRegExAppState createState() {
    _systemSettings();
    return _EasyRegExAppState();
  }
}

class _EasyRegExAppState extends State<EasyRegExApp> {
  int _pageSelection = 0;

  @override
  void initState() {
    // todo(kkundanani): verify app update.
    InAppUpdate.checkForUpdate()
        .then((state) => InAppUpdate.performImmediateUpdate())
        .catchError(print);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: _themeData,
        home: Scaffold(
          appBar: _appBar,
          body: _currentPage,
          bottomNavigationBar: _bottomNavigationBar,
          resizeToAvoidBottomPadding: false,
        ),
        debugShowCheckedModeBanner: false,
      );

  ThemeData get _themeData => ThemeData(
        brightness: Brightness.dark,
        accentColor: _accentColor,
        cursorColor: _accentColor,
        textSelectionHandleColor: _accentColor,
      );

  AppBar get _appBar => AppBar(title: Text('Easy RegEx'));

  Widget get _currentPage => _appPages.elementAt(_pageSelection).body;

  BottomNavigationBar get _bottomNavigationBar => BottomNavigationBar(
        items: _navigablePages,
        currentIndex: _pageSelection,
        selectedItemColor: _accentColor,
        onTap: (int index) {
          setState(() {
            _pageSelection = index;
          });
        },
      );

  List<BottomNavigationBarItem> get _navigablePages =>
      _appPages.map((_AppPage page) => page.navigationBarItem).toList();
}

@immutable
class _AppPage {
  final BottomNavigationBarItem navigationBarItem;
  final Widget body;

  const _AppPage({this.navigationBarItem, this.body});
}

final List<_AppPage> _appPages = <_AppPage>[
  _AppPage(
    body: CreateRegExWidget(),
    navigationBarItem:
        BottomNavigationBarItem(icon: Icon(Icons.edit), title: Text('Create')),
  ),
  _AppPage(
    body: TestRegExWidget(),
    navigationBarItem:
        BottomNavigationBarItem(icon: Icon(Icons.code), title: Text('Test')),
  ),
  _AppPage(
    body: CheatSheetWidget(),
    navigationBarItem: BottomNavigationBarItem(
        icon: Icon(Icons.list), title: Text('Cheat Sheet')),
  ),
];

void _systemSettings() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Color.fromRGBO(48, 48, 48, 1)));
}
