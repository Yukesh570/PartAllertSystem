import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'drawerController.dart';

class PageWrapper extends StatelessWidget {
  final String routeName;
  final Widget child;

  const PageWrapper({required this.routeName, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute(routeName); // set current route

    return WillPopScope(
      onWillPop: () async {
        drawerCtrl.goBack(); // update highlight on back
        return true; // allow pop
      },
      child: child,
    );
  }
}
