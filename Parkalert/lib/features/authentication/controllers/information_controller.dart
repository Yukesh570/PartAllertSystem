import 'package:Parkalert/features/authentication/screen/map/map.dart';
import 'package:Parkalert/features/authentication/screen/onboarding/onboarding.dart';
import 'package:get/get.dart';

class InformationController extends GetxController {
  static InformationController get instance => Get.find();

  //variable

  void InfonextPage() {
    Get.offAll(Mappage());
  }
}
