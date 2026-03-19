import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/controllers/pagger.dart';
import 'package:Parkalert/utils/storage/data/RingerData.dart';
import 'package:Parkalert/features/controllers/alert/isON.dart';
import 'package:Parkalert/features/controllers/main_controller.dart';
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

class AlertSetting extends StatefulWidget {
  final RingerData? ringerData; // 👈 make it nullable

  const AlertSetting({
    super.key,
    this.ringerData, // 👈 now it's optional
  });

  @override
  State<AlertSetting> createState() => _AlertSettingState();
}

class _AlertSettingState extends State<AlertSetting> {
  final TextEditingController _bluetoothDeviceController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController soundController = TextEditingController();
  bool _inform = true;
  bool _silent = false;
  bool _isConnectSelected = true;

  @override
  void dispose() {
    _bluetoothDeviceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    NotificationService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      // This means localization isn't yet loaded or context is not in a localized widget tree
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_silent) {
      checkAndRequestDndPermission(context);
    }
    final MainController controller = Get.put(MainController());
    DateTime now = DateTime.now();
    final drawerCtrl = Get.find<DrawerControllerX>();

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
      required bool vibration,
      required bool overRideSilence,
      required String triggerType,
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
        vibration: vibration,
        overRideSilence: overRideSilence,
        triggerType: triggerType,
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
        routeName: '/alertSetting',
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          drawerEnableOpenDragGesture: false,

          backgroundColor: dark ? Colors.black : Colors.white, // 👈 Add this
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,

            title: Text(
              (() {
                try {
                  return loc.parkingalarms;
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

          body: SafeArea(
            minimum: const EdgeInsets.only(bottom: 12.0),

            child: Stack(
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
                      height: 670,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              child: Text(
                                loc.setyouralarm,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              child: Text(
                                loc.myalarms,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),

                            // Main alert settings card
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              height: 550,

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

                                    child: Text(
                                      loc.createalert,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),

                                  // Name, Bluetooth device, Sound sections
                                  buildAlertFormRow(
                                    context: context,
                                    icon: Icons.person_outline,
                                    text: loc.name,
                                    controller: _nameController,
                                    onTap: () {
                                      /* Handle tap */
                                    },
                                    readOnly: false,
                                  ),
                                  const SizedBox(height: 15.0),
                                  buildAlertFormRow(
                                    context: context,
                                    icon: Icons.bluetooth,
                                    text: loc.bluetoothdevice,
                                    onTap: () async {
                                      final device =
                                          await showDialog<
                                            flutter_blue_classic.BluetoothDevice
                                          >(
                                            context: context,
                                            builder: (_) =>
                                                PairedDevicesDialog(),
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
                                    context: context,
                                    icon: Icons.music_note,
                                    text: loc.sound,
                                    controller: soundController,
                                    onTap: () {
                                      showSoundPicker(
                                        context: context,
                                        controller: soundController,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 15.0),

                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.vibration_rounded,
                                            color: AppColors.iconColor,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 15.0),
                                      Switch(
                                        value: _inform,
                                        onChanged: (value) async {
                                          setState(() => _inform = value);
                                        },
                                        activeColor: Colors.white,
                                        activeTrackColor: AppColors.iconColor,
                                        inactiveThumbColor: Colors.white,
                                        inactiveTrackColor:
                                            Colors.grey.shade400,
                                        trackOutlineColor:
                                            WidgetStatePropertyAll(
                                              Colors.transparent,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.volume_up,
                                        color: AppColors.iconColor,
                                        size: 30,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        loc.overrideSilentMode,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Switch(
                                        value: _silent,
                                        onChanged: (value) => setState(() {
                                          _silent = value;
                                        }),

                                        activeColor: Colors.white,
                                        activeTrackColor: AppColors.iconColor,
                                        inactiveThumbColor: Colors.white,
                                        inactiveTrackColor:
                                            Colors.grey.shade400,
                                        trackOutlineColor:
                                            WidgetStatePropertyAll(
                                              Colors.transparent,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 50.0),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: dark
                                          ? Colors.grey[850]
                                          : Colors
                                                .grey[200], // Background of the unselected area
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        // CONNECT BUTTON
                                        GestureDetector(
                                          onTap: () => setState(
                                            () => _isConnectSelected = true,
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              // If selected, show the highlight color
                                              color: _isConnectSelected
                                                  ? (dark
                                                        ? Colors.blueGrey[800]
                                                        : const Color(
                                                            0xFFDDE3F9,
                                                          ))
                                                  : Colors.transparent,
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                    top: Radius.circular(20.0),
                                                  ),
                                            ),
                                            child: Text(
                                              "Connect",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: _isConnectSelected
                                                    ? (dark
                                                          ? Colors.white
                                                          : const Color(
                                                              0xFF4A5C7D,
                                                            ))
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // DIVIDER LINE
                                        Divider(
                                          height: 1,
                                          color: dark
                                              ? Colors.grey[700]
                                              : Colors.grey[300],
                                        ),
                                        // DISCONNECT BUTTON
                                        GestureDetector(
                                          onTap: () => setState(
                                            () => _isConnectSelected = false,
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              // If selected, show the highlight color
                                              color: !_isConnectSelected
                                                  ? (dark
                                                        ? Colors.blueGrey[800]
                                                        : const Color(
                                                            0xFFDDE3F9,
                                                          ))
                                                  : Colors.transparent,
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                    bottom: Radius.circular(
                                                      20.0,
                                                    ),
                                                  ),
                                            ),
                                            child: Text(
                                              "Disconnect",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: !_isConnectSelected
                                                    ? (dark
                                                          ? Colors.white
                                                          : const Color(
                                                              0xFF4A5C7D,
                                                            ))
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                    padding: const EdgeInsets.only(bottom: 12.0),
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
                          text: loc.main,
                          onPressed: () {
                            controller.alertPage();
                          },
                          context: context,
                        ),
                        checkAlertButton(
                          context: context,
                          onPressed: () async {
                            final String name = _nameController.text.trim();
                            final String bluetoothDevice =
                                _bluetoothDeviceController.text.trim();
                            final String sound = soundController.text.trim();

                            if (name.isNotEmpty) {
                              await _addRingers(
                                name: name,
                                bluetooth: bluetoothDevice,
                                sound: sound,
                                date: currentDate,
                                time: currentTime, // or get from UI
                                isOn: false,
                                vibration: _inform,
                                overRideSilence: _silent,
                                triggerType: _isConnectSelected
                                    ? "Connect"
                                    : "Disconnect",
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
      ),
    );
  }
}
