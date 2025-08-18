import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/controllers/pagger.dart';
import 'package:Parkalert/utils/storage/data/RingerData.dart';
import 'package:Parkalert/features/controllers/alert/isON.dart';
import 'package:Parkalert/features/controllers/navItems/main_controller.dart';
import 'package:Parkalert/features/screen/helperWidget/backgroundCirlce.dart';
import 'package:Parkalert/features/screen/helperWidget/bluetooth.dart';
import 'package:Parkalert/features/screen/helperWidget/Button.dart';
import 'package:Parkalert/features/screen/helperWidget/alertFrom.dart';
import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
import 'package:Parkalert/features/screen/helperWidget/sound.dart';
import 'package:Parkalert/features/screen/navItems/alert/alert.dart';
import 'package:Parkalert/features/screen/navItems/alert/ringers.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:Parkalert/navigationButton.dart';
import 'package:Parkalert/utils/storage/ringerStorage/ringerStorage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:Parkalert/features/screen/helperWidget/sound.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart' as classic;
import 'package:flutter_blue_classic/flutter_blue_classic.dart'
    as flutter_blue_classic;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class AlertSettingEdit extends StatefulWidget {
  final RingerData? ringerData; // 👈 make it nullable

  const AlertSettingEdit({
    super.key,
    this.ringerData, // 👈 now it's optional
  });

  @override
  State<AlertSettingEdit> createState() => _AlertSettingEditState();
}

class _AlertSettingEditState extends State<AlertSettingEdit> {
  final TextEditingController _bluetoothDeviceController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final drawerCtrl = Get.find<DrawerControllerX>();

