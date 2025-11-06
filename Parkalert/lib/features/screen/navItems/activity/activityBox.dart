import 'package:Parkalert/features/controllers/navItems/freeZone_controller.dart';
import 'package:Parkalert/features/controllers/main_controller.dart';
import 'package:Parkalert/features/screen/helperWidget/Button.dart';
import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
import 'package:Parkalert/features/screen/map/locationHistory.dart';
import 'package:Parkalert/utils/storage/data/historyData.dart';
import 'package:Parkalert/utils/storage/zoneStorage/zoneStorage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ActivityBox extends StatefulWidget {
  final Historydata historydata;

  const ActivityBox({Key? key, required this.historydata});
  @override
  State<ActivityBox> createState() => ActivityBoxState();
}

class ActivityBoxState extends State<ActivityBox> {
  final MainController controller = Get.put(MainController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _initialTimeController = TextEditingController();
  final TextEditingController _stopTimeController = TextEditingController();
  bool _showExit = false; // 👈 NEW

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.historydata.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _initialTimeController.dispose();
    _stopTimeController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    final isOnController = Get.put(FreezoneController(), permanent: true);
    List<Color> colorOptions = [
      AppColors.alert1,
      AppColors.alert2,
      AppColors.alert3,
    ];
    final Color color =
        colorOptions[widget.historydata.index % colorOptions.length];
    List<Color> colorOptionsdark = [
      AppColors.alert1Dark,
      AppColors.alert2Dark,
      AppColors.alert3Dark,
    ];
    final Color colordark =
        colorOptionsdark[widget.historydata.index % colorOptionsdark.length];
    List<Color> colorOptions2 = [
      AppColors.button1,
      AppColors.button2,
      AppColors.button3,
    ];
    final Color color2 =
        colorOptions2[widget.historydata.index % colorOptions2.length];

    List<Color> colorText = [AppColors.text1, AppColors.text2, AppColors.text3];
    final Color Textcolor =
        colorText[widget.historydata.index % colorText.length];

    // List<Color> colorLoc = [AppColors.text1, AppColors.alert1, AppColors.text3];
    // final Color LocColor = colorText[historydata.index % colorText.length];

    Widget _timeBox(String time, Color textColor) {
      int timestamp = int.parse(time);

      DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      String formattedDate = DateFormat('yyyy/MM/dd').format(date);

      return Container(
        width: 150,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color2, // or any background color
          border: Border.all(
            color: Colors.grey, // border color
            width: 1, // border width
          ),
          borderRadius: BorderRadius.circular(15),
        ),

        child: Center(
          child: Text(
            formattedDate,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Textcolor,
            ),
            // decoration: const InputDecoration(
            //   border: InputBorder.none,
            //   isDense: true,
            //   contentPadding: EdgeInsets.zero,
            //   focusedBorder: InputBorder.none, // remove focus border
            //   enabledBorder: InputBorder.none, // remove enabled border
            //   hintText: "HH:mm",
            // ),
          ),
        ),
      );
    }

    Widget _timeBox_(String time, Color textColor) {
      int timestamp = int.parse(time);

      DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      String formattedTime = DateFormat('HH:mm').format(date);

      return Container(
        width: 70,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color2, // or any background color
          border: Border.all(
            color: Colors.grey, // border color
            width: 1, // border width
          ),
          borderRadius: BorderRadius.circular(15),
        ),

        child: Center(
          child: Text(
            formattedTime,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Textcolor,
            ),

            // ),
          ),
        ),
      );
    }

    Widget statusBox(String status, Color textColor) {
      final sat = status != null ? status : "hi";
      return Container(
        width: 235,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color2, // or any background color
          border: Border.all(
            color: Colors.grey, // border color
            width: 1, // border width
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            sat,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Textcolor,
            ),

            // ),
          ),
        ),
      );
    }

    return GestureDetector(
      child: Stack(
        children: [
          Container(
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
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    SizedBox(
                      width: 40, // match the height/width to balance shadows
                      height: 40,
                      child: Center(
                        child: Obx(() {
                          if (isOnController.isLoading.value) {
                            // Show loading or placeholder while loading
                            return CircularProgressIndicator();
                          }
                          // bool isOn =
                          //     isOnController.isOnList[widget.historydata.index];

                          return Center(
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        // isOn
                                        // ? const Color.fromARGB(
                                        //     255,
                                        //     22,
                                        //     230,
                                        //     129,
                                        //   ).withOpacity(0.9)
                                        // :
                                        Colors.transparent,
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
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 8), // spacing between icon and text
                    Expanded(
                      child: Text(
                        widget.historydata.name ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: color2,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: CircleAvatar(
                        radius: 14, // size of circle
                        backgroundColor: color2, // circle background color
                        child: IconButton(
                          padding: EdgeInsets.zero, // remove default padding
                          icon: Icon(
                            Icons.location_on,
                            size: 18,
                            color: color, // icon color
                          ),
                          onPressed: () {
                            // if (_polygons.isNotEmpty) {
                            //   goToPolygon(_polygons.first);
                            // }
                            controller.locationHistory(
                              historydata: widget.historydata,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _timeBox(widget.historydata.time, colordark),
                        const SizedBox(width: 15),

                        _timeBox_(widget.historydata.time, colordark),
                      ],
                    ),
                    const SizedBox(height: 8),

                    statusBox(widget.historydata.status ?? '', colordark),
                  ],
                ),

                const SizedBox(height: 8),

                // Obx(() {
                //   if (isOnController.isLoading.value) {
                //     // Show loading or placeholder while loading
                //     return CircularProgressIndicator();
                //   }

                //   bool isOn = isOnController.isOnList[widget.historydata.index];
                //   print("Obx is ============================rebuilding");

                //   return buildConnectButton(
                //     text: isOn ? 'Disconnect' : 'Connect',
                //     backgroundColor: color2,
                //     textColor: Textcolor,
                //     onPressed: () {},
                //   );
                // }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
