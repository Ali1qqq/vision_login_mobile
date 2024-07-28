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
  factory InstallmentModel.fromJson(Map<String, dynamic> json) {
    return InstallmentModel(
      installmentId: json['installmentId'] ?? '',
      installmentCost: json['installmentCost'] ?? '',
      installmentDate: json['installmentDate'] ?? '',
      InstallmentImage: json['InstallmentImage'] ?? 'https://image.shutterstock.com/image-vector/dotted-spiral-vortex-royaltyfree-images-600w-2227567913.jpg',
      isPay: json['isPay'] ?? false,
      payTime: json['payTime'] ?? '',
    );
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
