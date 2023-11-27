import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddimageScreen extends StatefulWidget {
  const AddimageScreen({super.key});

  @override
  State<AddimageScreen> createState() => _AddimageScreenState();
}

class _AddimageScreenState extends State<AddimageScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile?> _pickedImages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMultiImage();
  }

  // 이미지 여러개 불러오기
  void getMultiImage() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isEmpty) {
      return Navigator.pop(context);
    }
    setState(() {
      _pickedImages.addAll(images);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              _thumbPhoto(),
              const SizedBox(height: 20),
              _gridPhoto(),
            ],
          ),
        ),
      ),
    );
  }

  // 썸네일 이미지
  Widget _thumbPhoto() {
    return Expanded(
      child: _pickedImages.isNotEmpty
          ? Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 5.0),
              height: 1,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(_pickedImages.first!.path)),
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect(
                // make sure we apply clip it properly
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.grey.withOpacity(0.2),
                    child: const Text(
                      "title",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color:
                                Colors.black, // Choose the color of the shadow
                            blurRadius:
                                5.0, // Adjust the blur radius for the shadow effect
                            offset: Offset(1.0,
                                1.0), // Set the horizontal and vertical offset for the shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox(),
    );
  }

  // 불러온 이미지 gridView
  Widget _gridPhoto() {
    return Expanded(
      child: _pickedImages.isNotEmpty
          ? GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              children: _pickedImages.asMap().entries.map((entry) {
                int idx = entry.key;
                XFile? image = entry.value;

                return image != null
                    ? _gridPhotoItem(XFile(image.path), idx)
                    : const Text('No image');
              }).toList(),
            )
          : const SizedBox(),
    );
  }

  // gridView 이미지 박스 아이템 컴포넌트
  Widget _gridPhotoItem(XFile e, int idx) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: _pickedImages.length != idx + 1
          ? Stack(
              children: [
                Positioned.fill(
                  child: Image.file(
                    File(e.path),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _pickedImages.removeAt(idx);
                      });
                    },
                    child: const Icon(
                      Icons.cancel_rounded,
                      color: Colors.black87,
                    ),
                  ),
                )
              ],
            )
          : Stack(
              children: [
                Positioned(
                  top: 35,
                  right: 35,
                  child: GestureDetector(
                    onTap: () {
                      getMultiImage();
                    },
                    child: Column(
                      children: [
                        Positioned.fill(
                          child: Container(
                              color: const Color(
                                  0xFFD4A7FB) // Set the color for the Positioned.fill
                              ),
                        ),
                        const Icon(
                          Icons.add,
                          color: Colors.black87,
                          size: 25,
                        ),
                        const Text(
                          "추가하기",
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
