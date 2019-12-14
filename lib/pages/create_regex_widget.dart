import 'package:easy_regex/gui/tabs/contains_widget.dart';
import 'package:easy_regex/gui/tabs/ends_with_widget.dart';
import 'package:easy_regex/gui/tabs/starts_with_widget.dart';
import 'package:flutter/material.dart';

class CreateRegExWidget extends StatefulWidget {
  @override
  _CreateRegExWidgetState createState() => _CreateRegExWidgetState();
}

class _CreateRegExWidgetState extends State<CreateRegExWidget>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: _tabs.length,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Placeholder(
              // RegEx View
              fallbackHeight: 200,
            ),
          ),
        ),
        TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: buildTabTitles,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: buildTabBodies,
          ),
        ),
      ],
    );
  }

  List<Widget> get buildTabBodies => _tabs.map(((_tab) => _tab.body)).toList();

  List<Tab> get buildTabTitles =>
      _tabs.map(((_tab) => Tab(child: Text(_tab.title)))).toList();
}

final List<_CreateRegExTab> _tabs = <_CreateRegExTab>[
  _CreateRegExTab('Starts With', StartsWithWidget()),
  _CreateRegExTab('Contains', ContainsWidget()),
  _CreateRegExTab('Ends With', EndsWithWidget()),
];

@immutable
class _CreateRegExTab {
  final String title;
  final Widget body;

  const _CreateRegExTab(this.title, this.body);
}
