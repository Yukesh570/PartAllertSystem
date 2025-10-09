import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'drawerController.dart';

class PageWrapper extends StatefulWidget {
  final String routeName;
  final Widget child;

  const PageWrapper({required this.routeName, required this.child, super.key});

  @override
  State<PageWrapper> createState() => _PageWrapperState();
}

class _PageWrapperState extends State<PageWrapper> {
  @override
  void initState() {
    super.initState();
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute(
      widget.routeName,
    ); // run only once when the page opens
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final drawerCtrl = Get.find<DrawerControllerX>();
        drawerCtrl.goBack();
        return true;
      },
      child: widget.child,
    );
  }
}
