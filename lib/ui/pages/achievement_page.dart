// achievement_page.dart
// 업적 리스트 페이지 UI 및 로직 처리: 히든 업적은 해금 시 일반 업적처럼 보이고, 해금 전엔 아예 보이지 않음.

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart'; // responsive_sizer: 기기 화면 크기에 맞춰 UI 요소 크기 자동 조절 패키지
import 'package:flutter/material.dart';
import 'package:task_spark/data/user.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:task_spark/data/achievement.dart';
import 'package:task_spark/service/achievement_service.dart';
import 'package:task_spark/ui/widgets/achievement_tile.dart';

class AchievementPage extends StatefulWidget {
  final String nickname;
  final User myUser;
  final num expRate; // 경험치 비율

  const AchievementPage({
    super.key,
    required this.nickname,
    required this.myUser,
    required this.expRate,
  });

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  List<Achievement> achievements = []; // 업적 리스트
  bool isLoading = true; // 로딩상태 : true로 시작, 업적 로딩 끝나면 false로 바뀜
  Map<String, int> userValues = {}; // 사용자 메타데이터(각 업적 수치)를 저장

  /// 유저가 이 업적을 해금했는지 판단하는 함수
  bool _userHasUnlocked(Achievement achievement) {
    final currentValue = userValues[achievement.type] ?? 0;
    // 해금 조건: 해당 업적의 등급 중 하나라도 만족하면 true
    for (final tier in ['bronze', 'silver', 'gold', 'platinum', 'diamond']) {
      final required = achievement
          .amount[tier]; // 현등급에 해당하는 해금 조건 수치 | 여기서 required는 "이 등급의 목표 수치" )
      if (required != null && currentValue >= required) {
        return true; // 해금 O 업적: true
      }
    }
    return false; // 해금 X 업적: false
  }

  /// 업적 불러오기: PB에서 업적 리스트, 유저 메타데이터(진행상황).
  /// 받아온 데이터를 상태에 저장하고 로딩 해제
  Future<void> _fetchAchiv() async {
    final achivResult = await AchievementService()
        .getAchievementList(); // PB에서 업적 리스트 받아와 achivResult에 저장
    final userMetaData = await AchievementService()
        .getCurrentMetaData(); // 진행 상황(수치):유저가 현재까지 얼마나 업적을 달성했는가 받아옴
    setState(() {
      // UI에 반영되도록 상태 업데이트
      achievements = achivResult; // 받아온 업적 리스트를 상태변수에 저장
      isLoading = false; // 로딩 완료(스피너 멈춤)
      userValues = userMetaData; // 유저가 가진 업적 수치를 상태로 저장(나중에 해금 여부 판단할때 사용)
    });
  }

