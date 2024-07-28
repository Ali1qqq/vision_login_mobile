
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:vision_dashboard/controller/event_view_model.dart';

import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import 'package:vision_dashboard/screens/Widgets/Custom_Text_Filed.dart';

import '../../constants.dart';
import '../../controller/home_controller.dart';
import '../../models/event_model.dart';
import '../../utils/const.dart';

class EventInputForm extends StatefulWidget {
  @override
  _EventInputFormState createState() => _EventInputFormState();
}

class _EventInputFormState extends State<EventInputForm> {
  String? role;
  TextEditingController name = TextEditingController();
  TextEditingController pass = TextEditingController();
  HomeViewModel homeViewModel = Get.find<HomeViewModel>();
  int selectedColor = 4294198070;

  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("إضافة حدث".tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
            SizedBox(height: 50,),
            Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 25,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [

                CustomTextField(controller: name, title: "اسم الحدث".tr),

                SizedBox(
                  width: 50,
                ),
                Text("المستهدف".tr),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                    width: 100,
                    height: 50,
                    child: DropdownButton(
                  value: role ?? Const.eventTypeStudent,
                  isExpanded: true,
                  onChanged: (_) {
                    role = _;
                    setState(() {});
                  },
                  items: Const.allEventType.map((e) => DropdownMenuItem(value: e.toString(), child: Text(getEventTypeFromEnum(e)))).toList(),
                )),
              ],
            ),
            SizedBox(height: 50,),
            SizedBox(
              width: Get.width * 0.5,
              child: MaterialColorPicker(
                  colors: [Colors.red, Colors.pink, Colors.purple, Colors.deepPurple, Colors.indigo, Colors.blue, Colors.lightBlue, Colors.cyan, Colors.teal, Colors.green, Colors.lime, Colors.yellow, Colors.amber, Colors.orange, Colors.deepOrange, Colors.brown, Colors.blueGrey],
                  allowShades: false,
                  onMainColorChange: (ColorSwatch? color) {
                    selectedColor = color!.value;
                    setState(() {});
                  },
                  selectedColor: Color(selectedColor)),
            ),
            SizedBox(height: 50,),
            AppButton(text: "حفظ".tr,   onPressed: () {
              role ??= Const.eventTypeStudent;
              EventModel model = EventModel(name: name.text, id:generateId("EVENT"), role: role!, color: selectedColor);
              name.clear();
              pass.clear();
              role = null;
              EventViewModel eventViewModel = Get.find<EventViewModel>();
              eventViewModel.addEvent(model);
              setState(() {});
            },)

          ],
        ),
      ),
    );
  }
}
