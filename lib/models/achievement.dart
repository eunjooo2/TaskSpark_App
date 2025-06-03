//	업적 리스트 및 조건 정의
class Achievement {
  final String title;
  final String description;
  final String type;
  final bool isOneTime;
  final bool isHidden;
  final Map<String, int> amount;
  final Map<String, dynamic>? reward;
  final String? forceTier;

  Achievement({
    required this.title,
    required this.description,
    required this.type,
    required this.amount,
    this.isOneTime = false,
    this.isHidden = false,
    this.reward,
    this.forceTier,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      isOneTime: json['isOneTime'] ?? false,
      isHidden: json['isHidden'] ?? false,
      amount: Map<String, int>.from(json['amount'] ?? {}),
      reward: json['reward'],
      forceTier: json['forceTier'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'isOneTime': isOneTime,
      'isHidden': isHidden,
      'amount': amount,
      if (reward != null) 'reward': reward,
      if (forceTier != null) 'forceTier': forceTier,
    };
  }
}
