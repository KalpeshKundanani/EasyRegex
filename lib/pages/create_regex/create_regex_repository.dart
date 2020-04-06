import 'package:easy_regex/pages/create_regex/match_on.dart';
import 'package:easy_regex/pages/create_regex/regex_parameter.dart';
import 'package:easy_regex/pages/create_regex/tabs/regex_tab_state.dart';
import 'package:easy_regex/pages/create_regex/tabs/starts_with/starts_with_state.dart';
import 'package:hive/hive.dart';

class CreateRegexRepository {
  static CreateRegexRepository _instance;

  factory CreateRegexRepository() {
    _instance ??= CreateRegexRepository._internal();
    return _instance;
  }

  CreateRegexRepository._internal();

  static const String _boxKey = 'create_regex_data_box';
  static const String _startsWithDataKey = 'startsWithState';
  static const String _containsDataKey = 'containsState';
  static const String _endsWithDataKey = 'endsWithState';
  static const String _matchOnDataKey = 'matchOnDataKey';

  Future<void> init() async {
    await Hive.openBox(_boxKey);
    await _putIfNotPresentInBox(_startsWithDataKey, _initialStartsWithState);
    await _putIfNotPresentInBox(_containsDataKey, _initialRegexTabState);
    await _putIfNotPresentInBox(_endsWithDataKey, _initialRegexTabState);
    await _putIfNotPresentInBox(_matchOnDataKey, _initialMatchOn);
  }

  Box get _box => Hive.box(_boxKey);

  StartsWithState get startsWithState =>
      _box.get(_startsWithDataKey) as StartsWithState;

  RegexTabState get containsState =>
      _box.get(_containsDataKey) as RegexTabState;

  RegexTabState get endsWithState =>
      _box.get(_endsWithDataKey) as RegexTabState;

  MatchOn get matchOn => _box.get(_matchOnDataKey) as MatchOn;

  Future saveMatchOn(MatchOn matchOn) async =>
      await _box.put(_matchOnDataKey, matchOn);

  Future _putIfNotPresentInBox(dynamic key, dynamic value) async {
    if (!_box.containsKey(key)) await _box.put(key, value);
  }
}

StartsWithState get _initialStartsWithState => StartsWithState(
      startsWithAnything: true,
      startsWithLowercaseLetter: false,
      startsWithUppercaseLetter: false,
      startsWithNumber: false,
      startsWithSymbol: false,
      startsWithExactText: false,
      exactTextToStartWith: '',
    );

RegexTabState get _initialRegexTabState => RegexTabState(
      containsAnything: true,
      containsParameters: <RegexParameter>[],
      notContainsParameters: <RegexParameter>[],
    );

MatchOn get _initialMatchOn => MatchOn.words;
