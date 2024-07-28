/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constants.dart';

class InstallmentInput extends StatefulWidget {
  const InstallmentInput({super.key});

  @override
  State<InstallmentInput> createState() => _InstallmentInputState();
}

class _InstallmentInputState extends State<InstallmentInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 1.5,
      child: ListView(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.all(10),
        children: [
          Center(
              child:
              Text('سجل الدفعات'.tr, style: Styles.headLineStyle1)),
          SizedBox(
            height: defaultPadding,
          ),
          ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) => SizedBox(
                height: defaultPadding,
              ),
              physics: ClampingScrollPhysics(),
              itemCount: installmentStudent.length,
              itemBuilder: (context, parentIndex) {
                List<InstallmentModel> installment = installmentStudent
                    .values
                    .elementAt(
                    parentIndex) */
/*.where((element) => element.isPay!=true,)*//*

                    .toList();
                return Container(
                  alignment: Alignment.center,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: installment.length,
                    itemBuilder: (context, index) {
                      bool isLate = int.parse(
                          installment[index].installmentDate!) <=
                          DateTime.now().month;
                      Uint8List? _contractsTemp;
                      String? imageURL;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == 0)
                              Text(
                                studentController
                                    .studentMap[installmentStudent.keys
                                    .elementAt(parentIndex)]!
                                    .studentName!,
                                style: Styles.headLineStyle2,
                              ),
                            if (index == 0)
                              SizedBox(
                                height: defaultPadding,
                              ),
                            Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              children: [
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  width: Get.width / 2,
                                  decoration: BoxDecoration(
                                      color:
                                      Colors.white.withOpacity(0.5),
                                      borderRadius:
                                      BorderRadius.circular(15),
                                      border: Border.all(
                                          width: 2.0,
                                          color: isLate &&
                                              installment[index]
                                                  .isPay !=
                                                  true
                                              ? Colors.red
                                              .withOpacity(0.5)
                                              : installment[index]
                                              .isPay ==
                                              true
                                              ? Colors.green
                                              .withOpacity(0.5)
                                              : primaryColor
                                              .withOpacity(
                                              0.5))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14.0, horizontal: 10),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Spacer(),
                                        CustomTextField(
                                          controller:
                                          TextEditingController()
                                            ..text =
                                            installment[index]
                                                .installmentDate
                                                .toString(),
                                          title: 'الشهر'.tr,
                                          enable: false,
                                          size: Get.width / 7.5,
                                          isFullBorder: true,
                                        ),
                                        Spacer(),
                                        CustomTextField(
                                          controller:
                                          TextEditingController()
                                            ..text =
                                            installment[index]
                                                .installmentCost
                                                .toString(),
                                          title: "الدفعة".tr,
                                          enable: false,
                                          size: Get.width / 7.5,
                                          isFullBorder: true,
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text("صورة السند".tr),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                      height: 100,
                                      child: ListView(
                                        scrollDirection:
                                        Axis.horizontal,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              FilePickerResult? _ =
                                              await FilePicker
                                                  .platform
                                                  .pickFiles(
                                                  type: FileType
                                                      .image,
                                                  allowMultiple:
                                                  false);
                                              if (_ != null) {
                                                _.files.forEach(
                                                      (element) async {
                                                    if(element.bytes!=null)
                                                      _contractsTemp =
                                                      element.bytes!;
                                                  },
                                                );

                                                setState(() {});
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        15)),
                                                height: 100,
                                                width: 100,
                                                child:
                                                _contractsTemp==null?

                                                Icon(Icons.add):    Container(
                                                    clipBehavior:
                                                    Clip.hardEdge,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            15)),
                                                    width: 100,
                                                    height: 100,
                                                    child: Image.memory(
                                                      (_contractsTemp),
                                                      height: 100,
                                                      width: 100,
                                                      fit: BoxFit.fitHeight,
                                                    )),
                                              ),
                                            ),
                                          ),

                                          */
/* Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                        horizontal:
                                                        8.0),
                                                    child: Container(
                                                        clipBehavior:
                                                        Clip.hardEdge,
                                                        decoration: BoxDecoration(
                                                            color:
                                                            Colors.grey,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                15)),
                                                        width: 100,
                                                        height: 100,
                                                        child:
                                                        Image.network(
                                                          _contracts,
                                                          height: 200,
                                                          width: 200,
                                                          fit: BoxFit
                                                              .fitHeight,
                                                        )),
                                                  ),*//*


                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (installment[index].isPay != true)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AppButton(
                                      onPressed: () async{

                                        await uploadImages([_contractsTemp!], "contracts").then(
                                              (value) => imageURL=value.first,
                                        );
                                        studentController
                                            .setInstallmentPay(

                                            installment[index]
                                                .installmentId!,
                                            installmentStudent.keys
                                                .elementAt(
                                                parentIndex),
                                            true,imageURL!);
                                        Get.back();
                                      },
                                      text: "تسديد!"
                                          .tr, */
/*Row(
                                                  children: [
                                                    Text(
                                                      "تسديد!".tr,
                                                      style: Styles.headLineStyle3
                                                          .copyWith(
                                                              color:
                                                                  primaryColor),
                                                    ),
                                                    Icon(
                                                      Icons.check,
                                                      color: Colors.blue,
                                                    )
                                                  ],
                                                )*//*

                                    ),
                                  )
                                else
                                  GetBuilder<WaitManagementViewModel>(
                                      builder: (deleteController) {
                                        return Padding(
                                          padding:
                                          const EdgeInsets.all(8.0),
                                          child: AppButton(
                                            text: checkIfPendingDelete(
                                                affectedId:
                                                installment[index]
                                                    .installmentId!)
                                                ? 'في انتظار الموفقة..'.tr
                                                : "تراجع".tr,
                                            onPressed: () {
                                              if (checkIfPendingDelete(
                                                  affectedId:
                                                  installment[index]
                                                      .installmentId!))
                                                QuickAlert.show(
                                                    context: context,
                                                    type:
                                                    QuickAlertType.info,
                                                    width: Get.width / 2,
                                                    title:
                                                    "مراجعة المسؤول".tr,
                                                    text:
                                                    "يرجى مراجعة مسؤول المنصة"
                                                        .tr);
                                              else
                                                addWaitOperation(
                                                    type: waitingListTypes
                                                        .returnInstallment,
                                                    collectionName:
                                                    installmentCollection,
                                                    affectedId:
                                                    installment[index]
                                                        .installmentId!,
                                                    relatedId:
                                                    installmentStudent
                                                        .keys
                                                        .elementAt(
                                                        parentIndex));
                                              */
/*           studentController
                                                        .setInstallmentPay(
                                                            installment[index]
                                                                .installmentId!,
                                                            installmentStudent.keys
                                                                .elementAt(
                                                                    parentIndex),
                                                            false);*//*

                                            },
                                          ),
                                        );
                                      }),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
          SizedBox(
            height: defaultPadding,
          ),
          Center(
              child: AppButton(
                text: "حفظ".tr,
                onPressed: () {
                  Get.back();
                },
              )),
        ],
      ),
    );
  }
}
*/
