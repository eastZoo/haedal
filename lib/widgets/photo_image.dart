import 'dart:io';

import 'package:flutter/material.dart';

class PhotoImage extends StatelessWidget {
  const PhotoImage(
      {Key? key,
      required this.size,
      required this.file,
      required this.removeImage})
      : super(key: key);

  final double size;
  final File file;
  final GestureTapCallback removeImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size / 3 - 20,
      height: size / 3 - 20,
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.file(
                file,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: removeImage,
                child: Container(
                  width: 25,
                  height: 25,
                  padding: const EdgeInsets.all(3),
                  margin: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent,
                  ),
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
