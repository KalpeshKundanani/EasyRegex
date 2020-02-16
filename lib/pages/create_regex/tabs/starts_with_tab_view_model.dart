import 'package:easy_regex/pages/create_regex/regex_parameter.dart';
import 'package:easy_regex/pages/create_regex/regex_value_manager.dart';
import 'package:easy_regex/pages/create_regex/tabs/starts_with_repository.dart';
import 'package:flutter/material.dart';

class StartsWithTabViewModel {
  final ValueNotifier<String> regexValueNotifier;
  StartsWithTabViewModel(this.repository, this.regexValueNotifier);

  final StartsWithRepository repository;
  ValueNotifier<RegexParameter> exactTextNotifier;
  ValueNotifier<RegexParameter> anyTextNotifier;
  ValueNotifier<List<RegexParameter>> startsWithListNotifier;

  Future<bool> init() async {
    await _initAnyTextViewNotifier();
    await _initStartsWithViewNotifier();
    await _initExactTextViewNotifier();
    return true;
  }

  Future _initStartsWithViewNotifier() async {
    final startsWithParameterList =
        await repository.getStartsWithParameterList();
    startsWithListNotifier =
        ValueNotifier<List<RegexParameter>>(startsWithParameterList);

    startsWithListNotifier.addListener(() {
      repository.saveStartsWithList(startsWithListNotifier.value);
      final listToRegex = parameterListToRegex(startsWithListNotifier.value);
      if (listToRegex.isNotEmpty) {
        startsWithListenable.value = listToRegex;
        regexValueNotifier.value = buildRegex();
      } else if (exactTextNotifier.value.isIncluded) {
        startsWithListenable.value = exactTextNotifier.value.regexValue;
        regexValueNotifier.value = buildRegex();
      } else if (anyTextNotifier.value.isIncluded) {
        startsWithListenable.value = anyTextNotifier.value.regexValue;
        regexValueNotifier.value = buildRegex();
      }
    });
  }

  Future _initExactTextViewNotifier() async {
    final exactTextParameter = await repository.getExactTextParameter();
    exactTextNotifier = ValueNotifier<RegexParameter>(exactTextParameter);
    exactTextNotifier.addListener(() {
      var regexParameter = exactTextNotifier.value;
      repository.saveExactTextParameter(regexParameter);
      if (regexParameter.isIncluded) {
        startsWithListenable.value = regexParameter.regexValue;
        regexValueNotifier.value = buildRegex();
      }
    });
  }

  Future _initAnyTextViewNotifier() async {
    final anyTextParameter = await repository.getAnyTextParameter();
    anyTextNotifier = ValueNotifier<RegexParameter>(anyTextParameter);
    anyTextNotifier.addListener(() {
      var regexParameter = anyTextNotifier.value;
      print(regexParameter);
      repository.saveAnyTextParameter(regexParameter);
      if (regexParameter.isIncluded) {
        startsWithListenable.value = '.*';
        regexValueNotifier.value = buildRegex();
      }
    });
  }
}