  /// 힌트 다이얼로그: ? 아이콘 눌렀을 때 업적 설명창
  void _showHelpDialog(BuildContext context) {
    AwesomeDialog(
      // 팝업 다이얼로그 위젯 패키지
      context: context, // 지금 보고 있는 화면(context)에 알림창 띄우기
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide, // 다이얼로그 애니메이션
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        child: Text(
          '비공개 업적을 누르면 힌트가 보여요!',
          style: TextStyle(
              fontSize: 16.sp, fontWeight: FontWeight.w600), // 기기비율 맞게 16.sp ,
        ),
      ),
      btnOkText: "확인",
      btnOkOnPress: () {}, // 확인버튼: () {} -> 별도 동작 없이 닫기
    ).show();
  }

  /// 업적별 힌트
  void _showHintDialog(BuildContext context, Achievement achievement) {
    // context: 현재 위젯의 위치 정보 담고 있음 , achievemetn: 어떤 업적 눌렀는지 정보 넘겨 받아, 그 업적 힌트 보여줌
    AwesomeDialog(
      context: context,
      animType: AnimType.scale, // 애내매이션 효과
      dialogType: DialogType.question, // 다이얼로그 분위기 지정
      body: Column(
        children: [
          Text(
            "업적 힌트",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              SizedBox(width: 10.w), // 왼쪽 여백
              Expanded(
                // 텍스트 너무 길면 줄바꿈 되도록 Expanded안에 넣음. 즉, 가로 공간 충분히 확보
                child: Text(
                  "${achievement.hint}",
                  style: TextStyle(fontSize: 15.sp),
                ),
              ),
              SizedBox(width: 10.w), // 오른쪽 여백
            ],
          ),
          SizedBox(height: 3.h),
        ],
      ),
      showCloseIcon: true,
    ).show();
  }

  /// initState()에서 업적 불러오기: 페이지 열리면 자동으로 _fetchAciv()실행
  @override
  void initState() {
    super
        .initState(); // 부모 클래스의 initState()도 먼저 실행시켜주는 코드 // super: 부모클래스의 기능을 가져오겠다, 그걸 어디에 쓰느냐에 따라 순서가 결정됨
    _fetchAchiv(); // 업적 불러오기
  } //-> 페이지 열리면 > 기본설정(super.initState)먼저 실행  > 업적 정보를 PB에서 불러와서 > 화면에 바로 표시할 준비 해주는 함수

  @override
  Widget build(BuildContext context) {
    final visibleAchievements = achievements.where((a) {
      // 전체 업적 목록 중 "사용자에게 보여줄 업적"만 필터링 해서 visibleAchievements리스트 만드는 것
      // 리스트 안의 요소들을 하나씩 a라는 이름으로 받아 검사하겠다는 뜻
      if (!a.isHidden) return true; // 일반&일회성 업적: 무조건 보임
      return _userHasUnlocked(a); // 히든 업적은: 해금된 경우에만 보임
    }).toList(); // toList(): 리스트 형태로 바꿔주는 함수

    /// 업적 정렬
    visibleAchievements.sort((a, b) {
      // a,b는 Achievement 리스트 안의 두 개의 업적을 비교하는 대상.
      final userValueA = userValues[a.type] ?? 0;
      // userValues는 Map형식임. 각 업적 타입별로 유저가 쌓은 수치를 저장하는 것.
      final userValueB = userValues[b.type] ?? 0;
      // 즉, A와 B업적 각각에 대해 유저가 얼마나 진행했는지 값을 불러오는 것.

      final tierA = AchievementService().getCurrentTierKey(userValueA, a);
      // getCurrenTierKey: 현재 업적 수치로 얻은 등급
      final tierB = AchievementService().getCurrentTierKey(userValueB, b);
      final progressA = AchievementService().getProgress(userValueA, a);
      // getProgress: 해당 업적에 대한 진행률
      final progressB = AchievementService().getProgress(userValueB, b);

      /// 히든 > 해금된 일회성 > 해금된 일반 > 해금 안된(any)
      int priority(Achievement ach, String tier) {
        if (ach.isHidden) return 0; // 0번째: 히든 업적이 최우선
        if (tier == 'none') return 3; // 3번째: 아직 해금 안된 업적은 맨 마지막
        if (ach.isOnce) return 1; // 1번째: 일회성 업적
        return 2; // 2번째: 일반 업적
      }

      /// 1) priority 비교: 업적 중요도(둘이 다르면 우선순위 높은게 먼저)
      final pA = priority(a, tierA);
      final pB = priority(b, tierB);
      final priorityCompare = pA.compareTo(pB); //compareTo()로 숫자 비교
      if (priorityCompare != 0)
        // priorityCOmpare결과 다르면 그 값으로 정렬 방향 결정, 같으면 다른 단계 비교로 넘어감
        return priorityCompare;
      // ** compareTo()->>  -1: 왼쪽 값 < 오른쪽 값  -> 왼쪽이 먼저 | 0: 두 값이 같음 | 1: 왼쪽 값 > 오른쪽 값 -> 오른쪽이 먼저

      /// 2) 등급 우선순위(다이아 > 플래티넘 > … > none)
      int tierValue(String t) => {
            // tier값을 int형으로 형변환, String t는  tierA, tireB에서 전달되는 문자열 등급
            // tireValue를 숫자로 바꿔서 비교
            'diamond': 5,
            'platinum': 4,
            'gold': 3,
            'silver': 2,
            'bronze': 1,
            'none': 0,
          }[t]!;
      final tierCompare = tierValue(tierB).compareTo(tierValue(tierA));
      if (tierCompare != 0) return tierCompare;

      /// 3) 진행률 높은 순
      final progressCompare = progressB.compareTo(progressA);
      if (progressCompare != 0) return progressCompare;

      /// 4) 누적값 높은 순
      return userValueB.compareTo(userValueA);
    });

    /// 업적 리스트 UI 구성
    return Scaffold(
      appBar: AppBar(
        title: Text('업적 리스트',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: BackButton(
          // 좌측에 뒤로 가기 버튼
          onPressed: () => Navigator.pop(context, true),
          color: Theme.of(context).colorScheme.secondary,
        ),
        actions: [
          // 우측엔 ? 아이콘 버튼:누르면 _showHelpDialog()함수 실행 - > 힌트 다이얼로그
          IconButton(
            icon: const Icon(FontAwesomeIcons.circleQuestion),
            color: Theme.of(context).colorScheme.secondary,
            // secondary: primary가 주색이면 secondary는 그걸 보조하는 색(ex:버튼 글자, 아이콘 색상 등)
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: isLoading // 로딩 스피너
          ? const Center(
              child:
                  CircularProgressIndicator()) // 데이터를 아직 불러오는 중이면 로딩 스피너를 가운데에 보여줌
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    // ListView: 스크롤 기능
                    itemCount: visibleAchievements
                        .length, // itemCount: 먗 게의 아이템을 만들 건지 정해줌
                    itemBuilder: (context, index) {
                      // 화면을 보여줄 업적 하나하나 "어떻게 만들까?" 정의하는 함수
                      final achievement = visibleAchievements[
                          index]; // achievement: 현재 index에 해당하는 업적 정보
                      final int userValue = userValues[achievement.type] ??
                          0; // userValues: 해당업적의 현재 달성 수치
                      /// 각 업적을 보여주는 위젯
                      return AchievementTile(
                        achievement: achievement,
                        currentValue: userValue,
                        isUnlocked: _userHasUnlocked(achievement),
                        onTap: () {
                          // 업적 클릭 시 힌트
                          print(
                              '[힌트탭] ${achievement.title} | isHidden: ${achievement.isHidden}, isUnlocked: ${_userHasUnlocked(achievement)}');
                          if (achievement.isHidden == false &&
                              !_userHasUnlocked(achievement)) {
                            if ((achievement.hint ?? '').trim().isNotEmpty) {
                              _showHintDialog(context, achievement);
                            } else {
                              print('[경고] 힌트가 비어있습니다: ${achievement.title}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("아직 힌트를 준비 중이에요!")),
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
