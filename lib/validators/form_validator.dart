class FormValidator {
  static String? nonEmpty(String? val, String field) {
    if (val == null || val.isEmpty) {
      return "Invalid " + field + " value.";
    }
    return null;
  }
}
