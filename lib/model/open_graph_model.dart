class OpenGraphModel {
  int resultCd;

  String resultMsg;

  String title;

  String description;

  String image;

  String url;

  String host;

  String ogUrl;

  OpenGraphModel.fromJson(Map<String, dynamic> json)
      : resultCd = json['result_cd'],
        resultMsg = json['result_msg'],
        title = json['data']?['title'] ?? "",
        description = json['data']?['description'] ?? "",
        image = json['data']?['image'] ?? "",
        url = json['data']?['url'] ?? "",
        host = json['data']?['host'] ?? "",
        ogUrl = json['data']?['ogUrl'] ?? "";
}
