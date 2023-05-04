import 'package:vchatcloud_flutter_sdk/model/channel_result_model.dart';

/// 해당 클래스를 상속해서 메서드를 구현해야 합니다.
abstract class ChannelHandler {
  /// 메시지 수신 시 실행
  void onMessage(ChannelResultModel message) {
    throw UnimplementedError();
  }

  /// 귓속말 수신 시 실행
  void onWhisper(ChannelResultModel message) {
    throw UnimplementedError();
  }

  /// 공지사항 수신 시 실행
  void onNotice(ChannelResultModel message) {
    throw UnimplementedError();
  }

  /// `CustomEvent` 수신 시 실행
  void onCustom(ChannelResultModel message) {
    throw UnimplementedError();
  }

  /// 방에 새 유저 접속시 실행
  void onJoinUser(ChannelResultModel message) {
    throw UnimplementedError();
  }

  /// 방에서 유저 퇴장 시 실행
  void onLeaveUser(ChannelResultModel message) {
    throw UnimplementedError();
  }

  /// 추방당할 시 실행
  void onPersonalKickUser(ChannelResultModel message) {
    throw UnimplementedError();
  }

  /// 추방 해제 시 실행
  void onPersonalUnkickUser(ChannelResultModel message) {
    throw UnimplementedError();
  }

  /// 차단당할 시 실행
  void onPersonalMuteUser(ChannelResultModel message) {
    throw UnimplementedError();
  }

  /// 차단 해제 시 실행
  void onPersonalUnmuteUser(ChannelResultModel message) {
    throw UnimplementedError();
  }

  /// 중복 로그인 시도 시 접속 유저에게 실행
  void onPersonalDuplicateUser(ChannelResultModel message) {
    throw UnimplementedError();
  }

  void onPersonalInvite(ChannelResultModel message) {
    throw UnimplementedError();
  }

  void onKickUser(ChannelResultModel message) {
    throw UnimplementedError();
  }

  void onUnkickUser(ChannelResultModel message) {
    throw UnimplementedError();
  }

  void onMuteUser(ChannelResultModel message) {
    throw UnimplementedError();
  }

  void onUnmuteUser(ChannelResultModel message) {
    throw UnimplementedError();
  }
}
