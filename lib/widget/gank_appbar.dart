import 'package:flutter/material.dart';

class GankAppBar extends StatefulWidget implements PreferredSizeWidget {
  GankAppBar({@required this.child}) : assert(child != null);
  final Widget child;

  @override
  Size get preferredSize {
    return new Size.fromHeight(56.0);
  }

  @override
  State createState() {
    return new _GankAppBarState();
  }
}

class _GankAppBarState extends State<GankAppBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: widget.child);
  }
}
