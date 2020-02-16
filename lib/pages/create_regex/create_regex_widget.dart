import 'package:easy_regex/pages/create_regex/regex_output_widget.dart';
import 'package:easy_regex/pages/create_regex/tabs/starts_with_repository.dart';
import 'package:easy_regex/pages/create_regex/tabs/starts_with_tab_view_model.dart';
import 'package:easy_regex/regex_change_notifier_provider.dart';
import 'package:flutter/material.dart';

import 'tabs/contains_widget.dart';
import 'tabs/ends_with_widget.dart';
import 'tabs/starts_with_widget.dart';

class CreateRegExWidget extends StatefulWidget {
  @override
  _CreateRegExWidgetState createState() => _CreateRegExWidgetState();
}

class _CreateRegExWidgetState extends State<CreateRegExWidget>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    final tabBodies = _tabBodies(context);
    _tabController ??= TabController(vsync: this, length: tabBodies.length);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RegExOutputWidget(),
          TabBar(
            isScrollable: true,
            controller: _tabController,
            tabs: _tabs(context),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: tabBodies,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _tabBodies(BuildContext context) => _createRegExTabs(context)
      .map((_createRegExTab) => _createRegExTab.body)
      .toList();

  List<Tab> _tabs(BuildContext context) => _createRegExTabs(context)
      .map((_createRegExTab) => _createRegExTab.toTab())
      .toList();

  List<_CreateRegExTab> _regExTabs;

  List<_CreateRegExTab> _createRegExTabs(BuildContext context) {
    _regExTabs ??= <_CreateRegExTab>[
      _CreateRegExTab('Starts With', startsWithWidget(context)),
      _CreateRegExTab('Contains', ContainsWidget()),
      _CreateRegExTab('Ends With', EndsWithWidget()),
    ];
    return _regExTabs;
  }

  Widget startsWithWidget(BuildContext context) {
    print('build - startsWithWidget');
    final repository = StartsWithRepository('starts_with_parameters_data');
    final regexValueNotifier = _regexValueNotifier(context);
    var startsWithTabViewModel =
        StartsWithTabViewModel(repository, regexValueNotifier);
    return FutureBuilder(
      future: startsWithTabViewModel.init(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return Container();
        return StartsWithWidget(startsWithTabViewModel);
      },
    );
  }

  ValueNotifier<String> _regexValueNotifier(BuildContext context) =>
      RegexChangeNotifierProvider.of(context).regexValueNotifier;
}

@immutable
class _CreateRegExTab {
  final String title;
  final Widget body;

  const _CreateRegExTab(this.title, this.body);

  Tab toTab() => Tab(child: Text(title));
}
