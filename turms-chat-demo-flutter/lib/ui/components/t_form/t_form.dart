import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../t_checkbox/t_simple_checkbox.dart';
import '../t_dropdown_menu.dart';
import '../t_horizontal_divider.dart';
import '../t_radio.dart';
import '../t_shortcut_text_field.dart';

class TForm extends StatelessWidget {
  const TForm({super.key, required this.formData});

  final TFormData formData;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: formData.groups.indexed.expand((item) {
          final (index, group) = item;
          final children = <Widget>[];
          if (index > 0) {
            children.add(const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: THorizontalDivider(),
            ));
          }
          children.add(Text(group.title,
              key: group.titleKey, style: const TextStyle(fontSize: 16)));
          group.fields.indexed.expand<Widget>(
            (element) {
              final (index, field) = element;
              return _buildFormField(index, field);
            },
          ).forEach(children.add);
          return children;
        }).toList(),
      );

  List<Widget> _buildFormField(int index, TFormField field) {
    final widgets = <Widget>[];
    widgets.add(const SizedBox(
      height: 8,
    ));
    final List<Widget> list = switch (field) {
      TFormFieldCheckbox() => [
          TSimpleCheckbox(
              onChanged: field.onChanged,
              value: field.value,
              label: field.label)
        ],
      TFormFieldRadioGroup() => [
          Wrap(
            direction: Axis.vertical,
            spacing: 8,
            children: [
              Text(field.label),
              Wrap(
                  direction: Axis.vertical,
                  spacing: 8,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (final radio in field.radios)
                      TRadio(
                        value: radio.value,
                        groupValue: field.groupValue,
                        label: radio.label,
                        onChanged: (value) {
                          // TODO: Wait for "declaration-site variance"
                          // https://github.com/dart-lang/language/issues/524
                          (radio as dynamic)?.onChanged?.call(value);
                          (field as dynamic)?.onChanged?.call(value);
                        },
                      )
                  ])
            ],
          ),
        ],
      TFormFieldShortcutTextField() => [
          Row(mainAxisSize: MainAxisSize.min, children: [
            Text(field.label),
            const SizedBox(
              width: 16,
            ),
            SizedBox(
              width: 180,
              child: TShortcutTextField(
                initialKeys: field.initialKeys,
                onShortcutChanged: field.onShortcutChanged,
              ),
            )
          ])
        ],
      TFormFieldSelect() => [
          Row(mainAxisSize: MainAxisSize.min, children: [
            Text(field.label),
            const SizedBox(
              width: 16,
            ),
            SizedBox(
              width: 180,
              child: TDropdownMenu(
                value: field.value,
                entries: field.entries,
                onSelected: (TDropdownMenuEntry item) {
                  // TODO: Wait for "declaration-site variance"
                  // https://github.com/dart-lang/language/issues/524
                  (field as dynamic).onSelected.call(item.value);
                },
              ),
            )
          ])
        ],
      _ => []
    };
    widgets.addAll(list);
    return widgets;
  }
}

class TFormData {
  TFormData({required this.groups});

  final List<TFormFieldGroup> groups;
}

class TFormFieldGroup {
  TFormFieldGroup({required this.title, this.titleKey, required this.fields});

  final String title;
  final Key? titleKey;
  final List<TFormField> fields;
}

class TFormField {
  TFormField({required this.label});

  final String label;
}

class TFormFieldCheckbox extends TFormField {
  TFormFieldCheckbox(
      {required super.label, required this.value, required this.onChanged});

  final bool value;

  final ValueChanged<bool> onChanged;
}

class TFormFieldRadioGroup<T> extends TFormField {
  TFormFieldRadioGroup(
      {required super.label,
      required this.groupValue,
      required this.radios,
      this.onChanged});

  final T groupValue;

  final List<TFormFieldRadio<T>> radios;

  final ValueChanged<T>? onChanged;
}

class TFormFieldRadio<T> {
  TFormFieldRadio({required this.label, required this.value, this.onChanged});

  final String label;

  final T value;

  final ValueChanged<T>? onChanged;
}

class TFormFieldShortcutTextField extends TFormField {
  TFormFieldShortcutTextField(
      {required super.label,
      this.initialKeys,
      required this.onShortcutChanged});

  final List<LogicalKeyboardKey>? initialKeys;
  final void Function(List<LogicalKeyboardKey> keys) onShortcutChanged;
}

class TFormFieldSelect<T> extends TFormField {
  TFormFieldSelect(
      {required super.label,
      this.value,
      required this.entries,
      required this.onSelected});

  final T? value;
  final List<TDropdownMenuEntry<T>> entries;
  final void Function(T value) onSelected;
}