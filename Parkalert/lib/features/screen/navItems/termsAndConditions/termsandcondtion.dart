import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/controllers/main_controller.dart';
import 'package:Parkalert/features/controllers/pagger.dart';
import 'package:Parkalert/features/screen/helperWidget/Button.dart';
import 'package:Parkalert/features/screen/helperWidget/backgroundCirlce.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:Parkalert/navigationButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Termsandcondtion extends StatefulWidget {
  const Termsandcondtion({super.key});

  @override
  State<Termsandcondtion> createState() => _TermsandcondtionState();
}

class _TermsandcondtionState extends State<Termsandcondtion> {
  // Helper function to build a rich text section for a heading
  TextSpan _buildHeading(String text, Color color) {
    return TextSpan(
      text: '$text\n',
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 16, // Slightly larger for main headings
      ),
    );
  }

  // Helper function to build a rich text section for a subheading (Title Case, e.g., "Privacy Policy")
  TextSpan _buildSubheading(String text, bool dark) {
    return TextSpan(
      text: '$text: ',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: dark ? Colors.white : Colors.black,
      ),
    );
  }

  // Helper function to build a rich text section for body content
  TextSpan _buildBodyText(String text, bool dark, {bool isListItem = false}) {
    String prefix = isListItem ? '\n- ' : '';
    return TextSpan(
      text: '$prefix$text',
      style: TextStyle(
        fontWeight: FontWeight.normal,
        color: dark ? Colors.white70 : Colors.black87,
        height: 1.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drawerCtrl = Get.find<DrawerControllerX>();
    final MainController controller = Get.put(MainController());

    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    final headingColor = const Color.fromARGB(255, 90, 102, 224);

    if (loc == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return PageWrapper(
      routeName: '/terms',
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawerEnableOpenDragGesture: false,

        backgroundColor: dark ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            loc.termsAndConditions,
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
                          // Localized "Last updated"
                          _buildBodyText('${loc.lastupdated}\n\n', dark),

                          // 1. General Provisions
                          _buildHeading(
                            '1. ${loc.generalprovisions}',
                            headingColor,
                          ),
                          _buildBodyText(
                            '${loc.generalprovisionsparagraph1}\n',
                            dark,
                          ),
                          _buildBodyText(
                            '${loc.generalprovisionsparagraph2}\n\n',
                            dark,
                          ),

                          // 2. Service Description
                          _buildHeading(
                            '2. ${loc.servicedescription}',
                            headingColor,
                          ),
                          _buildBodyText(
                            '${loc.servicedescriptionparagraph}',
                            dark,
                          ),
                          _buildBodyText(
                            loc.servicedescription1,
                            dark,
                            isListItem: true,
                          ),
                          _buildBodyText(
                            loc.servicedescription2,
                            dark,
                            isListItem: true,
                          ),
                          _buildBodyText(
                            loc.servicedescription3,
                            dark,
                            isListItem: true,
                          ),
                          _buildBodyText(
                            '${loc.servicedescription4}\n\n',
                            dark,
                            isListItem: true,
                          ),

                          // 3. Use of the App
                          _buildHeading('3. ${loc.useoftheapp}', headingColor),
                          _buildBodyText('${loc.useoftheappparagrapgh}', dark),
                          _buildBodyText(
                            loc.useoftheapp1,
                            dark,
                            isListItem: true,
                          ),
                          _buildBodyText(
                            loc.useoftheapp2,
                            dark,
                            isListItem: true,
                          ),
                          _buildBodyText(
                            loc.useoftheapp3,
                            dark,
                            isListItem: true,
                          ),
                          _buildBodyText(
                            loc.useoftheapp4,
                            dark,
                            isListItem: true,
                          ),
                          _buildBodyText(
                            '${loc.useoftheapp5}\n\n',
                            dark,
                            isListItem: true,
                          ),

                          // 4. User Account
                          _buildHeading('4. ${loc.useraccount}', headingColor),
                          _buildBodyText('${loc.useraccountparagraph}', dark),
                          _buildBodyText(
                            loc.useraccount1,
                            dark,
                            isListItem: true,
                          ),
                          _buildBodyText(
                            loc.useraccount2,
                            dark,
                            isListItem: true,
                          ),
                          _buildBodyText(
                            loc.useraccount3,
                            dark,
                            isListItem: true,
                          ),
                          _buildBodyText(
                            '${loc.useraccount4}\n\n',
                            dark,
                            isListItem: true,
                          ),

                          // 5. Availability and Maintenance
                          _buildHeading(
                            '5. ${loc.availabilityandmaintenance}',
                            headingColor,
                          ),
                          _buildBodyText(
                            '${loc.availabilityandmaintenanceparagraph}',
                            dark,
                          ),
                          _buildBodyText(
                            loc.availabilityandmaintenance1,
                            dark,
                            isListItem: true,
                          ),
                          _buildBodyText(
                            loc.availabilityandmaintenance2,
                            dark,
                            isListItem: true,
                          ),
                          _buildBodyText(
                            loc.availabilityandmaintenance3,
                            dark,
                            isListItem: true,
                          ),
                          _buildBodyText(
                            '${loc.availabilityandmaintenance4}\n\n',
                            dark,
                            isListItem: true,
                          ),

                          // 6. Intellectual Property
                          _buildHeading(
                            '6. ${loc.intellectualproperty}',
                            headingColor,
                          ),
                          _buildBodyText(
                            '${loc.intellectualpropertyparagraph}\n\n',
                            dark,
                          ),

                          // 7. Privacy and Data Protection
                          _buildHeading(
                            '7. ${loc.privacyanddataprotection}',
                            headingColor,
                          ),
                          _buildBodyText(
                            '${loc.privacyanddataprotectionparagraph.split('Privacy Policy').first}',
                            dark,
                          ),
                          TextSpan(
                            text:
                                'Privacy Policy', // Assuming the link text is fixed
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: dark ? Colors.white : Colors.black,
                            ),
                          ),
                          _buildBodyText(
                            '${loc.privacyanddataprotectionparagraph.split('Privacy Policy').last}\n\n',
                            dark,
                          ),

                          // 8. Liability
                          _buildHeading('8. ${loc.liability}', headingColor),
                          _buildBodyText('${loc.liabilityparagraph1}', dark),
                          _buildBodyText(
                            loc.liability1,
                            dark,
                            isListItem: true,
                          ), // Note: Your keys for liability 1-4 are all 'liability1', assuming this is a typo in your provided data and they are distinct for the list items. I'm using 'liability1' for all for now.
                          _buildBodyText(
                            loc.liability1,
                            dark,
                            isListItem: true,
                          ),
                          _buildBodyText(
                            loc.liability1,
                            dark,
                            isListItem: true,
                          ),
                          _buildBodyText(
                            loc.liability1,
                            dark,
                            isListItem: true,
                          ),
                          _buildBodyText(
                            '${loc.liabilityparagraph2}\n\n',
                            dark,
                          ),

                          // 9. Termination
                          _buildHeading('9. ${loc.termination}', headingColor),
                          _buildBodyText(
                            '${loc.terminationparagraph}\n\n',
                            dark,
                          ),

                          // 10. Changes
                          _buildHeading('10. ${loc.changes}', headingColor),
                          _buildBodyText('${loc.changesparagraph}\n\n', dark),

                          // 11. Applicable Law and Disputes
                          _buildHeading(
                            '11. ${loc.applicablelawanddisputes}',
                            headingColor,
                          ),
                          _buildBodyText(
                            '${loc.applicablelawanddisputesparagraph}\n\n',
                            dark,
                          ),

                          // 12. Contact
                          _buildHeading('12. ${loc.contact}', headingColor),
                          _buildBodyText('${loc.contactparagraph}', dark),
                          _buildBodyText(loc.contact1, dark, isListItem: true),
                          _buildBodyText(loc.contact2, dark, isListItem: true),
                          _buildBodyText(loc.contact3, dark, isListItem: true),
                          _buildBodyText(loc.contact4, dark, isListItem: true),
                          _buildBodyText(
                            '${loc.contact5}\n\n',
                            dark,
                            isListItem: true,
                          ),

                          // 13. Final Provisions
                          _buildHeading(
                            '13. ${loc.finalprovisions}',
                            headingColor,
                          ),
                          _buildBodyText(
                            '${loc.finalprovisionsparagraph}\n\n',
                            dark,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom buttons for navigation
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
