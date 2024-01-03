import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:vchatcloud_flutter_sdk/vchatcloud_flutter_sdk.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Channel {
  WebSocketChannel _client;
  final ChannelHandler _handler;
  StreamSubscription? _subscription;
  Completer<ChannelResultModel>? _joined;
  Completer<List<UserModel>>? _clientList;
  Function(ChannelResultModel)? _callback;
  Timer? _pingTimer;

  UserModel? user;
  VChatCloudResult? _finalDisconnectResult;

  get roomId {
    return user?.roomId;
  }

  set globalCallback(Function(ChannelResultModel) callback) {
    _callback = callback;
  }

  Channel(this._client, this._handler) {
    _eventInit();
  }

  Channel _eventInit() {
    if (_subscription != null) return this;
    _subscription = _client.stream.listen(
      (event) {
        var data = _decode(event);
        ChannelMessageModel message;
        if (data.type == 'err' && data.error != null) {
          message = ChannelMessageModel.fromError(data.error!);
        } else {
          message = ChannelMessageModel.fromJson(data.body)..error = data.error;
        }

        // 첫 조인 시 히스토리 수신
        if (data.address == "join_user_init" && _joined != null) {
          if (data.error == null) {
            _joined!.complete(data);
          } else {
            _joined!.completeError(data.error!);
          }
        }
        if (data.address == "client_user_list" && _clientList != null) {
          try {
            var clientList = (data.body["clientlist"] as List<dynamic>)
                .map((data) => UserModel.fromJson(data as Map<String, dynamic>))
                .toList();
            _clientList!.complete(clientList);
          } catch (e) {
            if (e is Error) {
              debugPrintStack(label: e.toString(), stackTrace: e.stackTrace);
            }
            _clientList!.completeError(
              data.error ??
                  VChatCloudError.fromResult(VChatCloudResult.systemError),
            );
          }
        }
        if (data.address == "s2c.notify.message/$roomId") {
          _handler.onMessage(message);
        }
        if (data.address.startsWith("s2c.personal.whisper/$roomId")) {
          _handler.onWhisper(message);
        }
        if (data.address == "s2c.notify.notice/$roomId") {
          _handler.onNotice(message);
        }
        if (data.address == "s2c.notify.custom/$roomId") {
          _handler.onCustom(message);
        }
        if (data.address == "s2c.notify.join.user/$roomId") {
          _handler.onJoinUser(message);
        }
        if (data.address == "s2c.notify.leave.user/$roomId") {
          _handler.onLeaveUser(message);
        }
        if (data.address == "s2c.notify.kick.user/$roomId") {
          _handler.onKickUser(message);
        }
        if (data.address == "s2c.notify.unkick.user/$roomId") {
          _handler.onUnkickUser(message);
        }
        if (data.address == "s2c.notify.mute.user/$roomId") {
          _handler.onMuteUser(message);
        }
        if (data.address == "s2c.notify.unmute.user/$roomId") {
          _handler.onUnmuteUser(message);
        }
        if (data.address.startsWith("s2c.personal.duplicate.user/$roomId")) {
          _handler.onPersonalDuplicateUser(message);
        }
        if (data.address.startsWith("s2c.personal.invite/$roomId")) {
          _handler.onPersonalInvite(message);
        }
        if (data.address.startsWith("s2c.personal.kick.user/$roomId")) {
          _handler.onPersonalKickUser(message);
        }
        if (data.address.startsWith("s2c.personal.mute.user/$roomId")) {
          _handler.onMuteUser(message);
        }
        if (data.address.startsWith("s2c.personal.unmute.user/$roomId")) {
          _handler.onUnmuteUser(message);
        }

        if (_callback != null) {
          _callback!(data);
        }
      },
      onError: (e) {},
      onDone: () async {
        _pingTimer?.cancel();

        if (_finalDisconnectResult == VChatCloudResult.channelUserBaned) {
          // dispose(_finalDisconnectResult!);
          return;
        }
        if (_finalDisconnectResult == null) {
          await _reconnect();
          if (user != null && _client.closeCode != 3000) {
            _subscription = null;
            try {
              _eventInit();
              await join(user!);
            } catch (e) {
              _pingTimer?.cancel();
              if (e is VChatCloudError) {
                _finalDisconnectResult = VChatCloudResult.fromCode(e.code);
                if (_finalDisconnectResult ==
                    VChatCloudResult.channelUserBaned) {
                  dispose(VChatCloudResult.userBannedByAdmin);
                } else {
                  dispose(_finalDisconnectResult!);
                }
              }
            }
          }
        }
      },
    );

    _pingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      try {
        if (_client.closeReason == null) {
          _send({"type": "ping"});
        } else {
          timer.cancel();
          dispose(VChatCloudResult.systemError);
        }
      } catch (e) {
        timer.cancel();
        dispose(VChatCloudResult.systemError);
      }
    });

    return this;
  }

  /// 접속유저 목록 조회
  Future<List<UserModel>> requestClientList() async {
    _clientList = Completer();
    _send({
      "type": "send",
      "address": "c2s.clientlist",
      "headers": {},
      "body": {
        "roomId": roomId,
      },
      "replyAddress": "client_user_list",
    });

    var result = await _clientList!.future;
    _clientList = null;
    return result;
  }

  /// 메시지 발송
  Channel sendMessage(
    String message, {
    MimeType mimeType = MimeType.text,
  }) {
    _send({
      "type": "send",
      "address": "c2s.send.message",
      "headers": {},
      "body": {
        "nickName": user?.nickName,
        "roomId": roomId,
        "clientKey": user?.clientKey,
        "message": message,
        "mimeType": mimeType.type,
      },
    });

    return this;
  }

  /// 이모지 발송
  Channel sendEmoji(
    String message, {
    MimeType mimeType = MimeType.emojiImg,
  }) {
    _send({
      "type": "send",
      "address": "c2s.send.message",
      "headers": {},
      "body": {
        "nickName": user?.nickName,
        "roomId": roomId,
        "clientKey": user?.clientKey,
        "message": message,
        "mimeType": mimeType.type,
      },
    });

    return this;
  }

  /// 공지사항 발송
  Channel sendNotice(
    String message, {
    MimeType mimeType = MimeType.text,
    dynamic userInfo,
  }) {
    _send({
      "type": "send",
      "address": "c2s.send.message",
      "headers": {},
      "body": {
        "nickName": user?.nickName,
        "roomId": roomId,
        "clientKey": user?.clientKey,
        "message": message,
        "messageType": "notice",
        "mimeType": mimeType.type,
      },
    });

    return this;
  }

  /// 귓속말 발송
  Channel sendWhisper(
    String message, {
    required String receivedClientKey,
    MimeType mimeType = MimeType.text,
  }) {
    _send({
      "type": "send",
      "address": "c2s.whisper.message",
      "headers": {},
      "body": {
        "roomId": roomId,
        "receivedClientKey": receivedClientKey,
        "clientKey": user?.clientKey,
        "nickName": user?.nickName,
        "message": message,
        "mimeType": mimeType.type,
      },
    });

    return this;
  }

  /// 커스텀 이벤트 발송
  Channel sendCustom(String message) {
    _send({
      "type": "send",
      "address": "c2s.sendcustom",
      "headers": {},
      "body": {
        "nickName": user?.nickName,
        "roomId": roomId,
        "clientKey": user?.clientKey,
        "message": message,
        "mimeType": MimeType.text.type,
      },
    });

    return this;
  }

  /// 파일 전송
  Future<Channel> sendFile(UploadFileModel file) async {
    /// 파일 업로드 크기 제한 = 100MB
    const fileSizeLimit = 100 * 1024 * 1024;

    var uri = ApiPath.saveFile.toUri();
    var request = MultipartRequest('POST', uri);

    var ext = file.name.split(".").last;
    if (ext.length > 5) {
      throw VChatCloudError.fromResult(VChatCloudResult.incorrectRequest,
          message: "지원하지 않는 확장자입니다.");
    }
    if (await file.size > fileSizeLimit) {
      throw VChatCloudError.fromResult(VChatCloudResult.incorrectRequest,
          message: "파일 업로드 제한 100MB를 초과하였습니다.");
    }

    request.fields['roomId'] = roomId;
    if (kIsWeb && file.isByte) {
      request.files.add(
        MultipartFile.fromBytes("file", file.bytes!, filename: file.name),
      );
    } else if (file.isFile) {
      request.files.add(await MultipartFile.fromPath(
        "file",
        file.file!.path,
        filename: file.name,
      ));
    }

    var response = await request.send();
    var byteJson = await response.stream.bytesToString();
    var uploadFile = FileModel.fromJson(json.decode(byteJson)['data']);

    _send({
      "type": "send",
      "address": "c2s.send.message",
      "headers": {},
      "body": {
        "roomId": roomId,
        "nickName": user?.nickName,
        "clientKey": user?.clientKey,
        "mimeType": MimeType.file.type,
        "grade": user?.grade,
        "message": json.encode([
          {
            "id": uploadFile.fileKey,
            "name": uploadFile.fileNm,
            "type": uploadFile.fileExt,
            "size": uploadFile.fileSize,
            "expire": uploadFile.expire,
          }
        ]),
        "messageType": json.encode(user?.userInfo),
        "replyAddress": null,
      },
    });

    return this;
  }

  /// 방 접속
  Future<ChannelResultModel> join(UserModel user) async {
    if (_joined != null && _joined!.isCompleted) {
      throw VChatCloudError.fromResult(VChatCloudResult.alreadyInConnection);
    }

    try {
      this.user = user;
      _joined = Completer();

      _eventInit();

      _send({
        "type": "send",
        "address": "c2s.join",
        "headers": {},
        "body": {
          "roomId": roomId,
          "clientKey": user.clientKey,
          "nickName": user.nickName,
          "grade": user.grade,
          "userInfo": user.userInfo,
        },
        "replyAddress": "join_user_init"
      });

      // 방 조인 대기
      var history = await _joined!.future;

      return history;
    } catch (e) {
      if (e is VChatCloudError) {
        _finalDisconnectResult = VChatCloudResult.fromCode(e.code);
      }
      rethrow;
    } finally {
      _joined = null;
    }
  }

  /// 방 퇴장
  Channel leave() {
    _send({
      "type": "send",
      "address": "c2s.leave",
      "headers": {},
      "body": {
        "roomId": roomId,
        "clientKey": user?.clientKey,
      },
    });

    return this;
  }

  void dispose(VChatCloudResult result) async {
    if (_client.closeCode == null && _client.closeReason == null) {
      try {
        leave();
      } catch (e) {
        if (e is StateError && e.message == "Cannot add event after closing.") {
          // pass;
        }
      }
      _client.sink.close(3000);
    }
    _pingTimer?.cancel();
    _subscription?.cancel();
    _handler.onDisconnect(result);
  }

  ChannelResultModel _decode(dynamic message) {
    var text = utf8.decode(message);
    var decodedJson = json.decode(text);

    return ChannelResultModel.fromJson(decodedJson)
      ..error = decodedJson['failureCode'] != null
          ? VChatCloudError.fromCode(decodedJson['failureCode'])
          : null;
  }

  void _send(dynamic message) {
    try {
      if (_client.closeReason == null) {
        _client.sink.add(json.encode(message));
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> _reconnect() async {
    final uri = Uri.parse("wss://${VChatCloud.url}:9001/eventbus/websocket");
    _client = WebSocketChannel.connect(uri);
    await _client.ready;
  }
}
