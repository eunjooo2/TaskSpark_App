// 업적 모델 정의
import 'package:task_spark/models/achievement.dart';

final List<Achievement> achievements = [
  Achievement.fromJson({
    "title": "할일 등록 업적(임시)",
    "description": "할 일을 추가했을 때 주어지는 업적입니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    },
    "reward": {
      "bronze": {"exp": 50}
    },
    "isOneTime": false
  }),
  Achievement.fromJson({
    "title": "(임시)",
    "description": "(임시)",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    },
    "isOneTime": false
  }),
  Achievement.fromJson({
    "title": "루틴 요정 등장!",
    "description": "루틴 연속 성공 시 달성",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    },
    "reward": {
      "bronze": {"exp": 50},
      "silver": {
        "items": [
          {"id": "exp_boost_item", "amount": 1}
        ]
      }
    },
    "isOneTime": false
  }),
  Achievement.fromJson({
    "title": "계획의 마법사",
    "description": "7일 동안 계획 달성률 95% 유지 시",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    },
    "reward": {
      "gold": {"exp": 250}
    },
    "isOneTime": false
  }),
  Achievement.fromJson({
    "title": "어느새 고인물",
    "description": "레벨 50 달성",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    },
    "reward": {
      "platinum": {
        "items": [
          {"id": "nickname_tag_change", "amount": 1}
        ]
      }
    },
    "isOneTime": false
  }),
  Achievement.fromJson({
    "title": "이제는 썩은물",
    "description": "레벨 150 달성",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    },
    "reward": {
      "diamond": {
        "items": [
          {"id": "exp_boost_1_5x", "amount": 1},
          {"id": "shield_item", "amount": 1}
        ]
      }
    },
    "isOneTime": false
  }),

  // 일회성 업적
  Achievement.fromJson({
    "title": "꼴도 보기 싫어!",
    "description": "차단 기능 사용 시 얻게 되는 업적",
    "type": "block_friend",
    "amount": {"bronze": 1},
    "reward": {
      "bronze": {"exp": 500}
    },
    "isOneTime": true,
    "forceTier": "다이아"
  }),
];
