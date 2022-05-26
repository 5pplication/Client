String? validateEmail(String? value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty || value.trim() == "") {
    return "email을 입력해주세요.";
  } else {
    if (!regex.hasMatch(value.trim())) {
      return "올바르지 않은 형식 입니다.";
    }
    return null;
  }
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty || value.trim() == "") {
    return "이 항목을 입력해주세요.";
  } else {
    return null;
  }
}
