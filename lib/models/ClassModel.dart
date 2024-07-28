class ClassModel {
  String? className;
  String? classId;
  bool? isAccepted;



  ClassModel({this.className, this.classId,this.isAccepted });


  ClassModel.fromJson(Map<String, dynamic> json) {
    className = json['className']??'';
    classId = json['classId']??'';
    isAccepted = json['isAccepted']??true;
  }


  Map<String, dynamic> toJson() {
    return {
      'className': className,
      'classId': classId,
      'isAccepted': isAccepted,
    };
  }

  // toString: A method that returns a string representation of an instance
  @override
  String toString() {
    return 'ClassModel(className: $className, classId: $classId,  )';
  }
}