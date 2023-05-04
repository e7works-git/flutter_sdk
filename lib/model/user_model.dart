import 'package:vchatcloud_flutter_sdk/util.dart';

class UserModel {
  final String roomId;
  late String clientKey;
  final String nickName;
  late String grade;
  final dynamic userInfo;

  UserModel({
    required this.roomId,
    required this.nickName,
    String? clientKey,
    String? grade,
    this.userInfo,
  }) {
    this.clientKey = clientKey ?? Util.getRandomString(10);
    this.grade = grade ?? 'user';
  }

  UserModel.fromJson(Map<String, dynamic> json)
      : roomId = json["roomId"],
        nickName = json["nickName"],
        clientKey = json["clientKey"],
        grade = json["grade"],
        userInfo = json["userInfo"];
}
