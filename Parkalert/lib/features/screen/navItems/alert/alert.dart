import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/controllers/pagger.dart';
import 'package:Parkalert/utils/storage/data/RingerData.dart';
import 'package:Parkalert/features/controllers/main_controller.dart';
import 'package:Parkalert/features/screen/helperWidget/Button.dart';
import 'package:Parkalert/features/screen/helperWidget/backgroundCirlce.dart';
import 'package:Parkalert/features/controllers/alert/isON.dart';
import 'package:Parkalert/features/screen/navItems/alert/ringers.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:Parkalert/navigationButton.dart';
import 'package:Parkalert/utils/storage/ringerStorage/ringerStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // for SystemNavigator

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Alert extends StatefulWidget {
  const Alert({super.key});

  @override
  State<Alert> createState() => _AlertState();
}

var ringersList = <Ringers>[].obs;
List<Ringers> ringersListdemo = [];

class _AlertState extends State<Alert> {
  @override
  void initState() {
    super.initState();
    loadAndSetRingers();
    final isOnController = Get.put(IsOnController());
    isOnController.loadIsOnFromStorage();
    checkIfDataSaved();
  }

  void checkIfDataSaved() {
    final box = GetStorage();
    final userData = box.read('userData');

    if (userData != null) {
      print("📦 Saved user data: $userData");
    } else {
      print("⚠️ No user data found in storage.");
    }
  }

  void loadAndSetRingers() async {
    List<RingerData> savedRingers = await loadRingers();

    setState(() {
      ringersListdemo = savedRingers
          .map(
            (data) => Ringers(
              ringerData: data,
              onDelete: refreshRingers, // Pass the refresh callback
            ),
          )
          .toList();

      ringersList.value = savedRingers
          .map(
            (data) => Ringers(
              ringerData: data,
              onDelete: refreshRingers, // Pass the refresh callback
            ),
          )
          .toList();
    });
    print("ringersList: $ringersListdemo");
  }

  void refreshRingers() async {
    List<RingerData> savedRingers = await loadRingers();

    setState(() {
      ringersListdemo = savedRingers
          .map(
            (data) => Ringers(
              ringerData: data,
              onDelete: refreshRingers, // Add onDelete here too
            ),
          )
          .toList();

      ringersList.value = savedRingers
          .map(
            (data) => Ringers(
              ringerData: data,
              onDelete: refreshRingers, // Add onDelete here too
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

    void printAllSharedPreferences() async {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      if (keys.isEmpty) {
        print("🔍 SharedPreferences is empty.");
        return;
      }

      print("🔐 SharedPreferences Contents:");
      for (String key in keys) {
        final value = prefs.get(key);
        print("yjkesh: $key → Value: $value");
      }
    }

    printAllSharedPreferences();

    final dark = Theme.of(context).brightness == Brightness.dark;
    bool isOn = false;
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      // This means localization isn't yet loaded or context is not in a localized widget tree
      return const Center(child: CircularProgressIndicator());
    }

    return PageWrapper(
      routeName: '/alerts',
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        backgroundColor: dark ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,

          title: Text(
            loc.parkingalarms,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(Icons.menu, color: dark ? Colors.white : Colors.black),
            ),
          ),
        ),
        drawer: const navButton(),
        body: SafeArea(
          minimum: const EdgeInsets.only(bottom: 12.0),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: BackgroundCirclesPainter(dark)),
              ),
              // other children here...
              Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  bottom: 0,
                  right: 22,
                  left: 22,
                ),
                child: Container(
                  width: double.infinity,
                  height: 690,
                  padding: const EdgeInsets.symmetric(
                    vertical: 2.0,
                    horizontal: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: dark
                        ? const Color.fromARGB(255, 34, 34, 34)
                        : const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
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
                          loc.setupyourparkingalarms,
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
                          loc.myparkingalarms,

                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      if (ringersList.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),

                          child: Padding(
                            padding: EdgeInsets.only(top: 200.0),
                            child: Center(
                              child: Text(
                                'No Ringers',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Main alert settings card
                      Expanded(
                        child: Obx(
                          () => SingleChildScrollView(
                            child: Column(
                              children: ringersList
                                  .map(
                                    (ringer) => (Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ringer,
                                    )),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ), // Space before bottom navigation
                    ],
                  ),
                ),
              ),
              // Bottom navigation buttons
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20.0,
                    right: 20.0,
                  ), // padding from bottom and left
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end, // align to left
                    children: [
                      //   buildCircularIconButton(
                      //     context: context,
                      //     icon: Icons.arrow_back,
                      //     onPressed: () {
                      //       final isDark =
                      //           Theme.of(context).brightness == Brightness.dark;
                      //       showDialog(
                      //         context: context,
                      //         builder: (context) => AlertDialog(
                      //           backgroundColor: isDark
                      //               ? Colors.grey[900]
                      //               : Colors.white,

                      //           title: const Text('Exit ParkAlert'),
                      //           content: const Text(
                      //             'Are you sure you want to exit the app?',
                      //           ),
                      //           actions: [
                      //             TextButton(
                      //               onPressed: () =>
                      //                   Navigator.of(context).pop(false),
                      //               child: const Text(
                      //                 'Cancel',
                      //                 style: TextStyle(
                      //                   fontSize: 18, // 👈 Bigger text
                      //                   fontWeight:
                      //                       FontWeight.w600, // 👈 Semi-bold
                      //                 ),
                      //               ),
                      //             ),
                      //             TextButton(
                      //               onPressed: () =>
                      //                   Navigator.of(context).pop(true),
                      //               child: const Text(
                      //                 'Exit',
                      //                 style: TextStyle(
                      //                   fontSize: 18, // 👈 Bigger text
                      //                   fontWeight:
                      //                       FontWeight.w600, // 👈 Semi-bold
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ).then((shouldExit) {
                      //         if (shouldExit == true) {
                      //           SystemNavigator.pop(); // closes the app
                      //         }
                      //       });
                      //     },
                      //     // },
                      //   ),
                      // const SizedBox(width: 100),
                      buildCircularAddbButton(
                        context: context,
                        onPressed: () {
                          controller.alertSettingPage();
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
