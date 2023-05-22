import 'package:vchatcloud_flutter_sdk/vchatcloud_flutter_sdk.dart';

/// 메시지의 데이터 타입
enum MimeType {
  text('text'),
  emojiImg('emoji_img'),
  image('image'),
  video('video'),
  file('file');

  final String type;
  const MimeType(this.type);

  factory MimeType.getByCode(String? type) {
    return MimeType.values.firstWhere(
      (value) => value.type == type,
      orElse: () => MimeType.text,
    );
  }
}

/// 메시지의 종류
enum MessageType {
  join('join'),
  leave('leave'),
  notice('notice'),
  normal('normal'),
  whisper('whisper'),
  custom('custom');

  final String type;
  const MessageType(this.type);

  factory MessageType.getByCode(String? type) {
    return MessageType.values.firstWhere(
      (value) => value.type == type,
      orElse: () => MessageType.normal,
    );
  }
}

const List<String> imgTypeList = ["png", "jpg", "jpeg", "bmp"];
const List<String> videoTypeList = ["mp4", "wmv", "avi", "mkv"];

class ApiPath {
  static String get apiPath => "https://${VChatCloud.url}/api";
  static String get saveFile => "$apiPath/openapi/saveFile";
  static String get loadFile => "$apiPath/openapi/loadFile";
  static String get getFileList => "$apiPath/openapi/getFileList";
  static String get getRoomInfo => "$apiPath/openapi/roomInfo";
  static String get like => "$apiPath/openapi/like";
  static String get getOpenGraph => "$apiPath/openapi/getOepnGraph";
  static String get googleTranslate => "$apiPath/openapi/googleTranslate";
  static String get getLike => "$apiPath/openapi/getLike";
  static String get reportUser => "$apiPath/openapi/insertChatBanUser";
  ApiPath._();
}

extension ApiPathUri on String {
  Uri toUri() {
    return Uri.parse(this);
  }

  Uri addGetParam(Map<String, dynamic> param) {
    var resultPath = this;
    var paramUrl = '';
    var list = param.entries.toList();
    for (var i = 0; i < list.length; i++) {
      paramUrl += "${i == 0 ? "?" : "&"}${list[i].key}=${list[i].value}";
    }

    return Uri.parse("$resultPath$paramUrl");
  }

  Uri addPostParam(Map<String, dynamic> param) {
    return Uri.parse(this).replace(queryParameters: param);
  }
}
