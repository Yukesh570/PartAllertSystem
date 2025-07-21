import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/screen/map/map.dart';
import 'package:Parkalert/features/screen/navItems/activity/activity.dart';
import 'package:Parkalert/features/screen/navItems/alert/alert.dart';
import 'package:Parkalert/features/screen/navItems/freezones/freezone.dart';
import 'package:Parkalert/features/screen/navItems/privacyPolicy/privacypolicy.dart';
import 'package:Parkalert/features/screen/navItems/questions/question.dart';
import 'package:Parkalert/features/screen/navItems/termsAndConditions/termsandcondtion.dart';
import 'package:Parkalert/features/screen/navItems/working/working.dart';
import 'package:Parkalert/features/screen/navItems/yourInformation/yourinfo.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MainController extends GetxController {
  static MainController get instance => Get.find();

  void alertPage() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/alerts'); // Set current route

    Get.off(
      () => Alert(),
    ); // ✅ use () => Alert() for better route stack handling
  }

  void activityPage() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/activity'); // Set current route

    Get.off(() => Activity()); //
  }

  void freezone() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/freezone'); // Set current route
    // Get.off(() => Freezone()); //

    Get.off(() => Mappage()); //
  }

  void privacyPage() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/privacy'); // Set current route

    Get.off(() => Privacypolicy()); //
  }

  void question() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/questions'); // Set current route

    Get.off(() => Question()); //
  }

  void termsandconditions() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/terms'); // Set current route

    Get.off(() => Termsandcondtion()); //
  }

  void working() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/working'); // Set current route

    Get.off(() => Working()); //
  }

  void yourinfo() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/yourinfo'); // Set current route

    Get.off(() => Yourinfo()); //
  }
}
