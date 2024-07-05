import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class HomepageCard extends StatelessWidget {
  final dynamic icons;
  final dynamic screen;
  const HomepageCard({
    required this.icons,
    this.screen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(screen!);
      },
      //splashColor: Colors.blueGrey,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          color: Color(0xFFCBE3FB),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                onPressed: () {
                  Get.to(screen!);
                },
                icon: Icon(
                  icons,
                  size: 35,
                ))
          ],
        ),
      ),
    );
  }
}
