import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/screen/navItems/alert/alert.dart';
import 'package:Parkalert/features/screen/navItems/questions/question.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class QuestionController extends GetxController {
  static QuestionController get instance => Get.find();

  void question() {
    final drawerCtrl = Get.find<DrawerControllerX>();
    drawerCtrl.changeRoute('/questions'); // Set current route

    Get.offAll(
      () => Question(),
    ); // ✅ use () => Alert() for better route stack handling
  }
}
