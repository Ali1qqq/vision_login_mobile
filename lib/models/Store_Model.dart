class StoreModel{
  String? id,subName,subQuantity;

bool? isAccepted;
  StoreModel({
    this.id,
    this.subName,
    this.subQuantity,
    this.isAccepted,

  });

  // fromJson method
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      subName: json['subName'],
      subQuantity: json['subQuantity'],
      isAccepted: json['isAccepted']??true,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subName': subName,
      'subQuantity': subQuantity,
      'isAccepted': isAccepted,
    };
  }

}