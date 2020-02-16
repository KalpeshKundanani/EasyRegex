import 'package:easy_regex/pages/create_regex/regex_parameter.dart';

class StartsWithRepository {
  StartsWithRepository(this.dataAccessKey);

  final String dataAccessKey;

  final List<RegexParameter> _startsWithRegexParameterList = [
    RegexParameter('Uppercase letter', 'A-Z'),
    RegexParameter('Lowercase letter', 'a-z'),
    RegexParameter('Number', '0-9'),
    RegexParameter('Symbol', '!-/:-@\\[-`\\{-~'),
  ];

  Future<List<RegexParameter>> getStartsWithParameterList() async {
    return _startsWithRegexParameterList;
  }

  Future<RegexParameter> getExactTextParameter() async {
    return RegexParameter();
  }

  Future<RegexParameter> getAnyTextParameter() async {
    return defaultRegexParameter;
  }
}
