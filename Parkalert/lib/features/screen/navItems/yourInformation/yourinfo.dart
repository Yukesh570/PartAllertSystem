import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/controllers/main_controller.dart';
import 'package:Parkalert/features/controllers/pagger.dart';
import 'package:Parkalert/features/screen/helperWidget/Button.dart';
import 'package:Parkalert/features/screen/helperWidget/backgroundCirlce.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:Parkalert/navigationButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Yourinfo extends StatefulWidget {
  const Yourinfo({super.key});

  @override
  State<Yourinfo> createState() => _YourinfoState();
}

class _YourinfoState extends State<Yourinfo> {
  Map<String, dynamic> userData = {};

  final drawerCtrl = Get.find<DrawerControllerX>();
  final MainController controller = Get.put(MainController());

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final box = GetStorage();
    final data = box.read('userData');
    if (data != null && data is Map<String, dynamic>) {
      setState(() {
        userData = data;
      });
    }
  }

  Widget _buildInfoCard(String label, String? value, bool dark) {
    return Card(
      color: dark ? Colors.grey[850] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ), // smaller vertical gap
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Text(
              "$label: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: dark ? Colors.white : Colors.black,
              ),
            ),
            Expanded(
              child: Text(
                value ?? "-",
                style: TextStyle(
                  fontSize: 16,
                  color: dark ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    if (loc == null) return const Center(child: CircularProgressIndicator());

    return PageWrapper(
      routeName: '/yourinfo',
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: dark ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            loc.yourInformation,
            style: const TextStyle(fontWeight: FontWeight.bold),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: userData.isEmpty
                  ? Center(
                      child: Text(
                        "No information available",
                        style: TextStyle(
                          color: dark ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: dark
                            ? const Color.fromARGB(255, 34, 34, 34)
                            : const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 12),
                        children: [
                          _buildInfoCard(
                            "First Name",
                            userData['firstName'],
                            dark,
                          ),
                          _buildInfoCard(
                            "Last Name",
                            userData['lastName'],
                            dark,
                          ),
                          _buildInfoCard("Email", userData['email'], dark),
                          _buildInfoCard("Phone", userData['phone'], dark),
                        ],
                      ),
                    ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 20.0,
                  left: 16,
                  right: 16,
                ),
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
                      onPressed: () => controller.alertPage(),
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
