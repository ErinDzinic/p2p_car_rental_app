String? validation(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field cannot be empty';
  }
  if (value.length < 3) {
    return 'This field must be at least 3 characters';
  }
  return null;
}

String? nonEmptyValidation(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field cannot be empty';
  }
  return null;
}
