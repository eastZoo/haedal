import 'package:flutter/material.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/widgets/app_button.dart';
import 'package:haedal/widgets/popover.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AddLocationBottonSheet extends StatelessWidget {
  final PanelController panelController;
  final TextEditingController inputController;
  final String? address;
  final String? buttonTitle;
  final void Function() onSaveLocation;
  final void Function() onClosedBottomSheet;
  final void Function(String text) onChangedText;

  const AddLocationBottonSheet({
    super.key,
    required this.panelController,
    required this.inputController,
    required this.onSaveLocation,
    required this.onChangedText,
    required this.onClosedBottomSheet,
    this.address,
    this.buttonTitle = "지점등록",
  });

  @override
  Widget build(BuildContext context) {
    void openBottonSheet() {}

    return SlidingUpPanel(
      // defaultPanelState: PanelState.OPEN,
      renderPanelSheet: false,
      panel: Container(
        alignment: Alignment.bottomCenter,
        child: Popover(
          child: Container(
            padding: const EdgeInsets.all(18),
            width: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "주소",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF797979),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'NotoSansKR',
                  ),
                ),
                Text(
                  address ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'NotoSansKR',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // const Text(
                //   "별명지정",
                //   style: TextStyle(
                //     fontSize: 14,
                //     color: Color(0xFF797979),
                //     fontWeight: FontWeight.w400,
                //     fontFamily: 'NotoSansKR',
                //   ),
                // ),
                // const SizedBox(
                //   height: 3,
                // ),
                // TextField(
                //   controller: inputController,
                //   decoration: const InputDecoration(
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(5),
                //       ),
                //     ),
                //     contentPadding: EdgeInsets.all(5),
                //     // enabledBorder:
                //   ),
                //   onChanged: onChangedText,
                // ),
                // const SizedBox(
                //   height: 20,
                // ),

                AppButton(
                  width: double.infinity,
                  minimumSize: const Size(double.infinity, 50),
                  text: '$buttonTitle',
                  color: AppColors().mainColor,
                  onPressed: onSaveLocation,
                )
              ],
            ),
          ),
        ),
      ),
      controller: panelController,
      onPanelClosed: onClosedBottomSheet,
      onPanelOpened: openBottonSheet,
    );
  }
}
