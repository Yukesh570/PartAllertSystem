import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/controllers/main_controller.dart';
import 'package:Parkalert/features/controllers/pagger.dart';
import 'package:Parkalert/features/screen/helperWidget/Button.dart';
import 'package:Parkalert/features/screen/helperWidget/backgroundCirlce.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:Parkalert/navigationButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Working extends StatefulWidget {
  const Working({super.key});

  @override
  State<Working> createState() => _WorkingState();
}

class _WorkingState extends State<Working> {
  Widget buildCircleText(String text, bool dark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(255, 90, 102, 224),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: dark ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drawerCtrl = Get.find<DrawerControllerX>();
    final MainController controller = Get.put(MainController());

    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    final subTopicColor = Color.fromARGB(255, 90, 102, 224);

    if (loc == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return PageWrapper(
      routeName: '/working',
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawerEnableOpenDragGesture: false,

        backgroundColor: dark ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            loc.howParkAlertWorks,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: dark ? Colors.white : Colors.black,
            ),
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

              // Box with Scrollable Content
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: dark ? Colors.grey[900] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: dark ? Colors.black54 : Colors.black12,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: dark ? Colors.white70 : Colors.black87,
                          height: 1.5,
                        ),
                        children: [
                          // 1. User Journey
                          TextSpan(
                            text: "1.${loc.theuserjourney}\n",

                            style: const TextStyle(
                              color: Color.fromARGB(255, 90, 102, 224),

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: "${loc.theuserjourneyparagraph}\n\n"),

                          // Permissions & Registration
                          TextSpan(
                            text: "${loc.permissionsAndRegistration}\n",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 90, 102, 224),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "${loc.personaldata}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,

                                  color: dark ? Colors.white : Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "${loc.personaldataparagraph}\n",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: dark ? Colors.white70 : Colors.black87,
                                ),
                              ),
                            ],
                          ),

                          TextSpan(
                            children: [
                              TextSpan(
                                text: "${loc.accountsetup}: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,

                                  color: dark ? Colors.white : Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "${loc.accontsetupparagraph}\n",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: dark ? Colors.white70 : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          TextSpan(
                            text: "${loc.landingpage}: ",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,

                              color: dark ? Colors.white : Colors.black,
                            ),
                          ),
                          TextSpan(text: "${loc.landingpageparagraph}\n\n"),

                          // Alarm Setup
                          TextSpan(
                            text: "${loc.alarmsetup}\n",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 90, 102, 224),

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // TextSpan(
                          //   children: [
                          //     TextSpan(
                          //       text: "1 Free Alarm: ",
                          //       style: TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //         color: subTopicColor,
                          //       ),
                          //     ),
                          //     WidgetSpan(
                          //       alignment: PlaceholderAlignment.middle,
                          //       child: buildCircleText("+", dark),
                          //     ),
                          //     const TextSpan(
                          //       text:
                          //           " If you add another, you will be redirected to the Subscription Page.\n",
                          //     ),
                          //   ],
                          // ),
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "${loc.createalert}: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,

                                  color: dark ? Colors.white : Colors.black,
                                ),
                              ),
                              TextSpan(text: "${loc.createalertparagraph1}"),
                              TextSpan(
                                text: "${loc.parkingalarms}.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,

                                  color: dark ? Colors.white : Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: " ${loc.onthemyparkingalarmspagetapthe} ",
                              ),
                              TextSpan(
                                text: "${loc.myparkingalarms} ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,

                                  color: dark ? Colors.white : Colors.black,
                                ),
                              ),
                              TextSpan(text: "${loc.pagetapthe} "),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: buildCircleText("+", dark),
                              ),
                              TextSpan(text: " ${loc.createalertparagraph2} "),
                              TextSpan(
                                text: "${loc.connectcar} ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,

                                  color: dark ? Colors.white : Colors.black,
                                ),
                              ),
                              TextSpan(text: "${loc.or} "),

                              TextSpan(
                                text: "${loc.disconnectcar}\n",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,

                                  color: dark ? Colors.white : Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "${loc.connecttoyourbluetoothdevice}\n",
                              ),
                              TextSpan(
                                text: "${loc.chooseasoundforyouralarm}\n",
                              ),
                              TextSpan(text: "${loc.choosevibrationorsound}\n"),
                              TextSpan(text: "${loc.enableIgnoresilentmode} "),
                              TextSpan(
                                text: "${loc.ignoresilentmode}\n",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,

                                  color: dark ? Colors.white : Colors.black,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "${loc.onlythenwillyoualwaysbeabletohearthealarm}\n",
                              ),
                              TextSpan(
                                text: "${loc.connect} ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,

                                  color: dark ? Colors.white : Colors.black,
                                ),
                              ),
                              TextSpan(text: "${loc.or} "),
                              TextSpan(
                                text: "${loc.disconnect}\n",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,

                                  color: dark ? Colors.white : Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "${loc.important}: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,

                                  color: dark ? Colors.white : Colors.black,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "${loc.forthealarmtoregisteryourcarchoosedisconnect} ",
                              ),
                              TextSpan(
                                text: "${loc.connect} \n",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,

                                  color: dark ? Colors.white : Colors.black,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "${loc.forthealarmtoderegisteryourcarchooseconnect} ",
                              ),
                              TextSpan(
                                text: "${loc.disconnect}\n",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,

                                  color: dark ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),

                          // Core Logic
                          TextSpan(
                            text: "2. ${loc.coreoperationallogic}\n",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 90, 102, 224),

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "${loc.coreoperationallogicparagraph}\n",
                          ),
                          TextSpan(
                            text: "• ${loc.bluetoothdisconnected} → ",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,

                              color: dark ? Colors.white : Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "${loc.bluetoothdisconnectedparagraph}\n",
                          ),
                          TextSpan(
                            text: "• ${loc.bluetoothconnected} → ",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,

                              color: dark ? Colors.white : Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "${loc.bluetoothconnectedparagraph}\n\n",
                          ),

                          // Geofencing
                          // Geofencing
                          TextSpan(
                            text: "3. ${loc.geofencing}\n",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 90, 102, 224),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "${loc.freezones}: ",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: dark ? Colors.white : Colors.black,
                            ),
                          ),
                          TextSpan(text: "${loc.freezonesparagraph}\n\n"),

                          // Creating & Activating Freezone
                          TextSpan(
                            text: "${loc.creatingandactivatingfreezone}\n",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 90, 102, 224),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                "• ${loc.creatingandactivating1}.\n"
                                "• ${loc.creatingandactivating2Step1} ",
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: buildCircleText("+", dark),
                          ),
                          TextSpan(
                            text:
                                " ${loc.creatingandactivating2Step2} \n"
                                "• ${loc.creatingandactivating3} \n"
                                "• ${loc.creatingandactivating4} \n"
                                "• ${loc.creatingandactivating5}\n"
                                "• ${loc.creatingandactivating6} \n"
                                "• ${loc.creatingandactivating7} \n\n",
                          ),

                          // Managing Freezone
                          TextSpan(
                            text: "${loc.managingafreezone}\n",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 90, 102, 224),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "${loc.managingafreezonepragraph}\n\n",
                          ),

                          TextSpan(
                            text: "${loc.freezones}: ",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,

                              color: dark ? Colors.white : Colors.black,
                            ),
                          ),
                          TextSpan(
                            text:
                                "${loc.managingafreezonefreezonepragraph}\n\n",
                          ),

                          // Activities
                          TextSpan(
                            text: "4. ${loc.activitiesandhistory}\n",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 90, 102, 224),

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "${loc.activities}: ",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,

                              color: dark ? Colors.white : Colors.black,
                            ),
                          ),
                          TextSpan(text: "${loc.activitiesparagraphs}\n\n"),

                          // // Navigation
                          // TextSpan(
                          //   text: "5. ${loc.navigationmeu}\n",
                          //   style: const TextStyle(
                          //     color: Color.fromARGB(255, 90, 102, 224),
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          // TextSpan(
                          //   text: "${loc.sidebarincludes}: ",
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.w500,

                          //     color: dark ? Colors.white : Colors.black,
                          //   ),
                          // ),
                          // const TextSpan(
                          //   text:
                          //       "\n- Alerts\n"
                          //       "- Freezones\n"
                          //       "- Activity\n"
                          //       "- Your information\n"
                          //       "- How ParkAlert works\n"
                          //       "- Frequently asked questions\n"
                          //       "- Terms and conditions\n"
                          //       "- Privacy policy\n"
                          //       "- Exit ParkAlert\n",
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom buttons
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
                          drawerCtrl.goBack();
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else {
                            debugPrint("No screen to go back to");
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
