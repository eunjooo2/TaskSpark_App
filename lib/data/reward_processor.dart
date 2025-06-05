import 'package:task_spark/utils/models/achievement.dart';
import 'package:task_spark/utils/models/user.dart';

/// 업적 보상 지급 유틸리티 (경험치, 아이템)
class RewardProcessor {
  /// 보상 지급: 업적 객체와 등급명 전달 (e.g. 'bronze')
  static void grantReward({
    required Achievement achievement,
    required String tier,
    required User user,
  }) {
    final rewardData = achievement.reward?[tier.toLowerCase()];
    if (rewardData == null) return;

    // 경험치 보상 지급
    if (rewardData.containsKey('exp')) {
      final expAmount = rewardData['exp'] as int;
      user.exp = (user.exp ?? 0) + expAmount;
      print('[보상 지급] 경험치 +$expAmount');
    }

    // 아이템 보상 지급
    if (rewardData.containsKey('items')) {
      final List<dynamic> items = rewardData['items'];
      for (final item in items) {
        final String id = item['id'];
        final int amount = item['amount'];

        // inventory가 null일 경우 초기화
        user.inventory ??= {};
        final current = user.inventory![id] ?? 0;
        user.inventory![id] = current + amount;

        print('[보상 지급] 아이템 $id x$amount');
      }
    }
  }
}
