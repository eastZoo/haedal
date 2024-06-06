import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:haedal/widgets/my_button.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool isExpanded = false;
  int currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flex 화면'),
      ),
      body: Column(
        children: [
          // 위의 Flex
          Flexible(
            flex: isExpanded ? 0 : 4,
            child: Container(
              color: Colors.blue,
              child: Center(
                child: isExpanded
                    ? Container()
                    : Text(
                        '위의 위젯 (flex ${isExpanded ? 0 : 1})',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
              ),
            ),
          ),
          // 아래의 Flex
          Flexible(
            flex: isExpanded ? 1 : 4,
            child: Container(
              color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '아래의 위젯 (flex ${isExpanded ? 1 : 0})',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(isExpanded ? '축소하기' : '확장하기'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
