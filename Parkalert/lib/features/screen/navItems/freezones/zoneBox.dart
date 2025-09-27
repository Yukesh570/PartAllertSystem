import 'dart:async';

import 'package:Parkalert/features/controllers/alert/isON.dart';
import 'package:Parkalert/features/controllers/navItems/freeZone_controller.dart';
import 'package:Parkalert/features/controllers/main_controller.dart';
import 'package:Parkalert/features/screen/helperWidget/Button.dart';
import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
import 'package:Parkalert/features/screen/helperWidget/snackbar.dart';
import 'package:Parkalert/features/screen/map/map.dart';
import 'package:Parkalert/utils/storage/data/ZoneData.dart';
import 'package:Parkalert/utils/storage/zoneStorage/zoneStorage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ZoneBox extends StatefulWidget {
  final ZoneData zoneData;

  const ZoneBox({Key? key, required this.zoneData});
  @override
  State<ZoneBox> createState() => ZoneBoxState();
}

class ZoneBoxState extends State<ZoneBox> {
  final MainController controller = Get.put(MainController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _initialTimeController = TextEditingController();
  final TextEditingController _stopTimeController = TextEditingController();
  bool showExit = false; // 👈 local state

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.zoneData.name;
    _initialTimeController.text = widget.zoneData.initialTime;
    _stopTimeController.text = widget.zoneData.stopTime;
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
        colorOptions[widget.zoneData.index % colorOptions.length];
    List<Color> colorOptionsdark = [
      AppColors.alert1Dark,
      AppColors.alert2Dark,
      AppColors.alert3Dark,
    ];
    final Color colordark =
        colorOptionsdark[widget.zoneData.index % colorOptionsdark.length];
    List<Color> colorOptions2 = [
      AppColors.button1,
      AppColors.button2,
      AppColors.button3,
    ];
    final Color color2 =
        colorOptions2[widget.zoneData.index % colorOptions2.length];

    List<Color> colorText = [AppColors.text1, AppColors.text2, AppColors.text3];
    final Color Textcolor = colorText[widget.zoneData.index % colorText.length];
    print("nnnnaaammmeee===${widget.zoneData.name}");
    print("nnnnaaammmeee===${_nameController.text}");
    // List<Color> colorLoc = [AppColors.text1, AppColors.alert1, AppColors.text3];
    // final Color LocColor = colorText[zoneData.index % colorText.length];

    Widget _timeBox(TextEditingController controller, Color textColor) {
      return Container(
        width: 80,
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
          child: TextField(
            controller: controller,
            onSubmitted: (value) {
              updateZones(widget.zoneData.index, null, null, null, value, null);
              setState(() {
                widget.zoneData.initialTime = value;
              });
            },
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Textcolor,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              focusedBorder: InputBorder.none, // remove focus border
              enabledBorder: InputBorder.none, // remove enabled border
              hintText: "HH:mm",
            ),
          ),
        ),
      );
    }

    Widget _timeBox_(TextEditingController controller, Color textColor) {
      return Container(
        width: 80,
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
          child: TextField(
            controller: controller,
            onSubmitted: (value) {
              updateZones(widget.zoneData.index, null, null, null, null, value);
              setState(() {
                widget.zoneData.stopTime = value;
              });
            },

            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Textcolor,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              focusedBorder: InputBorder.none, // remove focus border
              enabledBorder: InputBorder.none, // remove enabled border
              hintText: "HH:mm",
            ),
          ),
        ),
      );
    }

    Future<void> _showEditDialog(BuildContext context) async {
      final nameController = TextEditingController(text: widget.zoneData.name);
      final initialTimeController = TextEditingController(
        text: widget.zoneData.initialTime,
      );
      final stopTimeController = TextEditingController(
        text: widget.zoneData.stopTime,
      );

      final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          final dark = Theme.of(context).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: dark
                ? AppColors.alert3Dark
                : Colors.white, // 👈 Dark/Light mode

            title: const Text("Edit Zone"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Zone Name"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: initialTimeController,
                  decoration: const InputDecoration(
                    labelText: "Initial Time (HH:mm)",
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: stopTimeController,
                  decoration: const InputDecoration(
                    labelText: "Stop Time (HH:mm)",
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 14,
                    color: dark
                        ? Colors.white
                        : Colors.black, // adjust if needed
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                    255,
                    90,
                    102,
                    224,
                  ), // light mode background
                  foregroundColor: Colors.white, // text/icon stays white
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Update zone values
                  updateZones(
                    widget.zoneData.index,
                    null,
                    null,
                    nameController.text,
                    null,
                    null,
                  );

                  setState(() {
                    widget.zoneData.name = nameController.text;
                    // widget.zoneData.initialTime = initialTimeController.text;
                    // widget.zoneData.stopTime = stopTimeController.text;
                    // _initialTimeController.text = initialTimeController.text;
                    // _stopTimeController.text = stopTimeController.text;
                  });

                  Navigator.pop(context, true);
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      );

      if (result == true) {
        CustomSnackBar.show(
          context,
          message: "Zone updated successfully",
          backgroundColor: Colors.green[600]!,
        );
      }
    }

    return GestureDetector(
      onLongPress: () {
        setState(() {
          showExit = !showExit; // 👈 toggle on long press
        });
      },
      onTap: () {
        if (showExit) {
          setState(() {
            showExit = false;
          });
        } else {
          _showEditDialog(context); // 👈 open popup
        }
        FocusScope.of(context).unfocus();
      },
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
                      height: 60,
                      child: Center(
                        child: Obx(() {
                          if (isOnController.isLoading.value) {
                            // Show loading or placeholder while loading
                            return CircularProgressIndicator();
                          }
                          bool isOn =
                              isOnController.isOnList[widget.zoneData.index];

                          return Center(
                            child: Container(
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
                            ),
                          );
                        }),
                      ),
                    ),
                    const Spacer(),

                    // SizedBox(width: 37),
                    Center(
                      child: SizedBox(
                        height: 34, // tighter height
                        width: 160, // fixed width instead of expanding
                        child: Text(
                          widget
                              .zoneData
                              .name, // 👈 replaces _nameController.text
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: color2,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
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

                            controller.mapPage(widget.zoneData);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 8),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     _timeBox(_initialTimeController, colordark),
                //     const SizedBox(width: 15),

                //     Text(
                //       "TOT",
                //       style: TextStyle(
                //         fontSize: 15,
                //         fontWeight: FontWeight.bold,
                //         color: color2,
                //       ),
                //     ),
                //     const SizedBox(width: 15),

                //     _timeBox_(_stopTimeController, colordark),
                //   ],
                // ),
                const SizedBox(height: 8),
                Obx(() {
                  // if (isOnController.isLoading.value) {
                  //   // Show loading or placeholder while loading
                  //   return CircularProgressIndicator();
                  // }
                  bool isOn = isOnController.isOnList[widget.zoneData.index];

                  return buildConnectButton(
                    context: context,
                    text: isOn ? 'Disconnect' : 'Connect',
                    backgroundColor: color2,
                    textColor: dark ? Colors.white : Textcolor,

                    onPressed: () {
                      isOnController.toggleSwitch(context, widget.zoneData);
                    },
                  );
                }),
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

          if (showExit)
            Positioned(
              right: 2,
              top: 2,
              child: GestureDetector(
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: dark
                            ? AppColors.alert3Dark
                            : Colors.white, // 👈 Dark/Light mode
                        title: Text(
                          "Delete Zone",
                          style: TextStyle(
                            fontSize: 14,
                            color: dark
                                ? Colors.white
                                : Colors.black, // adjust if needed
                          ),
                        ),
                        content: Text(
                          "Are you sure you want to delete this zone?",
                          style: TextStyle(
                            fontSize: 14,
                            color: dark
                                ? Colors.white
                                : Colors.black, // adjust if needed
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 14,
                                color: dark
                                    ? Colors.white
                                    : Colors.black, // adjust if needed
                              ),
                            ),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              elevatedButtonTheme: ElevatedButtonThemeData(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  minimumSize: const Size(60, 30),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  elevation: 0,
                                ),
                              ),
                              splashColor: Colors.transparent, // remove splash
                              highlightColor:
                                  Colors.transparent, // remove focus highlight
                              focusColor:
                                  Colors.transparent, // remove focus border
                            ),
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: dark
                                      ? Colors.black
                                      : Colors.white, // adjust if needed
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    await deleteZone(widget.zoneData.index);
                    setState(() {
                      showExit = false;
                    });
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
