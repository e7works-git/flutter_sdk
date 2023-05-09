import 'package:flutter/foundation.dart';
import 'package:vchatcloud_flutter_sdk/vchatcloud_flutter_sdk.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// `VChatCloud.connect()` 실행으로 초기화
///
/// 실행 후 `socket` 객체를 반환하는데 `Channel`클래스를 상속받아 새 클래스를 만들어야 한다.
///
/// 예시 코드:
/// ```
/// class CustomHandler extends ChannelHandler {
///   ...
/// }
///
/// void main() async {
///   var channel = await VChatCloud.connect(CustomHandler());
///   await channel.join(...);
/// }
/// ```
class VChatCloud {
  static late WebSocketChannel _socket;
  static late Channel _channel;
  static String url = 'vchatcloud.com';
  static bool _isInitialized = false;

  VChatCloud._();

  /// 초기 실행
  static Future<Channel> connect(
    ChannelHandler channelHandler, {
    String? url,
  }) async {
    if (url != null) {
      VChatCloud.url = url;
    }
    if (_isInitialized && _socket.closeCode == null) {
      return _channel;
    }

    final uri = Uri.parse("wss://${VChatCloud.url}:9001/eventbus/websocket");
    _socket = WebSocketChannel.connect(uri);
    await _socket.ready;

    _channel = Channel(_socket, channelHandler);
    _isInitialized = true;
    return _channel;
  }

  static disconnect() async {
    try {
      _channel.leave();
      _socket.sink.close();
    } catch (e) {
      if (e is Error) {
        debugPrintStack(label: e.toString(), stackTrace: e.stackTrace);
      }
    } finally {
      _isInitialized = false;
    }
  }
}
