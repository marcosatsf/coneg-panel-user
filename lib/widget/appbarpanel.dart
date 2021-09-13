import 'package:flutter/material.dart';

class AppBarPanel extends PreferredSize {
  final double height;

  AppBarPanel({this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF23A39B),
      title: Padding(
        padding: EdgeInsets.all(10),
        child: Image.asset(
          'assets/images/ConEg.png',
          height: 50,
          width: 50,
        ),
      ),
      centerTitle: true,
    );
  }
}
