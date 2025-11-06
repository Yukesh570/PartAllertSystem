import 'package:get/get.dart';

class DrawerControllerX extends GetxController {
  RxString currentRoute = ''.obs;
  final List<String> history = [];

  void changeRoute(String route) {
    // print("1111111111111111111111111111111111111111111111111111111${route}");
    if (route == "/alerts") {
      // Clear history and make alert the root
      history.clear();
      history.add(route);
    } else {
      if (history.isEmpty || history.last != route) {
        history.add(route); // push new route
      }
    }
    currentRoute.value = route;
    // print("===================currentRoute changed to: $route");
    // print("===================history: $history"); // Debug history
  }

  void goBack() {
    if (history.length > 1) {
      history.removeLast(); // remove current route
      currentRoute.value = history.last; // set to previous route
      // print("===================currentRoute back to: ${currentRoute.value}");
      // print("===================history: $history"); // Debug history
    }
    // else {
    //   print("===================Already at root page: ${history.last}");
    // }
  }

  String get previousRoute =>
      history.length > 1 ? history[history.length - 2] : '';

  bool get isAtRoot => history.length <= 1; // 👈 add this
}
