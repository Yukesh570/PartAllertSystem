import 'package:get/get.dart';

class DrawerControllerX extends GetxController {
  RxString currentRoute = ''.obs;
  final List<String> _history = [];

  void changeRoute(String route) {
    if (_history.isEmpty || _history.last != route) {
      _history.add(route); // push new route
    }
    currentRoute.value = route;
    print("===================currentRoute changed to: $route");
  }

  void goBack() {
    if (_history.length > 1) {
      _history.removeLast(); // remove current route
      currentRoute.value = _history.last; // set to previous route
      print("===================currentRoute back to: ${currentRoute.value}");
    } else {
      // at root page, no previous route
      print("===================Already at root page: ${_history.last}");
    }
  }

  String get previousRoute =>
      _history.length > 1 ? _history[_history.length - 2] : '';

  bool get isAtRoot => _history.length <= 1; // 👈 add this
}
