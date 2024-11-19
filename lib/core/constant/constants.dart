import 'package:flutter/material.dart';

import 'package:vision_dashboard/models/TimeModel.dart';
import 'package:vision_dashboard/models/account_management_model.dart';

import 'package:vision_dashboard/screens/logout/logout_View.dart';
String formatDateTimeFromString(String isoString) {
  DateTime dateTime = DateTime.parse(isoString);

  // تحديد الفترة (AM/PM)
  String period = dateTime.hour >= 12 ? "PM" : "AM";

  // تحويل الساعة إلى تنسيق 12 ساعة
  int hour = dateTime.hour % 12;
  if (hour == 0) hour = 12; // تحويل الساعة 0 إلى 12

  // تنسيق التاريخ والوقت
  String formattedDateTime = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} \n"
      "${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period";

  return formattedDateTime;
}

const primaryColor = Color(0xff3E96F4);
const secondaryColor = Color(0xffCCC7BF);
const blueColor = Color(0xffBC9F88);
const bgColor = Color(0xffF6F6F4);
//Color(0xff3d0312)CCC7BF
//Color(0xff7e0303)F6F6F4
//Color(0xffc89665) 3E96F4
const defaultPadding = 16.0;
EmployeeModel? currentEmployee;

// Map<String, String> cardsMap = {
//   "1": "04:AB:C0:21:5F:61:80",
//   "2": "04:8B:BB:F8:9F:61:80",
//   "3": "04:50:49:22:5F:61:80",
//   "4": "04:2C:E1:F3:9F:61:80",
//   "5": "04:96:CA:1D:5F:61:80",
//   "6": "04:9B:32:1F:5F:61:80",
//   "7": "04:FE:59:F5:9F:61:80",
//   "8": "04:E4:CD:1F:5F:61:80",
//   "9": "04:85:80:1E:5F:61:80",
//   "10": "04:65:17:F1:9F:61:81",
//   "11": "04:D6:EE:20:5F:61:80",
//   "12": "04:B0:EE:1F:5F:61:80",
//   "13": "04:40:0E:1F:5F:61:80",
// };



String generateId(String type) {
  var _ = DateTime.now().microsecondsSinceEpoch.toString();
  return "$type$_";
}

bool enableUpdate = true;
const String parentsCollection = 'Parents';
const String classCollection = 'Class';
const String studentCollection = 'Students';
const String storeCollection = 'Store';
const String examsCollection = 'Exams';
const String salaryCollection = 'Salaries';
const String archiveCollection = 'Archive';
const String busesCollection = 'Buses';
const String installmentCollection = 'Installment';
const String nfcCardCollection = 'NfcCards';

TimesModel? thisTimesModel;





List<String> sexList = [
  "ذكر",
  "انثى",
];
List<String> jobList = [
  "مدير",
  "سائق",
  "عامل/ه",
  "مدرس اسلامية(ابتدائي)",
  "مدرس علوم(ابتدائي)",
  "مدرس رياضيات(ابتدائي)",
  "مدرس دراسات اجتماعية(ابتدائي)",
  "مدرس Math(ابتدائي)",
  "مدرس Science(ابتدائي)",
  "مدرس عربي(ابتدائي)",
  "مدرس عربي",
  "مدرس اسلامية",
  "مدرس علوم",
  "مدرس رياضيات",
  "مدرس دراسات اجتماعية",
  "مدرس فيزياء",
  "مدرس كيمياء",
  "مدرس أحياء",
  "مدرس تاريخ",
  "مدرس جغرافيا",
  "مدرس فلسفة",
  "مدرس Math",
  "مدرس Science",
  "مدرس Chemistry",
  "مدرس Physics",
  "مدرس Biology",
  "مدرس لغة أجنبية",
  "مدرس لغة فرنسية",
  "مدرس لغة المانية",
];

List<({String name, String img, Widget widget})> allData =  [

  (
  name: "تسجيل الخروج",
  img: "assets/dashIcon/logout.png",
  widget: LogoutView(),
  ),
];

initDashboard(List<({String name, String img, Widget widget})> ourData){
  allData =ourData;
}
List<String> contractsList = ['دوام جزئي', 'دوام كلي', 'اون لاين'];
List<String> languageList = [
  "عربي",
  "لغات",
];
List<String> year=List.generate(50, (index) => "20${24+index}",);
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

enum waitingListTypes { delete, returnInstallment, waitDiscounts, add, edite }
enum TimeName { LateTime, AppendTime, OutTime, FriLateTime, FriAppendTime, FriOutTime,}

const accountManagementCollection = "AccountManagement";
