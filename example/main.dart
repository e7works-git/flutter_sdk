import 'package:vchatcloud_flutter_sdk/vchatcloud_flutter_sdk.dart';

// Extends ChannelHandler to implement method
class CustomHandler extends ChannelHandler {
  @override
  void onMessage(ChannelMessageModel message) {
    // Write your code..
  }
}

void main() async {
  // connect VChatCloud server
  var channel = await VChatCloud.connect(CustomHandler());
  // join chat room and return chat history
  await channel.join(UserModel(
    roomId: "YOUR_CHANNEL_KEY",
    nickName: 'USER_NICKNAME',
    // userInfo: {"profile": "2"} >> use index 2 profile image
    userInfo: {"profile": "PROFILE_IMAGE_INDEX"},
    clientKey: "USER_UNIQUE_CLIENT_KEY", // not required
  ));
  // send your message
  channel.sendMessage("hello world!");
}
