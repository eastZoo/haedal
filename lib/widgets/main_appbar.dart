import 'package:flutter/material.dart';
import 'package:haedal/styles/colors.dart';

class MainAppbar extends StatelessWidget {
  final String title;

  const MainAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height,
              height: AppBar().preferredSize.height,
              child: IconButton.filled(
                  onPressed: () {}, icon: const Icon(Icons.menu)),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: AppColors().appBarPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
