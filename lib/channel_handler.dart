import 'package:vchatcloud_flutter_sdk/vchatcloud_flutter_sdk.dart';

/// 해당 클래스를 상속해서 메서드를 구현해야 합니다.
abstract class ChannelHandler {
  /// 메시지 수신 시 실행
  void onMessage(ChannelMessageModel message) {
    throw UnimplementedError();
  }

  /// 귓속말 수신 시 실행
  void onWhisper(ChannelMessageModel message) {
    throw UnimplementedError();
  }

  /// 공지사항 수신 시 실행
  void onNotice(ChannelMessageModel message) {
    throw UnimplementedError();
  }

  /// `CustomEvent` 수신 시 실행
  void onCustom(ChannelMessageModel message) {
    throw UnimplementedError();
  }

  /// 방에 새 유저 접속시 실행
  void onJoinUser(ChannelMessageModel message) {
    throw UnimplementedError();
  }

  /// 방에서 유저 퇴장 시 실행
  void onLeaveUser(ChannelMessageModel message) {
    throw UnimplementedError();
  }

  /// 추방당할 시 실행
  void onPersonalKickUser(ChannelMessageModel message) {
    throw UnimplementedError();
  }

  /// 차단당할 시 실행
  void onPersonalMuteUser(ChannelMessageModel message) {
    throw UnimplementedError();
  }

  /// 차단 해제 시 실행
  void onPersonalUnmuteUser(ChannelMessageModel message) {
    throw UnimplementedError();
  }

  /// 중복 로그인 시도 시 접속 유저에게 실행
  void onPersonalDuplicateUser(ChannelMessageModel message) {
    throw UnimplementedError();
  }

  /// 채팅방에 특정 유저 초대 시 실행
  void onPersonalInvite(ChannelMessageModel message) {
    throw UnimplementedError();
  }

  /// 채팅방에서 유저 추방 시 실행
  void onKickUser(ChannelMessageModel message) {
    throw UnimplementedError();
  }

  /// 채팅방에서 유저 추방 해제 시 실행
  void onUnkickUser(ChannelMessageModel message) {
    throw UnimplementedError();
  }

  /// 채팅방에서 유저 채팅 금지 시 실행
  void onMuteUser(ChannelMessageModel message) {
    throw UnimplementedError();
  }

  /// 채팅방에서 유저 채팅 금지 해제 시 실행
  void onUnmuteUser(ChannelMessageModel message) {
    throw UnimplementedError();
  }
}