  final TextEditingController soundController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.ringerData != null) {
      _bluetoothDeviceController.text = widget.ringerData!.bluetooth;
      _nameController.text = widget.ringerData!.name;
      soundController.text = widget.ringerData!.sound;
    }
    NotificationService.initialize();
  }

  @override
  void dispose() {
    _bluetoothDeviceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      // This means localization isn't yet loaded or context is not in a localized widget tree
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final MainController controller = Get.put(MainController());
    IsOnController isOnController = Get.put(IsOnController());
    DateTime now = DateTime.now();

    String currentDate = DateFormat(
      'yyyy-MM-dd',
    ).format(now); // e.g., 2025-08-01
    String currentTime = DateFormat('HH:mm').format(now);
    List<RingerData> ringersDataList = [];
    _addRingers({
      required String name,
      required String bluetooth,
      required String sound,
      required String date,
      required String time,
      required bool isOn,
    }) async {
      final List<RingerData> savedRingers = await loadRingers();

      final newIndex = savedRingers.length;
      // Create new RingerData with default or initial values
      RingerData newRingerData = RingerData(
        index: newIndex,
        date: date, // or get from UI
        time: time, // or get from UI
        isOn: isOn,
        name: name,
        bluetooth: bluetooth,
        sound: sound,
      );
      ringersDataList.add(newRingerData);

      // Extract data to save
      // List<RingerData> dataToSave = ringersList.map((ringer) {
      //   return RingerData(
      //     index: ringer.ringerData.index,
      //     date: ringer.ringerData.date, // ← Replace with actual data from UI
      //     time: ringer.ringerData.time, // ← Replace with actual data from UI
      //     isOn: ringer
      //         .ringerData
      //         .isOn, // ← Get this from your controller if dynamic
      //     name: ringer.ringerData.name,
      //     bluetooth: ringer.ringerData.bluetooth,
      //     sound: ringer.ringerData.sound,
      //   );
      // }).toList();
      await saveRingers(ringersDataList);
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),

      child: PageWrapper(
        routeName: '/alertSettingEdit',
        child: Scaffold(
          resizeToAvoidBottomInset: false,

          backgroundColor: dark ? Colors.black : Colors.white, // 👈 Add this
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,

            title: Text(
              (() {
                try {
                  return loc.alerts;
                } catch (e) {
                  print("Localization error: $e");
                  return 'Alerts';
                }
              })(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: dark ? Colors.white : Colors.black,
                  ),

                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              },
            ),
          ),
          drawer: const navButton(),

          body: Stack(
            children: [
              // Background pattern (simplified for demonstration)
              Positioned.fill(
                child: CustomPaint(painter: BackgroundCirclesPainter(dark)),
              ),

              // Main content
              Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  bottom: 0,
                  right: 20,
                  left: 20,
                ),
                child: SingleChildScrollView(
                  child: Container(
                    height: 680,
                    padding: const EdgeInsets.symmetric(
                      vertical: 2.0,
                      horizontal: 20.0,
                    ),
                    decoration: BoxDecoration(
                      color: dark
                          ? const Color.fromARGB(255, 20, 20, 20)
                          : AppColors.alertHeaderBackground,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // "Set your Alert" and "My Alerts" text
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            child: Text(
                              'Set your Alert',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            child: Text(
                              'My Alerts',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // Main alert settings card
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            height: 580,

                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: dark
                                  ? const Color.fromARGB(255, 44, 44, 44)
                                  : AppColors.cardBackground,
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

                                  child: const Text(
                                    'Edit Alert',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 20.0),

                                // Name, Bluetooth device, Sound sections
                                buildAlertFormRow(
                                  icon: Icons.person_outline,
                                  text: 'Name',
                                  controller: _nameController,
                                  onTap: () {
                                    /* Handle tap */
                                  },
                                ),
                                const SizedBox(height: 15.0),
                                buildAlertFormRow(
                                  icon: Icons.bluetooth,
                                  text: 'Bluetooth device',
                                  onTap: () async {
                                    final device =
                                        await showDialog<
                                          flutter_blue_classic.BluetoothDevice
                                        >(
                                          context: context,
                                          builder: (_) => PairedDevicesDialog(),
                                        );
                                    if (device != null) {
                                      _bluetoothDeviceController.text =
                                          device.name ?? "Unknown Device";
                                    }
                                  },
                                  controller: _bluetoothDeviceController,
                                ),
                                const SizedBox(height: 15.0),
                                buildAlertFormRow(
                                  icon: Icons.music_note,
                                  text: 'Sound',
                                  controller: soundController,
                                  onTap: () {
                                    showSoundPicker(
                                      context: context,
                                      controller: soundController,
                                    );
                                  },
                                ),

                                const SizedBox(height: 30),
                                // Pushes buttons to the bottom
                                // Connect and Disconnect buttons
                                buildConnectButton(
                                  text: 'Connect',
                                  backgroundColor: AppColors.buttonBackground,
                                  textColor: AppColors.lightTextColor,
                                  onPressed: () {
                                    print("object");
                                    NotificationService.showBigTextNotification(
                                      title: "ParkAlert",
                                      body: "You are out of parking zone",
                                      fln: flutterLocalNotificationsPlugin,
                                    );
                                  },
                                ),
                                const SizedBox(height: 5.0),
                                buildConnectButton(
                                  text: 'Disconnect',
                                  backgroundColor: AppColors.buttonBackground,
                                  textColor: AppColors.lightTextColor,
                                  onPressed: () {
                                    /* Handle disconnect */
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ), // Space before bottom navigation
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Bottom navigation buttons
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildCircularIconButton(
                        context: context,

                        icon: Icons.arrow_back,
                        onPressed: () {
                          drawerCtrl.goBack(); // update drawer highlight

                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else {
                            // Optionally handle the case where there's no back route
                            print("No screen to go back to");
                          }
                        },
                      ),
                      buildMainButton(
                        text: 'Main',
                        onPressed: () {
                          controller.alertPage();
                        },
                        context: context,
                      ),
                      addAlertButton(
                        context: context,
                        onPressed: () async {
                          final String name = _nameController.text.trim();
                          final String bluetoothDevice =
                              _bluetoothDeviceController.text.trim();
                          final String sound = soundController.text.trim();

                          if (name.isNotEmpty &&
                              // bluetoothDevice.isNotEmpty &&
                              sound.isNotEmpty) {
                            await updateRingers(
                              widget.ringerData!.index,
                              widget.ringerData!.isOn,
                              name,
                              bluetoothDevice,
                              sound,
                            );
                            controller.alertPage();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
