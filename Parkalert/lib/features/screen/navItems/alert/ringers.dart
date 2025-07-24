import 'dart:convert';

import 'package:Parkalert/data/RingerData.dart';
import 'package:Parkalert/features/controllers/alert/isON.dart';
import 'package:Parkalert/features/controllers/navItems/main_controller.dart';
import 'package:Parkalert/features/screen/helperWidget/Button.dart';
import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
import 'package:Parkalert/features/screen/navItems/alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class Ringers extends StatelessWidget {
  final RingerData ringerData;
  // final RingerData ringerData;

  // const Ringers({super.key, required this.ringerData});
  const Ringers({Key? key, required this.ringerData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

    final dark = Theme.of(context).brightness == Brightness.dark;

    final isOnController = Get.put(IsOnController(), permanent: true);
    List<Color> colorOptions = [
      AppColors.alert1,
      AppColors.alert2,
      AppColors.alert3,
    ];
    final Color color = colorOptions[ringerData.index % colorOptions.length];
    List<Color> colorOptionsdark = [
      AppColors.alert1Dark,
      AppColors.alert2Dark,
      AppColors.alert3Dark,
    ];
    final Color colordark =
        colorOptionsdark[ringerData.index % colorOptionsdark.length];
    List<Color> colorOptions2 = [
      AppColors.button1,
      AppColors.button2,
      AppColors.button3,
    ];
    final Color color2 = colorOptions2[ringerData.index % colorOptions2.length];

    List<Color> colorText = [AppColors.text1, AppColors.text2, AppColors.text3];
    final Color Textcolor = colorText[ringerData.index % colorText.length];

    return GestureDetector(
      onTap: () => {print('Container tapped!'), controller.alertSettingPage()},
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: dark ? AppColors.alert3Dark : color,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Alert 1 Header
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 16.0,
              ),

              child: Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: const Offset(-18, -15),
                    child: Obx(() {
                      if (isOnController.isLoading.value) {
                        // Show loading or placeholder while loading
                        return CircularProgressIndicator();
                      }

                      print(
                        " isOnController.isOnList======== ${isOnController.isOnList}",
                      );

                      bool isOn = isOnController.isOnList[ringerData.index];

                      return Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: isOn
                                  ? Color.fromARGB(
                                      255,
                                      22,
                                      230,
                                      129,
                                    ).withOpacity(0.9)
                                  : Colors.transparent,
                              spreadRadius: 2,
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/logos/partalertlogosplash.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(width: 100.0),

                  Transform.translate(
                    offset: const Offset(-25, -15),
                    child: Text(
                      'Alert 1',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: dark
                            ? Colors.white
                            : const Color.fromARGB(255, 0, 0, 0),
                      ),

                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              child: Row(
                children: [
                  SizedBox(width: 20),

                  Container(
                    width: 120, // set your width
                    height: 40, // set your height

                    decoration: BoxDecoration(
                      color: color2, // or any background color
                      border: Border.all(
                        color: Colors.grey, // border color
                        width: 2, // border width
                      ),
                      borderRadius: BorderRadius.circular(16), // curved edges
                    ),
                    child: Center(
                      child: Text(
                        "12-6-2025",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Textcolor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 90, // set your width
                    height: 40, // set your height
                    decoration: BoxDecoration(
                      color: color2, // or any background color
                      border: Border.all(
                        color: Colors.grey, // border color
                        width: 2, // border width
                      ),
                      borderRadius: BorderRadius.circular(16), // curved edges
                    ),
                    child: Center(
                      child: Text(
                        "15:55",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Textcolor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            Obx(() {
              if (isOnController.isLoading.value) {
                // Show loading or placeholder while loading
                return CircularProgressIndicator();
              }

              bool isOn = isOnController.isOnList[ringerData.index];

              return buildConnectButton(
                text: isOn ? 'Disconnect' : 'Connect',
                backgroundColor: color2,
                textColor: Textcolor,
                onPressed: () {
                  isOnController.toggleSwitch(ringerData.index);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
