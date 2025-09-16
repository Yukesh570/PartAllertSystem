import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/screen/map/locationHistory.dart';
import 'package:Parkalert/features/screen/map/map.dart';
import 'package:Parkalert/features/screen/navItems/activity/activity.dart';
import 'package:Parkalert/features/screen/navItems/activity/allActivities.dart';
import 'package:Parkalert/features/screen/navItems/alert/alert.dart';
import 'package:Parkalert/features/screen/navItems/alert/alertSettingEdit.dart';
import 'package:Parkalert/features/screen/navItems/alert/alertSettings.dart';
import 'package:Parkalert/features/screen/navItems/freezones/freezone.dart';
import 'package:Parkalert/features/screen/navItems/freezones/zoneBox.dart';
import 'package:Parkalert/features/screen/navItems/privacyPolicy/privacypolicy.dart';
import 'package:Parkalert/features/screen/navItems/questions/question.dart';
import 'package:Parkalert/features/screen/navItems/termsAndConditions/termsandcondtion.dart';
import 'package:Parkalert/features/screen/navItems/working/working.dart';
import 'package:Parkalert/features/screen/navItems/yourInformation/yourinfo.dart';
import 'package:Parkalert/utils/storage/data/RingerData.dart';
import 'package:Parkalert/utils/storage/data/ZoneData.dart';
import 'package:Parkalert/utils/storage/data/historyData.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MainController extends GetxController {
  static MainController get instance => Get.find();

  void alertPage() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/alerts'); // Set current route

    Get.offAll(
      () => Alert(),
    ); // ✅ use () => Alert() for better route stack handling
  }

  void alertSettingPage() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/alertSetting'); // Set current route

    Get.to(
      () => AlertSetting(),
    ); // ✅ use () => Alert() for better route stack handling
  }

  void alertSettingeEditingPage(RingerData ringerData) {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/alertSettingEdit'); // Set current route

    Get.to(
      () => AlertSettingEdit(ringerData: ringerData),
    ); // ✅ use () => Alert() for better route stack handling
  }

  void activityPage() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/activity'); // Set current route

    Get.to(() => Activity()); //
  }

  void freezone() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/freezone'); // Set current route
    Get.to(() => Freezone()); //

    // Get.off(() => Mappage()); //
  }

  void mapPage(ZoneData zoneData) {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/map'); // Set current route
    // Get.off(() => Freezone()); //

    Get.to(() => Mappage(zoneData: zoneData)); //
  }

  void privacyPage() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/privacy'); // Set current route

    Get.off(() => Privacypolicy()); //
  }

  void question() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/questions'); // Set current route

    Get.to(() => Question()); //
  }

  void termsandconditions() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/terms'); // Set current route

    Get.to(() => Termsandcondtion()); //
  }

  void working() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/working'); // Set current route

    Get.to(() => Working()); //
  }

  void yourinfo() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/yourinfo'); // Set current route

    Get.to(() => Yourinfo()); //
  }

  void locationHistory({Historydata? historydata}) {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/locationHistory'); // Set current route

    if (historydata != null) {
      Get.to(() => LocationHistory(historydata: historydata));
    } else {
      Get.to(() => LocationHistory()); // fallback without data
    }
  }

  void activityHistory() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/activityHistory'); // Set current route

    Get.to(() => ActivityHistory()); //
  }
}
