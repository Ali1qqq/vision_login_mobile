import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/expenses/expenses_input_form.dart';
import 'package:vision_dashboard/screens/expenses/expenses_users_screen.dart';
import '../../constants.dart';


class ExpensesViewScreen extends StatefulWidget {
  ExpensesViewScreen({super.key});

  @override
  State<ExpensesViewScreen> createState() => _ExpensesViewScreenState();
}

class _ExpensesViewScreenState extends State<ExpensesViewScreen> {
  bool isAdd=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedCrossFade(
        duration: Duration(milliseconds: 500),
        firstChild: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.height),
          // child: AllExp(),
          child: ExpensesScreen(),
        ),
        secondChild: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.height),
          child: ExpensesInputForm(),
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
}




