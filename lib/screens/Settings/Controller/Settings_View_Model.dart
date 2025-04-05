import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/core/binding/binding.dart';
import 'package:vision_dashboard/screens/login/login_screen.dart';

import '../../../core/constant/constants.dart';
import '../../../core/constant/const.dart';

class SettingsViewModel extends GetxController {

  Map<String, dynamic> settingsMap = {
    "AppendTime": {"Time": "8 00"},
    "LateTime": {"Time": "7 30"},
    "OutTime": {"Time": "14 00"},
    "FriAppendTime": {"Time": "7 30"},
    "FriLateTime": {"Time": "7 45"},
    "FriOutTime": {"Time": "11 45"},
  };

  TextEditingController lateTimeController = TextEditingController()..text = "0 0";
  TextEditingController appendTimeController = TextEditingController()..text = "0 0";
  TextEditingController outTimeController = TextEditingController()..text = "0 0";
  TextEditingController friLateTimeController = TextEditingController()..text = "0 0";
  TextEditingController friAppendTimeController = TextEditingController()..text = "0 0";
  TextEditingController friOutTimeController = TextEditingController()..text = "0 0";

  final fireStoreInstance = FirebaseFirestore.instance;

  SettingsViewModel() {
    getAllArchive();
    getAllSettings();
  }

  List allArchive = [];

  setTime(String time, String TimeName) async {
    await fireStoreInstance.collection(Const.settingsCollection).doc(TimeName).set({"Time": time});
    update();
  }

  getAllSettings() async {
    await fireStoreInstance.collection(Const.settingsCollection).snapshots().listen(
      (date) {
        settingsMap.clear();
        for (var element in date.docs) {
          settingsMap[element.id] = element.data();
        }
        update();
      },
    );
  }

  changeLanguage(String lan) async {
/*    HomeViewModel homeViewModel =Get.find<HomeViewModel>();
    homeViewModel.changeIsLoading();*/

    if (lan == 'عربي') {
      await Get.updateLocale(Locale("ar", 'ar'));
    } else {
      await Get.updateLocale(Locale("en", 'US'));
    }
    // await _busViewModel.getColumns();

    await Get.offAll(() => LoginScreen(), binding: GetBinding());
/* await   homeViewModel.changeIsLoading();
    // await  Get.offNamed(AppRoutes.EmployeeView);
    update();*/
  }

  getAllArchive() {
    fireStoreInstance.collection(archiveCollection).get().then(
      (event) {
        allArchive.clear();
        for (var value in event.docs) {
          allArchive.add(value.id);
        }
        allArchive.add("الافتراضي");
        update();
      },
    );
  }


  Future<void> deleteAllDocumentsInCollection(String collectionName) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collection = firestore.collection(collectionName);

    try {
      QuerySnapshot querySnapshot = await collection.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      print("Finished deleting all documents in $collectionName");
    } catch (e) {
      print("Error deleting documents in $collectionName: $e");
    }
  }


}