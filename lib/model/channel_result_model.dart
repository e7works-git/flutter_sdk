import 'package:vchatcloud_flutter_sdk/vchatcloud_flutter_sdk.dart';

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
