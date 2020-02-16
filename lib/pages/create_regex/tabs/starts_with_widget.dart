import 'package:easy_regex/pages/create_regex/regex_parameter.dart';
import 'package:easy_regex/pages/create_regex/tabs/starts_with_tab_view_model.dart';
import 'package:flutter/material.dart';

class StartsWithWidget extends StatefulWidget {
  final StartsWithTabViewModel startsWithTabViewModel;

  StartsWithWidget(this.startsWithTabViewModel);

  @override
  _StartsWithWidgetState createState() => _StartsWithWidgetState();
}

class _StartsWithWidgetState extends State<StartsWithWidget> {
  StartsWithTabViewModel get _viewModel => widget.startsWithTabViewModel;
  Color _accentColor;

  @override
  Widget build(BuildContext context) {
    _accentColor = Theme.of(context).accentColor;
    final _exactTextNotifier = _viewModel.exactTextNotifier;
    var exactText = _exactTextNotifier.value;
    final _anyTextNotifier = _viewModel.anyTextNotifier;
    final _startsWithListNotifier = _viewModel.startsWithListNotifier;
    return ValueListenableBuilder<List<RegexParameter>>(
      valueListenable: _startsWithListNotifier,
      builder: (BuildContext context, List<RegexParameter> list, Widget child) {
        return ListView.builder(
          itemCount: list.length + 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return CheckboxListTile(
                dense: true,
                title: Text(defaultRegexParameter.title),
                activeColor: _accentColor,
                value: defaultRegexParameter.isIncluded,
                onChanged: (bool isChecked) {
                  defaultRegexParameter.isIncluded = isChecked;
                  if (isChecked) {
                    for (final parameter in list) {
                      parameter.isIncluded = false;
                    }
                    exactText.isIncluded = false;
                    _anyTextNotifier.value =
                        RegexParameter.from(defaultRegexParameter);
                    _startsWithListNotifier.value = List.from(list);
                  }
                },
              );
            }
            if (index == (list.length + 1)) {
              return ValueListenableBuilder(
                valueListenable: _exactTextNotifier,
                builder: (_, RegexParameter exactText, __) {
                  return CheckboxListTile(
                    dense: true,
                    title: TextFormField(
                      initialValue: exactText.title,
                      onChanged: (String value) {
                        _exactTextNotifier.value = RegexParameter(
                          value,
                          value,
                          true,
                        );
                      },
                    ),
                    activeColor: _accentColor,
                    value: exactText.isIncluded,
                    onChanged: (bool isChecked) {
                      exactText.isIncluded = isChecked;
                      _exactTextNotifier.value = RegexParameter.from(exactText);
                      if (isChecked) {
                        for (final parameter in list) {
                          parameter.isIncluded = false;
                        }
                        defaultRegexParameter.isIncluded = false;
                        _startsWithListNotifier.value = List.from(list);
                      }
                    },
                  );
                },
              );
            }

            index = index - 1;
            final parameter = list[index];
            return CheckboxListTile(
              dense: true,
              title: Text(parameter.title),
              activeColor: _accentColor,
              value: parameter.isIncluded,
              onChanged: (bool value) {
                parameter.isIncluded = value;
                _startsWithListNotifier.value = List.from(list);
                exactText.isIncluded = false;
                defaultRegexParameter.isIncluded = false;
              },
            );
          },
        );
      },
    );
  }
}
