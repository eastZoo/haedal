import 'package:flutter/material.dart';
import 'package:haedal/styles/colors.dart';

class SelectPhoto extends StatelessWidget {
  final String textLabel;
  final IconData icon;
  final bool? disabled;
  final void Function()? onTap;

  const SelectPhoto(
      {Key? key,
      required this.textLabel,
      required this.icon,
      required this.onTap,
      this.disabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 10,
        backgroundColor:
            disabled! ? AppColors().mainDisabledColor : AppColors().mainColor,
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 6,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(
              width: 14,
            ),
            Text(
              textLabel,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
