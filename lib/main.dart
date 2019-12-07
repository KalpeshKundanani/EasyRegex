import 'package:easy_regex/gui/regex_output_widget.dart';
import 'package:easy_regex/gui/tabs/contains_widget.dart';
import 'package:easy_regex/gui/tabs/ends_with_widget.dart';
import 'package:easy_regex/gui/tabs/starts_with_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'cheat_sheet/cheat_sheet_widget.dart';
import 'gui/main_ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Color.fromRGBO(48, 48, 48, 1)));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Color.fromRGBO(245, 130, 37, 1),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Widget> get _widgetOptions => <Widget>[
        Stack(
          children: <Widget>[
            kIsWeb
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                          child: Column(
                        children: <Widget>[
                          Text(
                            'Starts With',
                            style: Theme.of(context).textTheme.title,
                          ),
                          StartsWithWidget(),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        children: <Widget>[
                          Text(
                            'Contains',
                            style: Theme.of(context).textTheme.title,
                          ),
                          ContainsWidget(),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        children: <Widget>[
                          Text(
                            'Ends With',
                            style: Theme.of(context).textTheme.title,
                          ),
                          EndsWithWidget(),
                        ],
                      )),
                    ],
                  )
                : TabBarDemo(),
            RegExOutputWidget(),
          ],
        ),
        CheatSheetWidget(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RegEx'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            title: Text('Create'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Cheat Sheet'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
