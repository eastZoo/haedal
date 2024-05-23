import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:haedal/styles/app_style.dart';
import 'package:table_calendar/table_calendar.dart';

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({
    super.key,
    this.titleText = "",
    required this.valueText,
    required this.iconSection,
    required this.onTap,
  });

  final String? titleText;
  final String valueText;
  final IconData iconSection;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      titleText!.isNotEmpty
          ? Text(
              titleText ?? "",
              style: AppStyle.headingOne,
            )
          : const SizedBox(),
      const Gap(6),
      Material(
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => onTap(),
            child: Container(
              width: 200,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(iconSection),
                  const Gap(10),
                  Text(valueText),
                ],
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
