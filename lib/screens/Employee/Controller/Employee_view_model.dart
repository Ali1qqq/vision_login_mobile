import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';
import 'package:vision_dashboard/core/constant/const.dart';

import 'package:vision_dashboard/models/Salary_Model.dart';
import 'package:vision_dashboard/models/employee_time_model.dart';
import 'package:vision_dashboard/core/router/router.dart';
import 'package:vision_dashboard/screens/Buses/Controller/Bus_View_Model.dart';

import 'package:vision_dashboard/screens/Salary/controller/Salary_View_Model.dart';

import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Text_Filed.dart';
import 'package:vision_dashboard/core/dialogs/Dialogs.dart';
import 'package:vision_dashboard/screens/expenses/Controller/expenses_view_model.dart';

import '../../../controller/nfc/non_web.dart';
import '../../../core/constant/constants.dart';
import '../../../controller/NFC_Card_View_model.dart';
import '../../../core/Utils/service.dart';
import '../../../models/TimeModel.dart';
import '../../../models/account_management_model.dart';
import '../../../models/event_model.dart';
import '../../../models/event_record_model.dart';
import '../../../core/Utils/Hive_DataBase.dart';
import '../../../core/Utils/To_AR.dart';
import '../../Buses/Buses_View.dart';
import '../../Parents/Parents_View.dart';
import '../../Salary/SalaryView.dart';
import '../../Settings/Controller/Settings_View_Model.dart';
import '../../Settings/Setting_View.dart';
import '../../Store/Store_View.dart';
import '../../Student/Student_view_Screen.dart';
import '../../Study Fees/Study_Fees_View.dart';
import '../../classes/classes_view.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../employee_time/employee_time.dart';
import '../../event/event_view_screen.dart';
import '../../expenses/expenses_view_screen.dart';
import '../../logout/logout_View.dart';
import '../Edite_Add_Employee/Employee_user_details.dart';
import '../Employee_View.dart';

enum UserManagementStatus {
  first,
  login,
  block,
  auth,
}

enum typeNFC { login, time, add }

Map accountType = {
  "user": "مستخدم".tr,
  "admin": "مدير".tr,
  "superAdmin": "مالك".tr,
};

class EmployeeViewModel extends GetxController {
  final fullNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final addressController = TextEditingController();
  final nationalityController = TextEditingController();
  final genderController = TextEditingController();
  final ageController = TextEditingController();
  final jobTitleController = TextEditingController();
  final salaryController = TextEditingController();
  final contractController = TextEditingController();
  final busController = TextEditingController();
  final startDateController = TextEditingController();
  final eventController = TextEditingController();
  final bodyEvent = TextEditingController();
  final dayWorkController = TextEditingController();
  final editController = TextEditingController();
  final userNameController = TextEditingController();
  final userPassController = TextEditingController();
  double imageHeight = 150;
  double imageWidth = 150;
  String? userName;
  String? password;
  String? serialNFC;
  EmployeeModel? myUserModel;

  /// we use this for fold Screen
  bool isAdd = false;

  /// current row selected
  String currentId = '';

  /// card id selected
  String selectedCardId = '';

  /// bus id selected
  String busValue = '';

  /// user role selected
  String role = '';

  /// event selected when add event
  EventModel? selectedEvent = null;

  /// previous events
  List<EventRecordModel> eventRecords = [];

  /// Edite Employee model
  EmployeeModel? employeeModel = null;

  /// we need this for Refresh pluto grid
  GlobalKey plutoKey = GlobalKey();
  String? loginUserPage;
  NfcCardViewModel nfcCardViewModel = Get.find<NfcCardViewModel>();
  bool isLogIn = true;

  bool startAddTime = true;

  /// we use this for cancel listener
  late StreamSubscription<QuerySnapshot<EmployeeModel>> listener;
  Color selectedColor = secondaryColor;

  /// when scan NFC Card
  TextEditingController nfcController = TextEditingController();

  /// we use this in Employee time
  bool isLoading = false;

  /// we use this in Employee time when expand employee time details
  List<bool> isOpen = [];

  ///pluto header
  List<PlutoColumn> columns = [];

  /// this for image already have in Edite Expenses model
  List imageLinkList = [];

  /// this for image upload from user (we save it temporary before we upload it )
  List<Uint8List> imagesTempData = [];

  /// pluto data
  List<PlutoRow> rows = [];

  bool isSupportNfc = false;

  bool enableEdit = false;
  RxMap<String, EmployeeModel> allAccountManagement = <String, EmployeeModel>{}.obs;
  final accountManagementFireStore = FirebaseFirestore.instance.collection(accountManagementCollection).withConverter<EmployeeModel>(
        fromFirestore: (snapshot, _) => EmployeeModel.fromJson(snapshot.data()!),
        toFirestore: (account, _) => account.toJson(),
      );
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final settingFireStore = FirebaseFirestore.instance.collection(Const.settingsCollection);

  Map<String, PlutoColumnType> data = {
    "الرقم التسلسلي": PlutoColumnType.text(),
    "اسم المستخدم": PlutoColumnType.text(),
    "الاسم الكامل": PlutoColumnType.text(),
    "كامة السر": PlutoColumnType.text(),
    "الدور": PlutoColumnType.text(),
    "الحالة": PlutoColumnType.text(),
    "رقم الموبايل": PlutoColumnType.text(),
    "العنوان": PlutoColumnType.text(),
    "الجنسية": PlutoColumnType.text(),
    "الجنس": PlutoColumnType.text(),
    "العمر": PlutoColumnType.text(),
    "الوظيفة": PlutoColumnType.text(),
    "العقد": PlutoColumnType.text(),
    "الحافلة": PlutoColumnType.text(),
    "تاريخ البداية": PlutoColumnType.text(),
    "سجل الاحداث": PlutoColumnType.text(),
    "موافقة المدير": PlutoColumnType.text(),
  };

  EmployeeViewModel() {
    getColumns();
    if (currentEmployee?.id != null) getAllEmployee();
    getScreens();
    Future.delayed(Duration(seconds: 2), () {
      Get.find<ExpensesViewModel>().getAllWitOutListenExpenses();
    });
  }

  bool getIfDelete() {
    return checkIfPendingDelete(affectedId: currentId);
  }

