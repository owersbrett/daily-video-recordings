class FormValidator {
  static String? nonEmpty(String? val, String field) {
    if (val == null || val.isEmpty) {
      return "Empty " + field + " value is invalid.";
    }
    return null;
  }
  static String? mustBeAnInt(String? val, String field) {
    if (val == null || val.isEmpty || int.tryParse(val) == null) {
      return field + " must be an integer.";
    }
    return null;
  }
}
