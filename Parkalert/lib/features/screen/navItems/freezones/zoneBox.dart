import 'package:Parkalert/features/controllers/alert/isON.dart';
import 'package:Parkalert/features/controllers/navItems/main_controller.dart';
import 'package:Parkalert/features/screen/helperWidget/Button.dart';
import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
import 'package:Parkalert/utils/storage/data/ZoneData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoneBox extends StatelessWidget {
  final ZoneData zoneData;

  const ZoneBox({Key? key, required this.zoneData}) : super(key: key);

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
    final Color color = colorOptions[zoneData.index % colorOptions.length];
    List<Color> colorOptionsdark = [
      AppColors.alert1Dark,
      AppColors.alert2Dark,
      AppColors.alert3Dark,
    ];
    final Color colordark =
        colorOptionsdark[zoneData.index % colorOptionsdark.length];
    List<Color> colorOptions2 = [
      AppColors.button1,
      AppColors.button2,
      AppColors.button3,
    ];
    final Color color2 = colorOptions2[zoneData.index % colorOptions2.length];

    List<Color> colorText = [AppColors.text1, AppColors.text2, AppColors.text3];
    final Color Textcolor = colorText[zoneData.index % colorText.length];
    var ZoneBoxList = <ZoneData>[].obs;

    return GestureDetector(
      onTap: () => {
        print('Container tapped!'),
        // controller.alertSettingeEditingPage(zoneData),
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
                  Center(
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(
                              255,
                              22,
                              230,
                              129,
                            ).withOpacity(0.9),

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
                    ),
                  ),
                  const SizedBox(width: 44), // small space between logo & text
                  Text(
                    "SwetaMajarkans",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color2,
                    ),
                  ),
                  const Spacer(), // pushes the icon to the right

                  CircleAvatar(
                    radius: 14, // size of circle
                    backgroundColor: colorOptions[1], // circle background color
                    child: Icon(
                      Icons.location_on,
                      size: 18,
                      color: Colors.white, // icon color
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_timeBox('10:20', colordark)],
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
                        zoneData.initialTime,
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
                        zoneData.stopTime,
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

              // Obx(() {
              //   if (isOnController.isLoading.value) {
              //     // Show loading or placeholder while loading
              //     return CircularProgressIndicator();
              //   }

              //   bool isOn = isOnController.isOnList[zoneData.index];
              //   print("Obx is ============================rebuilding");

              //   return buildConnectButton(
              //     text: isOn ? 'Disconnect' : 'Connect',
              //     backgroundColor: color2,
              //     textColor: Textcolor,
              //     onPressed: () {
              //       isOnController.toggleSwitch(context, zoneData);
              //     },
              //   );
              // }),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _timeBox(String time, Color textColor) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.9),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      time,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    ),
  );
}
