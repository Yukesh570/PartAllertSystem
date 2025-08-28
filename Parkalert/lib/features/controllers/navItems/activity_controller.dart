// import 'dart:convert';

// import 'package:Parkalert/features/controllers/drawerController.dart';
// import 'package:Parkalert/features/screen/navItems/activity/activity.dart';
// import 'package:Parkalert/features/screen/navItems/alert/alertSettings.dart';
// import 'package:Parkalert/utils/storage/data/historyData.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ActivityController extends GetxController {
//   static ActivityController get instance => Get.find();
//   var history = <Historydata>[].obs;

//   RxBool isLoading = true.obs; // <-- Add loading indicator

// Future<void> loadHistoryFromPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? locationJson = prefs.getString('currentLocation');
//     print("🔍Current location JSON: $locationJson");
//      if (locationJson != null && locationJson.isNotEmpty) {
        
//           final List<dynamic> dataList = jsonDecode(locationJson);
      
//     isLoading.value = false; // done
//     return dataList
 
// }
// }

// }
