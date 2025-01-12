import 'package:flutter/material.dart';

import 'package:pluto_grid/pluto_grid.dart';
import 'package:vision_dashboard/core/constant/constants.dart';

import '../../controller/Wait_management_view_model.dart';
import '../../core/Styling/app_style.dart';

class CustomPlutoGrid extends StatefulWidget {
 const CustomPlutoGrid({super.key, required this.onSelected, this.controller, this.idName, this.onRowDoubleTap, this.isEmp = false, this.selectedColor = secondaryColor});

  @override
  State<CustomPlutoGrid> createState() => _CustomPlutoGridState();
  final Function(PlutoGridOnSelectedEvent) onSelected;
  final Function(PlutoGridOnRowDoubleTapEvent)? onRowDoubleTap;
  final controller, idName;
 final Color selectedColor;
  final bool isEmp;
}


class _CustomPlutoGridState extends State<CustomPlutoGrid> {
  bool canColor=true;
  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      key: widget.controller.plutoKey,
      columns: widget.controller.columns,
      rows: widget.controller.rows,
      onLoaded: (PlutoGridOnLoadedEvent event) {
        
      },
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
          return Colors.green.withOpacity(0.3);
        } else if (checkIfPendingDelete(affectedId: rowColorContext.row.cells[widget.idName]?.value)) {
          return Colors.red.withOpacity(0.3);
        }else if(rowColorContext.row.cells['اللون']!=null ) {
          if(canColor) {
            widget.controller.selectedColor=Color(int.parse(rowColorContext.row.cells['اللون']!.value.toString())).withOpacity(0.5);
            canColor=false;
          }
          return Color(int.parse(rowColorContext.row.cells['اللون']!.value.toString())).withOpacity(0.2);

        }
        // widget.controller.selectedColor = Colors.transparent;
        return Colors.transparent;
      },
      createFooter: (stateManager) {
        stateManager.setPageSize(40, notify: false); // default 40

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'عدد العناصر: ${stateManager.refRows.length}',
              style: AppStyles.headLineStyle4,
            ),
            Expanded(child: PlutoPagination(stateManager)),

          ],
        );
      },
    );
  }
}
