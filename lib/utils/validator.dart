String? validateNickname(String? value) {
  if (value == null || value.isEmpty || value.trim() == "") {
    return "이 항목을 입력해주세요.";
  } else if (value.length < 3 || value.length > 12) {
    return "닉네임의 길이는 3자 이상, 12자 이하 입니다.";
  } else {
    return null;
  }
}

String? validateTag(String? value) {
  if (value == null || value.isEmpty || value.trim() == "") {
    return "이 항목을 입력해주세요.";
  } else if (value.length != 4) {
    return "태그의 길이는 4입니다.";
  } else {
    return null;
  }
}
