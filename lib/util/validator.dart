String? validateNickname(String input) {
  if (input.trim().isEmpty) {
    return "닉네임을 입력해주세요.";
  }
  if (input.length > 20) {
    return "닉네임은 20자 이하로 입력해주세요.";
  }
  return null;
}

String? validateTag(String input) {
  if (input.trim().isEmpty) {
    return "태그를 입력해주세요.";
  }
  final tag = int.tryParse(input);
  if (tag == null || tag < 0 || tag > 9999) {
    return "태그는 0~9999 사이 숫자여야 합니다.";
  }
  return null;
}
