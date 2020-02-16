import 'package:easy_regex/pages/create_regex/regex_parameter.dart';
import 'package:hive/hive.dart';

const int regexParameterTypeId = 0;

void registerHiveAdapter() {
  Hive.registerAdapter(RegexParameterAdapter());
}
