class GoogleTranslationModel {
  int resultCd;
  String resultMsg;
  String data;

  GoogleTranslationModel.fromJson(Map<String, dynamic> json)
      : resultCd = json['result_cd'],
        resultMsg = json['result_msg'],
        data = json['data'];
}
