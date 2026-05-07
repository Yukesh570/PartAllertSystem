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
  final String? preSelectedTrigger; // ✅ 1. Add this to catch the data
  const AlertSetting({
    super.key,
    this.ringerData, // 👈 now it's optional
    this.preSelectedTrigger, // ✅ 2. Add this
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
    if (widget.preSelectedTrigger != null) {
      _isConnectSelected = widget.preSelectedTrigger == "Connect";
      _nameController.text = "${widget.preSelectedTrigger}";
    }
  }

  // ✅ 2. Add this variable to prevent overwriting user input
  bool _isNameSet = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isNameSet && widget.preSelectedTrigger != null) {
      final loc = AppLocalizations.of(context);

      if (loc != null) {
        // Set the controller text using your translated ARB values
        _nameController.text = _isConnectSelected
            ? loc.connect
            : loc.disconnect; // (Make sure to add "disconnect" to your ARB files!)

        _isNameSet = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final MainController controller = Get.put(MainController());
    final drawerCtrl = Get.find<DrawerControllerX>();
    DateTime now = DateTime.now();
    String currentDate = DateFormat('yyyy-MM-dd').format(now);
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
          resizeToAvoidBottomInset:
              true, // ✅ Ensures layout moves up for keyboard
          backgroundColor: dark ? Colors.black : Colors.white,
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
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu,
                  color: dark ? Colors.white : Colors.black,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          drawer: const navButton(),
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: BackgroundCirclesPainter(dark)),
                ),
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        // ✅ Single scroll view for the entire form
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: dark
                                ? const Color.fromARGB(255, 20, 20, 20)
                                : AppColors.alertHeaderBackground,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                loc.setyouralarm,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                loc.myalarms,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16.0),

                              // Main Card
                              Container(
                                padding: const EdgeInsets.all(16.0),
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
                                  children: [
                                    Text(
                                      loc.createalert,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
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
                                      controller: _bluetoothDeviceController,
                                      onTap: () async {
                                        final device =
                                            await showDialog<
                                              flutter_blue_classic.BluetoothDevice
                                            >(
                                              context: context,
                                              builder: (_) =>
                                                  PairedDevicesDialog(),
                                            );
                                        if (device != null)
                                          setState(
                                            () =>
                                                _bluetoothDeviceController
                                                        .text =
                                                    device.name ??
                                                    "Unknown Device",
                                          );
                                      },
                                    ),
                                    const SizedBox(height: 15.0),
                                    buildAlertFormRow(
                                      context: context,
                                      icon: Icons.music_note,
                                      text: loc.sound,
                                      controller: soundController,
                                      onTap: () => showSoundPicker(
                                        context: context,
                                        controller: soundController,
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),

                                    // Switches
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.vibration_rounded,
                                          color: AppColors.iconColor,
                                          size: 30,
                                        ),
                                        const SizedBox(width: 15.0),
                                        Switch(
                                          value: _inform,
                                          onChanged: (v) =>
                                              setState(() => _inform = v),
                                          activeTrackColor: AppColors.iconColor,
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
                                        Expanded(
                                          child: Text(
                                            loc.overrideSilentMode,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Switch(
                                          value: _silent,
                                          onChanged: (v) =>
                                              setState(() => _silent = v),
                                          activeTrackColor: AppColors.iconColor,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 30.0),

                                    // ✅ Connection Selection UI
                                    if (widget.preSelectedTrigger == null)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: dark
                                              ? Colors.grey[850]
                                              : Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            20.0,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            _buildToggleButton(
                                              "Connect",
                                              _isConnectSelected,
                                              dark,
                                              true,
                                            ),
                                            Divider(
                                              height: 1,
                                              color: dark
                                                  ? Colors.grey[700]
                                                  : Colors.grey[300],
                                            ),
                                            _buildToggleButton(
                                              "Disconnect",
                                              !_isConnectSelected,
                                              dark,
                                              false,
                                            ),
                                          ],
                                        ),
                                      )
                                    else
                                      // SHOW THE LOCKED SELECTION (Read-only confirmation)
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: dark
                                              ? Colors.blueGrey[800]
                                              : const Color(0xFFDDE3F9),
                                          borderRadius: BorderRadius.circular(
                                            20.0,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              widget.preSelectedTrigger ==
                                                      "Connect"
                                                  ? Icons
                                                        .directions_car // Car icon for Connect
                                                  : Icons
                                                        .directions_walk, // Walking icon for Disconnect
                                              color: dark
                                                  ? Colors.white
                                                  : const Color(0xFF4A5C7D),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              widget.preSelectedTrigger ==
                                                      "Connect"
                                                  ? loc.connect
                                                  : loc.disconnect,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: dark
                                                    ? Colors.white
                                                    : const Color(0xFF4A5C7D),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ✅ Bottom Navigation (Stays outside the scroll view)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0, top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildCircularIconButton(
                            context: context,
                            icon: Icons.arrow_back,
                            onPressed: () {
                              drawerCtrl.goBack();
                              if (Navigator.of(context).canPop())
                                Navigator.of(context).pop();
                            },
                          ),
                          buildMainButton(
                            text: loc.main,
                            context: context,
                            onPressed: () => controller.alertPage(),
                          ),
                          checkAlertButton(
                            context: context,
                            onPressed: () async {
                              if (_nameController.text.trim().isNotEmpty) {
                                await _addRingers(
                                  name: _nameController.text.trim(),
                                  bluetooth: _bluetoothDeviceController.text
                                      .trim(),
                                  sound: soundController.text.trim(),
                                  date: currentDate,
                                  time: currentTime,
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Helper for the Connect/Disconnect toggle to ensure proper sizing
  Widget _buildToggleButton(
    String label,
    bool isSelected,
    bool dark,
    bool isTop,
  ) {
    return GestureDetector(
      onTap: () => setState(() => _isConnectSelected = isTop),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (dark ? Colors.blueGrey[800] : const Color(0xFFDDE3F9))
              : Colors.transparent,
          borderRadius: isTop
              ? const BorderRadius.vertical(top: Radius.circular(20.0))
              : const BorderRadius.vertical(bottom: Radius.circular(20.0)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? (dark ? Colors.white : const Color(0xFF4A5C7D))
                : Colors.grey,
          ),
        ),
      ),
    );
  }
}
