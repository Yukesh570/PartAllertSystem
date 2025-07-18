import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/screen/navItems/alert/alert.dart';
import 'package:Parkalert/features/screen/navItems/termsAndConditions/termsandcondtion.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class TermsandconditionsController extends GetxController {
  static TermsandconditionsController get instance => Get.find();

  void termsandconditions() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/terms'); // Set current route

    Get.offAll(
      () => Termsandcondtion(),
    ); // ✅ use () => Alert() for better route stack handling
  }
}
