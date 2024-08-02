
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../Controller/Parents_View_Model.dart';
import 'BuildParentAddContractButton.dart';
import 'BuildParentContractImage.dart';

Widget buildParentContractImageSection(ParentsViewModel parentController) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("صورة العقد".tr),
      SizedBox(height: 15),
      SizedBox(
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            BuildParentAddContractButton(parentController),
            ...parentController.contractsTemp.map((contract) => BuildParentContractImage(memoryImage: contract)).toList(),
            ...parentController.contracts.map((contractUrl) => BuildParentContractImage(networkImageUrl: contractUrl)).toList(),
          ],
        ),
      ),
    ],
  );
}