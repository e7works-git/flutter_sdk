class CommonResultModel {
  final bool success;
  final int resultCd;
  final String resultMsg;

  CommonResultModel.fromJson(Map<String, dynamic> json)
      : success = json["success"],
        resultCd = json["result_cd"],
        resultMsg = json["result_msg"];
}
