import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/expenses/Controller/expenses_view_model.dart';
import 'package:vision_dashboard/screens/expenses/Input_Edit_Expenses/expenses_input_form.dart';
import 'package:vision_dashboard/screens/expenses/View_Expenses/expenses_users_screen.dart';
import '../../core/constant/constants.dart';


class ExpensesViewScreen extends StatefulWidget {
  ExpensesViewScreen({super.key});

  @override
  State<ExpensesViewScreen> createState() => _ExpensesViewScreenState();
}

class _ExpensesViewScreenState extends State<ExpensesViewScreen> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpensesViewModel>(
      builder: (expensesController) {
        return Scaffold(
          body: AnimatedCrossFade(
            duration: Duration(milliseconds: 500),
            firstChild: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: Get.height),

              child: ExpensesScreen(),
            ),
            secondChild: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: Get.height),
              child: ExpensesInputForm(),
            ),
            crossFadeState:expensesController. isAdd ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          ),
          floatingActionButton:enableUpdate?FloatingActionButton(
            backgroundColor:primaryColor,
            onPressed: () {
              expensesController.foldScreen();
          
            },
            child: Icon(!expensesController.isAdd? Icons.add:Icons.grid_view,color: Colors.white,),
          ):Container(),
        
        );
      }
    );
  }
}




