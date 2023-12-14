import 'package:flutter/material.dart';

class FormValidator {
  static String? nonEmpty(String? val, String field) {
    if (val == null || val.isEmpty) {
      return "Cannot save. $field field cannot be empty.";
    }
    return null;
  }

  static String? mustBeAnInt(String? val, String field) {
    if (val == null || val.isEmpty || int.tryParse(val) == null) {
      return "$field must be an integer.";
    }
    return null;
  }

  static String? mustBeEmojiOrSingleCharacter(String? val, String field) {

    if (val == null || val.isEmpty) {
      return "Empty $field value is invalid.";
    } else {
      val = val.trim();
    }
    if (val.characters.length > 2) {
      return "$field must 1 character long.";
    }
    return null;
  }
}
