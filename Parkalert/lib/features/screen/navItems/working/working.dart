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
        body: Stack(
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
                          text: "1. The User Journey\n",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 90, 102, 224),

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              "When you first open the Parkalert app, you will be taken through a startup wizard to set up your account and your first alarm.\n\n",
                        ),

                        // Permissions & Registration
                        TextSpan(
                          text: "Permissions & Registration\n",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 90, 102, 224),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Personal Data: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,

                                color: dark ? Colors.white : Colors.black,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "The app first requests necessary permissions. "
                                  "This includes location access to detect Bluetooth events and geofences. "
                                  'A special, persistent permission is required to "allow all the time" '
                                  "to ensure the app works properly even when closed.\n",
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
                              text: "Account Setup: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,

                                color: dark ? Colors.white : Colors.black,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "You will be directed to the registration page, "
                                  "where you will fill in your details to create your account. "
                                  "Registration is done directly in the app.\n",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: dark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        TextSpan(
                          text: "Landing Page: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,

                            color: dark ? Colors.white : Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text:
                              "After registration, the landing page is always the \"My Alerts\" page.\n\n",
                        ),

                        // Alarm Setup
                        TextSpan(
                          text: "Alarm Setup\n",
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
                              text: "Create Alert: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,

                                color: dark ? Colors.white : Colors.black,
                              ),
                            ),
                            const TextSpan(
                              text: "On the \"My Alerts\" page, clicking the ",
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: buildCircleText("+", dark),
                            ),
                            const TextSpan(
                              text: " icon opens the \"Create Alert\" form.\n",
                            ),
                          ],
                        ),
                        TextSpan(
                          text: "Fill in Details: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,

                            color: dark ? Colors.white : Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text:
                              "Here, you will give your alert a custom name (not related to a location), "
                              "select a Bluetooth device (your car), and choose a notification sound.\n",
                        ),
                        TextSpan(
                          text: "Activate Alert: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,

                            color: dark ? Colors.white : Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text:
                              "The newly created alert appears as a box on the \"My Alerts\" page. "
                              "The alert is not active until you click the separate Connect button on its box.\n\n",
                        ),

                        // Core Logic
                        TextSpan(
                          text: "2. Core Operational Logic\n",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 90, 102, 224),

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              "The app's behavior is driven by the Bluetooth connection status and your location relative to a Freezone.\n",
                        ),
                        TextSpan(
                          text: "• Bluetooth Disconnected → ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,

                            color: dark ? Colors.white : Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text:
                              "User has left the car, Parkalert is activated.\n",
                        ),
                        TextSpan(
                          text: "• Bluetooth Connected → ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,

                            color: dark ? Colors.white : Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text:
                              "User has returned, Parkalert is deactivated.\n\n",
                        ),

                        // Geofencing
                        // Geofencing
                        TextSpan(
                          text: "3. Geofencing (Freezones)\n",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 90, 102, 224),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "Freezones: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: dark ? Colors.white : Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text:
                              "This feature allows you to define \"no alert zones\" to prevent alerts in familiar locations. "
                              "No time duration is needed for a Freezone.\n\n",
                        ),

                        // Creating & Activating Freezone
                        TextSpan(
                          text: "Creating and Activating a Freezone\n",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 90, 102, 224),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              "• From the sidebar menu, select \"Freezones\".\n"
                              "• Click the ",
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: buildCircleText("+", dark),
                        ),
                        const TextSpan(
                          text:
                              " .A box will appear.\n"
                              "• Click the location icon in the box to open a map.\n"
                              "• Click the location icon below the search bar to locate yourself.\n"
                              "• Click the pencil with a location icon to start drawing your zone. "
                              "Click on the map to place blue location icons to create a custom shape.\n"
                              "• Once the shape is complete, click the ✓ (tick icon) to save it.\n"
                              "• Go back to the \"Set Alert Zone\" screen and click the Connect button on the box to activate your Freezone.\n\n",
                        ),

                        // Managing Freezone
                        TextSpan(
                          text: "Managing a Freezone\n",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 90, 102, 224),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              "You can edit, rename, or delete your Freezones anytime from the Freezones screen. "
                              "Only one zone can be activated at a time to avoid conflicts.\n\n",
                        ),

                        TextSpan(
                          text: "Freezones: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,

                            color: dark ? Colors.white : Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text:
                              "This feature allows you to define no alert zones to prevent alerts in familiar locations. "
                              "No time duration is needed for a Freezone.\n\n",
                        ),

                        // Activities
                        TextSpan(
                          text: "4. Activities and History\n",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 90, 102, 224),

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "Activities: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,

                            color: dark ? Colors.white : Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text:
                              "This section shows your comprehensive history of alarms and parking locations. "
                              "The Activity menu has 'All Activities' and 'All Location' views, with a map of Bluetooth disconnection events.\n\n",
                        ),

                        // Navigation
                        TextSpan(
                          text: "5. Navigation Menu\n",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 90, 102, 224),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "Sidebar Includes: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,

                            color: dark ? Colors.white : Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text:
                              "\n- Alerts\n"
                              "- Freezones\n"
                              "- Activity\n"
                              "- Your information\n"
                              "- How ParkAlert works\n"
                              "- Frequently asked questions\n"
                              "- Terms and conditions\n"
                              "- Privacy policy\n"
                              "- Exit ParkAlert\n",
                        ),
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
    );
  }
}
