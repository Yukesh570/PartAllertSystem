import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/screen/navItems/alert/alertSettings.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class WorkingController extends GetxController {
  static WorkingController get instance => Get.find();

  void working() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/working'); // Set current route

    Get.offAll(
      () => AlertSetting(),
    ); // ✅ use () => Alert() for better route stack handling
  }
}
