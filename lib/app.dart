import 'package:easy_regex/hive_utils.dart';
import 'package:easy_regex/pages/cheat_sheet/cheat_sheet_widget.dart';
import 'package:easy_regex/pages/create_regex/create_regex_widget.dart';
import 'package:easy_regex/pages/create_regex/regex_change_notification.dart';
import 'package:easy_regex/pages/create_regex/regex_parameter_change_notification.dart';
import 'package:easy_regex/pages/test_regex/test_regex_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

final Color _accentColor = Color.fromRGBO(245, 130, 37, 1);

@immutable
class EasyRegExApp extends StatelessWidget {
  static const String _pageSelectionKey = 'selected_page';
  static const String _pageSelectionValueKey = 'page_selection_value';

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: _themeData,
        home: FutureBuilder(
          future: _init(),
          builder: (_, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder<Box<int>>(
                future: _pageSelectionBox,
                builder:
                    (BuildContext context, AsyncSnapshot<Box<int>> snapshot) {
                  if (snapshot.hasData) {
                    return ValueListenableBuilder(
                      valueListenable: snapshot.data.listenable(),
                      builder: (_, final Box box, __) {
                        if (snapshot.hasData) {
                          final _pageSelection = box.get(_pageSelectionValueKey,
                              defaultValue: 0) as int;
                          return Scaffold(
                            appBar: _appBar,
                            body: _appPages.elementAt(_pageSelection).body,
                            bottomNavigationBar:
                                _bottomNavigationBar(_pageSelection),
                            resizeToAvoidBottomPadding: true,
                          );
                        } else {
                          return _loadingWidget;
                        }
                      },
                    );
                  } else {
                    return _loadingWidget;
                  }
                },
              );
            } else {
              return _loadingWidget;
            }
          },
        ),
        debugShowCheckedModeBanner: false,
      );

  Material get _loadingWidget {
    return Material(
      child: Center(
        child: Text('Loading...'),
      ),
    );
  }

  ThemeData get _themeData => ThemeData(
        brightness: Brightness.dark,
        accentColor: _accentColor,
        cursorColor: _accentColor,
        textSelectionHandleColor: _accentColor,
      );

  AppBar get _appBar => AppBar(title: Text('Easy RegEx'));

  BottomNavigationBar _bottomNavigationBar(int _pageSelection) =>
      BottomNavigationBar(
        items: _navigablePages,
        currentIndex: _pageSelection,
        selectedItemColor: _accentColor,
        onTap: (int index) async {
          await (await _pageSelectionBox).put(_pageSelectionValueKey, index);
        },
      );

  List<BottomNavigationBarItem> get _navigablePages =>
      _appPages.map((_AppPage page) => page.navigationBarItem).toList();

  Future<bool> _init() async {
    _systemSettings();
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    registerHiveAdapter();
    return true;
  }

  Future<Box<int>> get _pageSelectionBox async =>
      await Hive.openBox<int>(_pageSelectionKey);

  void _systemSettings() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Color.fromRGBO(48, 48, 48, 1)));
  }
}

@immutable
class _AppPage {
  final BottomNavigationBarItem navigationBarItem;
  final Widget body;

  const _AppPage({this.navigationBarItem, this.body});
}

final List<_AppPage> _appPages = <_AppPage>[
  _AppPage(
    body: Builder(
      builder: (context) {
        return NotificationListener<RegexParameterChangeNotification>(
          onNotification: (RegexParameterChangeNotification notification) {
            final regexValue = convertNotificationToRegex(notification);
            RegexChangeNotification(regexValue).dispatch(context);
            return true;
          },
          child: CreateRegExWidget(),
        );
      },
    ),
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

RegexParameterChangeNotification currentNotification;

String convertNotificationToRegex(
  RegexParameterChangeNotification notification,
) {
  if (currentNotification == null) {
    currentNotification = notification;
  } else {
    currentNotification.consume(notification);
  }
  return currentNotification.calculate();
}
