// [ 업적 모델 클래스 정의 ]

class Achievement {
  final String title;
  final String description;
  final String type;
  final Map<String, int> amount;
  final Map<String, dynamic> reward;
  final bool isHidden;

  Achievement({
    required this.title,
    required this.description,
    required this.type,
    required this.amount,
    required this.reward,
    this.isHidden = false, //  기본값 false
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'make_task',
      amount: Map<String, int>.from(json['amount']),
      reward: json['reward'] != null
          ? Map<String, dynamic>.from(json['reward'])
          : {},
      isHidden: json['isHidden'] ?? false, //  히든 여부도 반영!
    );
  }
}
