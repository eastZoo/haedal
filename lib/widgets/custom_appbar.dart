import 'package:flutter/material.dart';

/// CustomAppbar
class CustomAppbar extends StatefulWidget {
  /// 제목
  final String title;

  /// 앱바 왼쪽 아이콘
  final Widget? leading;

  /// 앱바 왼쪽 아이콘 보여주기 여부
  final bool leadingVisibility;

  /// 앱바 오른쪽 아이콘
  final Widget? actions;

  final bool bottomBorderVisibility;

  final String type;

  ///
  const CustomAppbar(
      {Key? key,
      this.leading,
      this.leadingVisibility = true,
      this.bottomBorderVisibility = true,
      this.actions,
      this.type = "normal",
      required this.title})
      : super(key: key);

  @override
  _CustomAppbarState createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    getBackgroundColor() {
      switch (widget.type) {
        case "normal":
          return Colors.white;
        case "blue":
          return const Color(0XFF4755EB);
        default:
          return Colors.white;
      }
    }

    getTitleColor() {
      switch (widget.type) {
        case "normal":
          return const Color(0xFF676B85);
        case "blue":
          return const Color(0xFFFFFFFF);
        default:
          return const Color(0xFF676B85);
      }
    }

    var leading = widget.leading;
    if (leading == null && widget.leadingVisibility) {
      leading = Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(32.0),
          ),
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back,
              color: getTitleColor(),
            ),
          ),
        ),
      );
    }

    var actions = widget.actions;
    actions ??= Container();

    var border = const Border(
      bottom: BorderSide(
        width: 0.3,
      ),
    );

    if (!widget.bottomBorderVisibility) {
      border = const Border(
        bottom: BorderSide(width: 0, color: Colors.transparent),
      );
    }

    if (widget.title == "") {
      return Container();
    }

    return Container(
      color: getBackgroundColor(),
      // decoration: BoxDecoration(border: _border),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: leading,
            ),
            Expanded(
              child: Center(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: getTitleColor(),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[actions],
              ),
            )
          ],
        ),
      ),
    );
  }
}
