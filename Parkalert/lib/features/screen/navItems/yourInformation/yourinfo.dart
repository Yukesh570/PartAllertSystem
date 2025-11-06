import 'dart:convert';

import 'package:Parkalert/api/api.dart';
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
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_picker/country_picker.dart';

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
  bool _isLoading = false;

  String? CountryCode;
  final deviceCountryCode =
      WidgetsBinding.instance.window.locale.countryCode ?? 'US';
  String selectedCountryPrefix = '+31'; // Default value
  final drawerCtrl = Get.find<DrawerControllerX>();
  final MainController controller = Get.put(MainController());
  final ApiService apiService = ApiService();

  get CountryPickerUtils => null;
  late String selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    selectedLanguageCode = GetStorage().read("languagecode") ?? "en";

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
        selectedCountryPrefix = userData['countryCode'] ?? '';
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
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 2,
      ), // reduced vertical margin
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 16,
        ), // reduced vertical padding
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
            const SizedBox(height: 6), // small gap between label and text field
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

  Widget _buildInfophoneCard(
    String label,
    TextEditingController controller,
    bool dark, {
    required TextInputType keyboardType,
  }) {
    const double baseFontSize = 17.0;

    return Card(
      color: dark ? Colors.grey[850] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: baseFontSize,
                color: dark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),

            // Phone input
            _isEditing
                ? TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.phone,
                    cursorColor: dark ? Colors.blueAccent : Colors.blue,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixText:
                          selectedCountryPrefix + " ", // <-- Show prefix here
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: dark ? Colors.white : Colors.black,
                        ),
                        onPressed: () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode: true,
                            onSelect: (Country country) {
                              setState(() {
                                selectedCountryPrefix = '+${country.phoneCode}';
                              });
                            },
                            countryListTheme: CountryListThemeData(
                              backgroundColor: dark
                                  ? Colors.grey[900]
                                  : Colors.white,
                              textStyle: TextStyle(
                                color: dark ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                              inputDecoration: InputDecoration(
                                labelText: 'Search',
                                labelStyle: TextStyle(
                                  color: dark ? Colors.white70 : Colors.black54,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: dark ? Colors.white24 : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    style: TextStyle(
                      fontSize: baseFontSize,
                      color: dark ? Colors.white : Colors.black,
                    ),
                  )
                : Text(
                    "$selectedCountryPrefix ${controller.text.isNotEmpty ? controller.text : "-"}",
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

    // Widget usage:

    Future<void> _saveUserData(AppLocalizations loc) async {
      print(
        "==================================================${selectedCountryPrefix}",
      );
      try {
        final newUserData = {
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'countryCode': selectedCountryPrefix,
        };
        final response = await apiService.editUser(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          countryCode: selectedCountryPrefix,
        );
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          print("User data saved successfully.");
          final box = GetStorage();
          box.write('userData', newUserData);
          Get.snackbar(
            loc.informationSaved,
            loc.yourInformationHasBeenUpdated,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          controller.alertPage();
        } else if (response.statusCode == 204) {
          // Handle 204 No Content separately
          print("User data updated successfully (No Content returned).");
          final box = GetStorage();
          box.write('userData', newUserData);
          Get.snackbar(
            loc.informationSaved,
            loc.yourInformationHasBeenUpdated,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          controller.alertPage();
        } else {
          final errorData = jsonDecode(response.body);

          final errorMessage = errorData['message'] ?? "Unknown error";
          final code = errorData['code'] ?? "Unknown code";

          final metadataList =
              (errorData['metadata']?['duplicate_identifiers']
                  as List<dynamic>?) ??
              [];

          if (metadataList.contains("email")) {
            Get.snackbar(
              loc.error,
              "Email Already Exists",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          } else if (metadataList.contains("SMS")) {
            Get.snackbar(
              loc.error,
              "Phone Number Already Exists",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          } else {
            print("Error saving user data: $errorMessage");
            Get.snackbar(
              loc.error,
              errorMessage,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        }

        setState(() {
          userData = newUserData;
          _isEditing = false;
        });
      } catch (e) {
        print("Error saving user data: $e");
        Get.snackbar(
          loc.error,
          loc.nointernetconnection,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        setState(() => _isLoading = false); // stop loading
      }
    }

    return PageWrapper(
      routeName: '/yourinfo',
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawerEnableOpenDragGesture: true,

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
            _isEditing
                ? const SizedBox.shrink() // No icon when editing
                : IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: dark ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                  ),
          ],
        ),
        drawer: const navButton(),
        body: SafeArea(
          minimum: const EdgeInsets.only(bottom: 12.0),
          child: GestureDetector(
            behavior:
                HitTestBehavior.opaque, // important: allows taps on empty space
            onTap: () {
              FocusScope.of(context).unfocus(); // dismiss keyboard
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: BackgroundCirclesPainter(dark)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
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
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              _buildInfoCard(
                                loc.firstName,
                                _firstNameController,
                                dark,
                              ),
                              const SizedBox(height: 6),
                              _buildInfoCard(
                                loc.lastName,
                                _lastNameController,
                                dark,
                              ),
                              const SizedBox(height: 6),

                              _buildInfoCard(
                                loc.email,
                                _emailController,
                                dark,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 6),

                              // I've used 'phoneNo' for the localization key here, assuming it exists
                              _buildInfophoneCard(
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
                            if (_isEditing) {
                              _loadUserData(); // Revert changes by reloading
                              setState(() => _isEditing = false);
                            } else {
                              drawerCtrl.goBack();
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              }
                            }
                          },
                        ),
                        const SizedBox(width: 30),
                        if (_isEditing)
                          buildSaveButton(
                            text: loc.save,
                            onPressed: _isLoading
                                ? null
                                : () {
                                    setState(() => _isLoading = true);
                                    _saveUserData(loc);
                                  },
                            child: _isLoading
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : null,
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
      ),
    );
  }
}
