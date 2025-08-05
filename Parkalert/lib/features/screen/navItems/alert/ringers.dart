import 'dart:convert';

import 'package:Parkalert/utils/storage/data/RingerData.dart';
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
    var ringersList = <RingerData>[].obs;

    return GestureDetector(
      onTap: () => {
        print('Container tapped!'),
        controller.alertSettingeEditingPage(ringerData),
      },
      child: Center(
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
            mainAxisSize: MainAxisSize.min,
            children: [
              // Alert 1 Header
              Row(
                children: [
                  Obx(() {
                    if (isOnController.isLoading.value) {
                      // Show loading or placeholder while loading
                      return CircularProgressIndicator();
                    }
                    bool isOn = isOnController.isOnList[ringerData.index];
                    return Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: isOn
                                ? const Color.fromARGB(
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
                        width: 25,
                        height: 25,
                        fit: BoxFit.contain,
                      ),
                    );
                  }),

                  const SizedBox(width: 8.0),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
                      ),
                      // width: 240, // set your width
                      // height: 40, // set your height
                      decoration: BoxDecoration(
                        color: color2, // or any background color
                        border: Border.all(
                          color: Colors.grey, // border color
                          width: 1, // border width
                        ),
                        borderRadius: BorderRadius.circular(16), // curved edges
                      ),
                      child: Center(
                        child: Text(
                          ringerData.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Textcolor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.bluetooth,
                        size: 20,
                        color: colorOptions2[2],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8.0),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
                      ),
                      // width: 240, // set your width
                      // height: 40, // set your height
                      decoration: BoxDecoration(
                        color: color2, // or any background color
                        border: Border.all(
                          color: Colors.grey, // border color
                          width: 1, // border width
                        ),
                        borderRadius: BorderRadius.circular(16), // curved edges
                      ),
                      child: Center(
                        child: Text(
                          ringerData.bluetooth,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Textcolor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  SizedBox(width: 20),

                  Container(
                    width: 120, // set your width
                    height: 40, // set your height

                    decoration: BoxDecoration(
                      color: color2, // or any background color
                      border: Border.all(
                        color: Colors.grey, // border color
                        width: 1, // border width
                      ),
                      borderRadius: BorderRadius.circular(16), // curved edges
                    ),
                    child: Center(
                      child: Text(
                        ringerData.date,
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
                        width: 1, // border width
                      ),
                      borderRadius: BorderRadius.circular(16), // curved edges
                    ),
                    child: Center(
                      child: Text(
                        ringerData.time,
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

              SizedBox(height: 8),

              Obx(() {
                if (isOnController.isLoading.value) {
                  // Show loading or placeholder while loading
                  return CircularProgressIndicator();
                }

                bool isOn = isOnController.isOnList[ringerData.index];
                print("Obx is ============================rebuilding");

                return buildConnectButton(
                  text: isOn ? 'Disconnect' : 'Connect',
                  backgroundColor: color2,
                  textColor: Textcolor,
                  onPressed: () {
                    isOnController.toggleSwitch(context, ringerData);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
