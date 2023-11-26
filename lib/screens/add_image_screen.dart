import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:haedal/widgets/image_picker/stateless_pickers.dart';
import 'package:haedal/widgets/camera/camera_picker.dart';
import 'package:haedal/widgets/camera/wechat_camera_picker.dart';
import 'package:haedal/widgets/image_picker/restorable_picker.dart';
import 'package:haedal/widgets/image_picker/insta_picker_interface.dart';

const kDefaultColor = Colors.deepPurple;

late List<CameraDescription> _cameras;

class addImageScreen extends StatelessWidget {
  const addImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PickersScreen extends StatelessWidget {
  const PickersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<InstaPickerInterface> pickers = [
      const SinglePicker(),
      const MultiplePicker(),
      const RestorablePicker(),
      CameraPicker(camera: _cameras.first),
      const WeChatCameraPicker(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Insta pickers')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext context, int index) {
          final PickerDescription description = pickers[index].description;

          return Card(
            child: ListTile(
              leading: Text(description.icon),
              title: Text(description.label),
              subtitle: description.description != null
                  ? Text(description.description!)
                  : null,
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => pickers[index]),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 4),
        itemCount: pickers.length,
      ),
    );
  }
}
