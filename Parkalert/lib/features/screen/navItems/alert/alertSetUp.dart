import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/controllers/main_controller.dart';
import 'package:Parkalert/features/controllers/pagger.dart';
import 'package:Parkalert/features/screen/helperWidget/backgroundCirlce.dart';
import 'package:Parkalert/features/screen/helperWidget/Button.dart';
import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
import 'package:Parkalert/features/screen/navItems/alert/alertSettings.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:Parkalert/navigationButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TriggerSelectionScreen extends StatelessWidget {
  const TriggerSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final MainController controller = Get.put(MainController());
    final drawerCtrl = Get.find<DrawerControllerX>();

    // Safely get localizations
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return PageWrapper(
      routeName: '/alertSetUp',
      child: Scaffold(
        backgroundColor: dark ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            loc?.parkingalarms ?? "New Alarm",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: dark ? Colors.white : Colors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: const navButton(),
        body: SafeArea(
          child: Stack(
            children: [
              // 1. The Background Circles
              Positioned.fill(
                child: CustomPaint(painter: BackgroundCirclesPainter(dark)),
              ),

              // 2. The Main Content
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
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
                              loc.triggerevent,

                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              loc.whentoremindyou,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16.0),

                            // Main Inner Card
                            Container(
                              // ✅ INCREASED outer vertical padding to make the blue box longer
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 24.0,
                              ),
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
                                  // ✅ INCREASED gap before the buttons
                                  const SizedBox(height: 30),

                                  // 🚗 Option 1: Leave the car (Disconnect)
                                  _buildSelectionCard(
                                    context: context,
                                    dark: dark,
                                    title: loc.whenileavethecar,
                                    subtitle:
                                        loc.alertswhenbluetoothdisconnects,
                                    icon: Icons.directions_walk,
                                    color: Colors.redAccent,
                                    onTap: () {
                                      Get.to(
                                        () => const AlertSetting(
                                          preSelectedTrigger: "Disconnect",
                                        ),
                                      );
                                    },
                                  ),

                                  // ✅ INCREASED gap between the two buttons
                                  const SizedBox(height: 20),

                                  // 🚗 Option 2: Return to the car (Connect)
                                  _buildSelectionCard(
                                    context: context,
                                    dark: dark,
                                    title: loc.whenireturntothecar,
                                    subtitle: loc.alertswhenbluetoothreconnects,
                                    icon: Icons.directions_car,
                                    color: Colors.blueAccent,
                                    onTap: () {
                                      Get.to(
                                        () => const AlertSetting(
                                          preSelectedTrigger: "Connect",
                                        ),
                                      );
                                    },
                                  ),
                                  // ✅ Added a little padding at the bottom for balance
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Bottom Navigation Row
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
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                        buildMainButton(
                          text: loc?.main ?? "Main",
                          context: context,
                          onPressed: () => controller.alertPage(),
                        ),
                        const SizedBox(width: 60),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionCard({
    required BuildContext context,
    required bool dark,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        // ✅ INCREASED vertical padding inside the buttons to make them taller
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        decoration: BoxDecoration(
          color: dark ? Colors.grey[800] : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: dark ? Colors.grey[700]! : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ), // Slightly bigger gap between title and subtitle
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: dark ? Colors.white70 : Colors.black54,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: dark ? Colors.grey[500] : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
