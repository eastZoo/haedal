import 'dart:io';

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
              _imageLoadButtons(),
              const SizedBox(height: 20),
              _gridPhoto(),
            ],
          ),
        ),
      ),
    );
  }

  // 화면 상단 버튼
  Widget _imageLoadButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 20),
          SizedBox(
            child: ElevatedButton(
              onPressed: () => getMultiImage(),
              child: const Text('Multi Image'),
            ),
          ),
        ],
      ),
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
              children: _pickedImages
                  .where((element) => element != null)
                  .map((e) => _gridPhotoItem(e!))
                  .toList(),
            )
          : const SizedBox(),
    );
  }

  Widget _gridPhotoItem(XFile e) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Stack(
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
                  _pickedImages.remove(e);
                });
              },
              child: const Icon(
                Icons.cancel_rounded,
                color: Colors.black87,
              ),
            ),
          )
        ],
      ),
    );
  }
}
