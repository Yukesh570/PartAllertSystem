import 'package:Parkalert/features/screen/helperWidget/Button.dart'; // Assuming this imports the button functions
import 'package:Parkalert/features/screen/helperWidget/backgroundCirlce.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class Policy extends StatefulWidget {
  const Policy({super.key});

  @override
  State<Policy> createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {
  // Helper for bold subtopics, similar to the reference
  TextSpan _buildSubTopic(String text, Color color, bool dark) {
    return TextSpan(
      text: '$text\n',
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  // Helper for bolding key headings, similar to the reference's internal TextSpans
  TextSpan _buildHeading(String text, bool dark) {
    return TextSpan(
      text: '$text: ',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: dark ? Colors.white : Colors.black,
      ),
    );
  }

  // Helper for normal body text
  TextSpan _buildBodyText(String text, bool dark) {
    return TextSpan(
      text: '$text\n\n',
      style: TextStyle(
        fontWeight: FontWeight.normal,
        color: dark ? Colors.white70 : Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    final subTopicColor = Color.fromARGB(
      255,
      90,
      102,
      224,
    ); // Color from reference

    if (loc == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: dark ? Colors.black : Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        title: Text(
          loc.privacyPolicy,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: dark ? Colors.white : Colors.black, // Apply dark mode color
          ),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(bottom: 12.0),

        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: BackgroundCirclesPainter(dark)),
            ),

            // Box with Scrollable Content
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                90,
              ), // leave space for bottom buttons
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
                        _buildBodyText(
                          "Last updated: September 22, 2025",
                          dark,
                        ),

                        // 1. General Information
                        _buildSubTopic(
                          "1. General Information",
                          subTopicColor,
                          dark,
                        ),
                        _buildBodyText(
                          "ParkAlarm is a trade name of Muza Holding B.V., located in Barendrecht at Weerkant 27 First floor. We are registered with the Chamber of Commerce under number 24471820.\n"
                          "This privacy policy describes how we handle your personal data when using our ParkAlarm app and services. We respect your privacy and act in accordance with the General Data Protection Regulation (GDPR).",
                          dark,
                        ),

                        // 2. What Data Do We Collect?
                        _buildSubTopic(
                          "2. What Data Do We Collect?",
                          subTopicColor,
                          dark,
                        ),
                        _buildHeading("Location data", dark),
                        _buildBodyText(
                          "To alert you about parking zones and restrictions",
                          dark,
                        ),

                        _buildHeading("Device data", dark),
                        _buildBodyText(
                          "Device type, operating system, and app version for technical support",
                          dark,
                        ),

                        _buildHeading("Usage data", dark),
                        _buildBodyText(
                          "How you use the app to improve our service",
                          dark,
                        ),

                        _buildHeading("Contact details", dark),
                        _buildBodyText("Email address if you contact us", dark),

                        // 3. Why Do We Process Your Data?
                        _buildSubTopic(
                          "3. Why Do We Process Your Data?",
                          subTopicColor,
                          dark,
                        ),
                        const TextSpan(
                          text:
                              "We process your personal data for the following purposes:\n"
                              "• Providing parking alarm services\n"
                              "• Improving our app and service delivery\n"
                              "• Technical support and troubleshooting\n"
                              "• Communication about our services\n\n",
                        ),

                        // 4. Legal Basis
                        _buildSubTopic("4. Legal Basis", subTopicColor, dark),
                        _buildBodyText(
                          "We process your personal data based on your consent and our legitimate interest to provide you with quality service delivery. For location data, we always ask for your explicit consent.",
                          dark,
                        ),

                        // 5. Sharing with Third Parties
                        _buildSubTopic(
                          "5. Sharing with Third Parties",
                          subTopicColor,
                          dark,
                        ),
                        _buildBodyText(
                          "We do not share your personal data with third parties, except when necessary for the operation of our service or when we are legally required to do so. Any third parties who have access to your data are contractually obligated to treat it confidentially.",
                          dark,
                        ),

                        // 6. Data Security
                        _buildSubTopic("6. Data Security", subTopicColor, dark),
                        _buildBodyText(
                          "We take appropriate technical and organizational measures to protect your personal data against loss, misuse, unauthorized access, and unwanted disclosure. Your data is stored and transmitted encrypted.",
                          dark,
                        ),

                        // 7. Retention Period
                        _buildSubTopic(
                          "7. Retention Period",
                          subTopicColor,
                          dark,
                        ),
                        _buildBodyText(
                          "We do not keep your personal data longer than necessary for the purposes for which it was collected. Usage data is retained for a maximum of 2 years, unless you request deletion earlier.",
                          dark,
                        ),

                        // 8. Your Rights
                        _buildSubTopic("8. Your Rights", subTopicColor, dark),
                        const TextSpan(
                          text:
                              "You have the following rights regarding your personal data:\n"
                              "• Right to access your data\n"
                              "• Right to rectification (correction of incorrect data)\n"
                              "• Right to erasure ('right to be forgotten')\n"
                              "• Right to restriction of processing\n"
                              "• Right to data portability\n"
                              "• Right to object to processing\n"
                              "• Right to withdraw consent\n\n",
                        ),

                        // 9. Contact and Complaints
                        _buildSubTopic(
                          "9. Contact and Complaints",
                          subTopicColor,
                          dark,
                        ),
                        _buildBodyText(
                          "For questions about this privacy policy or exercising your rights, you can contact us through the contact details in our app. You also have the right to file a complaint with the relevant data protection authority.",
                          dark,
                        ),

                        // 10. Changes
                        _buildSubTopic("10. Changes", subTopicColor, dark),
                        _buildBodyText(
                          "We may update this privacy policy from time to time. Changes will be announced through our app and website. We recommend regularly reviewing this privacy policy.",
                          dark,
                        ),

                        // 11. Contact Details
                        _buildSubTopic(
                          "11. Contact Details",
                          subTopicColor,
                          dark,
                        ),
                        const TextSpan(
                          text:
                              "Muza Holding B.V.\n"
                              "Weerkant 27 First floor\n"
                              "Barendrecht\n"
                              "Chamber of Commerce number: 24471820\n"
                              "Trade name: ParkAlarm\n\n",
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
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
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