  /// Refresh pluto header when change language
  getColumns() {
    columns.clear();

    columns.addAll(toAR(data));
  }

  getAllEmployee() {
    listener = accountManagementFireStore.snapshots().listen(
      (event) async {
        isLoading = false;
        update();
        await Get.find<BusViewModel>().getAllWithoutListenBuse();
        selectedColor = secondaryColor;
        plutoKey = GlobalKey();
        rows.clear();
        int index = 4;
        allAccountManagement = Map<String, EmployeeModel>.fromEntries(event.docs.toList().map((i) {
          if (currentEmployee!.type != 'مالك') {
            if (i.data().type == "مالك") return MapEntry(i.id.toString(), i.data());
          }
          rows.add(
            PlutoRow(
              cells: {
                data.keys.elementAt(0): PlutoCell(value: i.id),
                data.keys.elementAt(1): PlutoCell(value: i.data().userName),
                data.keys.elementAt(2): PlutoCell(value: i.data().fullName),
                data.keys.elementAt(3): PlutoCell(value: i.data().password),
                data.keys.elementAt(index): PlutoCell(value: i.data().type),
                data.keys.elementAt(index + 1): PlutoCell(value: i.data().isActive == true ? "فعال".tr : "غير فعال".tr),
                data.keys.elementAt(index + 2): PlutoCell(value: i.data().mobileNumber),
                data.keys.elementAt(index + 3): PlutoCell(value: i.data().address),
                data.keys.elementAt(index + 4): PlutoCell(value: i.data().nationality),
                data.keys.elementAt(index + 5): PlutoCell(value: i.data().gender),
                data.keys.elementAt(index + 6): PlutoCell(value: i.data().age),
                data.keys.elementAt(index + 7): PlutoCell(value: i.data().jobTitle),
                data.keys.elementAt(index + 8): PlutoCell(value: i.data().contract),
                data.keys.elementAt(index + 9):
                    PlutoCell(value: Get.find<BusViewModel>().busesMap[i.data().bus.toString()]?.name ?? i.data().bus),
                data.keys.elementAt(index + 10): PlutoCell(value: i.data().startDate),
                data.keys.elementAt(index + 11): PlutoCell(value: i.data().eventRecords?.length.toString()),
                data.keys.elementAt(index + 12):
                    PlutoCell(value: i.data().isAccepted == true ? "تمت الموافقة".tr : "في انتظار الموافقة".tr),
              },
            ),
          );
          return MapEntry(i.id.toString(), i.data());
        })).obs;
        isOpen = List.generate(allAccountManagement.length, (index) => false);
        isLoading = true;
        Get.find<SalaryViewModel>().getEmployeeSalaryPluto();

        update();
        getAllUserAppend();
        print("listener from user");
      },
    );
  }

  getAllEmployeeWithoutListen() async {
    accountManagementFireStore.get().then(
      (event) async {
        await Get.find<BusViewModel>().getAllWithoutListenBuse();
        plutoKey = GlobalKey();
        rows.clear();
        allAccountManagement = Map<String, EmployeeModel>.fromEntries(event.docs.toList().map((i) {
          rows.add(
            PlutoRow(
              cells: {
                data.keys.elementAt(0): PlutoCell(value: i.id),
                data.keys.elementAt(1): PlutoCell(value: i.data().userName),
                data.keys.elementAt(2): PlutoCell(value: i.data().fullName),
                data.keys.elementAt(3): PlutoCell(value: i.data().password),
                data.keys.elementAt(4): PlutoCell(value: i.data().type),
                data.keys.elementAt(5): PlutoCell(value: i.data().isActive),
                data.keys.elementAt(6): PlutoCell(value: i.data().mobileNumber),
                data.keys.elementAt(7): PlutoCell(value: i.data().address),
                data.keys.elementAt(8): PlutoCell(value: i.data().nationality),
                data.keys.elementAt(9): PlutoCell(value: i.data().gender),
                data.keys.elementAt(10): PlutoCell(value: i.data().age),
                data.keys.elementAt(11): PlutoCell(value: i.data().jobTitle),
                data.keys.elementAt(12): PlutoCell(value: i.data().contract),
                data.keys.elementAt(13): PlutoCell(value: Get.find<BusViewModel>().busesMap[i.data().bus.toString()]?.name ?? i.data().bus),
                data.keys.elementAt(14): PlutoCell(value: i.data().startDate),
                data.keys.elementAt(15): PlutoCell(value: i.data().eventRecords?.length.toString()),
                data.keys.elementAt(16): PlutoCell(value: i.data().isAccepted),
              },
            ),
          );
          return MapEntry(i.id.toString(), i.data());
        })).obs;
        update();
      },
    );
  }

  addAccount(EmployeeModel accountModel) {
    accountManagementFireStore.doc(accountModel.id).set(accountModel, SetOptions(merge: true));
  }

  deleteUnAcceptedAccount(String accountModelId) {
    accountManagementFireStore.doc(accountModelId).delete();
  }

  Future<String> uploadImage(bytes, fileName) async {
    try {
      await _storage.ref(fileName).putData(bytes!.buffer.asUint8List());
      return await _storage.ref(fileName).getDownloadURL();
    } catch (e) {
      print('Error uploading signature: $e');
      return 'Error';
    }
  }

  addReceiveSalary(
      String accountId, String paySalary, String salaryDate, String constSalary, String dilaySalary, bytes, String nots) async {
    String fileName = 'signatures/$accountId/$salaryDate.png';
    uploadImage(bytes, fileName).then(
      (value) async {
        if (value != Error) {
          String salaryId = "${salaryDate} ${generateId("SALARY")}";
          await FirebaseFirestore.instance.collection(accountManagementCollection).doc(accountId).set({
            "discounts": (double.parse(paySalary) - double.parse(dilaySalary)).toInt(),
            "salaryReceived": FieldValue.arrayUnion([salaryId])
          }, SetOptions(merge: true));

          await Get.find<SalaryViewModel>().addSalary(SalaryModel(
            salaryId: salaryId,
            constSalary: constSalary,
            employeeId: accountId,
            dilaySalary: dilaySalary,
            paySalary: paySalary,
            signImage: value,
          ));

          if (double.parse(paySalary).toInt() != double.parse(dilaySalary).toInt())
            await addWaitOperation(
                collectionName: accountManagementCollection,
                userName: currentEmployee?.userName.toString() ?? "",
                affectedId: accountId,
                type: waitingListTypes.waitDiscounts,
                details: "الراتب الممنوح".tr + " ($paySalary) " + "الراتب المستحق".tr + " ($dilaySalary) ${nots}          ($salaryDate) ");
          Get.back();
          Get.back();
        }
      },
    );
  }

