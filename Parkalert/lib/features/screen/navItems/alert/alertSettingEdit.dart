import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/controllers/pagger.dart';
import 'package:Parkalert/utils/healper/permissiongate.dart';
import 'package:Parkalert/utils/storage/bluetoothStorage/bluetoothStorage.dart';
import 'package:Parkalert/utils/storage/data/RingerData.dart';
import 'package:Parkalert/features/controllers/alert/isON.dart';
import 'package:Parkalert/features/controllers/main_controller.dart';
import 'package:Parkalert/features/screen/helperWidget/backgroundCirlce.dart';
import 'package:Parkalert/features/screen/helperWidget/bluetooth.dart';
import 'package:Parkalert/features/screen/helperWidget/Button.dart';
import 'package:Parkalert/features/screen/helperWidget/alertFrom.dart';
import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

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

  bool _inform = true;
  bool overrideSilentMode = false;
  bool _isConnectSelected = true;

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
    _inform = widget.ringerData?.vibration ?? true;
    overrideSilentMode = widget.ringerData?.overRideSilence ?? false;
    _isConnectSelected =
        (widget.ringerData?.triggerType.toLowerCase() ?? 'connect') ==
        'connect';
  }

  // Future<void> _loadOverrideSilentMode() async {
  //   final value = widget.ringerData?.overRideSilence ?? false;
  //   setState(() {
  //     overrideSilentMode = value;
  //   });
  // }

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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (overrideSilentMode) {
      checkAndRequestDndPermission(context);
    }
    final MainController controller = Get.put(MainController());
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PageWrapper(
        routeName: '/alertSettingEdit',
        child: Scaffold(
          resizeToAvoidBottomInset:
              true, // ✅ Essential for iOS keyboard handling
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
                        // ✅ Single scroll view logic
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
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      loc.editalarm,
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
                                        if (device != null) {
                                          _bluetoothDeviceController.text =
                                              device.name ?? "Unknown Device";
                                        }
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

                                    // Vibration Switch
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
                                    // Silent Mode Switch
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
                                          value: overrideSilentMode,
                                          onChanged: (v) => setState(
                                            () => overrideSilentMode = v,
                                          ),
                                          activeTrackColor: AppColors.iconColor,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 30.0),

                                    // ✅ Connection Selection UI (Connect/Disconnect)
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
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ✅ Bottom Buttons Bar (Always pinned to bottom)
                    Container(
                      color: dark ? Colors.black : Colors.white,
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
                              final String name = _nameController.text.trim();
                              final String bluetoothDevice =
                                  _bluetoothDeviceController.text.trim();
                              final String sound = soundController.text.trim();

                              if (name.isNotEmpty && sound.isNotEmpty) {
                                await updateRingers(
                                  widget.ringerData!.index,
                                  null,
                                  name,
                                  bluetoothDevice,
                                  sound,
                                );
                                await vibrationOption(
                                  widget.ringerData!.index,
                                  _inform,
                                );
                                triggerTypeOption(
                                  widget.ringerData!.index,
                                  _isConnectSelected ? "Connect" : "Disconnect",
                                  context,
                                );
                                await overRideSilence(
                                  widget.ringerData!.index,
                                  overrideSilentMode,
                                  context,
                                );
                                await activeBluetooth();
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

  // ✅ Helper method to keep UI consistent and fluid
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
