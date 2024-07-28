import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/controller/account_management_view_model.dart';

import 'package:vision_dashboard/screens/account_management/account_management_screen.dart';

import '../../constants.dart';
import 'Employee_user_details.dart';


class EmployeeView extends StatefulWidget {
  EmployeeView({super.key});

  @override
  State<EmployeeView> createState() => _EmployeeViewState();
}

class _EmployeeViewState extends State<EmployeeView> {
  bool isAdd=false;

  @override
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountManagementViewModel>(
      builder: (context) {
        return Scaffold(

          body: AnimatedCrossFade(
            duration: Duration(milliseconds: 500),
            firstChild: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: Get.height),
              child: AccountManagementScreen(),
            ),
            secondChild: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: Get.height),
              child: EmployeeInputForm(),
            ),
            crossFadeState: isAdd ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          ),
          floatingActionButton:enableUpdate?FloatingActionButton(
            backgroundColor:primaryColor,
            onPressed: () {
              setState(() {
                isAdd = !isAdd;
              });
            },
            child: Icon(!isAdd? Icons.add:Icons.grid_view,color: Colors.white,),
          ):Container(),

        );
      }
    );
  }
}




