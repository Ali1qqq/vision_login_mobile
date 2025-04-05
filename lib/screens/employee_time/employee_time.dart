import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_dashboard/screens/Widgets/AppButton.dart';
import '../../core/constant/constants.dart';
import '../../core/Styling/app_style.dart';
import 'Controller/Employee_view_model.dart';

class EmployeeTimeView extends StatefulWidget {
  @override
  State<EmployeeTimeView> createState() => _EmployeeTimeViewState();
}

class _EmployeeTimeViewState extends State<EmployeeTimeView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isSecure = true;
  EmployeeViewModel accountManagementViewModel = Get.find<EmployeeViewModel>();

  String selectedMonth = '';
  String selectedDay = '';
  String dayNameNow = '';

/*  List<bool> _isOpen   = List.generate(
      Get.find<AccountManagementViewModel>().allAccountManagement.length,
  (index) => false);*/
  final selectedDate = TextEditingController();
  final selectedYear = TextEditingController();

  @override
  void initState() {
    super.initState();

    accountManagementViewModel.initNFC(typeNFC.time);
    selectedMonth = months.entries
        .where(
          (element) => element.value == thisTimesModel!.month.toString().padLeft(2, "0"),
        )
        .first
        .key;
    dayNameNow = thisTimesModel!.formattedTime;
    selectedDate.text = thisTimesModel!.formattedTime;

    selectedYear.text = thisTimesModel!.year.toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final ScrollController scrollController = ScrollController();

  bool isShowLogin = true;
  List<String> data = [
    "اليوم",
    "الدخول",
    "الخروج",
    "المجموع",
    "التأخير",
    "عرض المبرر",
  ];
  List<String> empData = ["الموظف", "الخيارات"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<EmployeeViewModel>(builder: (controller) {
        return controller.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (controller.isSupportNfc && enableUpdate)
                    Column(
                      children: [
                        Text(
                          "تسجيل الدوام".tr,
                          style: AppStyles.headLineStyle1,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          accountManagementViewModel.isLogIn ? "سجل الدخول باستخدام بطاقتك".tr : "سجل الخروج باستخدام بطاقتك".tr,
                          style: TextStyle(fontSize: 22),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppButton(
                              text: "تسجيل دخول",
                              onPressed: () {
                                accountManagementViewModel.isLogIn = true;
                                accountManagementViewModel.update();
                              },
                              color: accountManagementViewModel.isLogIn ? Colors.green : Colors.blue,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            AppButton(
                              text: "تسجيل خروج",
                              onPressed: () {
                                accountManagementViewModel.isLogIn = false;
                                accountManagementViewModel.update();
                              },
                              color: accountManagementViewModel.isLogIn ? Colors.blue : Colors.green,
                            ),
                          ],
                        )
                      ],
                    )
                  else

                    ///الجهاز لا يدعم البطاقة
                    Center(
                      child: Container(
                        width: Get.width / 2,
                        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            "هذا الجهاز لا يحتوي قارئ NFC".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                    )
                ],
              );
      }),
    );
  }
}