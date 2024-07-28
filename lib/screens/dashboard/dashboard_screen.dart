import 'package:get/get.dart';
import 'package:vision_dashboard/controller/account_management_view_model.dart';
import 'package:vision_dashboard/controller/Wait_management_view_model.dart';
import 'package:vision_dashboard/controller/expenses_view_model.dart';
import 'package:vision_dashboard/responsive.dart';
import 'package:vision_dashboard/screens/Salary/controller/Salary_View_Model.dart';
import 'package:vision_dashboard/screens/Student/Controller/Student_View_Model.dart';
import 'package:vision_dashboard/screens/dashboard/components/Employee_Salary_Chart.dart';
import 'package:vision_dashboard/screens/dashboard/components/Student_Detiles_Chart.dart';
import 'package:vision_dashboard/screens/dashboard/components/Total_info_Widget.dart';
import 'package:flutter/material.dart';


import '../../constants.dart';
import '../../utils/Hive_DataBase.dart';
import '../Widgets/Custom_Drop_down.dart';
import '../Widgets/header.dart';

import '../main/main_screen.dart';
import 'components/Employee_Time_Box.dart';
import 'components/Employee_Details_Chart.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int index = 2;
  StudentViewModel _studentViewModel = Get.find<StudentViewModel>();
  ExpensesViewModel _expensesViewModel = Get.find<ExpensesViewModel>();
  AccountManagementViewModel _accountManagementViewModel =
      Get.find<AccountManagementViewModel>();
  SalaryViewModel _salaryViewModel = Get.find<SalaryViewModel>();
  WaitManagementViewModel _deleteManagementViewModel =
      Get.find<WaitManagementViewModel>();

  String selectedMonth = '';
  bool isAll = false;

  @override
  void initState() {
    super.initState();

    selectedMonth = months.entries
        .where(
          (element) =>
              element.value == thisTimesModel!.month.toString().padLeft(2, "0"),
        )
        .first
        .key;

/*    Future.delayed(Duration(seconds: 3),() async{
      _studentViewModel.update();
      _expensesViewModel.update();
      _accountManagementViewModel.update();
      _salaryViewModel.update();
    },);*/
/*    WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {

    },);*/
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountManagementViewModel>(
      builder: (_) {
        return Scaffold(
          appBar: Header(
            // enableSearch: false,
              context: context,
              title: 'الصفحة الرئيسية'.tr,
              middleText:
                  "تعرض هذه الواجهة كل المعلومات الاساسية عن حالة المدرسة والتي هي مجموع المصاريف مجموع الدفعات الواردة اجمالي الربح السنوي و الرواتب المستحقة لهذا الشهر كما ايضا تظهر تفصيل اعداد الطلاب وتفصيل اعداد الموظفين بالاضافة لمعرفة اوقات دوام الموظفين والرواتب المستحقة لهم لكل شهر"
                      .tr),
          body:_.isLoading? SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            primary: false,
            padding: EdgeInsets.symmetric(vertical: defaultPadding*3,horizontal: defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: Get.width,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      CustomDropDown(
                        value: selectedMonth.toString().tr,
                        listValue: (months.keys
                                .map(
                                  (e) => e.toString().tr,
                                )
                                .toList()) +
                            ["الكل".tr],
                        label: "اختر الشهر".tr,
                        onChange: (value) {
                          if (value != null && value != "الكل") {
                            // print(value.tr);
                            selectedMonth = value.tr;

                            isAll = false;
                          } else {
                            isAll = true;
                          }
                          setState(() {});
                        },
                        isFullBorder: true,
                      ),
                      if (_deleteManagementViewModel.allWaiting.values
                          .where(
                            (element) => element.isAccepted == null,
                          )
                          .isNotEmpty)
                        InkWell(
                          onTap: () {
                            HiveDataBase.setCurrentScreen("12");
                            Get.offAll(MainScreen());
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                  padding: EdgeInsets.all(5),
                                  // decoration: BoxDecoration(color: Colors.red.withOpacity(1),shape: BoxShape.circle,),

                                  child: Icon(
                                    Icons.notifications_none_outlined,
                                    color: secondaryColor,
                                    size: 30,
                                  )),
                              Positioned(
                                  top: -5,
                                  right: -2,
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      _deleteManagementViewModel.allWaiting.values
                                          .where(
                                            (element) => element.isAccepted == null,
                                          )
                                          .length
                                          .toString(),
                                      style: Styles.headLineStyle4
                                          .copyWith(color: Colors.white),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                GetBuilder<ExpensesViewModel>(
                  builder: (_) {
                    return SizedBox(
                      width: Get.width,
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: MediaQuery.sizeOf(context).width < 800
                            ? WrapAlignment.center
                            : WrapAlignment.spaceEvenly,
                        runSpacing: 25,
                        spacing: 0,
                        children: [
                          InkWell(
                              onHover: (value) {},
                              onTap: () {
                                index = 2;
                                setState(() {});
                              },
                              child: SquareWidget(
                                  "الاجمالي",
                                  isAll
                                      ? (_studentViewModel.getAllReceivePay() -
                                          _expensesViewModel.getAllExpensesMoney() -
                                          _salaryViewModel.getAllSalaryPay())
                                      : (_studentViewModel.getAllReceivePayAtMonth(
                                                  months[selectedMonth]!) -
                                              _expensesViewModel.getExpensesAtMonth(
                                                  months[selectedMonth]!) -
                                              _accountManagementViewModel
                                                  .getAllSalariesAtMonth(months[
                                                      selectedMonth]! /*DateTime.now().month.toString()*/))
                                          .toString(),
                                  primaryColor,
                                  "assets/budget.png",
                                  true)),
                          InkWell(
                              onTap: () {
                                index = 1;
                                setState(() {});
                              },
                              child: SquareWidget(
                                  "الايرادات",
                                  isAll
                                      ? _studentViewModel.getAllReceivePay()
                                      : _studentViewModel
                                          .getAllReceivePayAtMonth(
                                              months[selectedMonth]!)
                                          .toString(),
                                  Colors.cyan,
                                  "assets/profit.png",
                                  true)),
                          InkWell(
                              onTap: () {
                                index = 0;
                                setState(() {});
                              },
                              child: SquareWidget(
                                  "المصروف",
                                  isAll
                                      ? _expensesViewModel.getAllExpensesMoney()
                                      : _expensesViewModel
                                          .getExpensesAtMonth(months[selectedMonth]!)
                                          .toString(),
                                  blueColor,
                                  "assets/poor.png",
                                  true)),
                          SquareWidget(
                              "الرواتب المستحقة",
                              _accountManagementViewModel
                                  .getAllSalariesAtMonth(
                                  thisTimesModel!.month.toString())
                                  .toString(),
                              Colors.black,
                              "assets/money-bag.png",
                              false),
                        ],
                      ),
                    );
                  }
                ),
                SizedBox(height: defaultPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TotalBarChartWidget(
                            index: index,
                          ),
                          SizedBox(height: defaultPadding),
                          EmployeeTimeBox(),
                          SizedBox(height: defaultPadding),
                          EmployeeSalaryChartBox(),
                          if (Responsive.isMobile(context))
                            SizedBox(height: defaultPadding),
                          if (Responsive.isMobile(context))
                            Column(
                              children: [
                                EmployeeDetailsChart(),
                                SizedBox(
                                  height: defaultPadding,
                                ),
                                StudentsDetailsChart(
                                  students: _studentViewModel.studentMap,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      SizedBox(width: defaultPadding),
                    // On Mobile means if the screen is less than 850 we don't want to show it
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            EmployeeDetailsChart(),
                            SizedBox(
                              height: defaultPadding,
                            ),
                            StudentsDetailsChart(
                              students: _studentViewModel.studentMap,
                            ),
                            SizedBox(
                              height: defaultPadding,
                            ),
                            SquareWidget(
                                "العام الدراسي".tr,
                                  "${thisTimesModel!.year}-${thisTimesModel!.year+1}",
                                Colors.black,
                                "assets/books.png",
                                false),
                            SizedBox(
                              height: defaultPadding*3,
                            ),
                          ],
                        ),
                      ),
                  ],
                )
              ],
            ),
          ):Center(child: CircularProgressIndicator(color: primaryColor,),),
        );
      }
    );
  }

  Widget SquareWidget(title, body, color, png, bool) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 275,
        width: 275,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: secondaryColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Center(
                    child: Text(
                  title.toString().tr,
                  textAlign: TextAlign.center,
                  style: Styles.headLineStyle2
                      .copyWith(color: color == false ? Colors.black : color),
                )),
              ),
            ),
            Text(
              body.toString(),
              style: Styles.headLineStyle1.copyWith(
                  color: color == false ? Colors.black : color, fontSize: 40),
            ),
            SizedBox(
              height: 20,
            ),
            color == false
                ? Image.asset(
                    png,
                    height: 100,
                    // color: color==false?Colors.transparent: color,
                  )
                : Image.asset(
                    png,
                    height: 70,
                    color: color,
                  ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
