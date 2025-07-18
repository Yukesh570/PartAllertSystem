import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/screen/navItems/alert/alert.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AlertController extends GetxController {
  static AlertController get instance => Get.find();

  void alertPage() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/alerts'); // Set current route

    Get.offAll(
      () => Alert(),
    ); // ✅ use () => Alert() for better route stack handling
  }
}
