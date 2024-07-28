import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Settings/Settings_Screen.dart';
import 'package:vision_dashboard/screens/account_management/Employee_user_details.dart';


import '../../utils/Hive_DataBase.dart';
import 'Controller/Settings_View_Model.dart';


class SettingsView extends StatefulWidget {
  SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {



  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsViewModel>(
        builder: (context) {
          return Scaffold(

            body: AnimatedCrossFade(
              duration: Duration(milliseconds: 500),
              firstChild: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: Get.height),
                child: SettingsScreen(),
              ),
              secondChild: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: Get.height),
                child: EmployeeInputForm(accountManagementModel: HiveDataBase.getAccountManagementModel(),enableEdit:false),
              ),
              crossFadeState: HiveDataBase.getAccountManagementModel()!.type!='مالك' ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            ),
            // floatingActionButton:enableUpdate?FloatingActionButton(
            //   backgroundColor:primaryColor,
            //   onPressed: () {
            //     setState(() {
            //       isAdd = !isAdd;
            //     });
            //   },
            //   child: Icon(!isAdd? Icons.add:Icons.grid_view),
            // ):Container(),

          );
        }
    );
  }
}




