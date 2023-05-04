class ChatRoomModel {
  /// rtc 사용 여부
  String rtcStat;

  /// 방 종류 (01: 채팅 | 02: 영상 | 03: 메타버스)
  String roomType;

  /// 방 잠금 유형 (PW: 비밀번호 | EM: 이메일 | ALL: 비밀번호+이메일)
  String lockType;

  /// 방 생성자 이메일
  String userEmail;

  /// 최대 접속 가능인원
  int userMax;

  /// 방 이름
  String roomNm;

  /// 방 삭제 여부
  String roomDestroyYn;

  /// 방 잠금 여부 (Y/N)
  String prtcRstr;

  /// 구글 번역 사용여부
  ///
  /// [Vchatcloud CMS](https://vchatcloud.com/cms)에서 채팅방 설정 - 구글 번역 사용 설정해야 함
  String gTransStat;

  /// 해상도 설정
  int wbrtRslt;

  ChatRoomModel.fromJson(Map<String, dynamic> json)
      : rtcStat = json['RTC_STAT'],
        roomType = json['ROOM_TYPE'],
        lockType = json['LOCK_TYPE'],
        userEmail = json['USER_EMAIL'],
        userMax = json['USER_MAX'],
        roomNm = json['ROOM_NM'],
        roomDestroyYn = json['ROOM_DESTROY_YN'],
        prtcRstr = json['PRTC_RSTR'],
        gTransStat = json['G_TRANS_STAT'],
        wbrtRslt = json['WBRT_RSLT'];
}
