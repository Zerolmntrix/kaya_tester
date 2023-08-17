import 'package:flutter/material.dart';

class FormData {
  const FormData(this.key, this.value);

  final String key;
  final String value;
}

FormField buildFormField(
  MapEntry entry,
  String initial,
  Function(String, String) onSaved,
) {
  final key = entry.key;
  final type = entry.value;

  final String label = key[0].toUpperCase() + key.substring(1);

  if (type == 'text') {
    return TextFormField(
      initialValue: initial,
      validator: (v) => v == null || v.isEmpty ? 'Provide a value' : null,
      onSaved: (value) => onSaved(key, value!),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
    );
  }

  return FormField(builder: (state) => const SizedBox());
}
