import 'dart:io';

import 'package:dio/dio.dart';

import 'package:haedal/styles/colors.dart';
import 'package:haedal/widgets/app_button.dart';
import 'package:haedal/widgets/photo_image.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart' as GET;
import 'package:path/path.dart';

class AddAlbum extends StatefulWidget {
  const AddAlbum({super.key});

  @override
  State<AddAlbum> createState() => _AddAlbumState();
}

class _AddAlbumState extends State<AddAlbum> {
  final List<File> _beforeImages = [];
  final List<File> _afterImages = [];

  bool isLoading = false;

  // 카메라에서 추가
  Future getImageAdd(int type) async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );
    if (photo != null) {
      int size = await photo.length();
      if (size < 99999) {
        GET.Get.snackbar(
          '등록 오류',
          '사진 이미지가 불량입니다.',
          snackPosition: GET.SnackPosition.TOP,
          backgroundColor: Colors.deepOrangeAccent,
        );
      } else {
        setState(() {
          File image = File(photo.path);
          if (type == 1) _beforeImages.add(image);
          if (type == 2) _afterImages.add(image);
        });
      }
    }
  }

  Future getImageAlbumAdd() async {
    await Permission.storage.request();
    final picker = ImagePicker();
    final photo = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (photo != null) {
      setState(() {
        File image = File(photo.path);
        _beforeImages.add(image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // 이미지 추가 후 미리보기
    Widget beforePhoto(int index) {
      return (_beforeImages.length > index)
          ? PhotoImage(
              size: width,
              file: _beforeImages[index],
              removeImage: () {
                setState(() {
                  _beforeImages.removeAt(index);
                });
              },
            )
          : Container();
    }

    submit() async {
      setState(() {
        isLoading = true;
      });

      if (_beforeImages.isEmpty) {
        GET.Get.snackbar(
          '저장 오류!!',
          '적어도 하나의 사진을 등록하세요.',
          snackPosition: GET.SnackPosition.TOP,
          backgroundColor: Colors.deepOrangeAccent,
        );
        return false;
      }
      var res;
      var images = [];
      Map<String, dynamic> requestData = {};
      for (int i = 0; i < _beforeImages.length; i++) {
        images.add(
          await MultipartFile.fromFile(
            _beforeImages[i].path,
            filename: basename(_beforeImages[i].path),
          ),
        );
        requestData["img${i + 1}"] = basename(_beforeImages[i].path);
      }
      requestData["images"] = images;

      if (res["success"]) {
        setState(() {
          isLoading = false;
          _beforeImages.clear();
          _afterImages.clear();
        });

        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        print(isLoading);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          showCloseIcon: true,
          content: Text('사진이 등록되었습니다.'),
        ));
      } else {
        setState(() {
          isLoading = false;
          _beforeImages.clear();
          _afterImages.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          showCloseIcon: true,
          content: Text(res["msg"] ?? '저장 오류!'),
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors().mainColor,
        title: const Text("영양소분석"),
      ),
      body: isLoading
          ? const Scaffold(
              body: Center(
                child: SizedBox(
                  height: 120,
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          height: 120,
                          width: 120,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      Center(
                        child: Text('분석중입니다...'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(15),
              children: [
                const Row(
                  children: [
                    Text(
                      '음식 사진 등록',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2B2F45),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 15,
                    runSpacing: 15,
                    children: [
                      SizedBox(
                        width: width / 3 - 20,
                        height: width / 3 - 20,
                        child: TextButton(
                          onPressed: () {
                            getImageAlbumAdd();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors().mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.add_circle,
                                size: 30,
                                color: Colors.white,
                              ),
                              Text(
                                '사진 등록',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      beforePhoto(0),
                      beforePhoto(1),
                      beforePhoto(2),
                      beforePhoto(3),
                      beforePhoto(4),
                    ],
                  ),
                ),
                const SizedBox(height: 12.0),
                AppButton(
                  width: width,
                  minimumSize: Size(width, 50),
                  text: "분석",
                  color: AppColors().mainColor,
                  onPressed: submit,
                ),
                Container(
                  height: 20.0,
                ),
              ],
            ),
    );
  }
}
