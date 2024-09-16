class InstallmentModel {
  String? installmentId;
  String? installmentCost;
  String? installmentDate;
  String? InstallmentImage;
  String? payTime;
  bool? isPay;

  InstallmentModel({
    this.installmentId,
    this.installmentCost,
    this.installmentDate,
    this.isPay,
    this.payTime,
    this.InstallmentImage,
  });

  // fromJson method
  InstallmentModel.fromJson(Map<String, dynamic> json) {
    installmentId = json['installmentId'] ?? '';
    installmentCost = json['installmentCost'] ?? '';
    installmentDate = json['installmentDate'] ?? '';
    InstallmentImage = json['InstallmentImage'] ?? '';
    isPay = json['isPay'] ?? false;
    payTime = json['payTime'] ?? '';
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'installmentId': installmentId,
      'installmentCost': installmentCost,
      'installmentDate': installmentDate,
      'InstallmentImage': InstallmentImage,
      'isPay': isPay,
      'payTime': payTime,
    };
  }

  // toString method
  @override
  String toString() {
    return 'InstallmentModel{installmentId: $installmentId, installmentCost: $installmentCost, installmentDate: $installmentDate , isPay: $isPay}';
  }
}
