import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vision_dashboard/models/TimeModel.dart';

const primaryColor = Color(0xff3E96F4);
const secondaryColor = Color(0xffCCC7BF);
const blueColor = Color(0xffBC9F88);
const bgColor = Color(0xffF6F6F4); // تخفيف لون الخلفية
//Color(0xff3d0312)CCC7BF
//Color(0xff7e0303)F6F6F4
//Color(0xffc89665) 3E96F4
const defaultPadding = 16.0;


List<String> employeeName = [
  "",
  'أحمد الأيوبي',
  'محمد الأسدي',
  'علي البغدادي',
  'حسين الكرمي',
  'عمر النجار',
  'يوسف الراوي',
  'إبراهيم الحسيني',
  'خالد الزبيدي',
  'عبدالله العطار',
  'سعيد الحداد',
  'طارق البصري',
  'ياسر الزهراني',
  'سامي الشمري',
  'ماجد القيسي',
  'عماد السعدي',
  'فهد العتيبي',
  'سليمان الجبوري',
  'أنس الفارسي',
  'بسام الزهيري',
  'جمال التميمي',
  'هيثم الهاشمي',
  'رامي الشميري',
  'نادر العدني',
  ''
];

String generateId(String type) {
  var _ = thisTimesModel!.dateTime.microsecondsSinceEpoch.toString();
  return "$type$_";
}
bool enableUpdate=true;
const String parentsCollection = 'Parents';
const String classCollection = 'Class';
const String studentCollection = 'Students';
const String storeCollection = 'Store';
const String examsCollection = 'Exams';
const String salaryCollection = 'Salaries';
const String archiveCollection = 'Archive';
const String busesCollection = 'Buses';
const String installmentCollection = 'Installment';
TimesModel? thisTimesModel;

List<String> classNameList = [
  "KG 1",
  "KG 2",
  "Grade 1",
  "Grade 2",
  "Grade 3",
  "Grade 4",
  "Grade 5",
  "Grade 6",
  "Grade 7",
  "Grade 8",
  "Grade 9",
  "Grade 10",
  "Grade 11",
];
List<String> sexList = [
  "ذكر",
  "انثى",
];
List<String> jobList = [
  "مدرس/ه",
  "مدير/ه",
  "موظف/ه اداري/ه",
  "سائق",
];

List<String> contractsList = ['دوام جزئي', 'دوام كلي', 'اون لاين'];
List<String> languageList = [
  "عربي",
  "لغات",
];


Map<String, String> months = {
  "يناير (1)": "01",
  "فبراير (2)": "02",
  "مارس (3)": "03",
  "أبريل (4)": "04",
  "مايو (5)": "05",
  "يونيو (6)": "06",
  "يوليو (7)": "07",
  "أغسطس (8)": "08",
  "سبتمبر (9)": "09",
  "أكتوبر (10)": "10",
  "نوفمبر (11)": "11",
  "ديسمبر (12)": "12",
};

enum waitingListTypes{
  delete,returnInstallment,waitDiscounts,add,edite
}

 const accountManagementCollection = "AccountManagement";
class Styles {
  static Color textColor = primaryColor;

  static TextStyle textStyle = GoogleFonts.cairo(
      color: textColor, fontSize: 16, fontWeight: FontWeight.w500);

  static TextStyle headLineStyle1 = GoogleFonts.cairo(
      fontSize: 26, color: textColor, fontWeight: FontWeight.bold);

  static TextStyle headLineStyle2 = GoogleFonts.cairo(
      fontSize: 21, color: textColor, fontWeight: FontWeight.bold);

  static TextStyle headLineStyle3 = GoogleFonts.cairo(
      fontSize: 17, color: Colors.grey.shade500, fontWeight: FontWeight.w500);

  static TextStyle headLineStyle4 = GoogleFonts.cairo(
      fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w500);
}

/*
import 'package:flutter/material.dart';

const primaryColor = Color(0xffc89665);
const secondaryColor = Color(0xff3d0312);
const bgColor = Color(0xff7e0303);
//Color(0xff3d0312)
//Color(0xff7e0303)
//Color(0xffc89665)
const defaultPadding = 16.0;
*/
