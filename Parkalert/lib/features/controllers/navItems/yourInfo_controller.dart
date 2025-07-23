import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/screen/navItems/alert/alertSettings.dart';
import 'package:Parkalert/features/screen/navItems/yourInformation/yourinfo.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class YourinfoController extends GetxController {
  static YourinfoController get instance => Get.find();

  void yourinfo() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/yourinfo'); // Set current route

    Get.offAll(
      () => Yourinfo(),
    ); // ✅ use () => Alert() for better route stack handling
  }
}
