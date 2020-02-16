import 'package:easy_regex/pages/create_regex/regex_parameter.dart';
import 'package:hive/hive.dart';

class StartsWithRepository {
  StartsWithRepository(this.dataAccessKey);

  final String dataAccessKey;

  Future<Box<RegexParameter>> get _startsWithRegexParameterListBox async =>
      await Hive.openBox<RegexParameter>('starts_with$dataAccessKey');

  final List<RegexParameter> _startsWithRegexParameterList = <RegexParameter>[
    RegexParameter('Uppercase letter', 'A-Z'),
    RegexParameter('Lowercase letter', 'a-z'),
    RegexParameter('Number', '0-9'),
    RegexParameter('Symbol', '!-/:-@\\[-`\\{-~'),
  ];

  Future<List<RegexParameter>> getStartsWithParameterList() async {
    print('getStartsWithParameterList');
    // ignore: omit_local_variable_types
    final Box<RegexParameter> box = await _startsWithRegexParameterListBox;
    print('box.isNotEmpty: ${box.isNotEmpty}');
    if (box.isNotEmpty) {
      List<RegexParameter> list = <RegexParameter>[];
      try {
        list = box.values.toList();
        print('list: $list');
      } catch (e) {
        print(e);
      }
      await box.close();
      return list;
    }
    await saveStartsWithList(_startsWithRegexParameterList);
    return getStartsWithParameterList();
  }

  Future<RegexParameter> getExactTextParameter() async {
    return RegexParameter();
  }

  Future<RegexParameter> getAnyTextParameter() async {
    return defaultRegexParameter;
  }

  Future saveStartsWithList(List<RegexParameter> parameterList) async {
    // ignore: omit_local_variable_types
    final Box<RegexParameter> box = await _startsWithRegexParameterListBox;
    await box.clear();
    parameterList.forEach((RegexParameter parameter) {
      box.put(parameter.title, parameter);
    });
    await box.close();
  }

  void saveExactTextParameter(RegexParameter regexParameter) {}

  void saveAnyTextParameter(RegexParameter regexParameter) {}
}