  initNFC(typeNFC type) async {
    initNFCWorker(type).then(
      (value) {
        if (value) {
          isSupportNfc = value;
          update();
        }
      },
    );
  }

  getScreens() async {
    if (currentEmployee?.type == "مستخدم") {
      HiveDataBase.setCurrentScreen("0");
      initDashboard([
        (
          name: "الدوام",
          img: "assets/dashIcon/time.png",
          widget: EmployeeTimeView(),
        ),
        (
          name: "تسجيل الخروج",
          img: "assets/dashIcon/logout.png",
          widget: LogoutView(),
        ),
      ]);
    } else {
      if (currentEmployee?.type == "مالك") {
        accountType = {
          "user": "مستخدم".tr,
          "admin": "مدير".tr,
          "superAdmin": "مالك".tr,
        };
      } else {
        accountType = {
          "user": "مستخدم".tr,
          "admin": "مدير".tr,
        };
      }
      initDashboard([
        (
          name: "لوحة التحكم",
          img: "assets/dashIcon/dash.png",
          widget: DashboardScreen(),
        ),
        (
          name: "أولياء الامور",
          img: "assets/dashIcon/family (1).png",
          widget: ParentsView(),
        ),
        (
          name: "الطلاب",
          img: "assets/dashIcon/student.png",
          widget: StudentView(),
        ),
        (
          name: "الصفوف",
          img: "assets/dashIcon/class.png",
          widget: ClassesView(),
        ),
        (
          name: "الدوام",
          img: "assets/dashIcon/time.png",
          widget: EmployeeTimeView(),
        ),
        (
          name: "الموظفين",
          img: "assets/dashIcon/employee.png",
          widget: EmployeeView(),
        ),
        (
          name: "الرواتب",
          img: "assets/dashIcon/salary.png",
          widget: SalaryView(),
        ),
        (
          name: "الحافلات",
          img: "assets/dashIcon/bus.png",
          widget: BusesView(),
        ),
        (
          name: "الرسوم الدراسية",
          img: "assets/dashIcon/accounting.png",
          widget: StudyFeesView(),
        ),
        (
          name: "الأحداث",
          img: "assets/dashIcon/events.png",
          widget: EventViewScreen(),
        ),
        (
          name: "المصاريف",
          img: "assets/dashIcon/audit.png",
          widget: ExpensesViewScreen(),
        ),
        (
          name: "المستودع",
          img: "assets/dashIcon/groceries.png",
          widget: StoreViewPage(),
        ),
        (
          name: "ادارة المنصة",
          img: "assets/dashIcon/setting.png",
          widget: SettingsView(),
        ),
        (
          name: "تسجيل الخروج",
          img: "assets/dashIcon/logout.png",
          widget: LogoutView(),
        ),
      ]);
    }
  }

