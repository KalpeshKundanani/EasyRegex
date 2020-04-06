import 'package:easy_regex/pages/create_regex/match_on.dart';
import 'package:easy_regex/pages/create_regex/regex_parameter.dart';
import 'package:easy_regex/pages/create_regex/tabs/regex_tab_state.dart';
import 'package:easy_regex/pages/create_regex/tabs/starts_with/starts_with_state.dart';
import 'package:hive/hive.dart';

const int regexParameterTypeId = 0;
const int regexTabStateTypeId = 1;
const int startsWithStateTypeId = 2;
const int matchOnTypeId = 3;

void registerHiveAdapter() {
  Hive.registerAdapter(RegexParameterAdapter());
  Hive.registerAdapter(RegexTabStateAdapter());
  Hive.registerAdapter(StartsWithStateAdapter());
  Hive.registerAdapter(MatchOnAdapter());
}
