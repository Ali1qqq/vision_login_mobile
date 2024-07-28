import 'package:flutter/material.dart';
import 'package:vision_dashboard/screens/Widgets/Filled_Container_Color.dart';

import '../../../constants.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    required this.title,
    required this.amountOfEmployee,
    required this.color,
    required this.onTap
  }) : super(key: key);

  final String title, amountOfEmployee;
final Color color;
final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: defaultPadding),
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
            color: color.withOpacity(0.25),
          border: Border.all(width: 2, color: color.withOpacity(0.25)),
          borderRadius: const BorderRadius.all(
            Radius.circular(defaultPadding),
          ),
        ),
        child: Row(
          children: [
            FilledContainerColor(color: color),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Text(amountOfEmployee)
          ],
        ),
      ),
    );
  }
}
