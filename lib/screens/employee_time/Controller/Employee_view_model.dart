import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:vision_dashboard/models/employee_time_model.dart';
import 'package:vision_dashboard/core/router/router.dart';

import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Text_Filed.dart';

import '../../../controller/nfc/non_web.dart';
import '../../../core/constant/constants.dart';
import '../../../controller/NFC_Card_View_model.dart';
import '../../../models/TimeModel.dart';
import '../../../models/account_management_model.dart';
import '../../../core/Utils/Hive_DataBase.dart';

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
  final userNameController = TextEditingController();
  final userPassController = TextEditingController();
  String? userName;
  String? password;
  String? serialNFC;
  EmployeeModel? myUserModel;

  /// Edite Employee model
  EmployeeModel? employeeModel = null;

  NfcCardViewModel nfcCardViewModel = Get.find<NfcCardViewModel>();
  bool isLogIn = true;

  /// we use this for cancel listener
  late StreamSubscription<QuerySnapshot<EmployeeModel>> listener;

  /// when scan NFC Card
  TextEditingController nfcController = TextEditingController();

  /// we use this in Employee time
  bool isLoading = true;

  bool isSupportNfc = false;

  RxMap<String, EmployeeModel> allAccountManagement = <String, EmployeeModel>{}.obs;
  final accountManagementFireStore = FirebaseFirestore.instance.collection(accountManagementCollection).withConverter<EmployeeModel>(
        fromFirestore: (snapshot, _) => EmployeeModel.fromJson(snapshot.data()!),
        toFirestore: (account, _) => account.toJson(),
      );

  @override
  onInit() {
    super.onInit();
    if (currentEmployee?.id != null) getAllEmployee();
  }

  getAllEmployee() {
    isLoading = true;
    update();
    listener = accountManagementFireStore.snapshots().listen(
      (event) async {
        allAccountManagement =
            Map<String, EmployeeModel>.fromEntries(event.docs.toList().map((i) => MapEntry(i.id.toString(), i.data()))).obs;
        isLoading = false;
        update();
        getAllUserAppend();
        print("listener from user");
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

  Future<bool?> showReasonDialog({
    required String title,
    required String message,
    required TextEditingController reasonController,
    required ValueNotifier<bool?> withReasonNotifier,
  }) {
    return Get.defaultDialog(
      barrierDismissible: false,
      backgroundColor: Colors.white,
      title: title,
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              Text(message),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    fillColor: const WidgetStatePropertyAll(primaryColor),
                    shape: const RoundedRectangleBorder(),
                    value: withReasonNotifier.value == false,
                    onChanged: (_) {
                      withReasonNotifier.value = false;
                      setState(() {});
                    },
                  ),
                  const Text("غير مبرر")
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    fillColor: const WidgetStatePropertyAll(primaryColor),
                    shape: const RoundedRectangleBorder(),
                    value: withReasonNotifier.value == true,
                    onChanged: (_) {
                      withReasonNotifier.value = true;
                      setState(() {});
                    },
                  ),
                  const Text("مبرر"),
                ],
              ),
              CustomTextField(controller: reasonController, title: "سبب".tr),
            ],
          );
        },
      ),
      actions: [
        AppButton(
          text: "موافق",
          onPressed: () => Get.back(result: true),
        ),
      ],
    );
  }

  Future<void> addTime({
    String? cardId,
    String? userName,
    String? password,
    required String appendTime,
    required String lateTime,
    required String outTime,
  }) async {
    final lateReasonController = TextEditingController();
    final earlierReasonController = TextEditingController();
    final isLateWithReason = ValueNotifier<bool?>(false);
    final isEarlierWithReason = ValueNotifier<bool?>(false);

    int totalLate = 0;
    int totalEarlier = 0;
    bool isDayOff = false;

    String? userId = nfcCardViewModel.nfcCardMap[cardId]?.userId;

    log('cardId $cardId');
    EmployeeModel? user = cardId != null && userId != null
        ? allAccountManagement[userId]
        : allAccountManagement.values.where((e) => e.userName == userName).firstOrNull;

    if (user == null) {
      print("User not found");
      return;
    }

    final now = Timestamp.now().toDate();
    final timeData = TimesModel.fromDateTime(now);

    final timeKey = timeData.formattedTime;
    final employeeTime = user.employeeTime ??= {};

    final startHour = int.parse(appendTime.split(" ")[0]);
    final startMin = int.parse(appendTime.split(" ")[1]);
    final lateHour = int.parse(lateTime.split(" ")[0]);
    final lateMin = int.parse(lateTime.split(" ")[1]);
    final outHour = int.parse(outTime.split(" ")[0]);
    final outMin = int.parse(outTime.split(" ")[1]);

    if (isLogIn) {
      if (employeeTime[timeKey]?.startDate == null) {
        if (timeData.isAfter(startHour, startMin)) {
          totalLate = timeData.dateTime.difference(now.copyWith(hour: startHour, minute: startMin)).inSeconds;
          isDayOff = true;
          await showReasonDialog(
            title: "أنت متأخر",
            message: "تأخرت اليوم",
            reasonController: lateReasonController,
            withReasonNotifier: isLateWithReason,
          );
        } else if (timeData.isAfter(lateHour, lateMin)) {
          totalLate = timeData.dateTime.difference(now.copyWith(hour: startHour, minute: startMin)).inSeconds;
          await showReasonDialog(
            title: "أنت متأخر",
            message: "تأخرت اليوم",
            reasonController: lateReasonController,
            withReasonNotifier: isLateWithReason,
          );
        }

        employeeTime[timeKey] = EmployeeTimeModel(
          dayName: timeKey,
          startDate: timeData.dateTime,
          isDayOff: isDayOff,
          isLateWithReason: isLateWithReason.value,
          reasonOfLate: lateReasonController.text,
          totalLate: totalLate,
          endDate: null,
          totalDate: null,
          isDayEnd: false,
          isEarlierWithReason: null,
          reasonOfEarlier: null,
          totalEarlier: null,
        );

        Get.snackbar("تم تسجيل الدخول بنجاح", "أهلاً بك ${user.userName}",
            backgroundColor: Colors.green.shade400, icon: const Icon(Icons.done));
      } else {
        Get.snackbar("فشل تسجيل الدخول", "لقد قمت بالدخول بالفعل ${user.userName}",
            backgroundColor: Colors.red.shade400, icon: const Icon(Icons.error_outline_rounded));
      }
    } else {
      final todayEntry = employeeTime[timeKey];
      if (todayEntry?.isDayEnd == true) {
        Get.snackbar("فشل تسجيل الخروج", "لقد قمت بالخروج بالفعل ${user.userName}",
            backgroundColor: Colors.red.shade400, icon: const Icon(Icons.error_outline_rounded));
      } else {
        if (timeData.isBefore(outHour, outMin)) {
          totalEarlier = now.copyWith(hour: outHour, minute: outMin).difference(now).inMinutes;
          await showReasonDialog(
            title: "خروج مبكر",
            message: "خرجت اليوم مبكراً",
            reasonController: earlierReasonController,
            withReasonNotifier: isEarlierWithReason,
          );
        }

        todayEntry!
          ..isEarlierWithReason = isEarlierWithReason.value
          ..totalEarlier = totalEarlier
          ..reasonOfEarlier = earlierReasonController.text
          ..endDate = now
          ..isDayEnd = true
          ..totalDate = now.difference(todayEntry.startDate!).inMinutes;

        Get.snackbar("تم تسجيل الخروج بنجاح", "وداعاً ${user.userName}",
            backgroundColor: Colors.green.shade400, icon: const Icon(Icons.done));
      }
    }

    await accountManagementFireStore.doc(user.id).update({"employeeTime": employeeTime.map((key, value) => MapEntry(key, value.toJson()))});

    update();
  }

  List<String> generateDaysInMonth(int year, int month) {
    int daysInMonth = DateTime(year, month + 1, 0).day;
    List<String> days = [];
    for (int day = 1; day <= daysInMonth; day++) {
      days.add(DateFormat('yyyy-MM-dd').format(DateTime(year, month, day)));
    }
    return days;
  }

  List<String> getAbsentDaysForEmployee(String empId, int year, int month) {
    List<String> daysInMonth = generateDaysInMonth(year, month);
    List<String> holidays = getHolidaysForMonth(year, month);

    daysInMonth.removeWhere(
      (element) => holidays.contains(element),
    );

    EmployeeModel employeeModel = allAccountManagement[empId]!;
    log('da' + daysInMonth.toString());
    log("emo time" + (employeeModel.employeeTime?.keys).toString());
    final normalizedEmployeeTimeKeys = employeeModel.employeeTime!.keys.map((key) => key.toString().trim()).toSet();

    List<String> employeeAbsentDays = daysInMonth.where((day) {
      return !normalizedEmployeeTimeKeys.contains(day.trim());
    }).toList();
    log('employeeAbsentDays' + employeeAbsentDays.toString());
    return employeeAbsentDays;
  }

  List<String> getHolidaysForMonth(int year, int month) {
    List<String> daysInMonth = generateDaysInMonth(year, month);

    Set<String> holidays = daysInMonth.toSet();

    for (var employee in allAccountManagement.values) {
      holidays.removeWhere((day) => employee.employeeTime!.containsKey(day) && employee.employeeTime![day]!.isDayEnd == true);
    }

    return holidays.toList();
  }

  List<String> monthCount = [];

  /// تُرجع خريطة حيث المفتاح هو الشهر بالشكل "yyyy-MM" والقيمة هي مجموعة من الأيام (بتنسيق "yyyy-MM-dd")
  /// التي تعتبر دوام، أي أنها مسجلة عند أي موظف وكان لديه سجل خروج (endDate != null).
  Map<String, Set<String>> getUniqueWorkingDaysByMonth(List<EmployeeModel> employees) {
    final Map<String, Set<String>> workingDaysByMonth = {};

    for (final employee in employees) {
      if (employee.employeeTime == null) continue;

      for (final entry in employee.employeeTime!.entries) {
        final dayKey = entry.key.toString();
        final timeRecord = entry.value;
        // اعتبار اليوم دوام إذا كان الموظف سجل خروج (endDate غير null)
        if (timeRecord.endDate != null) {
          final parts = dayKey.split("-");
          if (parts.length < 3) continue; // تأكد من تنسيق "yyyy-MM-dd"
          final monthKey = '${parts[0]}-${parts[1]}';
          workingDaysByMonth.putIfAbsent(monthKey, () => <String>{});
          workingDaysByMonth[monthKey]!.add(dayKey);
        }
      }
    }
    return workingDaysByMonth;
  }

  /// تقوم الدالة بتحديث سجلات كل موظف بحيث تُضاف سجلات الغياب للأيام التي تعتبر دوام
  /// (أي أنها موجودة عند أي موظف مع تسجيل خروج) ولكنها غير موجودة في سجل الموظف الحالي.
  void getAllUserAppend() {
    // الحصول على قائمة الموظفين من allAccountManagement
    final List<EmployeeModel> allEmployees = allAccountManagement.values.toList();

    // جمع الأيام التي تعتبر دوام عبر جميع الموظفين
    final Map<String, Set<String>> workingDaysByMonth = getUniqueWorkingDaysByMonth(allEmployees);

    // لكل موظف، يتم إضافة سجلات الغياب للأيام المفقودة التي تعتبر دوام
    for (var accountModel in allEmployees) {
      workingDaysByMonth.forEach((monthKey, workingDays) {
        for (var day in workingDays) {
          if (!accountModel.employeeTime!.containsKey(day)) {
            accountModel.employeeTime?[day] = EmployeeTimeModel(
              dayName: day,
              startDate: null,
              endDate: DateTime.now(),
              // يمكنك تعديل القيمة حسب الحاجة
              totalDate: null,
              isDayEnd: true,
              isLateWithReason: true,
              reasonOfLate: null,
              isEarlierWithReason: null,
              reasonOfEarlier: null,
              isDayOff: true,
              totalLate: null,
              totalEarlier: null,
            );
          }
        }
      });

      // ترتيب employeeTime حسب المفاتيح (أي التواريخ) لضمان تسلسل زمني صحيح
      final sortedEmployeeTime = Map.fromEntries(
        accountModel.employeeTime!.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      );
      accountModel.employeeTime = sortedEmployeeTime;
    }
  }

  void addCard({required String cardId}) {
    nfcController.text = cardId;
    print("------${cardId}");
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
} /*
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
        if (isLogIn) {
          if (user.employeeTime![timeData.formattedTime]?.startDate == null) {
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
            Get.snackbar("تم تسجيل الدخول بنجاح", "اهلا بك " + user.userName,
                backgroundColor: Colors.green.shade400, icon: Icon(Icons.done));

            accountManagementFireStore.doc(user.id).update(
                {"employeeTime": Map.fromEntries(user.employeeTime!.entries.map((e) => MapEntry(e.key, e.value.toJson())).toList())});
          } else {
            Get.snackbar("فشل تسجيل الدخول", "لقد قمت بالدخول بالفعل " + user.userName,
                backgroundColor: Colors.red.shade400, icon: Icon(Icons.error_outline_rounded));
          }
        }
        if (!isLogIn) {
          if (user.employeeTime![timeData.formattedTime]!.isDayEnd! ) {
            Get.snackbar("فشل تسجيل الخروج ", "لقد قمت بالخروج بالفعل " + user.userName,
                backgroundColor: Colors.red.shade400, icon: Icon(Icons.error_outline_rounded));
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
            Get.snackbar("تم تسجيل الخروج بنجاح", "وداعا" + user.userName, backgroundColor: Colors.green.shade400, icon: Icon(Icons.done));

            accountManagementFireStore.doc(user.id).update(
                {"employeeTime": Map.fromEntries(user.employeeTime!.entries.map((e) => MapEntry(e.key, e.value.toJson())).toList())});

          }
        }
      }

      update();
    } else {
      print("Not found");
    }
  }*/