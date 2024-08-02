import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';

import 'package:vision_dashboard/models/Salary_Model.dart';
import 'package:vision_dashboard/models/employee_time_model.dart';
import 'package:vision_dashboard/router.dart';
import 'package:vision_dashboard/screens/Buses/Controller/Bus_View_Model.dart';

import 'package:vision_dashboard/screens/Salary/controller/Salary_View_Model.dart';

import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Text_Filed.dart';
import 'package:vision_dashboard/utils/Dialogs.dart';

import '../../../constants.dart';
import '../../../controller/NFC_Card_View_model.dart';
import '../../../core/Utiles/service.dart';
import '../../../models/account_management_model.dart';
import '../../../models/event_model.dart';
import '../../../models/event_record_model.dart';
import '../../../utils/Hive_DataBase.dart';
import '../../../utils/To_AR.dart';
import '../../../controller/nfc/conditional_import.dart';
import '../Edite_Add_Employee/Employee_user_details.dart';

enum UserManagementStatus {
  first,
  login,
  block,
  auth,
}

enum typeNFC { login, time, add }

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

  /// when scan NFC Card
  TextEditingController nfcController = TextEditingController();

  /// we use this in Employee time
  bool isLoading = false;

  /// we use this in Employee time when expand employee time details
  List<bool> isOpen = [];
  RxMap<String, EmployeeModel> allAccountManagement = <String, EmployeeModel>{}.obs;
  final accountManagementFireStore = FirebaseFirestore.instance.collection(accountManagementCollection).withConverter<EmployeeModel>(
        fromFirestore: (snapshot, _) => EmployeeModel.fromJson(snapshot.data()!),
        toFirestore: (account, _) => account.toJson(),
      );
  final FirebaseStorage _storage = FirebaseStorage.instance;

  ///pluto header
  List<PlutoColumn> columns = [];

  /// pluto data
  List<PlutoRow> rows = [];

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

  /// we need this for Refresh pluto grid
  GlobalKey plutoKey = GlobalKey();

  EmployeeViewModel() {
    getColumns();
    getAllEmployee();
  }

  bool getIfDelete() {
    return checkIfPendingDelete(affectedId: currentId);
  }

  /// Refresh pluto header when change language
  getColumns() {
    columns.clear();
    columns.addAll(toAR(data));
  }

  /// we use this for cancel listener
  late StreamSubscription<QuerySnapshot<EmployeeModel>> listener;

  getAllEmployee() {
    listener = accountManagementFireStore.snapshots().listen(
      (event) async {
        isLoading = false;
        update();
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
                data.keys.elementAt(5): PlutoCell(value: i.data().isActive == true ? "فعال".tr : "غير فعال".tr),
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
                data.keys.elementAt(16): PlutoCell(value: i.data().isAccepted == true ? "تمت الموافقة".tr : "في انتظار الموافقة".tr),
              },
            ),
          );
          return MapEntry(i.id.toString(), i.data());
        })).obs;
        isOpen = List.generate(allAccountManagement.length, (index) => false);
        isLoading = true;
        update();
      },
    );
  }

  getAllEmployeeWithoutListen() {
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

  updateAccount(EmployeeModel accountModel) {
    accountManagementFireStore.doc(accountModel.id).update(accountModel.toJson());
  }

  deleteAccount(EmployeeModel accountModel) {
    accountManagementFireStore.doc(accountModel.id).delete();
  }

  deleteUnAcceptedAccount(String accountModelId) {
    accountManagementFireStore.doc(accountModelId).delete();
  }

  toggleStatusAccount(EmployeeModel accountModel) {
    accountManagementFireStore.doc(accountModel.id).update({"isActive": !accountModel.isActive});
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

  adReceiveSalary(String accountId, String paySalary, String salaryDate, String constSalary, String dilaySalary, bytes) async {
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
            signImage: fileName,
          ));

          if (double.parse(paySalary).toInt() != double.parse(dilaySalary).toInt())
            await addWaitOperation(collectionName: accountManagementCollection, affectedId: accountId, type: waitingListTypes.waitDiscounts, details: "الراتب الممنوح".tr + " ($paySalary) " + "الراتب المستحق".tr + " ($dilaySalary) ");
          Get.back();
          Get.back();
        }
      },
    );
  }

  bool isSupportNfc = false;

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

  String? userName;
  String? password;

  String? serialNFC;
  EmployeeModel? myUserModel;

  UserManagementStatus? userStatus;

  void checkUserStatus() async {
    if (userName != null) {
      FirebaseFirestore.instance.collection(accountManagementCollection).where('userName', isEqualTo: userName).where("password", isEqualTo: password).snapshots().listen((value) async {
        if (userName == null) {
          userStatus = UserManagementStatus.first;
          // print("1");
          // Get.offNamed(AppRoutes.main);
        } else if (value.docs.isNotEmpty) {
          // print("2");
          // print(value.docs.length);
          myUserModel = EmployeeModel.fromJson(value.docs.first.data());
          HiveDataBase.setCurrentScreen("0");

          await HiveDataBase.setUserData(id: myUserModel!.id, name: myUserModel!.userName, type: myUserModel!.type, serialNFC: myUserModel!.serialNFC ?? '', userName: myUserModel!.userName);
          await HiveDataBase.deleteAccountManagementModel();
          await HiveDataBase.setAccountManagementModel(myUserModel!);

          userStatus = UserManagementStatus.login;
          Get.offNamed(AppRoutes.DashboardScreen);
        } else if (value.docs.isEmpty) {
          // print("3");
          if (Get.currentRoute != AppRoutes.main) {
            userStatus = UserManagementStatus.first;
            Get.offNamed(AppRoutes.main);
          } else {
            Get.snackbar("error", "not matched");
          }
          userName = null;
          serialNFC = null;
        } else {
          userStatus = null;
        }
        update();
      });
    }
    /*else if (serialNFC != null) {
      FirebaseFirestore.instance
          .collection(accountManagementCollection)
          .where('serialNFC', isEqualTo: serialNFC)
          .snapshots()
          .listen((value) {
        if (serialNFC == null) {
          userStatus = UserManagementStatus.first;
          Get.offNamed(AppRoutes.main);
        } else if (value.docs.first.data()["isDisabled"]) {
          Get.snackbar("خطأ", "تم إلغاء تفعيل البطاقة");
          userStatus = UserManagementStatus.first;
          Get.offNamed(AppRoutes.main);
        } else if (value.docs.isNotEmpty) {
          myUserModel =
              AccountManagementModel.fromJson(value.docs.first.data());
          userStatus = UserManagementStatus.login;
          Get.offAll(() => MainScreen());
        } else if (value.docs.isEmpty) {
          if (Get.currentRoute != "/LoginScreen") {
            userStatus = UserManagementStatus.first;
            Get.offAll(() => LoginScreen());
          } else {
            Get.snackbar("error", "not matched");
          }
          userName = null;
          password = null;
          serialNFC = null;
        } else {
          userStatus = null;
        }
        update();
      });
    }*/
    else {
      WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
        userStatus = UserManagementStatus.first;
        Get.offNamed(AppRoutes.main);
      });
    }
  }

  String? loginUserPage;

  Future<void> addTime({String? cardId, String? userName, String? password}) async {
    bool? isLateWithReason;
    bool isDayOff = false;
    int totalLate = 0;
    int totalEarlier = 0;
    TextEditingController lateReasonController = TextEditingController();
    print(cardId);
    print("add Time");
    EmployeeModel? user;
    if (cardId != null) {
      user = allAccountManagement.values
          .where(
            (element) => element.serialNFC == cardId,
          )
          .firstOrNull;
    } else {
      user = allAccountManagement.values
          .where(
            (element) => element.userName == userName,
          )
          .firstOrNull;
    }
    print(user?.id);
    if (user != null) {
      getTime().then(
        (timeData) async {
          if (timeData != null) {
            // print(timeData.hour);
            if (user!.employeeTime[timeData.formattedTime] == null) {
              if (timeData.isAfter(8, 31)) {
                totalLate = timeData.dateTime.difference(DateTime.now().copyWith(hour: 7, minute: 41, second: 0)).inMinutes;
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
              } else if (timeData.isAfter(7, 40)) {
                totalLate = timeData.dateTime.difference(DateTime.now().copyWith(hour: 7, minute: 41, second: 0)).inMinutes;
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

              user.employeeTime[timeData.formattedTime] = EmployeeTimeModel(
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
            } else if (user.employeeTime[timeData.formattedTime]!.isDayEnd!) {
              loginUserPage = "لقد قمت بالخروج بالفعل " + user.userName;
              print("You close the day already");
            } else {
              if (timeData.isBefore(14, 00)) {
                totalEarlier = timeData.dateTime.copyWith(hour: 14, minute: 00, second: 0).difference(timeData.dateTime).inMinutes;

              }

              user.employeeTime[timeData.formattedTime]!.isEarlierWithReason = true;
              user.employeeTime[timeData.formattedTime]!.totalEarlier = totalEarlier;
              user.employeeTime[timeData.formattedTime]!.reasonOfEarlier = '';
              loginUserPage = "وداعا " + user.userName;
              user.employeeTime[timeData.formattedTime]!.endDate = timeData.dateTime.copyWith(hour: timeData.hour, day: timeData.day, minute: timeData.minute);
              ;
              user.employeeTime[timeData.formattedTime]!.isDayEnd = true;
              user.employeeTime[timeData.formattedTime]!.totalDate = timeData.dateTime.difference(user.employeeTime[timeData.formattedTime]!.startDate!).inMinutes;
            }
            accountManagementFireStore.doc(user.id).update({"employeeTime": Map.fromEntries(user.employeeTime.entries.map((e) => MapEntry(e.key, e.value.toJson())).toList())});

            update();
            await Future.delayed(Duration(seconds: 4));
            loginUserPage = null;
            update();
          }
        },
      );
    } else {
      print("Not found");
    }
  }

  getOldData(String value) {
    FirebaseFirestore.instance.collection(archiveCollection).doc(value).collection(accountManagementCollection)
      .get().then(
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
                  data.keys.elementAt(13): PlutoCell(value: Get.find<BusViewModel>().busesMap[i.data()["bus"].toString()]?.name ?? i.data()["bus"]),
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

  double getAllSalariesAtMonth(String month) {
    double pay = 0.0;
    allAccountManagement.forEach(
      (key, value) {
        if (value.employeeTime.entries.where(
          (element) {
            return element.key.toString().split("-")[1] == month.padLeft(2, "0");
          },
        ).isNotEmpty) {
          EmployeeModel accountModel = value;
          int totalLateAndEarlier = (accountModel.employeeTime.isEmpty
                      ? 0
                      : accountModel.employeeTime.values.where(
                            (element) {
                              return element.isDayOff != true && element.isLateWithReason != true;
                            },
                          ).length /
                          3)
                  .floor() *
              75;
          totalLateAndEarlier += (accountModel.employeeTime.isEmpty
                      ? 0
                      : accountModel.employeeTime.values.where(
                            (element) {
                              return element.isDayOff != true && element.endDate == null;
                            },
                          ).length /
                          3)
                  .floor() *
              75;
          int totalDayOff = (accountModel.employeeTime.isEmpty
                  ? 0
                  : accountModel.employeeTime.values.where(
                      (element) {
                        return element.isDayOff == true;
                      },
                    ).length) *
              (accountModel.salary! / accountModel.dayOfWork!).round();

          pay += accountModel.salary! - totalDayOff - totalLateAndEarlier;
        }
        //   AccountManagementModel accountModel = value;
        //   int totalLate = accountModel.employeeTime.isEmpty
        //       ? 0
        //       : accountModel.employeeTime.values
        //           .map((e) => e.totalLate ?? 0)
        //           .reduce((value, element) => value + element);
        //   int totalEarlier = accountModel.employeeTime.isEmpty
        //       ? 0
        //       : accountModel.employeeTime.values
        //           .map((e) => e.totalEarlier ?? 0)
        //           .reduce((value, element) => value + element);
        //   int totalTime = totalLate + totalEarlier;
        //   pay += ((accountModel.salary!) -
        //       ((accountModel.salary! / accountModel.dayOfWork!) *
        //           ((totalTime / 60).floor() * 0.5)));
        // }
      },
    );
    return pay;
  }

  double getUserSalariesAtMonth(String month, String user) {
    double pay = 0.0;
    if (allAccountManagement[user]!
        .employeeTime
        .entries
        .where(
          (element) => element.key.toString().split("-")[1] == month.padLeft(2, "0").toString(),
        )
        .isNotEmpty) {
      EmployeeModel accountModel = allAccountManagement[user]!;
      int totalLateAndEarlier = (accountModel.employeeTime.isEmpty
                  ? 0
                  : accountModel.employeeTime.values.where(
                        (element) {
                          return element.isDayOff != true && element.isLateWithReason != true;
                        },
                      ).length /
                      3)
              .floor() *
          75;
      totalLateAndEarlier += (accountModel.employeeTime.isEmpty
                  ? 0
                  : accountModel.employeeTime.values.where(
                        (element) {
                          return element.isDayOff != true && element.endDate == null;
                        },
                      ).length /
                      3)
              .floor() *
          75;
      int totalDayOff = (accountModel.employeeTime.isEmpty
              ? 0
              : accountModel.employeeTime.values.where(
                  (element) {
                    return element.isDayOff == true;
                  },
                ).length) *
          (accountModel.salary! / accountModel.dayOfWork!).round();

      pay += accountModel.salary! - totalDayOff - totalLateAndEarlier;
      // int totalLate = accountModel.employeeTime.isEmpty
      //     ? 0
      //     : accountModel.employeeTime.values
      //         .map((e) => e.totalLate ?? 0)
      //         .reduce((value, element) => value + element);
      // int totalEarlier = accountModel.employeeTime.isEmpty
      //     ? 0
      //     : accountModel.employeeTime.values
      //         .map((e) => e.totalEarlier ?? 0)
      //         .reduce((value, element) => value + element);
      // int totalTime = totalLate + totalEarlier;
      // pay += ((accountModel.salary!) -
      //     ((accountModel.salary! / accountModel.dayOfWork!) *
      //         ((totalTime / 60).floor() * 0.5)));
    }

    return pay;
  }

  double getAllUserSalariesAtMonth(String user) {
    double pay = 0.0;
    if (allAccountManagement[user]!.employeeTime.entries.isNotEmpty) {
      EmployeeModel accountModel = allAccountManagement[user]!;
      int totalLateAndEarlier = (accountModel.employeeTime.isEmpty
                  ? 0
                  : accountModel.employeeTime.values.where(
                        (element) {
                          return element.isDayOff != true && element.isLateWithReason != true;
                        },
                      ).length /
                      3)
              .floor() *
          75;
      totalLateAndEarlier += (accountModel.employeeTime.isEmpty
                  ? 0
                  : accountModel.employeeTime.values.where(
                        (element) {
                          return element.isDayOff != true && element.endDate == null;
                        },
                      ).length /
                      3)
              .floor() *
          75;
      int totalDayOff = (accountModel.employeeTime.isEmpty
              ? 0
              : accountModel.employeeTime.values.where(
                  (element) {
                    return element.isDayOff == true;
                  },
                ).length) *
          (accountModel.salary! / accountModel.dayOfWork!).round();

      pay += accountModel.salary! - totalDayOff - totalLateAndEarlier;
      // int totalLate = accountModel.employeeTime.isEmpty
      //     ? 0
      //     : accountModel.employeeTime.values
      //         .map((e) => e.totalLate ?? 0)
      //         .reduce((value, element) => value + element);
      // int totalEarlier = accountModel.employeeTime.isEmpty
      //     ? 0
      //     : accountModel.employeeTime.values
      //         .map((e) => e.totalEarlier ?? 0)
      //         .reduce((value, element) => value + element);
      // int totalTime = totalLate + totalEarlier;
      // pay += ((accountModel.salary!) -
      //     ((accountModel.salary! / accountModel.dayOfWork!) *
      //         ((totalTime / 60).floor() * 0.5)));
    }

    return pay;
  }

  List<double> getUserTimeToday(String day) {
    // String day = /*DateTime.now().day.toString()*/ "2024-07-16";
    List<double> time = [0.0];
    allAccountManagement.forEach(
      (key, value) {
        if (value.employeeTime.entries
            .where(
              (element) => element.key.toString() == day && element.value.isDayOff != true,
            )
            .isNotEmpty) {
          EmployeeModel accountModel = value;
          int totalLate = accountModel.employeeTime.isEmpty
              ? 0
              : accountModel.employeeTime.values
                      .where(
                        (element) => element.dayName == day,
                      )
                      .map((e) => e.totalLate ?? 0)
                      .firstOrNull ??
                  0;
          /*.reduce((value, element) => value + element);*/
          // int totalEarlier =   accountModel.employeeTime.isEmpty
          //     ? 0
          //     : accountModel.employeeTime.values
          //         .map((e) => e.totalEarlier ?? 0)
          //         .reduce((value, element) => value + element);
          double totalTime = (totalLate + 0 * 1.0);

          /* if (totalTime > 8)
            time.add(8);
          else*/
          time.add(8 - (totalTime / 60));
        } else
          time.add(0.0);
      },
    );

    return time;
  }

  void addCard({required String cardId}) {
    nfcController.text = cardId;
    print("------${cardId}");
  }

  setAccepted(String affectedId) async {
    FirebaseFirestore.instance.collection(accountManagementCollection).doc(affectedId).set({"isAccepted": true}, SetOptions(merge: true));
  }

  setBus(String busId, List employee) async {
    for (var employee in employee) FirebaseFirestore.instance.collection(accountManagementCollection).doc(employee).set({"bus": busId}, SetOptions(merge: true));
  }

  setAppend(String userId, date) {
    allAccountManagement[userId]!.employeeTime[date] = EmployeeTimeModel(
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
    accountManagementFireStore.doc(userId).update({"employeeTime": Map.fromEntries(allAccountManagement[userId]!.employeeTime.entries.map((e) => MapEntry(e.key, e.value.toJson())).toList())});
  }

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

  /// change current selected id
  void setCurrentId(value) {
    currentId = value;
    update();
  }

  bool enableEdit = false;

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
        EmployeeModel model = EmployeeModel(
          id: !enableEdit ? generateId("EMPLOYEE") : employeeModel!.id,
          userName: userNameController.text,
          fullName: fullNameController.text,
          password: userPassController.text,
          type: role,
          serialNFC: selectedCardId,
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
              employeeModel!.serialNFC.toString(),
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
            collectionName: accountManagementCollection,
            affectedId: model.id,
            details: model.toJson().toString(),
            type: waitingListTypes.add,
          );
        }

        if (enableEdit) Get.back();
        Get.back();
        await addAccount(model);
        getSuccessDialog(context);
        Get.find<NfcCardViewModel>().setCardForEMP(selectedCardId, model.id);
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
  void showEmployeeInputDialog(BuildContext context) {
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
            height: Get.height / 2,
            width: Get.width / 1.5,
            child: EmployeeInputForm(),
          ),
        );
      },
    );
  }

  addEmployeeEvent() {
    eventRecords.add(EventRecordModel(
      body: bodyEvent.text,
      type: selectedEvent!.name,
      date: thisTimesModel!.dateTime.toString().split(".")[0],
      color: selectedEvent!.color.toString(),
    ));
    bodyEvent.clear();
    update();
  }
}
