import 'package:vchatcloud_flutter_sdk/model/v_chat_cloud_error.dart';

class ChannelResultModel {
  final String type;
  final String address;
  final dynamic body;
  VChatCloudError? error;

  ChannelResultModel.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        address = json['address'],
        body = json['body'];
}
