import 'package:flutter/material.dart';

class DatePickerHelper {
  static Future<String?> selectDate({
    required BuildContext context,
    DateTime? initialDate,
  }) async {
    initialDate ??= DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      return "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, "0")}";
    }

    return null;
  }
}
