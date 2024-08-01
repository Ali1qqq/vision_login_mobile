class NfcCardModel {
  String? nfcId;
  String? nfcUid;
  String? userId;

  NfcCardModel({this.nfcId, this.nfcUid, this.userId});

  factory NfcCardModel.fromJson(Map<String, dynamic> json) {
    return NfcCardModel(
      nfcId: json['nfcId']??'',
      nfcUid: json['nfcUid']??'',
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nfcId': nfcId,
      'nfcUid': nfcUid,
      'userId': userId,
    };
  }


  @override
  String toString() {
    return 'NfcCardModel(nfcId: $nfcId, nfcUid: $nfcUid, nfcIsAvailable: $userId)';
  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NfcCardModel &&
        other.nfcId == nfcId &&
        other.nfcUid == nfcUid &&
        other.userId == userId;
  }

  @override
  int get hashCode => nfcId.hashCode ^ nfcUid.hashCode ^ userId.hashCode;
}
