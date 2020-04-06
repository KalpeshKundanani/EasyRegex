import 'package:easy_regex/hive_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'starts_with_state.g.dart';

@HiveType(typeId: startsWithStateTypeId)
class StartsWithState extends HiveObject {
  @HiveField(0)
  bool startsWithAnything;
  @HiveField(1)
  bool startsWithLowercaseLetter;
  @HiveField(2)
  bool startsWithUppercaseLetter;
  @HiveField(3)
  bool startsWithNumber;
  @HiveField(4)
  bool startsWithSymbol;
  @HiveField(5)
  bool startsWithExactText;
  @HiveField(6)
  String exactTextToStartWith;

  StartsWithState({
    @required this.startsWithAnything,
    @required this.startsWithLowercaseLetter,
    @required this.startsWithUppercaseLetter,
    @required this.startsWithNumber,
    @required this.startsWithSymbol,
    @required this.startsWithExactText,
    @required this.exactTextToStartWith,
  });

  set isStartWithAnything(bool isStartWithAnything) {
    startsWithAnything = isStartWithAnything;
    if (isStartWithAnything) {
      unCheckStartsWithParameter();
      startsWithExactText = false;
    }
  }

  set isStartWithExactText(bool isStartWithExactText) {
    startsWithExactText = isStartWithExactText;
    if (isStartWithExactText) {
      startsWithAnything = false;
      unCheckStartsWithParameter();
    } else {
      checkAnythingIfAllUnchecked();
    }
  }

  set isStartWithLowercaseLetter(bool isWithLowercaseLetter) {
    startsWithLowercaseLetter = isWithLowercaseLetter;
    if (isWithLowercaseLetter) {
      onStartsWithParameterChecked();
    } else {
      checkAnythingIfAllUnchecked();
    }
  }

  set isStartWithUppercaseLetter(bool isWithUppercaseLetter) {
    startsWithUppercaseLetter = isWithUppercaseLetter;
    if (isWithUppercaseLetter) {
      onStartsWithParameterChecked();
    } else {
      checkAnythingIfAllUnchecked();
    }
  }

  set isStartWithNumber(bool isWithNumber) {
    startsWithNumber = isWithNumber;
    if (isWithNumber) {
      onStartsWithParameterChecked();
    } else {
      checkAnythingIfAllUnchecked();
    }
  }

  set isStartWithSymbol(bool isWithSymbol) {
    startsWithSymbol = isWithSymbol;
    if (isWithSymbol) {
      onStartsWithParameterChecked();
    } else {
      checkAnythingIfAllUnchecked();
    }
  }

  void onStartsWithParameterChecked() {
    startsWithAnything = false;
    startsWithExactText = false;
  }

  void unCheckStartsWithParameter() {
    startsWithLowercaseLetter = false;
    startsWithUppercaseLetter = false;
    startsWithNumber = false;
    startsWithSymbol = false;
  }

  void checkAnythingIfAllUnchecked() {
    final isAnyStartsWithParameterChecked = startsWithLowercaseLetter ||
        startsWithUppercaseLetter ||
        startsWithNumber ||
        startsWithSymbol ||
        startsWithExactText;
    startsWithAnything = !isAnyStartsWithParameterChecked;
  }

  @override
  String toString() {
    return 'StartsWithState{'
        'startsWithAnything: $startsWithAnything,'
        ' startsWithLowercaseLetter: $startsWithLowercaseLetter,'
        ' startsWithUppercaseLetter: $startsWithUppercaseLetter,'
        ' startsWithNumber: $startsWithNumber,'
        ' startsWithSymbol: $startsWithSymbol,'
        ' startsWithExactText: $startsWithExactText,'
        ' exactTextToStartWith: $exactTextToStartWith'
        '}';
  }
}
