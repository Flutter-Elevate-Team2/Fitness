import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Super Fitness'**
  String get appTitle;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @doIt.
  ///
  /// In en, this message translates to:
  /// **'Do IT'**
  String get doIt;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'The Price Of Excellence\nIs Discipline'**
  String get onboarding1Title;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Fitness Has Never Been So\nMuch Fun'**
  String get onboarding2Title;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'NO MORE EXCUSES\nDo It Now'**
  String get onboarding3Title;

  /// No description provided for @onboarding1Desc.
  ///
  /// In en, this message translates to:
  /// **'Start your journey today. Success isn\'t owned, it\'s leased, and rent is due every single day.'**
  String get onboarding1Desc;

  /// No description provided for @onboarding2Desc.
  ///
  /// In en, this message translates to:
  /// **'Discover exciting workouts that keep you moving. We make reaching your goals the best part of your day.'**
  String get onboarding2Desc;

  /// No description provided for @onboarding3Desc.
  ///
  /// In en, this message translates to:
  /// **'Your goals are within reach. Stop waiting for the right moment; create it and transform your life now.'**
  String get onboarding3Desc;

  /// No description provided for @loremIpsum.
  ///
  /// In en, this message translates to:
  /// **'Lorem Ipsum Dolor Sit Amet Consectetur. Eu Urna Ut Gravida Quis Id Pretium Purus. Mauris Massa'**
  String get loremIpsum;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'WELCOME BACK'**
  String get welcomeBack;

  /// No description provided for @heyThere.
  ///
  /// In en, this message translates to:
  /// **'Hey There'**
  String get heyThere;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password?'**
  String get forgetPassword;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Dont Have An Account Yet?'**
  String get dontHaveAccount;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerNow;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'CREATE AN ACCOUNT'**
  String get createAccount;

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

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already Have An Account?'**
  String get alreadyHaveAccount;

  /// No description provided for @tellUsAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'TELL US ABOUT YOURSELF!'**
  String get tellUsAboutYourself;

  /// No description provided for @needToKnowGender.
  ///
  /// In en, this message translates to:
  /// **'We Need To Know Your Gender'**
  String get needToKnowGender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @howOldAreYou.
  ///
  /// In en, this message translates to:
  /// **'HOW OLD ARE YOU ?'**
  String get howOldAreYou;

  /// No description provided for @whatIsYourWeight.
  ///
  /// In en, this message translates to:
  /// **'WHAT IS YOUR WEIGHT ?'**
  String get whatIsYourWeight;

  /// No description provided for @whatIsYourHeight.
  ///
  /// In en, this message translates to:
  /// **'WHAT IS YOUR HEIGHT ?'**
  String get whatIsYourHeight;

  /// No description provided for @whatIsYourGoal.
  ///
  /// In en, this message translates to:
  /// **'WHAT IS YOUR GOAL ?'**
  String get whatIsYourGoal;

  /// No description provided for @personalizedPlanNote.
  ///
  /// In en, this message translates to:
  /// **'This Helps Us Create Your Personalized Plan'**
  String get personalizedPlanNote;

  /// No description provided for @gainWeight.
  ///
  /// In en, this message translates to:
  /// **'Gain Weight'**
  String get gainWeight;

  /// No description provided for @loseWeight.
  ///
  /// In en, this message translates to:
  /// **'Lose Weight'**
  String get loseWeight;

  /// No description provided for @getFitter.
  ///
  /// In en, this message translates to:
  /// **'Get Fitter'**
  String get getFitter;

  /// No description provided for @gainMoreFlexible.
  ///
  /// In en, this message translates to:
  /// **'Gain More Flexible'**
  String get gainMoreFlexible;

  /// No description provided for @learnTheBasic.
  ///
  /// In en, this message translates to:
  /// **'Learn The Basic'**
  String get learnTheBasic;

  /// No description provided for @physicalActivityLevel.
  ///
  /// In en, this message translates to:
  /// **'YOUR REGULAR PHYSICAL ACTIVITY LEVEL ?'**
  String get physicalActivityLevel;

  /// No description provided for @rookie.
  ///
  /// In en, this message translates to:
  /// **'Rookie'**
  String get rookie;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advance.
  ///
  /// In en, this message translates to:
  /// **'Advance'**
  String get advance;

  /// No description provided for @trueBeast.
  ///
  /// In en, this message translates to:
  /// **'True Beast'**
  String get trueBeast;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Email'**
  String get enterYourEmail;

  /// No description provided for @otpCode.
  ///
  /// In en, this message translates to:
  /// **'OTP CODE'**
  String get otpCode;

  /// No description provided for @checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Your OTP Check Your Email'**
  String get checkYourEmail;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didnt Recieve Verification Code?'**
  String get didntReceiveCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code?'**
  String get resendCode;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get createNewPassword;

  /// No description provided for @passwordLengthNote.
  ///
  /// In en, this message translates to:
  /// **'Make Sure Its 8 Characters Or More'**
  String get passwordLengthNote;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordWeak.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get passwordWeak;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneInvalid;

  /// No description provided for @nationalIdRequired.
  ///
  /// In en, this message translates to:
  /// **'National ID is required'**
  String get nationalIdRequired;

  /// No description provided for @nationalIdInvalidLength.
  ///
  /// In en, this message translates to:
  /// **'National ID must be 14 digits'**
  String get nationalIdInvalidLength;

  /// No description provided for @nationalIdInvalidChars.
  ///
  /// In en, this message translates to:
  /// **'National ID must contain numbers only'**
  String get nationalIdInvalidChars;

  /// No description provided for @vehicleNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Vehicle number is required'**
  String get vehicleNumberRequired;

  /// No description provided for @vehicleNumberLength.
  ///
  /// In en, this message translates to:
  /// **'Vehicle number must be between 3 and 10 characters'**
  String get vehicleNumberLength;

  /// No description provided for @vehicleNumberInvalidChars.
  ///
  /// In en, this message translates to:
  /// **'Vehicle number can only contain letters and numbers'**
  String get vehicleNumberInvalidChars;

  /// No description provided for @sessionExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Expired'**
  String get sessionExpiredTitle;

  /// No description provided for @sessionExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired, please login again.'**
  String get sessionExpiredMessage;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// Title for the forgot password screen
  ///
  /// In en, this message translates to:
  /// **'Forget password'**
  String get forgotPasswordTitle;

  /// Subtitle instructions for forgot password
  ///
  /// In en, this message translates to:
  /// **'Please enter your email associated to your account'**
  String get forgotPasswordSubTitle;

  /// Label for confirm buttons
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// Title for the email verification screen
  ///
  /// In en, this message translates to:
  /// **'Email verification'**
  String get verificationTitle;

  /// Validation message for incomplete OTP code
  ///
  /// In en, this message translates to:
  /// **'Please enter complete 6-digit code'**
  String get validationEnterCompleteCode;

  /// Generic error message for weak password validation
  ///
  /// In en, this message translates to:
  /// **'Password must not be empty and must contain 6 characters with upper case letter and one number at least'**
  String get weakPasswordError;

  /// Generic error message for invalid verification code
  ///
  /// In en, this message translates to:
  /// **'Invalid code'**
  String get invalidCodeError;

  /// Subtitle instructions for email verification
  ///
  /// In en, this message translates to:
  /// **'Please enter your code that sent to your email address'**
  String get verificationSubTitle;

  /// Button text to resend verification code
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// Title for the reset password screen
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordTitle;

  /// Subtitle instructions for reset password
  ///
  /// In en, this message translates to:
  /// **'Password must not be empty and must contain 6 characters with upper case letter and one number at least '**
  String get resetPasswordSubTitle;

  /// content of dialog
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully! Please login with your new password.'**
  String get resetSuccessfully;

  /// content of dialog
  ///
  /// In en, this message translates to:
  /// **'Your account has been created successfully! Please login to continue '**
  String get registerSuccessfully;

  /// success
  ///
  /// In en, this message translates to:
  /// **'success'**
  String get success;

  /// Label for the new password input field
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// Label for the cancel button in a dialog
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get cancelDialog;

  /// Label for the confirm password input field
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// Hint text for the confirm password input field
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordHint;

  /// Sent OTP
  ///
  /// In en, this message translates to:
  /// **'Sent OTP'**
  String get sentOtp;

  /// Enter Your OTP Check your email
  ///
  /// In en, this message translates to:
  /// **'Enter Your OTP Check your email'**
  String get enterYourOtp;

  /// Explore
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// Chat AI
  ///
  /// In en, this message translates to:
  /// **'Chat AI'**
  String get chatAi;

  /// Workouts
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get workouts;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @buildYourMusclesWorkout.
  ///
  /// In en, this message translates to:
  /// **'Build your muscles with this quick and effective workout.'**
  String get buildYourMusclesWorkout;

  /// No description provided for @thirtyMin.
  ///
  /// In en, this message translates to:
  /// **'30 MIN'**
  String get thirtyMin;

  /// No description provided for @oneHundredThirtyCal.
  ///
  /// In en, this message translates to:
  /// **'130 Cal'**
  String get oneHundredThirtyCal;

  /// No description provided for @noExercisesFoundForThisLevel.
  ///
  /// In en, this message translates to:
  /// **'No exercises found for this level.'**
  String get noExercisesFoundForThisLevel;

  /// No description provided for @invalidVideoUrl.
  ///
  /// In en, this message translates to:
  /// **'Invalid Video URL'**
  String get invalidVideoUrl;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @pleaseCheckNetworkToWatch.
  ///
  /// In en, this message translates to:
  /// **'Please check your network to watch'**
  String get pleaseCheckNetworkToWatch;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @times.
  ///
  /// In en, this message translates to:
  /// **'Times'**
  String get times;

  /// Food Recommendation
  ///
  /// In en, this message translates to:
  /// **'Food Recommendation'**
  String get foodRecommendation;

  /// Recommendation For You
  ///
  /// In en, this message translates to:
  /// **'Recommendation For You'**
  String get recommendationForYou;

  /// See All
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// Show more
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMore;

  /// Show less
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// Ingredients
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// Instructions
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// View
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// Could not open video, please try again
  ///
  /// In en, this message translates to:
  /// **'Could not open video, please try again'**
  String get couldNotOpenVideo;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get hi;

  /// No description provided for @letsStart.
  ///
  /// In en, this message translates to:
  /// **'Let’s Start Your Day'**
  String get letsStart;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @gym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get gym;

  /// No description provided for @fitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get fitness;

  /// No description provided for @yoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get yoga;

  /// No description provided for @aerobics.
  ///
  /// In en, this message translates to:
  /// **'Aerobics'**
  String get aerobics;

  /// No description provided for @trainer.
  ///
  /// In en, this message translates to:
  /// **'Trainer'**
  String get trainer;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon'**
  String get featureComingSoon;

  /// No description provided for @recommendationToday.
  ///
  /// In en, this message translates to:
  /// **'Recommendation Today'**
  String get recommendationToday;

  /// No description provided for @popularTraining.
  ///
  /// In en, this message translates to:
  /// **'Popular Training'**
  String get popularTraining;

  /// No description provided for @upcomingWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Workouts'**
  String get upcomingWorkouts;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// Please complete your registration
  ///
  /// In en, this message translates to:
  /// **'Please complete your registration'**
  String get completeRegister;

  /// Google login failed
  ///
  /// In en, this message translates to:
  /// **'Google login failed'**
  String get googleLoginFailed;

  /// No description provided for @smartCoachDefaultSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'New Conversation'**
  String get smartCoachDefaultSessionTitle;

  /// No description provided for @smartCoachSafetyBlockMessage.
  ///
  /// In en, this message translates to:
  /// **'Sorry, I can\'t help with this topic. Let\'s focus on your fitness goals!'**
  String get smartCoachSafetyBlockMessage;

  /// No description provided for @smartCoachEmptyChat.
  ///
  /// In en, this message translates to:
  /// **'Start your conversation with the Smart Coach 💪'**
  String get smartCoachEmptyChat;

  /// No description provided for @smartCoachRetryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get smartCoachRetryButton;

  /// No description provided for @smartCoachPartialMessage.
  ///
  /// In en, this message translates to:
  /// **'⚠ Incomplete message'**
  String get smartCoachPartialMessage;

  /// No description provided for @smartCoachPreviousConversations.
  ///
  /// In en, this message translates to:
  /// **'Previous Conversations'**
  String get smartCoachPreviousConversations;

  /// No description provided for @smartCoachNoConversations.
  ///
  /// In en, this message translates to:
  /// **'No previous conversations'**
  String get smartCoachNoConversations;

  /// No description provided for @smartCoachTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get smartCoachTypeMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
