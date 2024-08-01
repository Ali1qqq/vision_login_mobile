import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';

import 'package:vision_dashboard/models/Salary_Model.dart';
import 'package:vision_dashboard/models/employee_time_model.dart';
import 'package:vision_dashboard/router.dart';
import 'package:vision_dashboard/screens/Buses/Controller/Bus_View_Model.dart';

import 'package:vision_dashboard/screens/Salary/controller/Salary_View_Model.dart';

import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Text_Filed.dart';
import 'package:vision_dashboard/utils/Dialogs.dart';

import '../constants.dart';
import '../models/account_management_model.dart';
import '../utils/Hive_DataBase.dart';
import '../utils/To_AR.dart';
import 'nfc/conditional_import.dart';

enum UserManagementStatus {
  first,
  login,
  block,
  auth,
}

enum typeNFC { login, time, add }

class AccountManagementViewModel extends GetxController {
  bool isLoading=false;
  List<bool> isOpen=[];
  TextEditingController nfcController = TextEditingController();
  RxMap<String, AccountManagementModel> allAccountManagement =
      <String, AccountManagementModel>{}.obs;
  final accountManagementFireStore = FirebaseFirestore.instance
      .collection(accountManagementCollection)
      .withConverter<AccountManagementModel>(
        fromFirestore: (snapshot, _) =>
            AccountManagementModel.fromJson(snapshot.data()!),
        toFirestore: (account, _) => account.toJson(),
      );
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<PlutoColumn> columns = [];
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

  GlobalKey key = GlobalKey();

  AccountManagementViewModel() {
    getColumns();
    getAllEmployee();
  }

  getColumns() {
    columns.clear();
    columns.addAll(toAR(data));
  }

  late StreamSubscription<QuerySnapshot<AccountManagementModel>> listener;

  getAllEmployee() {
    listener = accountManagementFireStore.snapshots().listen(
      (event) async {
        isLoading=false;
        update();
        await Get.find<BusViewModel>().getAllWithoutListenBuse();
        key = GlobalKey();
        rows.clear();
        allAccountManagement = Map<String, AccountManagementModel>.fromEntries(
            event.docs.toList().map((i) {
          rows.add(
            PlutoRow(
              cells: {
                data.keys.elementAt(0): PlutoCell(value: i.id),
                data.keys.elementAt(1): PlutoCell(value: i.data().userName),
                data.keys.elementAt(2): PlutoCell(value: i.data().fullName),
                data.keys.elementAt(3): PlutoCell(value: i.data().password),
                data.keys.elementAt(4): PlutoCell(value: i.data().type),
                data.keys.elementAt(5): PlutoCell(value: i.data().isActive==true?"فعال".tr:"غير فعال".tr),
                data.keys.elementAt(6): PlutoCell(value: i.data().mobileNumber),
                data.keys.elementAt(7): PlutoCell(value: i.data().address),
                data.keys.elementAt(8): PlutoCell(value: i.data().nationality),
                data.keys.elementAt(9): PlutoCell(value: i.data().gender),
                data.keys.elementAt(10): PlutoCell(value: i.data().age),
                data.keys.elementAt(11): PlutoCell(value: i.data().jobTitle),
                data.keys.elementAt(12): PlutoCell(value: i.data().contract),
                data.keys.elementAt(13): PlutoCell(
                    value: Get.find<BusViewModel>()
                            .busesMap[i.data().bus.toString()]
                            ?.name ??
                        i.data().bus),
                data.keys.elementAt(14): PlutoCell(value: i.data().startDate),
                data.keys.elementAt(15):
                    PlutoCell(value: i.data().eventRecords?.length.toString()),
                data.keys.elementAt(16): PlutoCell(value: i.data().isAccepted==true?"تمت الموافقة".tr:"في انتظار الموافقة".tr),
              },
            ),
          );
          return MapEntry(i.id.toString(), i.data());
        })).obs;
        isOpen=List.generate(
            allAccountManagement.length,
                (index) => false);
        isLoading=true;
        update();
      },
    );
  }

