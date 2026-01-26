import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('nl')
  ];

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'T Store'**
  String get appName;

  /// No description provided for @tContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get tContinue;

  /// No description provided for @onBoardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Choose your product'**
  String get onBoardingTitle1;

  /// No description provided for @onBoardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get onBoardingTitle2;

  /// No description provided for @onBoardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Deliver at your door step'**
  String get onBoardingTitle3;

  /// No description provided for @onBoardingSubTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to a World of Limitless Choices - Your Perfect Product Awaits!'**
  String get onBoardingSubTitle1;

  /// No description provided for @onBoardingSubTitle2.
  ///
  /// In en, this message translates to:
  /// **'For Seamless Transactions, Choose Your Payment Path - Your Convenience, Our Priority!'**
  String get onBoardingSubTitle2;

  /// No description provided for @onBoardingSubTitle3.
  ///
  /// In en, this message translates to:
  /// **'From Our Doorstep to Yours - Swift, Secure, and Contactless Delivery!'**
  String get onBoardingSubTitle3;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-Mail'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @phoneNo.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNo;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @termsandconditions.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms and Conditions'**
  String get termsandconditions;

  /// No description provided for @inform.
  ///
  /// In en, this message translates to:
  /// **'I want to be kept informed about ParkAlert'**
  String get inform;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get language;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password?'**
  String get forgetPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @orSignInWith.
  ///
  /// In en, this message translates to:
  /// **'or sign in with'**
  String get orSignInWith;

  /// No description provided for @orSignUpWith.
  ///
  /// In en, this message translates to:
  /// **'or sign up with'**
  String get orSignUpWith;

  /// No description provided for @iAgreeTo.
  ///
  /// In en, this message translates to:
  /// **'I agree to'**
  String get iAgreeTo;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsOfUse;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'verificationCode'**
  String get verificationCode;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend Email'**
  String get resendEmail;

  /// No description provided for @resendEmailIn.
  ///
  /// In en, this message translates to:
  /// **'Resend email in'**
  String get resendEmailIn;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Information'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Information'**
  String get loginTitle;

  /// No description provided for @loginSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover Limitless Choices and Unmatched Convenience.'**
  String get loginSubTitle;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Let’s create your account'**
  String get signupTitle;

  /// No description provided for @forgetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forget password'**
  String get forgetPasswordTitle;

  /// No description provided for @forgetPasswordSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Don’t worry sometimes people can forget too, enter your email and we will send you a password reset link.'**
  String get forgetPasswordSubTitle;

  /// No description provided for @changeYourPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Reset Email Sent'**
  String get changeYourPasswordTitle;

  /// No description provided for @changeYourPasswordSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Account Security is Our Priority! We\'ve Sent You a Secure Link to Safely Change Your Password and Keep Your Account Protected.'**
  String get changeYourPasswordSubTitle;

  /// No description provided for @confirmEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify your email address!'**
  String get confirmEmail;

  /// No description provided for @confirmEmailSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! Your Account Awaits: Verify Your Email to Start Shopping and Experience a World of Unrivaled Deals and Personalized Offers.'**
  String get confirmEmailSubTitle;

  /// No description provided for @emailNotReceivedMessage.
  ///
  /// In en, this message translates to:
  /// **'Didn’t get the email? Check your junk/spam or resend it.'**
  String get emailNotReceivedMessage;

  /// No description provided for @yourAccountCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your account successfully created!'**
  String get yourAccountCreatedTitle;

  /// No description provided for @yourAccountCreatedSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Your Ultimate Shopping Destination: Your Account is Created, Unleash the Joy of Seamless Online Shopping!'**
  String get yourAccountCreatedSubTitle;

  /// No description provided for @popularProducts.
  ///
  /// In en, this message translates to:
  /// **'Popular Products'**
  String get popularProducts;

  /// No description provided for @homeAppbarTitle.
  ///
  /// In en, this message translates to:
  /// **'Good day for shopping'**
  String get homeAppbarTitle;

  /// No description provided for @homeAppbarSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Taimoor Sikander'**
  String get homeAppbarSubTitle;

  /// No description provided for @parkingalarms.
  ///
  /// In en, this message translates to:
  /// **'Parking Alarms'**
  String get parkingalarms;

  /// No description provided for @freezones.
  ///
  /// In en, this message translates to:
  /// **'No Alarm Zone'**
  String get freezones;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @yourInformation.
  ///
  /// In en, this message translates to:
  /// **'Your information'**
  String get yourInformation;

  /// No description provided for @howParkAlertWorks.
  ///
  /// In en, this message translates to:
  /// **'How ParkAlert works'**
  String get howParkAlertWorks;

  /// No description provided for @frequentlyAskedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get frequentlyAskedQuestions;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get termsAndConditions;

  /// No description provided for @privacyPolicyMenu.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicyMenu;

  /// No description provided for @exitParkAlarm.
  ///
  /// In en, this message translates to:
  /// **'Exit ParkAlarm'**
  String get exitParkAlarm;

  /// No description provided for @createzonewhereparkalarmwillbequit.
  ///
  /// In en, this message translates to:
  /// **'Create the zones where ParkAlarm will be quit'**
  String get createzonewhereparkalarmwillbequit;

  /// No description provided for @noringers.
  ///
  /// In en, this message translates to:
  /// **'No Ringers'**
  String get noringers;

  /// No description provided for @setupyourparkingalarms.
  ///
  /// In en, this message translates to:
  /// **'Setup your ParkingAlarms'**
  String get setupyourparkingalarms;

  /// No description provided for @myparkingalarms.
  ///
  /// In en, this message translates to:
  /// **'My Parking Alarms'**
  String get myparkingalarms;

  /// No description provided for @setalertzone.
  ///
  /// In en, this message translates to:
  /// **'Set No Alarm Zone'**
  String get setalertzone;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @visitparkalarm.
  ///
  /// In en, this message translates to:
  /// **'Visit ParkAlarm'**
  String get visitparkalarm;

  /// No description provided for @exitparkalarm.
  ///
  /// In en, this message translates to:
  /// **'Exit ParkAlarm'**
  String get exitparkalarm;

  /// No description provided for @changelanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changelanguage;

  /// No description provided for @allActivitiesAndLocations.
  ///
  /// In en, this message translates to:
  /// **'All Activities & Locations'**
  String get allActivitiesAndLocations;

  /// No description provided for @allactivities.
  ///
  /// In en, this message translates to:
  /// **'All Activities'**
  String get allactivities;

  /// No description provided for @alllocation.
  ///
  /// In en, this message translates to:
  /// **'All location'**
  String get alllocation;

  /// No description provided for @setnoalertzones.
  ///
  /// In en, this message translates to:
  /// **'Set no-alert zones'**
  String get setnoalertzones;

  /// No description provided for @parkedhistory.
  ///
  /// In en, this message translates to:
  /// **'Parked History'**
  String get parkedhistory;

  /// No description provided for @theuserjourney.
  ///
  /// In en, this message translates to:
  /// **'The User Journey'**
  String get theuserjourney;

  /// No description provided for @theuserjourneyparagraph.
  ///
  /// In en, this message translates to:
  /// **'When you first open the Parkalert app, you will be taken through a startup wizard to set up your account and your first alarm.'**
  String get theuserjourneyparagraph;

  /// No description provided for @permissionsAndRegistration.
  ///
  /// In en, this message translates to:
  /// **'Permissions & Registration'**
  String get permissionsAndRegistration;

  /// No description provided for @personaldata.
  ///
  /// In en, this message translates to:
  /// **'Personal Data'**
  String get personaldata;

  /// No description provided for @personaldataparagraph.
  ///
  /// In en, this message translates to:
  /// **'The app first requests necessary permissions. This includes location access to detect Bluetooth events and geofences. A special, persistent permission is required to allow all the time. to ensure the app works properly even when closed. '**
  String get personaldataparagraph;

  /// No description provided for @accountsetup.
  ///
  /// In en, this message translates to:
  /// **'Account Setup'**
  String get accountsetup;

  /// No description provided for @accontsetupparagraph.
  ///
  /// In en, this message translates to:
  /// **'You will be directed to the registration page,where you will fill in your details to create your account. Registration is done directly in the app.'**
  String get accontsetupparagraph;

  /// No description provided for @landingpage.
  ///
  /// In en, this message translates to:
  /// **'Landing Page'**
  String get landingpage;

  /// No description provided for @landingpageparagraph.
  ///
  /// In en, this message translates to:
  /// **'After registration, the landing page is always the \"My Alerts\" page.'**
  String get landingpageparagraph;

  /// No description provided for @alarmsetup.
  ///
  /// In en, this message translates to:
  /// **'Alarm Setup'**
  String get alarmsetup;

  /// No description provided for @createalert.
  ///
  /// In en, this message translates to:
  /// **'Create Alert'**
  String get createalert;

  /// No description provided for @createalertparagraph1.
  ///
  /// In en, this message translates to:
  /// **'On the \"My Alerts\" page, clicking the'**
  String get createalertparagraph1;

  /// No description provided for @createalertparagraph2.
  ///
  /// In en, this message translates to:
  /// **'icon opens the \"Create Alert\" form'**
  String get createalertparagraph2;

  /// No description provided for @fillindetails.
  ///
  /// In en, this message translates to:
  /// **'Fill in Details'**
  String get fillindetails;

  /// No description provided for @fillindetailsparagraph.
  ///
  /// In en, this message translates to:
  /// **'Here, you will give your alert a custom name (not related to a location),select a Bluetooth device (your car), and choose a notification sound.'**
  String get fillindetailsparagraph;

  /// No description provided for @activatealert.
  ///
  /// In en, this message translates to:
  /// **'Activate Alert'**
  String get activatealert;

  /// No description provided for @activatealertparagraph.
  ///
  /// In en, this message translates to:
  /// **'The newly created alert appears as a box on the \"My Alerts\" page.The alert is not active until you click the separate Connect button on its box.'**
  String get activatealertparagraph;

  /// No description provided for @coreoperationallogic.
  ///
  /// In en, this message translates to:
  /// **'Core Operational Logic'**
  String get coreoperationallogic;

  /// No description provided for @coreoperationallogicparagraph.
  ///
  /// In en, this message translates to:
  /// **'The app\'s behavior is driven by the Bluetooth connection status and your location relative to a Freezone.'**
  String get coreoperationallogicparagraph;

  /// No description provided for @bluetoothdisconnected.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Disconnected'**
  String get bluetoothdisconnected;

  /// No description provided for @bluetoothdisconnectedparagraph.
  ///
  /// In en, this message translates to:
  /// **'User has left the car, Parkalert is activated.'**
  String get bluetoothdisconnectedparagraph;

  /// No description provided for @bluetoothconnected.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Connected'**
  String get bluetoothconnected;

  /// No description provided for @bluetoothconnectedparagraph.
  ///
  /// In en, this message translates to:
  /// **'User has returned, Parkalert is deactivated.'**
  String get bluetoothconnectedparagraph;

  /// No description provided for @thenandnowoverview.
  ///
  /// In en, this message translates to:
  /// **'Then and now, an overview of all activities'**
  String get thenandnowoverview;

  /// No description provided for @geofencing.
  ///
  /// In en, this message translates to:
  /// **'Geofencing (Freezones)'**
  String get geofencing;

  /// No description provided for @freezonesparagraph.
  ///
  /// In en, this message translates to:
  /// **'This feature allows you to define \"no alert zones\" to prevent alerts in familiar locations.No time duration is needed for a Freezone.'**
  String get freezonesparagraph;

  /// No description provided for @creatingandactivatingfreezone.
  ///
  /// In en, this message translates to:
  /// **'Creating and Activating a Freezone'**
  String get creatingandactivatingfreezone;

  /// No description provided for @creatingandactivating1.
  ///
  /// In en, this message translates to:
  /// **'From the sidebar menu, select \"Freezones\".'**
  String get creatingandactivating1;

  /// No description provided for @creatingandactivating2Step1.
  ///
  /// In en, this message translates to:
  /// **'Click the'**
  String get creatingandactivating2Step1;

  /// No description provided for @creatingandactivating2Step2.
  ///
  /// In en, this message translates to:
  /// **'.A box will appear.'**
  String get creatingandactivating2Step2;

  /// No description provided for @creatingandactivating3.
  ///
  /// In en, this message translates to:
  /// **'Click the location icon in the box to open a map.'**
  String get creatingandactivating3;

  /// No description provided for @creatingandactivating4.
  ///
  /// In en, this message translates to:
  /// **'Click the location icon below the search bar to locate yourself.'**
  String get creatingandactivating4;

  /// No description provided for @creatingandactivating5.
  ///
  /// In en, this message translates to:
  /// **'Click the pencil with a location icon to start drawing your zone.Click on the map to place blue location icons to create a custom shape.'**
  String get creatingandactivating5;

  /// No description provided for @creatingandactivating6.
  ///
  /// In en, this message translates to:
  /// **'Once the shape is complete, click the ✓ (tick icon) to save it.'**
  String get creatingandactivating6;

  /// No description provided for @creatingandactivating7.
  ///
  /// In en, this message translates to:
  /// **'Go back to the \"Set Alert Zone\" screen and click the Connect button on the box to activate your Freezone.'**
  String get creatingandactivating7;

  /// No description provided for @managingafreezone.
  ///
  /// In en, this message translates to:
  /// **'Managing a Freezone'**
  String get managingafreezone;

  /// No description provided for @managingafreezonepragraph.
  ///
  /// In en, this message translates to:
  /// **'You can edit, rename, or delete your Freezones anytime from the Freezones screen.Only one zone can be activated at a time to avoid conflicts.'**
  String get managingafreezonepragraph;

  /// No description provided for @managingafreezonefreezonepragraph.
  ///
  /// In en, this message translates to:
  /// **'This feature allows you to define no alert zones to prevent alerts in familiar locations. No time duration is needed for a Freezone.'**
  String get managingafreezonefreezonepragraph;

  /// No description provided for @activitiesandhistory.
  ///
  /// In en, this message translates to:
  /// **'Activities and History'**
  String get activitiesandhistory;

  /// No description provided for @activities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get activities;

  /// No description provided for @activitiesparagraphs.
  ///
  /// In en, this message translates to:
  /// **'This section shows your comprehensive history of alarms and parking locations.The Activity menu has \'All Activities\' and \'All Location\' views, with a map of Bluetooth disconnection events.'**
  String get activitiesparagraphs;

  /// No description provided for @navigationmeu.
  ///
  /// In en, this message translates to:
  /// **'Navigation Menu'**
  String get navigationmeu;

  /// No description provided for @sidebarincludes.
  ///
  /// In en, this message translates to:
  /// **'Sidebar Includes'**
  String get sidebarincludes;

  /// No description provided for @generalinformation.
  ///
  /// In en, this message translates to:
  /// **'General Information'**
  String get generalinformation;

  /// No description provided for @generalinformationparagraph1.
  ///
  /// In en, this message translates to:
  /// **'ParkAlarm is a trade name of Muza Holding B.V., located in Barendrecht at Weerkant 27 First floor. We are registered with the Chamber of Commerce under number 24471820.'**
  String get generalinformationparagraph1;

  /// No description provided for @generalinformationparagraph2.
  ///
  /// In en, this message translates to:
  /// **'This privacy policy describes how we handle your personal data when using our ParkAlarm app and services. We respect your privacy and act in accordance with the General Data Protection Regulation (GDPR).'**
  String get generalinformationparagraph2;

  /// No description provided for @whatdatadowecollect.
  ///
  /// In en, this message translates to:
  /// **'What Data Do We Collect?'**
  String get whatdatadowecollect;

  /// No description provided for @whatdatadowecollectparagraph.
  ///
  /// In en, this message translates to:
  /// **'For the operation of ParkAlarm, we collect the following data:'**
  String get whatdatadowecollectparagraph;

  /// No description provided for @locationdata.
  ///
  /// In en, this message translates to:
  /// **'Location data:'**
  String get locationdata;

  /// No description provided for @locationdatatext.
  ///
  /// In en, this message translates to:
  /// **'To alert you about parking zones and restrictions'**
  String get locationdatatext;

  /// No description provided for @devicedata.
  ///
  /// In en, this message translates to:
  /// **'Device Data'**
  String get devicedata;

  /// No description provided for @devicedatatext.
  ///
  /// In en, this message translates to:
  /// **'Device type, operating system, and app version for technical support'**
  String get devicedatatext;

  /// No description provided for @usagedata.
  ///
  /// In en, this message translates to:
  /// **'Usage data'**
  String get usagedata;

  /// No description provided for @usagedatatext.
  ///
  /// In en, this message translates to:
  /// **'How you use the app to improve our service'**
  String get usagedatatext;

  /// No description provided for @contactdetails.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get contactdetails;

  /// No description provided for @whydoweprocessyourdata.
  ///
  /// In en, this message translates to:
  /// **'Why Do We Process Your Data'**
  String get whydoweprocessyourdata;

  /// No description provided for @whydoweprocessyourdataparagraph.
  ///
  /// In en, this message translates to:
  /// **'We process your personal data for the following purposes:'**
  String get whydoweprocessyourdataparagraph;

  /// No description provided for @whydoweprocessyourdata1.
  ///
  /// In en, this message translates to:
  /// **'Providing parking alarm services'**
  String get whydoweprocessyourdata1;

  /// No description provided for @whydoweprocessyourdata2.
  ///
  /// In en, this message translates to:
  /// **'Improving our app and service delivery'**
  String get whydoweprocessyourdata2;

  /// No description provided for @whydoweprocessyourdata3.
  ///
  /// In en, this message translates to:
  /// **'Technical support and troubleshooting'**
  String get whydoweprocessyourdata3;

  /// No description provided for @whydoweprocessyourdata4.
  ///
  /// In en, this message translates to:
  /// **'Communication about our services'**
  String get whydoweprocessyourdata4;

  /// No description provided for @legalbasis.
  ///
  /// In en, this message translates to:
  /// **'Legal Basis'**
  String get legalbasis;

  /// No description provided for @legalbasisparagraph.
  ///
  /// In en, this message translates to:
  /// **'We process your personal data based on your consent and our legitimate interest to provide you with quality service delivery. For location data, we always ask for your explicit consent.'**
  String get legalbasisparagraph;

  /// No description provided for @sharingwiththirdparties.
  ///
  /// In en, this message translates to:
  /// **'Sharing with Third Parties'**
  String get sharingwiththirdparties;

  /// No description provided for @sharingwiththirdpartiesparagraph.
  ///
  /// In en, this message translates to:
  /// **'We do not share your personal data with third parties, except when necessary for the operation of our service or when we are legally required to do so. Any third parties who have access to your data are contractually obligated to treat it confidentially.'**
  String get sharingwiththirdpartiesparagraph;

  /// No description provided for @datasecurity.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get datasecurity;

  /// No description provided for @datasecurityparagraph.
  ///
  /// In en, this message translates to:
  /// **'We take appropriate technical and organizational measures to protect your personal data against loss, misuse, unauthorized access, and unwanted disclosure. Your data is stored and transmitted encrypted.'**
  String get datasecurityparagraph;

  /// No description provided for @retentionperiod.
  ///
  /// In en, this message translates to:
  /// **'Retention Period'**
  String get retentionperiod;

  /// No description provided for @retentionperiodparagraph.
  ///
  /// In en, this message translates to:
  /// **'We do not keep your personal data longer than necessary for the purposes for which it was collected. Usage data is retained for a maximum of 2 years, unless you request deletion earlier.'**
  String get retentionperiodparagraph;

  /// No description provided for @yourrights.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get yourrights;

  /// No description provided for @yourrightsparagraph.
  ///
  /// In en, this message translates to:
  /// **'You have the following rights regarding your personal data:'**
  String get yourrightsparagraph;

  /// No description provided for @yourrights1.
  ///
  /// In en, this message translates to:
  /// **'Right to access your data'**
  String get yourrights1;

  /// No description provided for @yourrights2.
  ///
  /// In en, this message translates to:
  /// **'Right to rectification (correction of incorrect data)'**
  String get yourrights2;

  /// No description provided for @yourrights3.
  ///
  /// In en, this message translates to:
  /// **'Right to erasure (\'right to be forgotten\')'**
  String get yourrights3;

  /// No description provided for @yourrights4.
  ///
  /// In en, this message translates to:
  /// **'Right to restriction of processing'**
  String get yourrights4;

  /// No description provided for @yourrights5.
  ///
  /// In en, this message translates to:
  /// **'Right to data portability'**
  String get yourrights5;

  /// No description provided for @yourrights6.
  ///
  /// In en, this message translates to:
  /// **'Right to object to processing'**
  String get yourrights6;

  /// No description provided for @yourrights7.
  ///
  /// In en, this message translates to:
  /// **'Right to withdraw consent'**
  String get yourrights7;

  /// No description provided for @contactandcomplaints.
  ///
  /// In en, this message translates to:
  /// **'Contact and Complaints'**
  String get contactandcomplaints;

  /// No description provided for @contactandcomplaintsparagraph.
  ///
  /// In en, this message translates to:
  /// **'For questions about this privacy policy or exercising your rights, you can contact us through the contact details in our app. You also have the right to file a complaint with the relevant data protection authority.'**
  String get contactandcomplaintsparagraph;

  /// No description provided for @changes.
  ///
  /// In en, this message translates to:
  /// **'Changes'**
  String get changes;

  /// No description provided for @changesparagraph.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to modify these terms. Important changes will be announced through the app or website. Continued use after changes means you agree to the new terms.'**
  String get changesparagraph;

  /// No description provided for @contactdetails1.
  ///
  /// In en, this message translates to:
  /// **'Muza Holding B.V.'**
  String get contactdetails1;

  /// No description provided for @contactdetails2.
  ///
  /// In en, this message translates to:
  /// **'Weerkant 27 First floor'**
  String get contactdetails2;

  /// No description provided for @contactdetails3.
  ///
  /// In en, this message translates to:
  /// **'Barendrecht'**
  String get contactdetails3;

  /// No description provided for @contactdetails4.
  ///
  /// In en, this message translates to:
  /// **'Chamber of Commerce number: 24471820'**
  String get contactdetails4;

  /// No description provided for @contactdetails5.
  ///
  /// In en, this message translates to:
  /// **'Trade name: ParkAlarm'**
  String get contactdetails5;

  /// No description provided for @lastupdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: September 22, 2025'**
  String get lastupdated;

  /// No description provided for @generalprovisions.
  ///
  /// In en, this message translates to:
  /// **'General Provisions'**
  String get generalprovisions;

  /// No description provided for @generalprovisionsparagraph1.
  ///
  /// In en, this message translates to:
  /// **'These terms of service apply to the use of the ParkAlarm app and services, offered by Muza Holding B.V., located in Barendrecht at Weerkant 27 First floor, registered with the Chamber of Commerce under number 24471820.'**
  String get generalprovisionsparagraph1;

  /// No description provided for @generalprovisionsparagraph2.
  ///
  /// In en, this message translates to:
  /// **'By using our app and services, you agree to these terms. Please read them carefully before using our services.'**
  String get generalprovisionsparagraph2;

  /// No description provided for @servicedescription.
  ///
  /// In en, this message translates to:
  /// **'Service Description'**
  String get servicedescription;

  /// No description provided for @servicedescriptionparagraph.
  ///
  /// In en, this message translates to:
  /// **'ParkAlarm is a mobile application that helps users manage parking times and receive notifications about parking zones and restrictions. Our services include:'**
  String get servicedescriptionparagraph;

  /// No description provided for @servicedescription1.
  ///
  /// In en, this message translates to:
  /// **'Location-based parking alarms'**
  String get servicedescription1;

  /// No description provided for @servicedescription2.
  ///
  /// In en, this message translates to:
  /// **'Notifications about parking zones and times'**
  String get servicedescription2;

  /// No description provided for @servicedescription3.
  ///
  /// In en, this message translates to:
  /// **'Information about parking rules and costs'**
  String get servicedescription3;

  /// No description provided for @servicedescription4.
  ///
  /// In en, this message translates to:
  /// **'User support and app updates'**
  String get servicedescription4;

  /// No description provided for @useoftheapp.
  ///
  /// In en, this message translates to:
  /// **'Use of the App'**
  String get useoftheapp;

  /// No description provided for @useoftheappparagrapgh.
  ///
  /// In en, this message translates to:
  /// **'You may use the ParkAlarm app for personal, non-commercial purposes. It is not permitted to:'**
  String get useoftheappparagrapgh;

  /// No description provided for @useoftheapp1.
  ///
  /// In en, this message translates to:
  /// **'Use the app for illegal purposes'**
  String get useoftheapp1;

  /// No description provided for @useoftheapp2.
  ///
  /// In en, this message translates to:
  /// **'Disrupt the app\'s operation or attempt to hack it'**
  String get useoftheapp2;

  /// No description provided for @useoftheapp3.
  ///
  /// In en, this message translates to:
  /// **'Provide false information'**
  String get useoftheapp3;

  /// No description provided for @useoftheapp4.
  ///
  /// In en, this message translates to:
  /// **'Infringe on intellectual property rights'**
  String get useoftheapp4;

  /// No description provided for @useoftheapp5.
  ///
  /// In en, this message translates to:
  /// **'Use the app in a way that could harm others'**
  String get useoftheapp5;

  /// No description provided for @useraccount.
  ///
  /// In en, this message translates to:
  /// **'User Account'**
  String get useraccount;

  /// No description provided for @useraccountparagraph.
  ///
  /// In en, this message translates to:
  /// **'For some features, it may be necessary to create an account. You are responsible for:'**
  String get useraccountparagraph;

  /// No description provided for @useraccount1.
  ///
  /// In en, this message translates to:
  /// **'Providing accurate and complete information'**
  String get useraccount1;

  /// No description provided for @useraccount2.
  ///
  /// In en, this message translates to:
  /// **'Securing your account credentials'**
  String get useraccount2;

  /// No description provided for @useraccount3.
  ///
  /// In en, this message translates to:
  /// **'All activities that occur through your account'**
  String get useraccount3;

  /// No description provided for @useraccount4.
  ///
  /// In en, this message translates to:
  /// **'Immediately reporting unauthorized use'**
  String get useraccount4;

  /// No description provided for @availabilityandmaintenance.
  ///
  /// In en, this message translates to:
  /// **'Availability and Maintenance'**
  String get availabilityandmaintenance;

  /// No description provided for @availabilityandmaintenanceparagraph.
  ///
  /// In en, this message translates to:
  /// **'We strive to keep our services available 24/7, but cannot guarantee that the app will always work without interruption. We reserve the right to:'**
  String get availabilityandmaintenanceparagraph;

  /// No description provided for @availabilityandmaintenance1.
  ///
  /// In en, this message translates to:
  /// **'Perform maintenance and updates'**
  String get availabilityandmaintenance1;

  /// No description provided for @availabilityandmaintenance2.
  ///
  /// In en, this message translates to:
  /// **'Temporarily interrupt the service'**
  String get availabilityandmaintenance2;

  /// No description provided for @availabilityandmaintenance3.
  ///
  /// In en, this message translates to:
  /// **'Modify or remove features'**
  String get availabilityandmaintenance3;

  /// No description provided for @availabilityandmaintenance4.
  ///
  /// In en, this message translates to:
  /// **'Terminate the service with reasonable notice'**
  String get availabilityandmaintenance4;

  /// No description provided for @intellectualproperty.
  ///
  /// In en, this message translates to:
  /// **'Intellectual Property'**
  String get intellectualproperty;

  /// No description provided for @intellectualpropertyparagraph.
  ///
  /// In en, this message translates to:
  /// **'All rights to the ParkAlarm app, including but not limited to software, design, texts, logos, and other materials, belong to Muza Holding B.V. or our licensors. You receive a limited, non-exclusive license to use the app in accordance with these terms.'**
  String get intellectualpropertyparagraph;

  /// No description provided for @privacyanddataprotection.
  ///
  /// In en, this message translates to:
  /// **'Privacy and Data Protection'**
  String get privacyanddataprotection;

  /// No description provided for @privacyanddataprotectionparagraph.
  ///
  /// In en, this message translates to:
  /// **'Your privacy is important to us. The use of your personal data is governed by ourPrivacy Policy, which forms part of these terms.'**
  String get privacyanddataprotectionparagraph;

  /// No description provided for @liability.
  ///
  /// In en, this message translates to:
  /// **'Liability'**
  String get liability;

  /// No description provided for @liabilityparagraph1.
  ///
  /// In en, this message translates to:
  /// **'ParkAlarm is a tool that assists you in managing parking times. We are not liable for:'**
  String get liabilityparagraph1;

  /// No description provided for @liability1.
  ///
  /// In en, this message translates to:
  /// **'Indirect or consequential damages'**
  String get liability1;

  /// No description provided for @liabilityparagraph2.
  ///
  /// In en, this message translates to:
  /// **'You remain responsible at all times for complying with parking rules and times.'**
  String get liabilityparagraph2;

  /// No description provided for @termination.
  ///
  /// In en, this message translates to:
  /// **'Termination'**
  String get termination;

  /// No description provided for @terminationparagraph.
  ///
  /// In en, this message translates to:
  /// **'You can terminate your use of ParkAlarm at any time by deleting the app. We may terminate your access in case of violation of these terms. After termination, certain provisions remain in effect, including intellectual property rights and liability limitations.'**
  String get terminationparagraph;

  /// No description provided for @applicablelawanddisputes.
  ///
  /// In en, this message translates to:
  /// **'Applicable Law and Disputes'**
  String get applicablelawanddisputes;

  /// No description provided for @applicablelawanddisputesparagraph.
  ///
  /// In en, this message translates to:
  /// **'These terms are governed by Dutch law. Disputes are preferably resolved through mutual consultation. If this is not possible, the competent Dutch courts have exclusive jurisdiction.'**
  String get applicablelawanddisputesparagraph;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @contactparagraph.
  ///
  /// In en, this message translates to:
  /// **'For questions about these terms or our services, you can contact us through the contact details in our app.'**
  String get contactparagraph;

  /// No description provided for @contact1.
  ///
  /// In en, this message translates to:
  /// **'Muza Holding B.V.'**
  String get contact1;

  /// No description provided for @contact2.
  ///
  /// In en, this message translates to:
  /// **'Weerkant 27 First floor'**
  String get contact2;

  /// No description provided for @contact3.
  ///
  /// In en, this message translates to:
  /// **'Barendrecht'**
  String get contact3;

  /// No description provided for @contact4.
  ///
  /// In en, this message translates to:
  /// **'Chamber of Commerce number: 24471820'**
  String get contact4;

  /// No description provided for @contact5.
  ///
  /// In en, this message translates to:
  /// **'Trade name: ParkAlarm'**
  String get contact5;

  /// No description provided for @finalprovisions.
  ///
  /// In en, this message translates to:
  /// **'Final Provisions'**
  String get finalprovisions;

  /// No description provided for @finalprovisionsparagraph.
  ///
  /// In en, this message translates to:
  /// **'Should one or more provisions of these terms be invalid, the remaining provisions remain fully effective. Invalid provisions are deemed to be replaced by valid provisions that align as closely as possible with the intention of the original provisions.'**
  String get finalprovisionsparagraph;

  /// No description provided for @locationpermission.
  ///
  /// In en, this message translates to:
  /// **'Location Permission Needed'**
  String get locationpermission;

  /// No description provided for @locationpermissionparagraph.
  ///
  /// In en, this message translates to:
  /// **'This app requires location access to detect Bluetooth events and geofences. Please allow access to continue.'**
  String get locationpermissionparagraph;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @allowlocation.
  ///
  /// In en, this message translates to:
  /// **'Allow \'All the time\' Location'**
  String get allowlocation;

  /// No description provided for @allowlocationparagraph.
  ///
  /// In en, this message translates to:
  /// **'To detect Bluetooth events and geofences even when the app is closed, please enable \'Allow all the time\' in Settings.'**
  String get allowlocationparagraph;

  /// No description provided for @opensettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get opensettings;

  /// No description provided for @exitapp.
  ///
  /// In en, this message translates to:
  /// **'Exit App'**
  String get exitapp;

  /// No description provided for @exitappparagraph.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit ParkAlert?'**
  String get exitappparagraph;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @pleasefillinalltherequiredfields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all the required fields.'**
  String get pleasefillinalltherequiredfields;

  /// No description provided for @isrequired.
  ///
  /// In en, this message translates to:
  /// **'is required'**
  String get isrequired;

  /// No description provided for @enteravalidphonenumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get enteravalidphonenumber;

  /// No description provided for @enteravalidemail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enteravalidemail;

  /// No description provided for @nointernetconnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get nointernetconnection;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @main.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get main;

  /// No description provided for @addatleast3pointstoformapolygon.
  ///
  /// In en, this message translates to:
  /// **'Add at least 3 points to form a polygon'**
  String get addatleast3pointstoformapolygon;

  /// No description provided for @activityhistory.
  ///
  /// In en, this message translates to:
  /// **'Activity History'**
  String get activityhistory;

  /// No description provided for @ascending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get ascending;

  /// No description provided for @descending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get descending;

  /// No description provided for @nohistoryfound.
  ///
  /// In en, this message translates to:
  /// **'No History Found'**
  String get nohistoryfound;

  /// No description provided for @setyouralarm.
  ///
  /// In en, this message translates to:
  /// **'Set your Alarm'**
  String get setyouralarm;

  /// No description provided for @myalarms.
  ///
  /// In en, this message translates to:
  /// **'My Alarms'**
  String get myalarms;

  /// No description provided for @editalarm.
  ///
  /// In en, this message translates to:
  /// **'Edit Alarm'**
  String get editalarm;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @bluetoothdevice.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth device'**
  String get bluetoothdevice;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @deleteringer.
  ///
  /// In en, this message translates to:
  /// **'Delete Ringer'**
  String get deleteringer;

  /// No description provided for @areyousureyouwanttodeletethisringer.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this ringer?'**
  String get areyousureyouwanttodeletethisringer;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @nozonebox.
  ///
  /// In en, this message translates to:
  /// **'NoZoneBox'**
  String get nozonebox;

  /// No description provided for @editzone.
  ///
  /// In en, this message translates to:
  /// **'Edit Zone'**
  String get editzone;

  /// No description provided for @initialtime.
  ///
  /// In en, this message translates to:
  /// **'Initial Time (HH:mm)'**
  String get initialtime;

  /// No description provided for @zonename.
  ///
  /// In en, this message translates to:
  /// **'Zone Name'**
  String get zonename;

  /// No description provided for @stoptime.
  ///
  /// In en, this message translates to:
  /// **'Stop Time (HH:mm)'**
  String get stoptime;

  /// No description provided for @zoneupdatedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Zone updated successfully'**
  String get zoneupdatedsuccessfully;

  /// No description provided for @deletezone.
  ///
  /// In en, this message translates to:
  /// **'Delete zone'**
  String get deletezone;

  /// No description provided for @areyousureyouwanttodeletethiszone.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this zone?'**
  String get areyousureyouwanttodeletethiszone;

  /// No description provided for @informationSaved.
  ///
  /// In en, this message translates to:
  /// **'Information Saved'**
  String get informationSaved;

  /// No description provided for @yourInformationHasBeenUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your Information Has Been Updated'**
  String get yourInformationHasBeenUpdated;

  /// No description provided for @noInformationAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Information Available'**
  String get noInformationAvailable;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @overrideSilentMode.
  ///
  /// In en, this message translates to:
  /// **'Override Silent Mode'**
  String get overrideSilentMode;

  /// No description provided for @emailAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Email already exists'**
  String get emailAlreadyExists;

  /// No description provided for @phoneAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Phone number already exists'**
  String get phoneAlreadyExists;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @youMustAgreeToPrivacyPolicyAndInformConsentBeforeCreatingAccount.
  ///
  /// In en, this message translates to:
  /// **'You must agree to Privacy Policy and Inform consent before creating account.'**
  String get youMustAgreeToPrivacyPolicyAndInformConsentBeforeCreatingAccount;

  /// No description provided for @zoneSaved.
  ///
  /// In en, this message translates to:
  /// **'Zone Saved'**
  String get zoneSaved;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'fr', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
    case 'nl': return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
