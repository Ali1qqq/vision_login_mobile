import 'package:flutter/material.dart';

import 'package:pluto_grid/pluto_grid.dart';
import 'package:vision_dashboard/constants.dart';

import '../../controller/Wait_management_view_model.dart';
import '../../core/Styling/app_style.dart';

class CustomPlutoGrid extends StatefulWidget {
  CustomPlutoGrid({super.key, required this.onSelected, this.controller, this.idName, this.onRowDoubleTap, this.isEmp = false, this.selectedColor = secondaryColor});

  @override
  State<CustomPlutoGrid> createState() => _CustomPlutoGridState();
  final Function(PlutoGridOnSelectedEvent) onSelected;
  final Function(PlutoGridOnRowDoubleTapEvent)? onRowDoubleTap;
  final controller, idName;
  Color selectedColor;
  final bool isEmp;
}

class _CustomPlutoGridState extends State<CustomPlutoGrid> {
  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      key: widget.controller.plutoKey,
      columns: widget.controller.columns,
      rows: widget.controller.rows,
      onChanged: (event) {
        print("onChanged");
      },
      onLoaded: (PlutoGridOnLoadedEvent event) {},
      mode: PlutoGridMode.selectWithOneTap,
      onRowDoubleTap: widget.onRowDoubleTap,
      onSelected: widget.onSelected,
      configuration: PlutoGridConfiguration(
        style: PlutoGridStyleConfig(
            enableRowColorAnimation: true,
            columnTextStyle: AppStyles.headLineStyle2,
            activatedColor: widget.controller.selectedColor,
            gridBackgroundColor: secondaryColor,
            cellTextStyle: AppStyles.headLineStyle3,
            gridPopupBorderRadius: BorderRadius.all(Radius.circular(15)),
            gridBorderRadius: BorderRadius.all(Radius.circular(15)),
            gridBorderColor: Colors.transparent),
        localeText: PlutoGridLocaleText.arabic(),
      ),
      rowColorCallback: (PlutoRowColorContext rowColorContext) {
        if (rowColorContext.row.cells['موافقة المدير']?.value == "في انتظار الموافقة" || rowColorContext.row.cells['موافقة المدير']?.value == false) {
          widget.selectedColor = Colors.green.withOpacity(0.3);
          return Colors.green.withOpacity(0.3);
        } else if (checkIfPendingDelete(affectedId: rowColorContext.row.cells[widget.idName]?.value)) {
          widget.selectedColor = Colors.red.withOpacity(0.3);
          return Colors.red.withOpacity(0.3);
        }
        widget.selectedColor = Colors.transparent;
        return Colors.transparent;
      },
      createFooter: (stateManager) {
        stateManager.setPageSize(40, notify: false); // default 40

        return PlutoPagination(
          stateManager,
        );
      },
    );
  }
}
