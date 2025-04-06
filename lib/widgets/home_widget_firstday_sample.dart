import 'package:flutter/material.dart';

Widget home_widget_firstday_sample(int index) {
  switch (index) {
    case 0:
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "2024-06-23",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  shadows: [
                    Shadow(
                      blurRadius: 9.0,
                      color: Colors.black54,
                      offset: Offset(1.0, 1.5),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4),
              Text(
                "365일",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  shadows: [
                    Shadow(
                      blurRadius: 9.0,
                      color: Colors.black54,
                      offset: Offset(1.0, 1.5),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "해달",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          blurRadius: 9.0,
                          color: Colors.black54,
                          offset: Offset(1.0, 1.5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.favorite, color: Colors.white, size: 14),
                  SizedBox(width: 2),
                  Text(
                    "수달",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          blurRadius: 9.0,
                          color: Colors.black54,
                          offset: Offset(1.0, 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    case 1:
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "365일",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  shadows: [
                    Shadow(
                      blurRadius: 9.0,
                      color: Colors.black54,
                      offset: Offset(1.0, 1.5),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "해달",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      shadows: [
                        Shadow(
                          blurRadius: 9.0,
                          color: Colors.black54,
                          offset: Offset(1.0, 1.5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.favorite, color: Colors.white, size: 18),
                  SizedBox(width: 2),
                  Text(
                    "수달",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      shadows: [
                        Shadow(
                          blurRadius: 9.0,
                          color: Colors.black54,
                          offset: Offset(1.0, 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                "2024.06.23",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  shadows: [
                    Shadow(
                      blurRadius: 9.0,
                      color: Colors.black54,
                      offset: Offset(1.0, 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    case 2:
      return const Text(
        "365",
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Cafe24Meongi',
          fontWeight: FontWeight.w500,
          fontSize: 70,
          shadows: [
            Shadow(
              blurRadius: 9.0,
              color: Colors.black54,
              offset: Offset(1.0, 1.5),
            ),
          ],
        ),
      );
    case 3:
      return const Text(
        'Add Item 4',
        style: TextStyle(color: Colors.white),
      );
    case 4:
      return const Text(
        'Add Item 5',
        style: TextStyle(color: Colors.white),
      );
    case 5:
      return const Text(
        'Add Item 6',
        style: TextStyle(color: Colors.white),
      );
    default:
      return Text(
        'Add Item ${index + 1}',
        style: const TextStyle(color: Colors.white),
      );
  }
}
