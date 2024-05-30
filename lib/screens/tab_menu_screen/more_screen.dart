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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: isExpanded ? 0 : MediaQuery.of(context).size.height / 3,
            child: Container(
              color: Colors.blue,
              child: const Center(
                  child: Text('A 화면',
                      style: TextStyle(color: Colors.white, fontSize: 24))),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: isExpanded
                    ? MediaQuery.of(context).size.height
                    : MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Stack(
                  children: [
                    ListView.builder(
                      itemCount: 30, // 예시로 30개의 아이템을 생성
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Item $index'),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Icon(
                        isExpanded ? Icons.arrow_downward : Icons.arrow_upward,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
