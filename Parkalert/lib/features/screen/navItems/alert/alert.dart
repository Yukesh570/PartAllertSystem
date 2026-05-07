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

    // void printAllSharedPreferences() async {
    //   final prefs = await SharedPreferences.getInstance();
    //   final keys = prefs.getKeys();

    //   if (keys.isEmpty) {
    //     print("🔍 SharedPreferences is empty.");
    //     return;
    //   }

    //   print("🔐 SharedPreferences Contents:");
    //   for (String key in keys) {
    //     final value = prefs.get(key);
    //     print("yjkesh: $key → Value: $value");
    //   }
    // }

    // printAllSharedPreferences();

    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      // This means localization isn't yet loaded or context is not in a localized widget tree
      return const Center(child: CircularProgressIndicator());
    }

    return PageWrapper(
      routeName: '/alerts',
      child: WillPopScope(
        onWillPop: () async {
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: dark ? Colors.grey[900] : Colors.white,
              title: Text(loc.exitapp),
              content: Text(loc.exitappparagraph),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(
                    loc.cancel,
                    style: TextStyle(
                      fontSize: 18, // 👈 Bigger text
                      fontWeight: FontWeight.w600, // 👈 Semi-bold
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(
                    loc.exit,
                    style: TextStyle(
                      fontSize: 20, // 👈 Bigger text
                      fontWeight: FontWeight.w600, // 👈 Semi-bold
                    ),
                  ),
                ),
              ],
            ),
          );

          if (shouldExit == true) {
            // Quit the app
            Navigator.of(context).pop(); // close the drawer first
            Future.delayed(const Duration(milliseconds: 100), () {
              // Exit the app
              // import 'dart:io';
              // exit(0);
              SystemNavigator.pop(); // recommended for Flutter
            });
          }
          return false; // prevent normal back
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          drawerEnableOpenDragGesture: false,

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
                icon: Icon(
                  Icons.menu,
                  color: dark ? Colors.white : Colors.black,
                ),
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

                // Main content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Container(
                    width: double.infinity,
                    // ✅ REMOVED: height: 690 (Fixed the sizing issue)
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: dark
                          ? const Color.fromARGB(255, 34, 34, 34)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Headers
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.setupyourparkingalarms,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                loc.myparkingalarms,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // The Ringers List
                        Expanded(
                          child: Obx(() {
                            if (ringersList.isEmpty) {
                              return Center(
                                child: Text(
                                  loc.noringers,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                              // ✅ Use ListView instead of SingleChildScrollView for better iOS performance
                              padding: const EdgeInsets.only(
                                bottom: 80,
                              ), // Space for the floating button
                              itemCount: ringersList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                  ),
                                  child: ringersList[index],
                                );
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),

                // Fixed Floating "Add" Button
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0), // Spacing from edge
                    child: buildCircularAddbButton(
                      context: context,
                      onPressed: () => controller.alertSetUpPage(),
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
