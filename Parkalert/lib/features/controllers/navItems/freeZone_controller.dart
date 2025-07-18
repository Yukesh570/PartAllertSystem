import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/screen/navItems/alert/alert.dart';
import 'package:Parkalert/features/screen/navItems/freezones/freezone.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FreezoneController extends GetxController {
  static FreezoneController get instance => Get.find();

  void freezone() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/freezone'); // Set current route

    Get.offAll(
      () => Freezone(),
    ); // ✅ use () => Alert() for better route stack handling
  }
}