  void checkUserStatus() async {
    if (userName != null) {
      FirebaseFirestore.instance
          .collection(accountManagementCollection)
          .where('userName', isEqualTo: userName)
          .where("password", isEqualTo: password)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          myUserModel = EmployeeModel.fromJson(value.docs.first.data());
          if (myUserModel?.isAccepted == false) {
            Get.snackbar("خطأ", "هذا المستخدم غير فعال ");
            return;
          }
          currentEmployee = await myUserModel!;
          HiveDataBase.setCurrentScreen("0");
          await HiveDataBase.deleteAccountManagementModel();
          await HiveDataBase.setAccountManagementModel(myUserModel!);

          await getScreens();
          getAllEmployee();

          Get.offNamed(AppRoutes.DashboardScreen);
        } else if (value.docs.isEmpty) {
          Get.snackbar("error", "not matched");
        }
      });
    } else {
      Get.snackbar("error", "not matched");
    }
  }

 String getLateTime(String date) {
    SettingsViewModel settingsController = Get.find<SettingsViewModel>();
    String lateTime = settingsController.settingsMap[Const.lateTime][Const.time];
    String friLateTime = settingsController.settingsMap[Const.friLateTime][Const.time];
    if (DateTime.parse(date).weekday == DateTime.friday) {
      return friLateTime;
    } else {

      return lateTime;
    }
  }

  Future<void> addTime(
      {String? cardId,
      String? userName,
      String? password,
      required String appendTime,
      required String lateTime,
      required String outTime}) async {
    bool? isLateWithReason;
    bool? isEarlierWithReason;
    bool isDayOff = false;
    int totalLate = 0;
    int totalEarlier = 0;
    TextEditingController lateReasonController = TextEditingController();
    TextEditingController earlierReasonController = TextEditingController();
    print(cardId);
    print("add Time");
    EmployeeModel? user;
    if (cardId != null) {
      String? userId = nfcCardViewModel.nfcCardMap[cardId]?.userId;
      print(userId);
      if (userId != null) user = allAccountManagement[userId];
    } else {
      user = allAccountManagement.values
          .where(
            (element) => element.userName == userName,
          )
          .firstOrNull;
    }
    print(user?.id);

    if (user != null) {
      {
        TimesModel timeData = TimesModel.fromDateTime(Timestamp.now().toDate());
        if (isLogIn && startAddTime) {
          startAddTime = false;
          if (user.employeeTime![timeData.formattedTime] == null) {
            if (timeData.isAfter(int.parse(appendTime.split(" ")[0]), int.parse(appendTime.split(" ")[1]))) {
              totalLate = timeData.dateTime
                  .difference(DateTime.now()
                      .copyWith(hour: int.parse(appendTime.split(" ")[0]), minute: int.parse(appendTime.split(" ")[1]), second: 0))
                  .inSeconds;
              isDayOff = true;
              isLateWithReason = false;
              await Get.defaultDialog(
                  barrierDismissible: false,
                  backgroundColor: Colors.white,
                  title: "أنت متأخر ",
                  content: Container(
                    child: StatefulBuilder(
                      builder: (context, setstate) {
                        return Column(
                          children: [
                            Text("تأخرت اليوم "),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                    fillColor: WidgetStatePropertyAll(primaryColor),
                                    shape: RoundedRectangleBorder(),
                                    value: !isLateWithReason!,
                                    onChanged: (_) {
                                      isLateWithReason = !_!;
                                      setstate(() {});
                                    }),
                                Text("تأخر غير مبرر")
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                    fillColor: WidgetStatePropertyAll(primaryColor),
                                    shape: RoundedRectangleBorder(),
                                    value: isLateWithReason,
                                    onChanged: (_) {
                                      isLateWithReason = _!;
                                      setstate(() {});
                                    }),
                                Text("تأخر مبرر"),
                              ],
                            ),
                            CustomTextField(controller: lateReasonController, title: "سبب التأخر".tr),
                          ],
                        );
                      },
                    ),
                  ),
                  actions: [
                    AppButton(
                        text: "موافق",
                        onPressed: () {
                          Get.back();
                        })
                  ]);
            } else if (timeData.isAfter(int.parse(lateTime.split(" ")[0]), (int.parse(lateTime.split(" ")[1])))) {
              totalLate = timeData.dateTime
                  .difference(DateTime.now()
                      .copyWith(hour: int.parse(appendTime.split(" ")[0]), minute: int.parse(appendTime.split(" ")[1]), second: 0))
                  .inSeconds;
              isDayOff = false;
              isLateWithReason = false;
              await Get.defaultDialog(
                  barrierDismissible: false,
                  backgroundColor: Colors.white,
                  title: "أنت متأخر ",
                  content: Container(
                    child: StatefulBuilder(
                      builder: (context, setstate) {
                        return Column(
                          children: [
                            Text("تأخرت اليوم "),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                    fillColor: WidgetStatePropertyAll(primaryColor),
                                    shape: RoundedRectangleBorder(),
                                    value: !isLateWithReason!,
                                    onChanged: (_) {
                                      isLateWithReason = !_!;
                                      setstate(() {});
                                    }),
                                Text("تأخر غير مبرر")
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                    fillColor: WidgetStatePropertyAll(primaryColor),
                                    shape: RoundedRectangleBorder(),
                                    value: isLateWithReason,
                                    onChanged: (_) {
                                      isLateWithReason = _!;
                                      setstate(() {});
                                    }),
                                Text("تأخر مبرر"),
                              ],
                            ),
                            CustomTextField(controller: lateReasonController, title: "سبب التأخر".tr),
                          ],
                        );
                      },
                    ),
                  ),
                  actions: [
                    AppButton(
                        text: "موافق",
                        onPressed: () {
                          Get.back();
                        })
                  ]);
            }

            user.employeeTime![timeData.formattedTime] = EmployeeTimeModel(
                dayName: timeData.formattedTime,
                startDate: timeData.dateTime.copyWith(hour: timeData.hour, day: timeData.day, minute: timeData.minute),
                endDate: null,
                totalDate: null,
                isDayEnd: false,
                isDayOff: isDayOff,
                isLateWithReason: isLateWithReason,
                reasonOfLate: lateReasonController.text,
                totalLate: totalLate,
                isEarlierWithReason: null,
                reasonOfEarlier: null,
                totalEarlier: null);
            loginUserPage = "اهلا بك " + user.userName;

            accountManagementFireStore.doc(user.id).update(
                {"employeeTime": Map.fromEntries(user.employeeTime!.entries.map((e) => MapEntry(e.key, e.value.toJson())).toList())});
          } else {
            loginUserPage = "لقد قمت بالدخول بالفعل " + user.userName;
            update();
          }
        }
        if (!isLogIn && startAddTime) {
          startAddTime = false;
          if (user.employeeTime![timeData.formattedTime]!.isDayEnd! && user.employeeTime![timeData.formattedTime] == null) {
            loginUserPage = "لقد قمت بالخروج بالفعل " + user.userName;
            update();
          } else {
            if (timeData.isBefore(int.parse(outTime.split(" ")[0]), int.parse(outTime.split(" ")[1]))) {
              totalEarlier = timeData.dateTime
                  .copyWith(hour: int.parse(outTime.split(" ")[0]), minute: int.parse(outTime.split(" ")[1]), second: 0)
                  .difference(timeData.dateTime)
                  .inMinutes;
              isEarlierWithReason = false;
              await Get.defaultDialog(
                  barrierDismissible: false,
                  backgroundColor: Colors.white,
                  title: "خروج مبكر ",
                  content: Container(
                    child: StatefulBuilder(
                      builder: (context, setstate) {
                        return Column(
                          children: [
                            Text("خرجت اليوم مبكرا"),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                    fillColor: WidgetStatePropertyAll(primaryColor),
                                    shape: RoundedRectangleBorder(),
                                    value: !isEarlierWithReason!,
                                    onChanged: (_) {
                                      isEarlierWithReason = !_!;
                                      setstate(() {});
                                    }),
                                Text("خروج غير مبرر")
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                    fillColor: WidgetStatePropertyAll(primaryColor),
                                    shape: RoundedRectangleBorder(),
                                    value: isEarlierWithReason,
                                    onChanged: (_) {
                                      isEarlierWithReason = _!;
                                      setstate(() {});
                                    }),
                                Text("خروج مبرر"),
                              ],
                            ),
                            CustomTextField(controller: earlierReasonController, title: "سبب التأخر".tr),
                          ],
                        );
                      },
                    ),
                  ),
                  actions: [
                    AppButton(
                        text: "موافق",
                        onPressed: () {
                          Get.back();
                        })
                  ]);
            }
            user.employeeTime![timeData.formattedTime]!.isEarlierWithReason = isEarlierWithReason;
            user.employeeTime![timeData.formattedTime]!.totalEarlier = totalEarlier;
            user.employeeTime![timeData.formattedTime]!.reasonOfEarlier = earlierReasonController.text;
            user.employeeTime![timeData.formattedTime]!.endDate = Timestamp.now().toDate();
            user.employeeTime![timeData.formattedTime]!.isDayEnd = true;
            user.employeeTime![timeData.formattedTime]!.totalDate =
                timeData.dateTime.difference(user.employeeTime![timeData.formattedTime]!.startDate!).inMinutes;
            loginUserPage = "وداعا " + user.userName;
            accountManagementFireStore.doc(user.id).update(
                {"employeeTime": Map.fromEntries(user.employeeTime!.entries.map((e) => MapEntry(e.key, e.value.toJson())).toList())});
            settingFireStore.doc(Const.time).set({
              Const.time: FieldValue.arrayUnion([timeData.formattedTime])
            });
          }
        }
      }

      update();
      await Future.delayed(Duration(seconds: 4));
      loginUserPage = null;
      startAddTime = true;
      update();
    } else {
      print("Not found");
    }
  }

  getOldData(String value) {
    FirebaseFirestore.instance.collection(archiveCollection).doc(value).collection(accountManagementCollection).get().then(
      (event) async {
        await Get.find<BusViewModel>().getAllWithoutListenBuse();
        plutoKey = GlobalKey();
        rows.clear();
        allAccountManagement = Map<String, EmployeeModel>.fromEntries(event.docs.toList().map((i) {
          rows.add(
            PlutoRow(
              cells: {
                data.keys.elementAt(0): PlutoCell(value: i.id),
                data.keys.elementAt(1): PlutoCell(value: i.data()["userName"]),
                data.keys.elementAt(2): PlutoCell(value: i.data()["fullName"]),
                data.keys.elementAt(3): PlutoCell(value: i.data()["password"]),
                data.keys.elementAt(4): PlutoCell(value: i.data()["type"]),
                data.keys.elementAt(5): PlutoCell(value: i.data()["isActive"]),
                data.keys.elementAt(6): PlutoCell(value: i.data()["mobileNumber"]),
                data.keys.elementAt(7): PlutoCell(value: i.data()["address"]),
                data.keys.elementAt(8): PlutoCell(value: i.data()["nationality"]),
                data.keys.elementAt(9): PlutoCell(value: i.data()["gender"]),
                data.keys.elementAt(10): PlutoCell(value: i.data()["age"]),
                data.keys.elementAt(11): PlutoCell(value: i.data()["jobTitle"]),
                data.keys.elementAt(12): PlutoCell(value: i.data()["contract"]),
                data.keys.elementAt(13):
                    PlutoCell(value: Get.find<BusViewModel>().busesMap[i.data()["bus"].toString()]?.name ?? i.data()["bus"]),
                data.keys.elementAt(14): PlutoCell(value: i.data()["startDate"]),
                data.keys.elementAt(15): PlutoCell(value: i.data()["eventRecords"]?.length.toString()),
                data.keys.elementAt(16): PlutoCell(value: i.data()["isAccepted"] == true ? "تمت الموافقة".tr : "في انتظار الموافقة".tr),
              },
            ),
          );
          return MapEntry(i.id.toString(), EmployeeModel.fromJson(i.data()));
        })).obs;
        update();
      },
    );
  }

  double getAllSalariesAtMonth(String month, String year) {
    double pay = 0.0;
    allAccountManagement.forEach(
      (key, value) {
        pay += getUserSalariesAtMonth(month, key, year);
      },
    );

    return pay;
  }

  double getAllPaySalaryAtMonth(String month, String year) {
    double pay = 0.0;

    pay = Get.find<SalaryViewModel>()
        .salaryMap
        .values
        .where(
          (element) {
            return element.salaryId!.split(" ")[0].split("-")[1] == month && element.salaryId!.split(" ")[0].split("-")[0] == year;
          },
        )
        .map(
          (e) => double.parse(e.paySalary!),
        )
        .toList()
        .fold(
          0,
          (previousValue, element) => previousValue + element,
        );
    return pay;
  }

  double getUserSalariesAtMonth(String month, String user, String year) {
    double pay = 0.0;
    if (allAccountManagement[user]!
        .employeeTime!
        .entries
        .where(
          (element) =>
              element.key.toString().split("-")[1] == month.padLeft(2, "0").toString() && element.key.toString().split("-")[0] == year,
        )
        .isNotEmpty) {
      EmployeeModel accountModel = allAccountManagement[user]!;
      int totalLateAndEarlier = (accountModel.employeeTime!.isEmpty
                  ? 0
                  : accountModel.employeeTime!.values.where(
                        (element) {
                          return element.isDayOff != true &&
                              element.isLateWithReason == false &&
                              element.isEarlierWithReason == false &&
                              element.dayName.toString().split("-")[1] == month.padLeft(2, "0").toString();
                        },
                      ).length /
                      3)
              .floor() *
          75;

      totalLateAndEarlier += (accountModel.employeeTime!.isEmpty
                  ? 0
                  : accountModel.employeeTime!.values.where(
                        (element) {
                          return element.isDayOff != true &&
                              element.endDate == null &&
                              element.dayName.toString().split("-")[1] == month.padLeft(2, "0").toString();
                        },
                      ).length /
                      3)
              .floor() *
          75;

      int totalDayOff = (accountModel.employeeTime!.isEmpty
              ? 0
              : accountModel.employeeTime!.values.where(
                  (element) {
                    return element.isDayOff == true && element.dayName.toString().split("-")[1] == month.padLeft(2, "0").toString();
                  },
                ).length) *
          ((accountModel.salary ?? 0) / (accountModel.dayOfWork != 0 ? (accountModel.dayOfWork ?? 1) : 1)).round();

      pay += accountModel.salary! - totalDayOff - totalLateAndEarlier;
    }

    return pay;
  }

  List<String> generateDaysInMonth(int year, int month) {
    int daysInMonth = DateTime(year, month + 1, 0).day;
    List<String> days = [];
    for (int day = 1; day <= daysInMonth; day++) {
      days.add(DateFormat('yyyy-MM-dd').format(DateTime(year, month, day)));
    }
    return days;
  }

  Map<String, List<String>> getAbsentDaysForEmployees(int year, int month) {
    List<String> daysInMonth = generateDaysInMonth(year, month);
    List<String> holidays = getHolidaysForMonth(year, month);

    daysInMonth.removeWhere(
      (element) => holidays.contains(element),
    );

    Map<String, List<String>> absentDays = {};

    for (var employee in allAccountManagement.values) {
      List<String> employeeAbsentDays = daysInMonth.where((day) => !employee.employeeTime!.containsKey(day)).toList();
      absentDays[employee.userName] = employeeAbsentDays;
    }

    return absentDays;
  }

  List<String> getAbsentDaysForEmployee(String empId, int year, int month) {
    List<String> daysInMonth = generateDaysInMonth(year, month);
    List<String> holidays = getHolidaysForMonth(year, month);

    daysInMonth.removeWhere(
      (element) => holidays.contains(element),
    );

    EmployeeModel employeeModel = allAccountManagement[empId]!;
    List<String> employeeAbsentDays = daysInMonth.where((day) => !employeeModel.employeeTime!.containsKey(day)).toList();

    return employeeAbsentDays;
  }

  List<String> getHolidaysForMonth(int year, int month) {
    List<String> daysInMonth = generateDaysInMonth(year, month);

    Set<String> holidays = daysInMonth.toSet();

    for (var employee in allAccountManagement.values) {
      holidays.removeWhere((day) => employee.employeeTime!.containsKey(day));
    }

    return holidays.toList();
  }

