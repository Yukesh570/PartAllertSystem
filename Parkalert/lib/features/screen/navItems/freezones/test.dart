import 'package:Parkalert/features/controllers/alert/isON.dart';
import 'package:Parkalert/features/controllers/navItems/freeZone_controller.dart';
import 'package:Parkalert/features/controllers/navItems/main_controller.dart';
import 'package:Parkalert/features/screen/helperWidget/Button.dart';
import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
import 'package:Parkalert/utils/storage/data/ZoneData.dart';
import 'package:Parkalert/utils/storage/zoneStorage/zoneStorage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  bool _showExit = false;

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

  @override
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
    final Color textColor = colorText[widget.zoneData.index % colorText.length];

    Widget _timeBox(
      TextEditingController controller,
      Color textColor,
      bool isStart,
    ) {
      return Container(
        width: 80,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color2,
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: TextField(
            controller: controller,
            onSubmitted: (value) {
              updateZones(
                widget.zoneData.index,
                null,
                null,
                null,
                isStart ? value : null,
                isStart ? null : value,
              );
            },
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: "HH:mm",
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (_showExit) {
          setState(() {
            _showExit = false; // 👈 hide exit on tap anywhere
          });
        }
      },
      onLongPress: () {
        setState(() {
          _showExit = !_showExit; // 👈 toggle exit with long press
        });
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Obx(() {
                          if (isOnController.isLoading.value) {
                            return const CircularProgressIndicator();
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        onSubmitted: (value) {
                          updateZones(
                            widget.zoneData.index,
                            null,
                            null,
                            value,
                            null,
                            null,
                          );
                        },
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: color2,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: color2,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.location_on, size: 18, color: color),
                          onPressed: () {
                            controller.mapPage(widget.zoneData);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _timeBox(_initialTimeController, colordark, true),
                    const SizedBox(width: 15),
                    Text(
                      "TOT",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: color2,
                      ),
                    ),
                    const SizedBox(width: 15),
                    _timeBox(_stopTimeController, colordark, false),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(() {
                  bool isOn = isOnController.isOnList[widget.zoneData.index];
                  return buildConnectButton(
                    text: isOn ? 'Disconnect' : 'Connect',
                    backgroundColor: color2,
                    textColor: textColor,
                    onPressed: () {
                      isOnController.toggleSwitch(context, widget.zoneData);
                    },
                  );
                }),
              ],
            ),
          ),
          if (_showExit)
            Positioned(
              right: 8,
              top: 8,
              child: GestureDetector(
                behavior:
                    HitTestBehavior.opaque, // 👈 prevent tap from bubbling up
                onTap: () {
                  setState(() {
                    _showExit = false; // 👈 close only when tapping this button
                  });
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
