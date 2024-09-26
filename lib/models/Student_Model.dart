
import 'event_record_model.dart';

class StudentModel {
  String? studentName,
      studentID,
      gender,
      StudentBirthDay,
      stdLanguage,
      parentId,
      startDate,
      endDate,

      stdClass;
  String? studentNumber;
  double? grade;
  List<String>? stdExam, contractsImage;

  bool? available = false, isAccepted;

  List<EventRecordModel>? eventRecords;
  String? bus;

  // String? guardian;

  StudentModel({
    this.studentName,
    this.studentNumber,
    this.studentID,
    this.stdExam,
    this.gender,
    this.StudentBirthDay,
    this.grade,
    this.startDate,
    this.endDate,
    this.eventRecords,
    this.bus,
    this.parentId,
    this.available,
    this.isAccepted,
    this.stdClass,
    this.stdLanguage,
    this.contractsImage,
  });

  Map<String, dynamic> toJson() => {
        if (studentName != null) 'studentName': studentName,
        if (studentNumber != null) 'studentNumber': studentNumber,
        if (studentID != null) 'studentID': studentID,
        if (gender != null) 'gender': gender,
        if (StudentBirthDay != null) 'StudentBirthDay': StudentBirthDay,
        if (stdClass != null) 'stdClass': stdClass,
        if (grade != null) 'grade': grade,
        if (stdLanguage != null) 'stdLanguage': stdLanguage,
        if (stdExam != null) 'stdExam': stdExam,
        if (isAccepted != null) 'isAccepted': isAccepted,
        if (startDate != null) 'startDate': startDate!,
        if (endDate != null) 'endDate': endDate!,
        if (contractsImage != null) 'contractsImage': contractsImage!,
        if (eventRecords != null)
          'eventRecords': eventRecords!.map((event) => event.toJson()).toList(),

        if (parentId != null) 'parentId': parentId!,
        if (bus != null) 'bus': bus,
      };

  StudentModel.fromJson(Map<String, dynamic> json) {
    grade = json['grade'] != null ?double.parse(json['grade'].toString()):0.0;
    studentName = json['studentName'] ?? '';
    studentNumber = json['studentNumber'] ?? '';
    studentID = json['studentID'] ?? '';
    parentId = json['parentId'] ?? '';
    isAccepted = json['isAccepted'] ?? true;
    contractsImage = List.from(json['contractsImage'] ?? []);
    stdLanguage = json['stdLanguage'] ?? '';
    stdExam = (json['stdExam'] as List<dynamic>?)
            ?.map((item) => item as String)
            .toList() ??
        [];
    stdClass = json['stdClass'] ?? '';
    gender = json['gender'] ?? '';
    StudentBirthDay = json['StudentBirthDay'] ?? '';
    startDate = json['startDate'] ?? '';
    endDate = json['endDate'] ?? '';
    eventRecords = (json['eventRecords'] as List<dynamic>?)
        ?.map((event) => EventRecordModel.fromJson(event))
        .toList()
      ?..sort((a, b) {
        // افترض أن لديك حقل `date` في `EventRecordModel`
        DateTime dateA = DateTime.parse(a.date); // استبدل `date` بالحقل المناسب
        DateTime dateB = DateTime.parse(b.date); // استبدل `date` بالحقل المناسب
        return dateA.compareTo(dateB); // ترتيب تصاعدي
      });
    bus = json['bus'] ?? '';
    available = false;
  }

  @override
  String toString() {
    return 'Student(studentName: $studentName, studentNumber: $studentNumber, address: address, isAccepted: $isAccepted, gender: $gender, age: $StudentBirthDay, grade: $grade, teachers: teachers, exams: exams, startDate: $startDate,, eventRecords: $eventRecords, bus: $bus, )';
  }
}
