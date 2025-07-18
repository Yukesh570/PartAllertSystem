import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/screen/navItems/alert/alert.dart';
import 'package:Parkalert/features/screen/navItems/privacyPolicy/privacypolicy.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PrivacyController extends GetxController {
  static PrivacyController get instance => Get.find();

  void privacyPage() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/privacy'); // Set current route

    Get.offAll(
      () => Privacypolicy(),
    ); // ✅ use () => Alert() for better route stack handling
  }
}