/*  List<String> getMissedWorkDays(
      Map<String, Map<String, Map<String, dynamic>>> allEmployeesTime,
      String employeeId,
      DateTime startDate,
      DateTime endDate,
      ) {
    List<String> missedDays = [];
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    for (DateTime date = startDate; date.isBefore(endDate.add(Duration(days: 1))); date = date.add(Duration(days: 1))) {
      String dateString = formatter.format(date);

      // التحقق مما إذا كان اليوم عطلة
      bool isHoliday = allEmployeesTime.values.every(
            (employeeTime) => !employeeTime.containsKey(dateString),
      );

      // إذا لم يكن اليوم عطلة وكان الموظف المحدد لم يداوم
      if (!isHoliday && !allEmployeesTime[employeeId]!.containsKey(dateString)) {
        missedDays.add(dateString);
      }
    }

    return missedDays;
  }*/
  List<String> monthCount = [];

  getAllUserAppend() {
    for (var accountModel in allAccountManagement.values) {
      for (var month in accountModel.employeeTime?.keys ?? []) {
        monthCount.add(month.toString().split("-")[0] + "-" + month.toString().split("-")[1]);
      }
      for (var days in monthCount.toSet()) {
        for (var empTime in getAbsentDaysForEmployee(accountModel.id, int.parse(days.split("-")[0]), int.parse(days.split("-")[1]))
            .map((e) => MapEntry(
                e,
                EmployeeTimeModel(
                    dayName: e,
                    startDate: null,
                    endDate: null,
                    totalDate: null,
                    isDayEnd: true,
                    isLateWithReason: null,
                    reasonOfLate: null,
                    isEarlierWithReason: null,
                    reasonOfEarlier: null,
                    isDayOff: true,
                    totalLate: null,
                    totalEarlier: null)))
            .toList()) {
          accountModel.employeeTime?[empTime.key] = empTime.value;
        }
      }

      var sortedEmployeeTime = Map.fromEntries(
        accountModel.employeeTime!.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      );

      accountModel.employeeTime = sortedEmployeeTime;
    }
  }

  double getAllRequiredSalaries() {
    double pay = 0.0;
    for (var accountModel in allAccountManagement.values) {
      int totalLateAndEarlier = (accountModel.employeeTime!.isEmpty
                  ? 0
                  : accountModel.employeeTime!.values.where(
                        (element) {
                          return element.isDayOff != true && element.isLateWithReason == false && element.isEarlierWithReason == false;
                        },
                      ).length /
                      3)
              .floor() *
          75;

      totalLateAndEarlier += (accountModel.employeeTime!.isEmpty
                  ? 0
                  : accountModel.employeeTime!.values.where(
                        (element) {
                          return element.isDayOff != true && element.endDate == null;
                        },
                      ).length /
                      3)
              .floor() *
          75;

      int totalDayOff = (accountModel.employeeTime!.isEmpty
              ? 0
              : accountModel.employeeTime!.values.where(
                  (element) {
                    return element.isDayOff == true;
                  },
                ).length) *
          ((accountModel.salary ?? 0) / (accountModel.dayOfWork != 0 ? (accountModel.dayOfWork ?? 1) : 1)).round();

      pay += (accountModel.salary! * monthCount.toSet().length) - totalDayOff - totalLateAndEarlier;
    }

    return pay;
  }

  double getUserSalariesAllMonth(String user) {
    double pay = 0.0;

    EmployeeModel accountModel = allAccountManagement[user]!;
    for (var month in accountModel.employeeTime?.keys ?? []) {
      monthCount.add(month.toString().split("-")[0] + "-" + month.toString().split("-")[1]);
    }
    if (accountModel.employeeTime!.entries.isNotEmpty) {
      int totalLateAndEarlier = (accountModel.employeeTime!.values.where(
                    (element) {
                      return element.isDayOff != true && element.isLateWithReason == false && element.isEarlierWithReason == false;
                    },
                  ).length /
                  3)
              .floor() *
          75;
      totalLateAndEarlier += (accountModel.employeeTime!.values.where(
                    (element) {
                      return element.isDayOff != true && element.endDate == null;
                    },
                  ).length /
                  3)
              .floor() *
          75;
      int totalDayOff = (accountModel.employeeTime!.isEmpty
              ? 0
              : accountModel.employeeTime!.values.where(
                  (element) {
                    return element.isDayOff == true;
                  },
                ).length) *
          ((accountModel.salary ?? 0) / (accountModel.dayOfWork != 0 ? (accountModel.dayOfWork ?? 1) : 1)).round();

      pay += accountModel.salary! - totalDayOff - totalLateAndEarlier;
    }

    return pay;
  }

  List<double> getUserTimeToday(String day) {
    // String day = /*DateTime.now().day.toString()*/ "2024-07-16";
    List<double> time = [0.0];
    allAccountManagement.forEach(
      (key, value) {
        if (value.employeeTime!.entries
            .where(
              (element) => element.key.toString() == day && element.value.isDayOff != true,
            )
            .isNotEmpty) {
          double totalTime = (getTotalLateForUserAtDay(selectedDay: day, userId: key) + 0 * 1.0);

          time.add(6 + (totalTime / 60));
        } else
          time.add(0.0);
      },
    );

    return time;
  }

  int getTotalLateForUserAtMonth({required String selectedMonth, required String selectedYear, required String userId}) {
    int totalLate = 0;
    List<int> totalLateList = [];
    if (selectedMonth != 'الكل')
      totalLateList = allAccountManagement[userId]!
          .employeeTime!
          .values
          .where(
            (element) {
              return element.dayName!.split("-")[1] == months[selectedMonth] &&
                  element.dayName!.split("-")[0] == selectedYear &&
                  element.isDayOff != true &&
                  (element.startDate != null) &&
                  (element.startDate!.difference(element.startDate!.copyWith(hour: int.parse(getLateTime(element.dayName!).split(" ")[0]), minute: int.parse(getLateTime(element.dayName!).split(" ")[1]), second: 0)).inMinutes) > 0;
            },
          )
          .map((element) => element.startDate?.difference(element.startDate!.copyWith(hour: int.parse(getLateTime(element.dayName!).split(" ")[0]), minute: int.parse(getLateTime(element.dayName!).split(" ")[1]), second: 0)).inSeconds ?? 0)
          .toList();
    else
      totalLateList = allAccountManagement[userId]!
          .employeeTime!
          .values
          .where(
            (element) =>
                element.isDayOff != true &&
                (element.startDate != null) &&
                (element.startDate!.difference(element.startDate!.copyWith(hour: int.parse(getLateTime(element.dayName!).split(" ")[0]), minute: int.parse(getLateTime(element.dayName!).split(" ")[1]), second: 0)).inMinutes) > 0,
          )
          .map((element) => element.startDate?.difference(element.startDate!.copyWith(hour: int.parse(getLateTime(element.dayName!).split(" ")[0]), minute: int.parse(getLateTime(element.dayName!).split(" ")[1]), second: 0)).inSeconds ?? 0)
          .toList();
    if (totalLateList.isNotEmpty) totalLate = totalLateList.reduce((value, element) => value + element);

    return totalLate ~/ 60;
  }

  int getTotalLateForUserAtDay({required String selectedDay, required String userId}) {
    int totalLate = 0;
    List<int> totalLateList = [];

    if (selectedDay != 'الكل')
      totalLateList = allAccountManagement[userId]!.employeeTime!.values.where(
        (element) {
          return element.dayName! == selectedDay;
        },
      ).map((e) {
        return e.totalLate ?? 0;
      }).toList();
    else
      totalLateList = allAccountManagement[userId]!.employeeTime!.values.map((e) {
        return e.totalLate ?? 0;
      }).toList();
    if (totalLateList.isNotEmpty) totalLate = totalLateList.reduce((value, element) => value + element);
    return totalLate ~/ 60;
  }

  void addCard({required String cardId}) {
    nfcController.text = cardId;
    print("------${cardId}");
  }

  setAccepted(String affectedId) async {
    FirebaseFirestore.instance.collection(accountManagementCollection).doc(affectedId).set({"isAccepted": true}, SetOptions(merge: true));
  }

  setBus(String busId, List employee) async {
    for (var employee in employee)
      FirebaseFirestore.instance.collection(accountManagementCollection).doc(employee).set({"bus": busId}, SetOptions(merge: true));
  }

  setAppend(String userId, date) {
    allAccountManagement[userId]!.employeeTime![date] = EmployeeTimeModel(
        dayName: date,
        startDate: DateTime.now().copyWith(hour: 7, day: int.parse(date.toString().split("-")[1]), minute: 30),
        endDate: DateTime.now().copyWith(hour: 7, day: int.parse(date.toString().split("-")[1]), minute: 30),
        totalDate: null,
        isDayEnd: false,
        isDayOff: true,
        isLateWithReason: false,
        reasonOfLate: "",
        totalLate: 0,
        isEarlierWithReason: null,
        reasonOfEarlier: null,
        totalEarlier: null);
    accountManagementFireStore.doc(userId).update({
      "employeeTime":
          Map.fromEntries(allAccountManagement[userId]!.employeeTime!.entries.map((e) => MapEntry(e.key, e.value.toJson())).toList())
    });
  }

  /// change current selected id
  void setCurrentId(value) {
    currentId = value;
    update();
  }

  /// use this to change view screen
  foldScreen() {
    clearController();
    startDateController.text = thisTimesModel!.dateTime.toString().split(" ")[0];
    isAdd = !isAdd;
    update();
  }

  /// when press delete
  void showDeleteConfirmationDialog(BuildContext context) {
    TextEditingController editController = TextEditingController();
    if (currentEmployee?.salaryReceived?.isNotEmpty ?? true) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        widget: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              controller: editController,
              title: "سبب الحذف".tr,
              size: Get.width / 4,
            ),
          ),
        ),
        text: 'قبول هذه العملية'.tr,
        title: 'هل انت متأكد ؟'.tr,
        onConfirmBtnTap: () async {
          addWaitOperation(
            userName: currentEmployee?.userName.toString() ?? "",
            details: editController.text,
            collectionName: accountManagementCollection,
            affectedId: allAccountManagement[currentId]?.id ?? '',
            type: waitingListTypes.delete,
          );
          Get.back();
        },
        onCancelBtnTap: () => Get.back(),
        confirmBtnText: 'نعم'.tr,
        cancelBtnText: 'لا'.tr,
        confirmBtnColor: Colors.redAccent,
        showCancelBtn: true,
      );
    } else {
      showErrorDialog("خطأ اثناء الحذف", "لا يمكن حذف هذا الموظف");
    }
  }

  /// when add or edite Employee
  saveEmployee(BuildContext context) async {
    if (validateFields(requiredControllers: [
      userNameController,
      fullNameController,
      userPassController,
      addressController,
      nationalityController,
      jobTitleController,
      contractController,
      busController,
      startDateController,
      genderController,
      ageController,
      salaryController,
      dayWorkController,
      mobileNumberController,
    ], numericControllers: [
      ageController,
      salaryController,
      dayWorkController,
      mobileNumberController,
    ])) {
      loadingQuickAlert(context);
      try {
        await uploadImages(imagesTempData, "expenses").then(
          (value) => imageLinkList.addAll(value),
        );
        EmployeeModel model = EmployeeModel(
          id: !enableEdit ? generateId("EMPLOYEE") : employeeModel!.id,
          userName: userNameController.text,
          fullName: fullNameController.text,
          password: userPassController.text,
          employeeTime: !enableEdit ? {} : employeeModel!.employeeTime,
          type: role,
          serialNFC: selectedCardId,
          idImages: imageLinkList
              .map(
                (e) => e.toString(),
              )
              .toList(),
          isActive: true,
          isAccepted: false,
          salary: int.parse(salaryController.text),
          dayOfWork: int.parse(dayWorkController.text),
          mobileNumber: mobileNumberController.text,
          address: addressController.text,
          nationality: nationalityController.text,
          gender: genderController.text,
          age: ageController.text,
          jobTitle: jobTitleController.text,
          contract: contractController.text,
          bus: busController.text,
          startDate: startDateController.text,
          eventRecords: eventRecords,
          discounts: employeeModel?.discounts,
          salaryReceived: employeeModel?.salaryReceived,
        );

        ///اذا اختار باص او حو بدون حافلة
        if (busController.text.startsWith("BUS")) {
          Get.find<BusViewModel>().addEmployee(busController.text, model.id);
        }
        if (enableEdit) {
          ///addWaitOperation old Value=القيمة الي جاي من الويدجت newValue = القيم الجديدة من ال controller
          addWaitOperation(
            userName: currentEmployee?.userName.toString() ?? "",
            collectionName: accountManagementCollection,
            affectedId: employeeModel!.id,
            type: waitingListTypes.edite,
            oldData: employeeModel!.toJson(),
            newData: model.toJson(),
            details: editController.text,
          );

          ///يشوف وقت التعديل اذا عدل البطاقة ولا لا
          if (employeeModel!.serialNFC != selectedCardId) {
            Get.find<NfcCardViewModel>().deleteUserCard(employeeModel!.serialNFC);
            Get.find<NfcCardViewModel>().setCardForEMP(
              selectedCardId,
              employeeModel!.id,
            );
          }

          ///يشوف وقت التعديل اذا عدل الباص ولا لا
          if (employeeModel!.bus != busController.text) {
            Get.find<BusViewModel>().deleteEmployee(
              employeeModel!.bus!,
              employeeModel!.id,
            );
          }
        }
        if (!enableEdit) {
          ///اضافة العملية للموافقة عليها
          await addWaitOperation(
            userName: currentEmployee?.userName.toString() ?? "",
            collectionName: accountManagementCollection,
            affectedId: model.id,
            newData: model.toJson(),
            type: waitingListTypes.add,
          );
        }

        if (enableEdit) Get.back();
        Get.back();
        await addAccount(model);
        getSuccessDialog(context);
        if (!enableEdit) Get.find<NfcCardViewModel>().setCardForEMP(selectedCardId, model.id);
        clearController();
      } on Exception catch (e) {
        await getReedOnlyError(context, title: e.toString());
        print(e.toString());
        Get.back();
        Get.back();
      }
    }
  }

  clearController() {
    employeeModel = null;
    selectedEvent = null;
    fullNameController.clear();
    mobileNumberController.clear();
    addressController.clear();
    nationalityController.clear();
    genderController.clear();
    ageController.clear();
    jobTitleController.clear();
    salaryController.clear();
    contractController.clear();
    busController.clear();
    startDateController.clear();
    eventController.clear();
    dayWorkController.clear();
    bodyEvent.clear();
    userNameController.clear();
    userPassController.clear();
    editController.clear();
    eventRecords.clear();
    busValue = '';
    role = '';
    selectedCardId = '';
    eventRecords = [];
    imageLinkList.clear();
    imagesTempData.clear();
    update();
  }

  /// init controller when edite employee
  initController() {
    employeeModel = allAccountManagement[currentId];
    enableEdit = true;
    if (employeeModel != null) {
      selectedCardId = employeeModel!.serialNFC ?? '';
      fullNameController.text = employeeModel!.fullName.toString();
      mobileNumberController.text = employeeModel!.mobileNumber.toString();
      addressController.text = employeeModel!.address.toString();
      nationalityController.text = employeeModel!.nationality.toString();
      genderController.text = employeeModel!.gender.toString();
      ageController.text = employeeModel!.age.toString();
      jobTitleController.text = employeeModel!.jobTitle.toString();
      salaryController.text = employeeModel!.salary.toString();
      contractController.text = employeeModel!.contract.toString();
      busController.text = employeeModel!.bus.toString();
      startDateController.text = employeeModel!.startDate.toString();
      dayWorkController.text = employeeModel!.dayOfWork.toString();
      bodyEvent.clear();
      imageLinkList = employeeModel!.idImages ?? [];
      userNameController.text = employeeModel!.userName.toString();
      userPassController.text = employeeModel!.password.toString();
      employeeModel!.eventRecords?.forEach(
        (element) {
          eventRecords.add(element);
        },
      );

      role = employeeModel!.type.toString();
      busValue = Get.find<BusViewModel>().busesMap[employeeModel!.bus]?.name ?? employeeModel!.bus!;
    }
  }

  /// when press Edite button
  showEmployeeInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
            ),
            height: Get.height / 1.1,
            width: Get.width / 1.1,
            child: EmployeeInputForm(),
          ),
        );
      },
    );
  }

  addEmployeeEvent() async {
    eventRecords.add(EventRecordModel(
      body: bodyEvent.text,
      type: selectedEvent!.name,
      date: Timestamp.now().toDate().toIso8601String(),
      color: selectedEvent!.color.toString(),
    ));
    bodyEvent.clear();
    update();
  }

  clearDiscount(String affectedId) {
    FirebaseFirestore.instance.collection(accountManagementCollection).doc(affectedId).set({"discounts": 0}, SetOptions(merge: true));
  }

  double getMaxSalary() {
    double maxSalary = 3500;
    allAccountManagement.forEach(
      (key, value) {
        if (value.salary! > maxSalary) {
          maxSalary = value.salary! * 1.0;
        }
      },
    );

    return maxSalary + 1500;
  }
}