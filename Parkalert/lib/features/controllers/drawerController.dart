import 'package:get/get.dart';

class DrawerControllerX extends GetxController {
  RxString currentRoute = ''.obs;
  void changeRoute(String route) {
    currentRoute.value = route;
    print("===================currentRoute changed to: $route");
  }
}
