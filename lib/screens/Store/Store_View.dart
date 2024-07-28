import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Store/Store_Input.dart';
import 'package:vision_dashboard/screens/Store/Store_Screen.dart';


import '../../constants.dart';

class StoreViewPage extends StatefulWidget {
  const StoreViewPage({super.key});

  @override
  State<StoreViewPage> createState() => _StoreViewPageState();
}

class _StoreViewPageState extends State<StoreViewPage>{
  bool isAdd=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: AnimatedCrossFade(
        duration: Duration(milliseconds: 500),
        firstChild: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.height),
          child: StoreScreen(),
        ),
        secondChild: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.height),
          child: StoreInputForm(),
        ),
        crossFadeState: isAdd ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:primaryColor,
        onPressed: () {
          setState(() {
            isAdd = !isAdd;
          });
        },
        child: Icon(!isAdd? Icons.add:Icons.grid_view,color: Colors.white,),
      ),
    );
  }
}
