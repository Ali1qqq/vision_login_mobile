

class ExamModel {
  String? subject,professor,id,examPassMark,examMaxMark;
  DateTime? date;
  double? passRate;
bool? isDone;
bool? isAccepted;
  List<String>? questionImage,answerImage;
Map<String,dynamic>? marks;

  ExamModel({
     this.questionImage,
     this.subject,
     this.professor,
     this.date,
     this.marks,
     this.passRate,
    this.id,
    this.answerImage,
    this.examPassMark,
    this.isAccepted,
    this.examMaxMark,
    this.isDone,

  });

  Map<String, dynamic> toJson() => {
   if(id!=null) 'id':id,
    if(examPassMark!=null)    'examPassMark':examPassMark,
    if(questionImage!=null)   'questionImage': questionImage!.toList(),
    if(subject!=null)   'subject': subject,
    if(professor!=null)    'professor': professor,
    if(date!=null)    'date': date!.toIso8601String(),
    if(marks!=null)    'marks': marks,
    if(examMaxMark!=null)     'examMaxMark': examMaxMark,
    if(isDone!=null)     'isDone': isDone,
    if(isAccepted!=null)     'isAccepted': isAccepted,
    if(answerImage!=null)    'answerImage':answerImage!.toList(),
  };

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id:json['id']??'',
      questionImage:List<String>.from(json['questionImage']??[]),
      answerImage:  List<String>.from(json['answerImage']??[]),
      passRate:0.0,
      subject: json['subject']??'',
      isDone: json['isDone']??false,
      isAccepted: json['isAccepted']??true,
      examPassMark: json['examPassMark']??'0',
      examMaxMark: json['examMaxMark']??'0',
      professor: json['professor']??'',
      date: DateTime.parse(json['date']??DateTime.now()),
      marks: json['marks']??{"":"0"},

    );
  }

  @override
  String toString() {
    return 'Exam(image: $questionImage, subject: $subject, professor: $professor, date: $date, marks: ${marks!.values.toList()}, passRate: $passRate)';
  }
}
