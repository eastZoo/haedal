import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:haedal/styles/colors.dart';

class CustomBlockPicker extends StatelessWidget {
  final String label;
  final Color currentColor;
  final ValueChanged<Color> onColorChanged;
  final List<Color> availableColors;
  final int colorsPerRow;
  final double blockWidth;
  final double blockHeight;

  const CustomBlockPicker({
    super.key,
    this.label = "",
    required this.currentColor,
    required this.onColorChanged,
    required this.availableColors,
    this.colorsPerRow = 4, // 한 줄에 보이는 컬러의 개수
    this.blockWidth = 50.0, // 각 색상 블록의 넓이
    this.blockHeight = 50.0, // 각 색상 블록의 높이
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (label.isNotEmpty)
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors().darkGreyText),
              ),
            ],
          ),
        const Gap(8),
        SizedBox(
          height: (availableColors.length / colorsPerRow).ceil() * blockHeight,
          child: GridView.count(
            crossAxisCount: colorsPerRow,
            children: availableColors.map((Color color) {
              return GestureDetector(
                onTap: () => onColorChanged(color),
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  width: blockWidth,
                  height: blockHeight,
                  decoration: BoxDecoration(
                    color: color,
                    border: Border.all(
                      color: color == currentColor
                          ? Colors.white
                          : Colors.transparent,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: color == currentColor
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 25,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
