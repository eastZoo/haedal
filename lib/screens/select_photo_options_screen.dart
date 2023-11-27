import 'package:flutter/material.dart';
import 'package:haedal/routes/app_pages.dart';
import 'package:haedal/screens/add_image_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import '/widgets/re_usable_select_photo_button.dart';

class SelectPhotoOptionsScreen extends StatelessWidget {
  const SelectPhotoOptionsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey.shade300,
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -35,
            child: Container(
              width: 50,
              height: 6,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(children: [
            SelectPhoto(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: const AddimageScreen(),
                    isIos: true,
                    duration: routingDuration,
                  ),
                );
              },
              icon: Icons.image,
              textLabel: '앨범에서 추가',
            ),
            const SizedBox(
              height: 8,
            ),
            const Center(
              child: Text(
                'OR',
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            SelectPhoto(
              onTap: () {},
              icon: Icons.camera_alt_outlined,
              textLabel: '준비중...',
            ),
          ])
        ],
      ),
    );
  }
}
