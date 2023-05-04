import 'dart:io';

import 'package:vchatcloud_flutter_sdk/util.dart';

class UploadFileModel {
  final File? file;
  final List<int>? bytes;
  late final String name;

  bool get isFile => file != null;
  bool get isByte => file == null && bytes != null;
  Future<int> get size async =>
      isFile ? (await file!.stat()).size : bytes!.length;

  UploadFileModel({this.file, this.bytes, String? name}) {
    if (file == null && bytes == null) {
      throw ArgumentError("file or bytes argument is required");
    }
    if ((file?.path.split(Util.pathSeparator).last ?? name) == null) {
      throw ArgumentError.notNull("name");
    } else {
      this.name = file?.path.split(Util.pathSeparator).last ?? name!;
    }
  }
}
