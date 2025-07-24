import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IsOnController extends GetxController {
  RxList<bool> isOnList = <bool>[].obs;
  RxBool isLoading = true.obs; // <-- Add loading indicator

  @override
  void onInit() {
    super.onInit();
    loadIsOnFromStorage();
  }

  Future<void> loadIsOnFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonStringList = prefs.getStringList('ringers');

    if (jsonStringList != null) {
      final List<bool> extractedIsOnList = jsonStringList.map((jsonStr) {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
        return jsonMap['isOn'] as bool;
      }).toList();

      isOnList.value = extractedIsOnList;
      print("📥 Loaded isOnList: $isOnList");
    } else {
      print("⚠️ No saved ringer data found.");
    }
    isLoading.value = false; // <-- loading done
  }

  void InitializeButton() {
    // Grow the list up to the required index
    // while (isOnList.length <= index) {
    //   isOnList.add(false); // Or any default value
    // }
    isOnList.add(false); // Adds a new button with isOn = false
  }

  void toggleSwitch(int index) {
    isOnList[index] = !isOnList[index];
    print("isOn: $isOnList");
  }
}
