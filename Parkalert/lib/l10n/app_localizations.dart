import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
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
    Locale('en'),
    Locale('es'),
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

  /// No description provided for @exitParkAlert.
  ///
  /// In en, this message translates to:
  /// **'Exit ParkAlert'**
  String get exitParkAlert;

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

  /// No description provided for @exitparkalert.
  ///
  /// In en, this message translates to:
  /// **'Exit ParkAlert'**
  String get exitparkalert;

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
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'fr', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
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
