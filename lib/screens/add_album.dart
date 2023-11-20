import 'dart:io';

import 'package:haedal/widgets/media_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:photo_manager/photo_manager.dart';

class AddAlbum extends StatefulWidget {
  const AddAlbum({super.key});

  @override
  State<AddAlbum> createState() => _AddAlbumState();
}

class _AddAlbumState extends State<AddAlbum> {
  List<AssetEntity> selectedAssetList = [];
  List<File> selectedFiles = [];

  @override
  void initState() {
    // TODO: implement initState
    // pickAssets(
    //   maxCount: 10,
    //   requestType: RequestType.image,
    // );
    super.initState();
  }

  Future convertAssetsToFiles(List<AssetEntity> assetEntities) async {
    for (var i = 0; i < assetEntities.length; i++) {
      final File? file = await assetEntities[i].originFile;
      setState(() {
        selectedFiles.add(file!);
      });
    }
  }

  Future pickAssets({
    required int maxCount,
    required RequestType requestType,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MediaPicker(maxCount, requestType, selectedAssetList);
        },
      ),
    );
    print('::: $selectedAssetList');
    print('::: $result');
    if (result?.isNotEmpty || result != null) {
      setState(() {
        selectedAssetList = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GridView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: selectedAssetList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            AssetEntity assetEntity = selectedAssetList[index];
            return Padding(
              padding: const EdgeInsets.all(2),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AssetEntityImage(
                      assetEntity,
                      isOriginal: false,
                      thumbnailSize: const ThumbnailSize.square(1000),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  ),
                  if (assetEntity.type == AssetType.video)
                    const Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Iconsax.video5,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            pickAssets(
              maxCount: 10,
              requestType: RequestType.image,
            );
          },
          child: const Icon(Iconsax.image5),
        ),
      ),
    );
  }
}
