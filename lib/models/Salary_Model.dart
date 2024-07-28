class SalaryModel{
  String? salaryId,employeeId,constSalary,dilaySalary,paySalary,signImage;

  SalaryModel({
    this.salaryId,
    this.employeeId,
    this.constSalary,
    this.dilaySalary,
    this.paySalary,
    this.signImage,

  });

  // fromJson method
  factory SalaryModel.fromJson(Map<String, dynamic> json) {
    return SalaryModel(
      salaryId: json['salaryId']??"0" ,
      employeeId: json['employeeId'] ??"0",
      constSalary: json['constSalary'] ??"0",
      dilaySalary: json['dilaySalary']??"0" ,
      paySalary: double.parse(json['paySalary']??"0").round().toString(),
      signImage: json['signImage']??"0",
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'salaryId': salaryId,
      'employeeId': employeeId,
      'constSalary': constSalary,
      'dilaySalary': dilaySalary,
      'paySalary': paySalary,
      'signImage': signImage,
    };
  }

  // toString method
  @override
  String toString() {
    return 'SalaryModel{salaryId: $salaryId, employeeId: $employeeId, constSalary: $constSalary, dilaySalary: $dilaySalary, paySalary: $paySalary}';
  }
}
