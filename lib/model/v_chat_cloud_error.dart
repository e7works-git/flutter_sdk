/// vchatcloud 결과 코드
enum VChatCloudResult {
  /// 채팅엔진 결과 코드
  systemError(0, "시스템 에러 – 관리자에게 문의하세요."),
  success(1, "성공"),
  userLimitExceeded(10101, "접속 인원이 초과되었습니다."),
  channelNotExisted(10102, "존재하지 않는 채팅방입니다."),
  channelBeforeOpened(10103, "채팅방 개설시간 전입니다."),
  channelAfterClosed(10104, "채팅방이 종료되었습니다."),
  activeLimitExceeded(10105, "Active User 수를 초과했습니다."),
  channelUserBaned(10106, "추방된 유저입니다."),
  userNotExisted(10107, "접속하지 않은 유저입니다."),
  channelAlreadyDisconnected(10108, "이미 접속 종료된 채팅방입니다."),
  userNotAllowed(10114, "접속 불가한 유저입니다."),
  channelInvalidPassword(10115, "비밀번호가 일치하지 않습니다."),
  missingRequiredParam(10901, "필수 파라미터 누락"),

  /// API 결과 코드
  incorrectRequest(400, "잘못된 요청입니다."),

  /// 기타 네트워크 오류
  disconnectedNetwork(1000, "네트워크 연결이 끊어졌습니다.");

  final int code;
  final String message;
  const VChatCloudResult(this.code, this.message);

  static VChatCloudResult fromCode(int code) =>
      VChatCloudResult.values.firstWhere(
        (element) => element.code == code,
        orElse: () => VChatCloudResult.systemError,
      );
}

class VChatCloudError extends Error {
  late final int code;
  late final String message;

  VChatCloudError.fromCode(int code) {
    var result = VChatCloudResult.fromCode(code);
    code = result.code;
    message = result.message;
  }

  VChatCloudError(this.code, this.message);
  VChatCloudError.fromResult(
    VChatCloudResult result, {
    int? code,
    String? message,
  })  : code = code ?? result.code,
        message = message ?? result.message;
}
