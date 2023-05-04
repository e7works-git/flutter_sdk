class FileModel {
  final String fileNm;
  final int fileSize;
  final String expire;
  final String fileKey;
  final String? fileSizeText;
  String? fileExt;
  final String? originFileNm;

  FileModel.fromJson(Map<String, dynamic> json)
      : fileNm = json['fileNm'],
        fileSize = json['fileSize'],
        expire = json['expire'],
        fileKey = json['fileKey'],
        fileSizeText = json['fileSizeText'],
        fileExt = json['fileExt'],
        originFileNm = json['originFileNm'] {
    fileExt ??= originFileNm?.split(".").last;
  }

  FileModel.fromHistoryJson(Map<String, dynamic> json)
      : fileKey = json["id"],
        fileNm = json["name"],
        originFileNm = json["name"],
        fileExt = json["type"],
        fileSize = json["size"],
        fileSizeText = '',
        expire = json["expire"];
}
