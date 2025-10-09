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
  bool _isEditing = false;

  // Controllers for text fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final drawerCtrl = Get.find<DrawerControllerX>();
  final MainController controller = Get.put(MainController());

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final box = GetStorage();
    final data = box.read('userData');
    if (data != null && data is Map<String, dynamic>) {
      setState(() {
        userData = data;
        // Populate controllers with loaded data
        _firstNameController.text = userData['firstName'] ?? '';
        _lastNameController.text = userData['lastName'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _phoneController.text = userData['phone'] ?? '';
      });
    }
  }

  // New method to handle the cancellation of editing
  void _cancelEditing() {
    // 1. Revert text field content back to saved data
    _loadUserData();
    // 2. Toggle editing mode off
    setState(() {
      _isEditing = false;
    });
  }

  void _saveUserData(AppLocalizations loc) {
    // 1. Update the userData map from controllers
    final newUserData = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
    };

    // 2. Persist to GetStorage
    final box = GetStorage();
    box.write('userData', newUserData);

    // 3. Update state and toggle editing mode
    setState(() {
      userData = newUserData;
      _isEditing = false;
    });

    // Optional: Show a confirmation message
    // Localize the hardcoded snackbar strings using loc
    Get.snackbar(
      loc.informationSaved,
      loc.yourInformationHasBeenUpdated,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Widget _buildInfoCard(
    String label,
    TextEditingController controller,
    bool dark, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    const double baseFontSize = 17.0;

    return Card(
      color: dark ? Colors.grey[850] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: baseFontSize,
                color: dark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            _isEditing
                ? TextFormField(
                    controller: controller,
                    keyboardType: keyboardType,
                    cursorColor: dark ? Colors.blueAccent : Colors.blue,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(
                      fontSize: baseFontSize,
                      color: dark ? Colors.white : Colors.black,
                    ),
                  )
                : Text(
                    controller.text.isNotEmpty ? controller.text : "-",
                    style: TextStyle(
                      fontSize: baseFontSize,
                      color: dark ? Colors.white70 : Colors.black87,
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

    // NOTE: Ensure these localization keys are available in your .arb files:
    // "firstName", "lastName", "email", "phoneNo", "noInformationAvailable",
    // "save", "informationSaved", "yourInformationHasBeenUpdated", "yourInformation"

    return PageWrapper(
      routeName: '/yourinfo',
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawerEnableOpenDragGesture: false,

        backgroundColor: dark ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            loc.yourInformation,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: dark ? Colors.white : Colors.black,
            ),
          ),
          leading: Builder(
            builder: (context) {
              if (_isEditing) {
                // Show Cancel button when editing
                return IconButton(
                  onPressed: _cancelEditing,
                  icon: Icon(
                    Icons.close,
                    color: dark ? Colors.redAccent : Colors.red,
                    size: 28, // ↑ Increase icon size (default is 24)
                  ),
                  iconSize: 28,
                  padding: const EdgeInsets.all(8), // optional, adjust tap area
                  tooltip: "cancel",
                );
              } else {
                // Show Drawer Menu icon when not editing
                return IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: Icon(
                    Icons.menu,
                    color: dark ? Colors.white : Colors.black,
                  ),
                );
              }
            },
          ),
          actions: [
            // Edit / Save Button
            IconButton(
              icon: Icon(
                _isEditing ? Icons.save : Icons.edit,
                color: dark
                    ? Colors.white
                    : const Color.fromARGB(255, 90, 102, 224),
              ),
              onPressed: () {
                if (_isEditing) {
                  _saveUserData(loc);
                } else {
                  setState(() {
                    _isEditing = true;
                  });
                }
              },
            ),
          ],
        ),
        drawer: const navButton(),
        body: SafeArea(
          minimum: const EdgeInsets.only(bottom: 12.0),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: BackgroundCirclesPainter(dark)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child:
                    userData.isEmpty &&
                        !_isEditing // Show 'No info' only if not editing
                    ? Center(
                        child: Text(
                          loc.noInformationAvailable,
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
                              loc.firstName,
                              _firstNameController,
                              dark,
                            ),
                            _buildInfoCard(
                              loc.lastName,
                              _lastNameController,
                              dark,
                            ),
                            _buildInfoCard(
                              loc.email,
                              _emailController,
                              dark,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            // I've used 'phoneNo' for the localization key here, assuming it exists
                            _buildInfoCard(
                              loc.phoneNo,
                              _phoneController,
                              dark,
                              keyboardType: TextInputType.phone,
                            ),
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
                          // If user cancels editing, revert the state
                          if (_isEditing) {
                            _loadUserData(); // Revert changes by reloading
                            setState(() => _isEditing = false);
                          } else {
                            drawerCtrl.goBack();
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            } else {
                              debugPrint("No screen to go back to");
                            }
                          }
                        },
                      ),
                      // Show a save button below only if in editing mode
                      if (_isEditing)
                        buildMainButton(
                          text: loc.save,
                          onPressed: () => _saveUserData(loc),
                          context: context,
                        )
                      else
                        buildMainButton(
                          text: loc.main,
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
      ),
    );
  }
}