  getAllEmployeeWithoutListen() {
    accountManagementFireStore.get().then(
      (event) async {
        await Get.find<BusViewModel>().getAllWithoutListenBuse();
        key = GlobalKey();
        rows.clear();
        allAccountManagement = Map<String, AccountManagementModel>.fromEntries(
            event.docs.toList().map((i) {
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
                data.keys.elementAt(13): PlutoCell(
                    value: Get.find<BusViewModel>()
                            .busesMap[i.data().bus.toString()]
                            ?.name ??
                        i.data().bus),
                data.keys.elementAt(14): PlutoCell(value: i.data().startDate),
                data.keys.elementAt(15):
                    PlutoCell(value: i.data().eventRecords?.length.toString()),
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

  addAccount(AccountManagementModel accountModel) {
    accountManagementFireStore
        .doc(accountModel.id)
        .set(accountModel, SetOptions(merge: true));
  }

  updateAccount(AccountManagementModel accountModel) {
    accountManagementFireStore
        .doc(accountModel.id)
        .update(accountModel.toJson());
  }

  deleteAccount(AccountManagementModel accountModel) {
    accountManagementFireStore.doc(accountModel.id).delete();
  }

  deleteUnAcceptedAccount(String accountModelId) {
    accountManagementFireStore.doc(accountModelId).delete();
  }

  toggleStatusAccount(AccountManagementModel accountModel) {
    accountManagementFireStore
        .doc(accountModel.id)
        .update({"isActive": !accountModel.isActive});
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

  adReceiveSalary(String accountId, String paySalary, String salaryDate,
      String constSalary, String dilaySalary, bytes) async {
    String fileName = 'signatures/$accountId/$salaryDate.png';
    // print(dilaySalary);
    // print(paySalary);
    uploadImage(bytes, fileName).then(
      (value) async {
        if (value != Error) {
          String salaryId = "${salaryDate} ${generateId("SALARY")}";
          await FirebaseFirestore.instance
              .collection(accountManagementCollection)
              .doc(accountId)
              .set({
            "discounts":
                (double.parse(paySalary) - double.parse(dilaySalary)).toInt(),
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

          if (double.parse(paySalary).toInt() !=
              double.parse(dilaySalary).toInt())
            await addWaitOperation(
                collectionName: accountManagementCollection,
                affectedId: accountId,
                type: waitingListTypes.waitDiscounts,
                details: "الراتب الممنوح".tr +
                    " ($paySalary) " +
                    "الراتب المستحق".tr +
                    " ($dilaySalary) ");
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
  AccountManagementModel? myUserModel;

  UserManagementStatus? userStatus;

  void checkUserStatus() async {
    if (userName != null) {
      FirebaseFirestore.instance
          .collection(accountManagementCollection)
          .where('userName', isEqualTo: userName)
          .where("password", isEqualTo: password)
          .snapshots()
          .listen((value) async {
        if (userName == null) {
          userStatus = UserManagementStatus.first;
          // print("1");
          // Get.offNamed(AppRoutes.main);
        } else if (value.docs.isNotEmpty) {
          // print("2");
          // print(value.docs.length);
          myUserModel =
              AccountManagementModel.fromJson(value.docs.first.data());
          HiveDataBase.setCurrentScreen("0");

      await    HiveDataBase.setUserData(
              id: myUserModel!.id,
              name: myUserModel!.userName,
              type: myUserModel!.type,
              serialNFC: myUserModel!.serialNFC ?? '',
              userName: myUserModel!.userName);
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
      WidgetsFlutterBinding.ensureInitialized()
          .waitUntilFirstFrameRasterized
          .then((value) {
        userStatus = UserManagementStatus.first;
        Get.offNamed(AppRoutes.main);
      });
    }
  }

/*  void signInUsingNFC(String cardId) {
    print(cardId);
    Get.offAll(() => MainScreen());
  }*/

  String? loginUserPage;

  Future<void> addTime(
      {String? cardId, String? userName, String? password}) async {
    bool? isLateWithReason;
    bool isDayOff = false;
    int totalLate = 0;
    int totalEarlier = 0;
    TextEditingController lateReasonController = TextEditingController();
    print(cardId);
    print("add Time");
    AccountManagementModel? user;
    if (cardId != null) {
      user = allAccountManagement.values
          .where(
            (element) => element.serialNFC == cardId,
          )
          .firstOrNull;
    } else {
      user = allAccountManagement.values
          .where(
            (element) =>
                element.userName == userName ,
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
                totalLate = timeData.dateTime
                    .difference(
                        DateTime.now().copyWith(hour: 7, minute: 41, second: 0))
                    .inMinutes;
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
                              CustomTextField(
                                  controller: lateReasonController,
                                  title: "سبب التأخر".tr),
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
                totalLate = timeData.dateTime
                    .difference(
                        DateTime.now().copyWith(hour: 7, minute: 41, second: 0))
                    .inMinutes;
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
                              CustomTextField(
                                  controller: lateReasonController,
                                  title: "سبب التأخر".tr),
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
                  startDate: timeData.dateTime.copyWith(
                      hour: timeData.hour,
                      day: timeData.day,
                      minute: timeData.minute),
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
                totalEarlier = timeData.dateTime
                    .copyWith(hour: 14, minute: 00, second: 0)
                    .difference(timeData.dateTime)
                    .inMinutes;
                /*    await Get.defaultDialog(
                    barrierDismissible: false,
                    backgroundColor: Colors.white,
                    title: "لقد خرجت مبكرا ",
                    content: Container(),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text("موافق"))
                    ]);*/
              }

              user.employeeTime[timeData.formattedTime]!.isEarlierWithReason =
                  true;
              user.employeeTime[timeData.formattedTime]!.totalEarlier =
                  totalEarlier;
              user.employeeTime[timeData.formattedTime]!.reasonOfEarlier = '';
              loginUserPage = "وداعا " + user.userName;
              user.employeeTime[timeData.formattedTime]!.endDate =
                  timeData.dateTime.copyWith(
                      hour: timeData.hour,
                      day: timeData.day,
                      minute: timeData.minute);
              ;
              user.employeeTime[timeData.formattedTime]!.isDayEnd = true;
              user.employeeTime[timeData.formattedTime]!.totalDate = timeData
                  .dateTime
                  .difference(
                      user.employeeTime[timeData.formattedTime]!.startDate!)
                  .inMinutes;
            }
            accountManagementFireStore.doc(user.id).update({
              "employeeTime": Map.fromEntries(user.employeeTime.entries
                  .map((e) => MapEntry(e.key, e.value.toJson()))
                  .toList())
            });

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

  void disposeNFC() {}

  getOldData(String value) {
    FirebaseFirestore.instance
        .collection(archiveCollection)
        .doc(value)
        .collection(accountManagementCollection)
        ..get().then(
              (event) async {
            await Get.find<BusViewModel>().getAllWithoutListenBuse();
            key = GlobalKey();
            rows.clear();
            allAccountManagement = Map<String, AccountManagementModel>.fromEntries(
                event.docs.toList().map((i) {
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
                        data.keys.elementAt(13): PlutoCell(
                            value: Get.find<BusViewModel>()
                                .busesMap[i.data()["bus"].toString()]
                                ?.name ??
                                i.data()["bus"]),
                        data.keys.elementAt(14): PlutoCell(value: i.data()["startDate"]),
                        data.keys.elementAt(15):
                        PlutoCell(value: i.data()["eventRecords"]?.length.toString()),
                        data.keys.elementAt(16): PlutoCell(value: i.data()["isAccepted"]==true?"تمت الموافقة".tr:"في انتظار الموافقة".tr),
                      },
                    ),
                  );
                  return MapEntry(i.id.toString(),AccountManagementModel.fromJson(i.data()) );
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
            return element.key.toString().split("-")[1] ==
                month.padLeft(2, "0");
          },
        ).isNotEmpty) {
          AccountManagementModel accountModel = value;
          int totalLateAndEarlier = (accountModel.employeeTime.isEmpty
                      ? 0
                      : accountModel.employeeTime.values.where(
                            (element) {
                              return element.isDayOff != true &&
                                  element.isLateWithReason != true;
                            },
                          ).length /
                          3)
                  .floor() *
              75;
          totalLateAndEarlier += (accountModel.employeeTime.isEmpty
                      ? 0
                      : accountModel.employeeTime.values.where(
                            (element) {
                              return element.isDayOff != true &&
                                  element.endDate == null;
                            },
                          ).length /
                          3)
                  .floor() *
              75;
          // print(totalLateAndEarlier);
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
          (element) =>
              element.key.toString().split("-")[1] ==
              month.padLeft(2, "0").toString(),
        )
        .isNotEmpty) {
      AccountManagementModel accountModel = allAccountManagement[user]!;
      int totalLateAndEarlier = (accountModel.employeeTime.isEmpty
                  ? 0
                  : accountModel.employeeTime.values.where(
                        (element) {
                          return element.isDayOff != true &&
                              element.isLateWithReason != true ;
                        },
                      ).length /
                      3)
              .floor() *
          75;
      totalLateAndEarlier += (accountModel.employeeTime.isEmpty
          ? 0
          : accountModel.employeeTime.values.where(
            (element) {
          return element.isDayOff != true &&
              element.endDate == null;
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
  double getAllUserSalariesAtMonth( String user) {

    double pay = 0.0;
    if (allAccountManagement[user]!
        .employeeTime
        .entries
        .isNotEmpty) {
      AccountManagementModel accountModel = allAccountManagement[user]!;
      int totalLateAndEarlier = (accountModel.employeeTime.isEmpty
                  ? 0
                  : accountModel.employeeTime.values.where(
                        (element) {
                          return element.isDayOff != true &&
                              element.isLateWithReason != true ;
                        },
                      ).length /
                      3)
              .floor() *
          75;
      totalLateAndEarlier += (accountModel.employeeTime.isEmpty
          ? 0
          : accountModel.employeeTime.values.where(
            (element) {
          return element.isDayOff != true &&
              element.endDate == null;
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
              (element) =>
                  element.key.toString() == day&&element.value.isDayOff!=true,
            )
            .isNotEmpty) {
          AccountManagementModel accountModel = value;
          int totalLate = accountModel.employeeTime.isEmpty
              ? 0
              : accountModel.employeeTime.values.where((element) =>  element.dayName == day,)
                  .map((e) => e.totalLate ?? 0).firstOrNull??0;
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
            time.add(8-(totalTime / 60));
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
    FirebaseFirestore.instance
        .collection(accountManagementCollection)
        .doc(affectedId)
        .set({"isAccepted": true}, SetOptions(merge: true));
  }

  setBus(String s, List emp) async {
    for (var employee in emp)
      FirebaseFirestore.instance
          .collection(accountManagementCollection)
          .doc(employee)
          .set({"bus": s}, SetOptions(merge: true));
  }

   setAppend(String userId,date) {
     allAccountManagement[userId]!
      .employeeTime[date] = EmployeeTimeModel(
         dayName: date,
         startDate: DateTime.now().copyWith(
             hour: 7,
             day: int.parse(date.toString().split("-")[1]),
             minute: 30),
         endDate: DateTime.now().copyWith(
             hour: 7,
             day: int.parse(date.toString().split("-")[1]),
             minute: 30),
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
       "employeeTime": Map.fromEntries(  allAccountManagement[userId]!.employeeTime.entries
           .map((e) => MapEntry(e.key, e.value.toJson()))
           .toList())
     });
   }
}

// AccountManagementModel getMyUserId() {
//   /* print( HiveDataBase.getUserData().id);
//   print( HiveDataBase.getUserData().userName);
//   print( HiveDataBase.getUserData().seralNFC);
//   print( HiveDataBase.getUserData().type);
//   print( HiveDataBase.getUserData().name);*/
//   // return "a";
//   // return AccountManagementModel(id: HiveDataBase.getUserData().id, userName: HiveDataBase.getUserData().userName, password: "", type:HiveDataBase.getUserData(). type, serialNFC:HiveDataBase.getUserData(). seralNFC, isActive: true, salary: 34, dayOfWork: 20);
//   //
//   return Get.find<AccountManagementViewModel>().myUserModel!;
// }
/*     String date = DateTime.now().toString().split(" ")[0];
      print(DateTime.now().hour);
      print(DateTime.now().minute);
      if (user.employeeTime[date] == null) {
        if (DateTime.now().hour > 7 ||
            (DateTime.now().hour == 7 && DateTime.now().minute > 30)) {
          isLateWithReason = false;
          totalLate = DateTime.now()
              .difference(
                  DateTime.now().copyWith(hour: 7, minute: 30, second: 0))
              .inMinutes;

          List listOfTotalLate = user.employeeTime.values
              .map(
                (e) => e.totalLate ?? 0,
              )
              .toList();

          int AllTotalLate = listOfTotalLate.isEmpty
              ? 0
              : listOfTotalLate.length > 2
                  ? listOfTotalLate[0]
                  : listOfTotalLate.reduce(
                        (value, element) =>
                            int.parse(value) + int.parse(element),
                      ) +
                      totalLate.toInt();
          await Get.defaultDialog(
              barrierDismissible: false,
              backgroundColor: Colors.white,
              title: "أنت متأخر ",
              content: Container(
                height: Get.width / 4,
                width: Get.width / 3,
                child: StatefulBuilder(
                  builder: (context, setstate) {
                    return Column(
                      children: [
                        Text("تأخرت اليوم " + DateFun.minutesToTime(totalLate)),
                        SizedBox(
                          height: 10,
                        ),
                        Text("مجموع التأخر " +
                            DateFun.minutesToTime(AllTotalLate)),
                        Row(
                          children: [
                            Checkbox(
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
                                value: isLateWithReason,
                                onChanged: (_) {
                                  isLateWithReason = _!;
                                  setstate(() {});
                                }),
                            Text("تأخر مبرر"),
                          ],
                        ),
                        Expanded(
                          child: TextFormField(
                            enabled: isLateWithReason,
                            decoration: InputDecoration(hintText: "سبب التأخر"),
                            controller: lateReasonController,
                          ),
                        )
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
        user.employeeTime[date] = EmployeeTimeModel(
            dayName: date,
            startDate: DateTime.now(),
            endDate: null,
            totalDate: null,
            isDayEnd: false,
            isLateWithReason: isLateWithReason,
            reasonOfLate: lateReasonController.text,
            totalLate: totalLate,
            isEarlierWithReason: null,
            reasonOfEarlier: null,
            totalEarlier: null);
        loginUserPage = "اهلا بك " + user.userName;
      }
      else if (user.employeeTime[date]!.isDayEnd!) {
        loginUserPage = "لقد قمت بالخروج بالفعل " + user.userName;
        print("You close the day already");
      } else {
        if (DateTime.now().hour < 14 ||
            (DateTime.now().hour == 14 && DateTime.now().minute < 30)) {
          isEarlierWithReason = false;
          totalEarlier = DateTime.now()
              .copyWith(hour: 14, minute: 30, second: 0)
              .difference(DateTime.now())
              .inMinutes;

          int AllTotalEarlier = (user.employeeTime.values
                      .map(
                        (e) => e.totalEarlier ?? 0,
                      )
                      .reduce(
                        (value, element) => value + element,
                      ) +
                  totalEarlier)
              .toInt();

          await Get.defaultDialog(
              barrierDismissible: false,
              backgroundColor: Colors.white,
              title: "لقد خرجت مبكرا ",
              content: Container(
                height: Get.width / 4,
                width: Get.width / 3,
                child: StatefulBuilder(
                  builder: (context, setstate) {
                    return Column(
                      children: [
                        Text("خرجبت مبكرا اليوم " +
                            DateFun.minutesToTime(totalEarlier)),
                        Text("مجموع الخروج المبكر " +
                            DateFun.minutesToTime(AllTotalEarlier)),
                        Row(
                          children: [
                            Checkbox(
                                value: !isEarlierWithReason!,
                                onChanged: (_) {
                                  isEarlierWithReason = !_!;
                                  setstate(() {});
                                }),
                            Text("خروج مبكر غير مبرر")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: isEarlierWithReason,
                                onChanged: (_) {
                                  isEarlierWithReason = _!;
                                  setstate(() {});
                                }),
                            Text("خروج مبكر مبرر"),
                          ],
                        ),
                        Expanded(
                          child: TextFormField(
                            enabled: isEarlierWithReason,
                            decoration:
                                InputDecoration(hintText: "سبب الخروج المبكر"),
                            controller: earlierReasonController,
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("موافق"))
              ]);
        }
        if (isEarlierWithReason != null) {
          user.employeeTime[date]!.isEarlierWithReason = isEarlierWithReason;
          user.employeeTime[date]!.totalEarlier = totalEarlier;
          user.employeeTime[date]!.reasonOfEarlier =
              earlierReasonController.text;
        }
        loginUserPage = "وداعا " + user.userName;
        user.employeeTime[date]!.endDate = DateTime.now();
        user.employeeTime[date]!.isDayEnd = true;
        user.employeeTime[date]!.totalDate = DateTime.now()
            .difference(user.employeeTime[date]!.startDate!)
            .inMinutes;
      }
      accountManagementFireStore.doc(user.id).update({
        "employeeTime": Map.fromEntries(user.employeeTime.entries
            .map((e) => MapEntry(e.key, e.value.toJson()))
            .toList())
      });

      update();
      await Future.delayed(Duration(seconds: 4));
      loginUserPage = null;
      update();*/
