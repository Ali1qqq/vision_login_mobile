import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/core/Styling/app_colors.dart';
import 'package:vision_dashboard/core/Styling/app_style.dart';
import 'package:vision_dashboard/screens/Study%20Fees/Controller/Study_Fees_View_Model.dart';
import '../../constants.dart';
import '../Parents/Controller/Parents_View_Model.dart';
import '../Widgets/Custom_Pluto_Grid.dart';
import '../Widgets/Square_Widget.dart';
import '../Widgets/View_shape_Widget.dart';
import '../Widgets/header.dart';

class StudyFeesView extends StatefulWidget {
  const StudyFeesView({super.key});

  @override
  State<StudyFeesView> createState() => _StudyFeesViewState();
}

class _StudyFeesViewState extends State<StudyFeesView> {
  int inkwellIndex = 3;

  ParentsViewModel parentViewModel = Get.find<ParentsViewModel>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudyFeesViewModel>(builder: (controller) {

      return Scaffold(
        appBar: Header(context: context, title: 'الرسوم الدراسية'.tr, middleText: "تعرض هذه الواجهة اجمالي ادفعات المستلمة من الطلاب و اجمالي الدفعات الخير مستلمة واجمالي الدفعات المتأخرة عن الدفع عن هذا الشهر مع جدول يوضح تفاصيل الدفعات لكل اب مع امكانية استلام دفعة او التراجع عنها".tr),
        body: SingleChildScrollView(

            child:  Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: Get.width,
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: MediaQuery.sizeOf(context).width < 800 ? WrapAlignment.center : WrapAlignment.spaceEvenly,
                      runSpacing: 25,
                      spacing: 10,
                      children: [
                        InkWell(
                            onTap: () {
                              controller.setInkwellIndex(0);
                            },
                            child: SquareWidget(title: "الدفعات القادمة".tr, body: "${parentViewModel.getAllNunReceivePay()}", color: AppColors.textColor, png: "assets/poor.png")),
                        InkWell(
                            onTap: () {
                              controller.setInkwellIndex(1);
                            },
                            child: SquareWidget(title: "الدفعات المستلمة".tr, body: "${parentViewModel.getAllReceivePay()}", color: AppColors.textColor, png: "assets/profit.png")),
                        InkWell(
                            onTap: () {
                              controller.setInkwellIndex(2);
                            },
                            child: SquareWidget(title: "الدفعات المتأخرة".tr, body: "${parentViewModel.getAllNunReceivePayThisMonth()}", color: Colors.redAccent, png: "assets/late-payment.png")),
                        InkWell(
                            onTap: () {
                              controller.setInkwellIndex(3);
                              setState(() {});
                            },
                            child: SquareWidget(title: "الاجمالي".tr, body: "${parentViewModel.getAllTotalPay()}", color: Colors.black, png: "assets/budget.png")),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding * 2,
                  ),
                  ViewShapeWidget(
                    titleWidget: Text(
                      "معلومات الدفعات",
                      style: AppStyles.headLineStyle1,
                    ),
                    bodyWidget: SizedBox(
                      height: Get.height - 180,
                      width:Get.width,
                      child: CustomPlutoGrid(
                        controller: controller,
                        selectedColor: controller.selectedColor,
                        idName: "الرقم التسلسلي",
                        onSelected: (event) {
                          controller.selectedColor=Colors.white.withOpacity(0.5);
                          controller.setCurrentId(event.row?.cells["الرقم التسلسلي"]?.value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )

        ),
        floatingActionButton: controller.currentId != ''
            ? FloatingActionButton(
                onPressed: () {
                  controller.showInstallmentDialog(context);
                },
                backgroundColor: primaryColor,
                child: Icon(
                  Icons.remove_red_eye_outlined,
                  color: Colors.white,
                ),
              )
            : SizedBox(),
      );
    });
  }






}
