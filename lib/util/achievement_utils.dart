// achievement_utils.dart
// 업적 등급 계산, 진행률 계산, thresholds 계산 등 모든 숫자 로직 담당

const List<String> tierKeys = [
  'bronze',
  'silver',
  'gold',
  'platinum',
  'diamond'
];

const List<String> tierNamesKor = [
  '없음',
  '브론즈',
  '실버',
  '골드',
  '플래티넘',
  '다이아',
];

/// 브론즈~다이아까지 누적 수치 리스트 생성 (게이지바용)
List<int> getThresholds(Map<String, int> amountMap) {
  final tierAmounts = tierKeys.map((key) => amountMap[key] ?? 0).toList();
  final List<int> thresholds = [0];
  for (var a in tierAmounts) {
    thresholds.add(thresholds.last + a);
  }
  return thresholds;
}

/// 현재 값에 해당하는 등급 인덱스 계산
int getTierIndex(Map<String, dynamic> amount, int current) {
  for (int i = tierKeys.length - 1; i >= 0; i--) {
    if (current >= (amount[tierKeys[i]] ?? 999999)) {
      return i + 1; // 1부터 시작하도록 보정
    }
  }
  return 0;
}

/// 현재 등급 기준 다음 등급까지의 진행률 계산 (0.0 ~ 1.0)
double getProgressPercent(
    int current, Map<String, dynamic> amount, int tierIndex) {
  if (tierIndex <= 0 || tierIndex >= tierKeys.length) return 0.0;

  final start = amount[tierKeys[tierIndex - 1]] ?? 0;
  final end = amount[tierKeys[tierIndex]] ?? (start + 1);

  return ((current - start) / (end - start)).clamp(0.0, 1.0);
}

/// 인덱스를 한글 등급 이름으로 변환
String getTierNameKor(int tierIndex) {
  return tierNamesKor[tierIndex.clamp(0, tierNamesKor.length - 1)];
}
