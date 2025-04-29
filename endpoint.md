> header의 `Authorization: token` 필드는 필수

# 사용자 요청
|메서드|요청 URL|쿼리파라미터 및 body|기능|
|--|--|--|--|
|GET|HOST/user|NULL|사용자 정보 불러오기
|POST|HOST/user|nickname, tag body|사용자 회원가입(닉네임, 태그 입력)
|PATCH|HOST/user|nullable User 객체 body|사용자 정보 업데이트
|DELETE|HOST/user|NULL|사용자 회원탈퇴|
|POST|HOST/user/exist|닉네임 및 태그 body|사용자 닉네임 및 태그 중복 여부 체크|

# 업적 요청
|메서드|요청 URL|쿼리파라미터 및 body|기능|
|--|--|--|--|
|GET|HOST/achiv|NULL|내가 불러올 수 있는 요청 목록 조회|
|GET|HOST/achiv/desc|target id parameter|업적의 자세한 설명 요청|

# 친구 요청
|메서드|요청 URL|쿼리파라미터 및 body|기능|
|--|--|--|--|
|GET|HOST/friend|NULL|친구 목록 불러오기|
|GET|HOST/friend/rival|NULL|라이벌 목록 불러오기|
|POST|HOST/requestFriend|target user id|친구 요청 보내기|
|POST|HOST/responseFriend|target user id|친구 요청 응답하기|
|POST|HOST/revokeFriend|target user id|친구 요청 취소|
|POST|HOST/requestRival|target user id|라이벌 요청 보내기|
|POST|HOST/responseFriend|target user id|라이벌 요청 응답하기|
|POST|HOST/revokeRival|target user id|라이벌 요청 취소|
|DELETE|HOST/friend|target user id|친구 삭제|
|POST|HOST/blockFriend|target user id|친구 차단|
|GET|HOST/rivalResult|target 


# 할일 요청
|메서드|요청 URL|쿼리파라미터 및 body|기능|
|--|--|--|--|

# 상점 요청
|메서드|요청 URL|쿼리파라미터 및 body|기능|
|--|--|--|--|
