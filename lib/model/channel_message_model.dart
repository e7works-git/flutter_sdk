import 'dart:convert';

import 'package:vchatcloud_flutter_sdk/vchatcloud_flutter_sdk.dart';

class ChannelMessageModel {
  /// 받은 메시지 (보통은 String 또는 Json)
  dynamic message;

  /// 닉네임
  String? nickName;

  /// 사용자의 client key (unique 값)
  final String? clientKey;

  /// 채팅방 channel key
  final String? roomId;

  /// `MimeType`
  final MimeType? mimeType;

  /// `MessageType`
  final MessageType? messageType;

  /// YYYYMMDDHH24MISS 포맷
  late final DateTime messageDt;

  /// 사용자 정보(json)
  final dynamic userInfo;

  VChatCloudError? error;

  ChannelMessageModel.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        nickName = json['nickName'],
        clientKey = json['clientKey'],
        roomId = json['roomId'],
        mimeType = MimeType.getByCode(json['mimeType']),
        messageType = json['messageType'] is MessageType
            ? json['messageType']
            : MessageType.getByCode(json['messageType']),
        userInfo = json['userInfo'] is String
            ? jsonDecode(json['userInfo'])
            : json['userInfo'] {
    if (json['messageDt'] != null) {
      var date = json['messageDt'];
      if (date is DateTime) {
        messageDt = date;
      } else if (date is int) {
        messageDt =
            DateTime.fromMillisecondsSinceEpoch(date, isUtc: true).toLocal();
      } else if (date is String) {
        messageDt = DateTime.utc(
          int.parse(date.substring(0, 4)),
          int.parse(date.substring(4, 6)),
          int.parse(date.substring(6, 8)),
          int.parse(date.substring(8, 10)),
          int.parse(date.substring(10, 12)),
          int.parse(date.substring(12, 14)),
        ).subtract(serverTimezoneOffset).toLocal();
      }
    } else if (json['date'] is String) {
      String date = json['date'];
      messageDt = DateTime.utc(
        int.parse(date.substring(0, 4)),
        int.parse(date.substring(5, 7)),
        int.parse(date.substring(8, 10)),
        int.parse(date.substring(11, 13)),
        int.parse(date.substring(14, 16)),
        int.parse(date.substring(17, 19)),
      ).subtract(serverTimezoneOffset).toLocal();
    } else {
      messageDt = DateTime.now().toLocal();
    }
  }

  ChannelMessageModel.fromError(this.error)
      : clientKey = null,
        messageType = null,
        mimeType = null,
        roomId = null,
        userInfo = null;
}
