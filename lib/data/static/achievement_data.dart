// [ 업적 리스트 페이지 ]
// 브 5 실 15 골 30 플 50 다 80
// 업적은 추후후 다시 검토 (임시)

import '../achievement.dart';

final List<Achievement> achievements = [
// 브론즈 ~
  Achievement.fromJson({
    "title": "할 일을 등록해볼까?",
    "description": "할 일을 처음 추가했을 때 주어지는 업적입니다.",
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
    }
  }),
  Achievement.fromJson({
    "title": "계획의 첫 발걸음",
    "description": "할 일을 10개 이상 추가했을 때 주어지는 업적입니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    },
  }),
  Achievement.fromJson({
    "title": "나의 첫 루틴",
    "description": "루틴을 처음 등록했을 때 얻을 수 있습니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "이제부터 갓생살기",
    "description": "4일 연속 로그인 시 얻을 수 있습니다",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "완벽한 하루",
    "description": "하루 동안 모든 할 일을 완료",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),

// 브론즈 //

// 실버 ~ 15
  Achievement.fromJson({
    "title": "루틴 요정 등장!",
    "description": "루틴을 4일 연속 성공 시 달성",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    },
    "reward": {
      "silver": {
        "items": [
          {"id": "경험치 부스트 아이템 아이디", "amount": 1}
        ]
      }
    }
  }),
  Achievement.fromJson({
    "title": "불타는 출석왕!",
    "description": "7일 연속 로그인 시 얻을 수 있습니다. ",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "친구야 반가워!",
    "description": "친구를 첫 추가 시 얻을 수 있습니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "이제부터 갓생 시작",
    "description": "하루에 할 일, 루틴 모두 완료 시 얻을 수 있습니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "학습의 신",
    "description": "학습 관련 목표를 10회 달성하면 얻을 수 있습니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),

  Achievement.fromJson({
    "title": "소비는 나의 힘",
    "description": "아이템 첫 구매 시 얻을 수 있습니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "이것이 아이템의 힘?!",
    "description": "아이템 첫 사용 시 얻을 수 있습니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "루틴 완주자",
    "description": "루틴을 8일 연속 성공 시 얻을 수 있습니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "루틴 도장깨기 중!",
    "description": "루틴을 20일 연속 성공 시 얻을 수 있습니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "이제는 뉴비가 아니야!",
    "description": "레벨 15 도달 시 얻을 수 있습니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),

// 실버 //

// 골드 ~ 30
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
      "Gold": {"exp": 250}
    }
  }),
  Achievement.fromJson({
    "title": "끈기의 정석",
    "description": "30일 연속 로그인 시 획득",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    },
  }),
  Achievement.fromJson({
    "title": "도전을 기꺼이",
    "description": "라이벌 신청 수락하면 얻을 수 있는 업적",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "친화력 만렙",
    "description": "친구를 5명 이상 추가",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "파지직 나에겐 안통해!",
    "description": "방어권 사용 누적 5회 달성 시 얻을 수 있습니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),

  Achievement.fromJson({
    "title": "미루기 금지령",
    "description": "3일 연속 할 일을 미루지 않기",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "불타는 성장 중!",
    "description": "레벨 25 도달 시",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "갓생 챌린저",
    "description": "일주일 연속 할 일 80% 이상 달성률",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "오늘의 위너너",
    "description": "라이벌 매치에서 우승하면 얻게되는 업적",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "꾸준히 더 열심히",
    "description": "60일 연속 로그인 시 획득",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),

  Achievement.fromJson({
    "title": "아이템 사용 마스터",
    "description": "아이템 사용 총 50회 달성",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "계획 도장깨기",
    "description": "30일 연속 계획 달성률 80% 유지하면 얻을 수 있습니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "계획의 마법사",
    "description": "50일 연속 계획 달성률 90% 유지하면 얻을 수 있습니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "라이벌 신청이다!",
    "description": "라이벌 신청 아이템을 사용하면 얻을 수 있습니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "계획 폭주자",
    "description": "하루에 할 일을 20개 이상 등록하고 모두 완료",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
// 골드 //

// 플레티넘 ~ 50
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
          {"id": "닉네임 태그 변경권", "amount": 1}
        ]
      }
    }
  }),
  Achievement.fromJson({
    "title": "닉네임 태그를 변경해보자!",
    "description": "닉네임 태그 변경권 사용 시 얻게되는 업적",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "전설의 챌린저",
    "description": "라이벌 매치에서 누적 50회를 우승하면 얻을 수 있습니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "계획력 신화",
    "description": "120일 연속 계획 달성률 90% 이상 유지하면 얻을 수 있습니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "초월 루틴러",
    "description": "루틴을 200회 이상 실행",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),

  Achievement.fromJson({
    "title": "아이템 사용도 마스터",
    "description": "아이템 사용 누적 100회 달성",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "우승은 나의 것",
    "description": "라이벌 매치에서 누적 25회를 우승하면 얻을 수 있습니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    },
  }),
  Achievement.fromJson({
    "title": "포인트 벌이꾼",
    "description": "포인트가 800 이상 누적",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "전략적 소비자",
    "description": "아이템 사용 누적 200회 달성",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "루틴의 신",
    "description": "루틴 성공률 95% 이상 유지한 채 80회 이상 성공",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),

  Achievement.fromJson({
    "title": "할 일 폭격기",
    "description": "한 달 간 할 일 100개 완료",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "계획의 현자",
    "description": "하루 평균 계획 달성률 95%를 60일 유지",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "고인물을 벗어나",
    "description": "레벨 80달성",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "쉽게 당해주지 않아",
    "description": "방어권 사용 20회 달성 시 ",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "더 빠르게 달려볼까?",
    "description": "부스트 아이템 50회 사용",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "계획력 신화",
    "description": "30일 연속 계획 달성률 100% 유지지",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "무한루틴",
    "description": "루틴 30일 연속 성공",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "썩은물을 향해서",
    "description": "레벨 100 달성",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "달성률 100의 사나이",
    "description": "50일 연속 계획 달성률 100% 유지",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),

  Achievement.fromJson({
    "title": "계획 공장장",
    "description": "한 달간 할 일 생성 100개 이상",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
// 플레티넘 //

// 다이아 ~ 80
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
          {"id": "경험치 부스트 1.5배 아이템 아이디", "amount": 1},
          {"id": "방어권", "amount": 1}
        ]
      }
    }
  }),
  Achievement.fromJson({
    // 차단 기능 사용 시시
    "title": "꼴도 보기 싫어!",
    "description": "차단 기능 사용시",
    "type": "block_friend",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    },
    "reward": {
      "bronze": {"exp": 500},
    }
  }),
  Achievement.fromJson({
    "title": "아무도 못말려",
    "description": "레벨 200 달성",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "초월 루틴러",
    "description": "루틴을 200회 이상 실행",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "계획 폭주자",
    "description": "하루에 할 일을 25개 이상 등록하고 모두 완료",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "지는법을 까먹었다",
    "description": "라이벌 매치에서 누적 50회 우승",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "전설의 챌린저",
    "description": "라이벌 매치에서 누적 80회 우승",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "루틴의 신",
    "description": "루틴 성공률 90% 이상 유지한 채 30회 이상 성공",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "할 일 폭격기",
    "description": "한 달 간 할 일 200개 완료",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "최종 진화",
    "description": "레벨 50 달성",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),

  Achievement.fromJson({
    "title": "플랜 부스터",
    "description": "부스트 아이템 50회 사용",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "나를 이길 상대는 없어!",
    "description": "라이벌 매치에서 누적 100회 이상 우승",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "달성률 100의 사나이",
    "description": "50일 연속 달성률 100% 유지",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "무한루틴",
    "description": "루틴 30일 연속 성공",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "계획 공장장",
    "description": "한 달간 할 일 생성 300개 이상",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),

  Achievement.fromJson({
    "title": "달성왕",
    "description": "누적 할 일 등록 수 1000개 돌파",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "계획의 정점",
    "description": "80일 연속 모든 계획 100% 달성",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "버티기 장인",
    "description": "120일 연속 로그인",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "전설의 사용자",
    "description": "앱 누적 사용 100시간 돌파",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "달성왕",
    "description": "누적 할 일 완료 수 1000개 돌파",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),

  Achievement.fromJson({
    "title": "할 일 장인",
    "description": "누적 할 일 등록 수 2000개 달성",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "루틴 챔피언",
    "description": "루틴 누적 성공 500회 달성",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "무결점 달성자",
    "description": "200일 연속 모든 계획 100% 달성",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "계획 자동인간",
    "description": "하루 평균 10개 이상의 계획을 한 달간 유지",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "끝까지 간다",
    "description": "300일 이상 연속 로그인",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),

  Achievement.fromJson({
    "title": "계획의 달인",
    "description": "누적 할 일 등록 수 3000개 달성",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "100% 인간",
    "description": "하루 계획 달성률 100%를 누적 100회 달성",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "이제는 계획이 나의 삶",
    "description": "150일 연속 모든 계획 100% 달성",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "미루지 않기 챌린저",
    "description": "할 일 미룸 없이 100일 연속 완수",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "시간의 지배자",
    "description": "앱 누적 사용 시간 300시간 돌파",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
// 다이아 //

// 히든 업적 5개  // 비공개
  Achievement.fromJson({
    "title": "나는야 갓생 아침러",
    "description": "20일동안 루틴을 오전 6시~오후 12시에 15개 성공",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "나 잊은 거 아니지..?",
    "description": "15일 연속 접속 안하면 얻게 되는 업적",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "폭주 기관차",
    "description": "부스트 사용 누적 200회 달성 시 얻게 되는 업적입니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "이제부터가가 시작이야",
    "description": "라이벌 매치에서 누적 50회 패배시 얻게 되는 업적입니다.",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
  Achievement.fromJson({
    "title": "계획은 나의 삶",
    "description": "할일 등록수 누적 5000개 달성",
    "type": "make_task",
    "amount": {
      "bronze": 5,
      "silver": 15,
      "gold": 30,
      "platinum": 50,
      "diamond": 80
    }
  }),
// 히든 업적 //
];
