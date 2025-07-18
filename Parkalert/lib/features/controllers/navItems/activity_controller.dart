import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/screen/navItems/activity/activity.dart';
import 'package:Parkalert/features/screen/navItems/alert/alert.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ActivityController extends GetxController {
  static ActivityController get instance => Get.find();

  void activityPage() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/activity'); // Set current route

    Get.offAll(
      () => Activity(),
    ); // ✅ use () => Alert() for better route stack handling
  }
}
