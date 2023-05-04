# [VChatCloud](https://vchatcloud.com) Flutter SDK

[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)  
![Languages](https://img.shields.io/badge/language-DART-informational)  
![Platform](https://img.shields.io/badge/platform-ANDROID-informational)
![Platform](https://img.shields.io/badge/IOS-informational)
![Platform](https://img.shields.io/badge/MAC-informational)
![Platform](https://img.shields.io/badge/WINDOW-informational)
![Platform](https://img.shields.io/badge/WEB-informational)
![Platform](https://img.shields.io/badge/LINUX-informational)


## Usage

Add vchatcloud_flutter_sdk as a dependency in your pubspec.yaml file.

```
import 'package:vchatcloud_flutter_sdk/vchatcloud_flutter_sdk.dart';

class CustomHandler extends ChannelHandler {
  ...
}

void main() async {
  Channel channel = await VChatCloud.connect(CustomHandler());
  List<ChannelResultModel> history = await channel.join(...);
  channel.sendMessage("Hello VChatCloud!");
}
```

A more detailed usage guide is available on the [VChatCloud Docs](https://vchatcloud.com/doc/flutter/).
