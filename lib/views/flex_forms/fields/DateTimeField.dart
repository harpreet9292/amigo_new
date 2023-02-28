import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:amigotools/utils/types/Pair.dart';
import 'package:amigotools/utils/types/Proc.dart';
import 'package:amigotools/views/flex_forms/FlexFieldBase.dart';
import 'package:amigotools/utils/data/DateTimeHelper.dart';
import 'package:amigotools/view_models/flex_fields/FlexFieldModel.dart';

class DateTimeField extends FlexFieldBase {
  DateTimeField({required bool editMode}) : super(editMode: editMode);

  @override
  String getValue(BuildContext context, FlexFieldModel model) {
    final langCode = ui.window.locale.languageCode;

    if (!model.hasNotEmptyValue) return "";

    switch (model.inputType) {
      case FlexFieldInputTypeModel.Date:
        final dt = DateTime.parse(model.value);
        return DateFormat.yMd(langCode).format(dt);

      case FlexFieldInputTypeModel.Time:
        final t = parseIsoTime(model.value);
        return DateFormat.Hm(langCode).format(t);

      default:
        final dt = DateTime.parse(model.value);
        return dateTimeToLocalString(dt);
    }
  }

  @override
  Iterable<Pair<IconData, Proc2<BuildContext, FlexFieldModel>>> getActionIcons(
          FlexFieldModel model) =>
      model.hasNotEmptyValue && editMode
          ? [Pair(Icons.close, (context, model) => model.value = null)]
          : model.value == null && editMode
            ? [Pair(Icons.calendar_today_outlined, (context, model) => model.value = dateTimeToIsoDateTime(DateTime.now()))]
            : [];

  @override
  void onClick(BuildContext context, FlexFieldModel model) async {
    switch (model.inputType) {
      case FlexFieldInputTypeModel.Date:
        final res = await _editDate(context, model);
        if (res != null) model.value = dateTimeToIsoDateTime(res);
        break;

      case FlexFieldInputTypeModel.Time:
        final res = await _editTime(context, model);
        if (res != null) {
          final dt = DateTime(1);
          model.value = dateTimeToIsoDateTime(
              DateTime(dt.year, dt.month, dt.day, res.hour, res.minute));
        }
        break;

      default:
        final resd = await _editDate(context, model);
        if (resd != null) {
          final rest = await _editTime(context, model);

          if (rest != null)
            model.value = dateTimeToIsoDateTime(DateTime(
                resd.year, resd.month, resd.day, rest.hour, rest.minute));
        }
    }
  }

  Future<DateTime?> _editDate(
      BuildContext context, FlexFieldModel model) async {
    final current =
        model.value != null ? DateTime.tryParse(model.value) : null;

    return await showDatePicker(
      context: context,
      helpText: model.label,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
    );
  }

  Future<TimeOfDay?> _editTime(
      BuildContext context, FlexFieldModel model) async {
    final current = model.value != null ? parseIsoTime(model.value) : null;

    return await showTimePicker(
      context: context,
      helpText: model.label,
      initialTime:
          current != null ? TimeOfDay.fromDateTime(current) : TimeOfDay.now(),
    );
  }
}
