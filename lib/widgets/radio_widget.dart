import 'package:flutter/material.dart';

class RadioWidget extends StatelessWidget {
  const RadioWidget(
      {super.key, required this.categColor, required this.titleRadio});

  final String titleRadio;
  final Color categColor;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: Colors.green),
        child: RadioListTile(
          contentPadding: EdgeInsets.zero,
          title: Transform.translate(
            offset: const Offset(-22, 0),
            child: Text(
              titleRadio,
              style: TextStyle(color: categColor, fontWeight: FontWeight.bold),
            ),
          ),
          value: 1,
          groupValue: 0,
          onChanged: (value) {
            print("click");
          },
        ),
      ),
    );
  }
}
