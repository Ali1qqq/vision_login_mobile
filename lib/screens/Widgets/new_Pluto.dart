import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:vision_dashboard/core/constant/constants.dart';
import 'package:vision_dashboard/screens/Widgets/Pluto_View_Model.dart';
import '../../controller/Wait_management_view_model.dart';
import '../../core/Styling/app_style.dart';

class CustomPlutoGrid2 extends StatelessWidget {
  CustomPlutoGrid2({
    super.key,
    required this.onSelected,
    required this.modelList,
    this.onRowDoubleTap,

  });
  final Function(PlutoGridOnSelectedEvent) onSelected;
  late final List<dynamic> modelList;
  late final Function(PlutoGridOnRowDoubleTapEvent)? onRowDoubleTap;

  // قائمة من المودل
  @override
  Widget build(BuildContext context) {
        return PlutoGrid(
          key: Get.find<PlutoViewModel>().plutoKey,
          columns: Get.find<PlutoViewModel>().getColumns(modelList),
          rows:Get.find<PlutoViewModel>().getRows(modelList),
          onChanged: (event) {
            print("onChanged");
          },
          onSelected: onSelected,

          onLoaded: (event){

          },
          mode: PlutoGridMode.selectWithOneTap,
          onRowDoubleTap: onRowDoubleTap,
          configuration: PlutoGridConfiguration(
            style: PlutoGridStyleConfig(
              enableRowColorAnimation: true,
              columnTextStyle: AppStyles.headLineStyle2,
              activatedColor: Colors.white.withOpacity(0.4),
              gridBackgroundColor: secondaryColor,
              cellTextStyle: AppStyles.headLineStyle3,
              gridPopupBorderRadius: BorderRadius.all(Radius.circular(15)),
              gridBorderRadius: BorderRadius.all(Radius.circular(15)),
              gridBorderColor: Colors.transparent,
            ),
            localeText: PlutoGridLocaleText.arabic(),
          ),
          rowColorCallback: (PlutoRowColorContext rowColorContext) {
            if (rowColorContext.row.cells['موافقة المدير']!.value == "في انتظار الموافقة" || rowColorContext.row.cells['موافقة المدير']!.value == false) {
              return Colors.green.withOpacity(0.3);
            } else if (checkIfPendingDelete(affectedId: rowColorContext.row.cells["الرقم التسلسلي"]?.value)) {
              return Colors.red.withOpacity(0.3);
            } else if (rowColorContext.row.cells['اللون'] != null) {
              return Color(int.parse(rowColorContext.row.cells['اللون']!.value.toString())).withOpacity(0.2);
            }
            return Colors.transparent;
          },
          createFooter: (stateManager) {
            stateManager.setPageSize(40, notify: false); // default 40
            return PlutoPagination(stateManager);
          },
        );

  }
}
