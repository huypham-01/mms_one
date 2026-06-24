import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

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
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'CN'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @materialRequest.
  ///
  /// In en, this message translates to:
  /// **'Material Request'**
  String get materialRequest;

  /// No description provided for @preparer.
  ///
  /// In en, this message translates to:
  /// **'Preparer'**
  String get preparer;

  /// No description provided for @warehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get warehouse;

  /// No description provided for @materialReceiver.
  ///
  /// In en, this message translates to:
  /// **'Material Receiver'**
  String get materialReceiver;

  /// No description provided for @lineLeader.
  ///
  /// In en, this message translates to:
  /// **'Line Leader'**
  String get lineLeader;

  /// No description provided for @toProduction.
  ///
  /// In en, this message translates to:
  /// **'To Production'**
  String get toProduction;

  /// No description provided for @pdStorageArea.
  ///
  /// In en, this message translates to:
  /// **'PD Storage Area'**
  String get pdStorageArea;

  /// No description provided for @materialOvertime.
  ///
  /// In en, this message translates to:
  /// **'Material Overtime'**
  String get materialOvertime;

  /// No description provided for @materialManagement.
  ///
  /// In en, this message translates to:
  /// **'MATERIAL MANAGEMENT'**
  String get materialManagement;

  /// No description provided for @monitoring.
  ///
  /// In en, this message translates to:
  /// **'MONITORING'**
  String get monitoring;

  /// No description provided for @storageArea.
  ///
  /// In en, this message translates to:
  /// **'Storage Area'**
  String get storageArea;

  /// No description provided for @materialOvertimeModule.
  ///
  /// In en, this message translates to:
  /// **'Material Overtime'**
  String get materialOvertimeModule;

  /// No description provided for @transactionLog.
  ///
  /// In en, this message translates to:
  /// **'Transaction Log'**
  String get transactionLog;

  /// No description provided for @logHistory.
  ///
  /// In en, this message translates to:
  /// **'Log History'**
  String get logHistory;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @pendingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Pending Confirm'**
  String get pendingConfirm;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @chineseSimplified.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get chineseSimplified;

  /// No description provided for @chineseTraditional.
  ///
  /// In en, this message translates to:
  /// **'繁體中文'**
  String get chineseTraditional;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'v1.0.0'**
  String get version;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get status;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @pleaseDoNotCloseScreen.
  ///
  /// In en, this message translates to:
  /// **'Please do not close the screen'**
  String get pleaseDoNotCloseScreen;

  /// No description provided for @prepareDate.
  ///
  /// In en, this message translates to:
  /// **'Prepare Date'**
  String get prepareDate;

  /// No description provided for @tapToSelectChoice.
  ///
  /// In en, this message translates to:
  /// **'Tap to select choice'**
  String get tapToSelectChoice;

  /// No description provided for @requestNumber.
  ///
  /// In en, this message translates to:
  /// **'Request Number'**
  String get requestNumber;

  /// No description provided for @autoFilled.
  ///
  /// In en, this message translates to:
  /// **'Auto-filled'**
  String get autoFilled;

  /// No description provided for @workOrder.
  ///
  /// In en, this message translates to:
  /// **'Work Order'**
  String get workOrder;

  /// No description provided for @demandWk.
  ///
  /// In en, this message translates to:
  /// **'Demand WK'**
  String get demandWk;

  /// No description provided for @pcn.
  ///
  /// In en, this message translates to:
  /// **'PCN'**
  String get pcn;

  /// No description provided for @finishGoodCtn.
  ///
  /// In en, this message translates to:
  /// **'Finish Good/ctn'**
  String get finishGoodCtn;

  /// No description provided for @materialPn.
  ///
  /// In en, this message translates to:
  /// **'Material P/N'**
  String get materialPn;

  /// No description provided for @materialName.
  ///
  /// In en, this message translates to:
  /// **'Material Name'**
  String get materialName;

  /// No description provided for @requestQuantity.
  ///
  /// In en, this message translates to:
  /// **'Request Quantity'**
  String get requestQuantity;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @lotsInformation.
  ///
  /// In en, this message translates to:
  /// **'Lots Information'**
  String get lotsInformation;

  /// No description provided for @addLot.
  ///
  /// In en, this message translates to:
  /// **'Add Lot'**
  String get addLot;

  /// No description provided for @lot.
  ///
  /// In en, this message translates to:
  /// **'Lot'**
  String get lot;

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'qty'**
  String get qty;

  /// No description provided for @lotQty.
  ///
  /// In en, this message translates to:
  /// **'Lot qty'**
  String get lotQty;

  /// No description provided for @enterLotName.
  ///
  /// In en, this message translates to:
  /// **'Enter lot name'**
  String get enterLotName;

  /// No description provided for @warehouseVerification.
  ///
  /// In en, this message translates to:
  /// **'Warehouse Verification'**
  String get warehouseVerification;

  /// No description provided for @verificationInfo.
  ///
  /// In en, this message translates to:
  /// **'Verification & Info'**
  String get verificationInfo;

  /// No description provided for @preparedQuantity.
  ///
  /// In en, this message translates to:
  /// **'Prepared Quantity'**
  String get preparedQuantity;

  /// No description provided for @difference.
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get difference;

  /// No description provided for @verifyMethod.
  ///
  /// In en, this message translates to:
  /// **'Verify Method'**
  String get verifyMethod;

  /// No description provided for @verifyMethodPr.
  ///
  /// In en, this message translates to:
  /// **'Verify Method PR'**
  String get verifyMethodPr;

  /// No description provided for @barcodeScanPr.
  ///
  /// In en, this message translates to:
  /// **'Barcode Scan PR'**
  String get barcodeScanPr;

  /// No description provided for @pcnScan.
  ///
  /// In en, this message translates to:
  /// **'PCN Scan'**
  String get pcnScan;

  /// No description provided for @pcnScanResult.
  ///
  /// In en, this message translates to:
  /// **'PCN Scan Result'**
  String get pcnScanResult;

  /// No description provided for @pnScan.
  ///
  /// In en, this message translates to:
  /// **'Material P/N Scan'**
  String get pnScan;

  /// No description provided for @pnScanResult.
  ///
  /// In en, this message translates to:
  /// **'Material P/N Scan Result'**
  String get pnScanResult;

  /// No description provided for @tapIconToScan.
  ///
  /// In en, this message translates to:
  /// **'Tap icon to scan code'**
  String get tapIconToScan;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmount;

  /// No description provided for @scanResult.
  ///
  /// In en, this message translates to:
  /// **'Scan Result'**
  String get scanResult;

  /// No description provided for @locker.
  ///
  /// In en, this message translates to:
  /// **'Locker'**
  String get locker;

  /// No description provided for @scanLocker.
  ///
  /// In en, this message translates to:
  /// **'Scan Locker'**
  String get scanLocker;

  /// No description provided for @scanPreparerName.
  ///
  /// In en, this message translates to:
  /// **'Scan PreparerName'**
  String get scanPreparerName;

  /// No description provided for @preparerName.
  ///
  /// In en, this message translates to:
  /// **'Preparer Name'**
  String get preparerName;

  /// No description provided for @specCheck.
  ///
  /// In en, this message translates to:
  /// **'Spec Check'**
  String get specCheck;

  /// No description provided for @quantityCheck.
  ///
  /// In en, this message translates to:
  /// **'Quantity Check'**
  String get quantityCheck;

  /// No description provided for @warehouseLocker.
  ///
  /// In en, this message translates to:
  /// **'Warehouse Locker'**
  String get warehouseLocker;

  /// No description provided for @scanWarehouseLockerQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get scanWarehouseLockerQr;

  /// No description provided for @productionLocker.
  ///
  /// In en, this message translates to:
  /// **'Production Locker'**
  String get productionLocker;

  /// No description provided for @scanProductionLockerQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get scanProductionLockerQr;

  /// No description provided for @warehouseKeeper.
  ///
  /// In en, this message translates to:
  /// **'Warehouse Keeper'**
  String get warehouseKeeper;

  /// No description provided for @mrName.
  ///
  /// In en, this message translates to:
  /// **'MR Name'**
  String get mrName;

  /// No description provided for @receiverFrom.
  ///
  /// In en, this message translates to:
  /// **'Receiver From'**
  String get receiverFrom;

  /// No description provided for @leaderName.
  ///
  /// In en, this message translates to:
  /// **'Leader Name'**
  String get leaderName;

  /// No description provided for @quantityToProduction.
  ///
  /// In en, this message translates to:
  /// **'Quantity to Production'**
  String get quantityToProduction;

  /// No description provided for @toWhere.
  ///
  /// In en, this message translates to:
  /// **'To Where'**
  String get toWhere;

  /// No description provided for @toWho.
  ///
  /// In en, this message translates to:
  /// **'To Who'**
  String get toWho;

  /// No description provided for @fromLocker.
  ///
  /// In en, this message translates to:
  /// **'From Locker'**
  String get fromLocker;

  /// No description provided for @scanFromLockerQr.
  ///
  /// In en, this message translates to:
  /// **'Scan From Locker QR'**
  String get scanFromLockerQr;

  /// No description provided for @fromLeader.
  ///
  /// In en, this message translates to:
  /// **'From Leader'**
  String get fromLeader;

  /// No description provided for @fromName.
  ///
  /// In en, this message translates to:
  /// **'From Name'**
  String get fromName;

  /// No description provided for @specPicture.
  ///
  /// In en, this message translates to:
  /// **'Spec Picture'**
  String get specPicture;

  /// No description provided for @searchByIdName.
  ///
  /// In en, this message translates to:
  /// **'Search by ID, name, P/N, WO…'**
  String get searchByIdName;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// No description provided for @selectMaterialRequest.
  ///
  /// In en, this message translates to:
  /// **'Please select Material Request before submitting'**
  String get selectMaterialRequest;

  /// No description provided for @pictureVerificationRequired.
  ///
  /// In en, this message translates to:
  /// **'Verification method is Picture — please take at least 1 photo'**
  String get pictureVerificationRequired;

  /// No description provided for @scanBarcodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please scan barcode before submitting'**
  String get scanBarcodeRequired;

  /// No description provided for @barcodeNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Barcode does not match Verification Code'**
  String get barcodeNotMatch;

  /// No description provided for @enterLotNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter lot name'**
  String get enterLotNameRequired;

  /// No description provided for @enterLotQuantityRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter quantity'**
  String get enterLotQuantityRequired;

  /// No description provided for @scanLockerRequired.
  ///
  /// In en, this message translates to:
  /// **'Please scan Locker'**
  String get scanLockerRequired;

  /// No description provided for @scanPnRequired.
  ///
  /// In en, this message translates to:
  /// **'Please scan Material P/N'**
  String get scanPnRequired;

  /// No description provided for @scanPcnRequired.
  ///
  /// In en, this message translates to:
  /// **'Please scan PCN'**
  String get scanPcnRequired;

  /// No description provided for @scanWarehouseLockerRequired.
  ///
  /// In en, this message translates to:
  /// **'Please scan Warehouse Locker'**
  String get scanWarehouseLockerRequired;

  /// No description provided for @scanProductionLockerRequired.
  ///
  /// In en, this message translates to:
  /// **'Please scan Production Locker'**
  String get scanProductionLockerRequired;

  /// No description provided for @enterReceivedBy.
  ///
  /// In en, this message translates to:
  /// **'Please enter Received By'**
  String get enterReceivedBy;

  /// No description provided for @enterMrName.
  ///
  /// In en, this message translates to:
  /// **'Please enter MR Name'**
  String get enterMrName;

  /// No description provided for @enterReceiverFrom.
  ///
  /// In en, this message translates to:
  /// **'Please enter Receiver From'**
  String get enterReceiverFrom;

  /// No description provided for @enterLeaderName.
  ///
  /// In en, this message translates to:
  /// **'Please enter Leader Name'**
  String get enterLeaderName;

  /// No description provided for @enterQuantityToProduction.
  ///
  /// In en, this message translates to:
  /// **'Please enter Quantity to Production'**
  String get enterQuantityToProduction;

  /// No description provided for @quantityMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Quantity to Production must be positive'**
  String get quantityMustBePositive;

  /// No description provided for @enterToWhere.
  ///
  /// In en, this message translates to:
  /// **'Please enter To Where'**
  String get enterToWhere;

  /// No description provided for @enterToWho.
  ///
  /// In en, this message translates to:
  /// **'Please enter To Who'**
  String get enterToWho;

  /// No description provided for @enterFromLeader.
  ///
  /// In en, this message translates to:
  /// **'Please enter From Leader'**
  String get enterFromLeader;

  /// No description provided for @enterFromName.
  ///
  /// In en, this message translates to:
  /// **'Please enter From Name'**
  String get enterFromName;

  /// No description provided for @rejectSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reject successfully'**
  String get rejectSuccess;

  /// No description provided for @rejectFailed.
  ///
  /// In en, this message translates to:
  /// **'Reject failed. Please try again'**
  String get rejectFailed;

  /// No description provided for @submitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Submit successfully'**
  String get submitSuccess;

  /// No description provided for @submitFailed.
  ///
  /// In en, this message translates to:
  /// **'Submit failed. Please try again'**
  String get submitFailed;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'No network connection. Please check and try again'**
  String get networkError;

  /// No description provided for @timeoutError.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out. Please try again'**
  String get timeoutError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later'**
  String get serverError;

  /// No description provided for @otpInvalid.
  ///
  /// In en, this message translates to:
  /// **'OTP code is invalid. Please check again'**
  String get otpInvalid;

  /// No description provided for @otpEmptyError.
  ///
  /// In en, this message translates to:
  /// **'OTP cannot be empty'**
  String get otpEmptyError;

  /// No description provided for @otpLengthError.
  ///
  /// In en, this message translates to:
  /// **'OTP must have exactly 6 digits'**
  String get otpLengthError;

  /// No description provided for @verifyOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtpTitle;

  /// No description provided for @otpCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'OTP Code'**
  String get otpCodeLabel;

  /// No description provided for @submitError.
  ///
  /// In en, this message translates to:
  /// **'Error occurred when submitting. Please try again'**
  String get submitError;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get scanBarcode;

  /// No description provided for @barcodeScan.
  ///
  /// In en, this message translates to:
  /// **'Barcode Scan'**
  String get barcodeScan;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// No description provided for @wrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get wrong;

  /// No description provided for @receiver.
  ///
  /// In en, this message translates to:
  /// **'Receiver'**
  String get receiver;

  /// No description provided for @production.
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get production;

  /// No description provided for @rejectCurrentStep.
  ///
  /// In en, this message translates to:
  /// **'Reject Current Step'**
  String get rejectCurrentStep;

  /// No description provided for @rejectCurrentStepDescription.
  ///
  /// In en, this message translates to:
  /// **'Return this workflow to previous verification step.'**
  String get rejectCurrentStepDescription;

  /// No description provided for @rejectReason.
  ///
  /// In en, this message translates to:
  /// **'Reject Reason'**
  String get rejectReason;

  /// No description provided for @supervisorOtp.
  ///
  /// In en, this message translates to:
  /// **'Supervisor OTP'**
  String get supervisorOtp;

  /// No description provided for @enterRejectReason.
  ///
  /// In en, this message translates to:
  /// **'Enter reject reason...'**
  String get enterRejectReason;

  /// No description provided for @confirmReject.
  ///
  /// In en, this message translates to:
  /// **'Confirm Reject'**
  String get confirmReject;

  /// No description provided for @enterAllOtpDigits.
  ///
  /// In en, this message translates to:
  /// **'Please enter all 6 OTP digits'**
  String get enterAllOtpDigits;

  /// No description provided for @returnToPreviousStep.
  ///
  /// In en, this message translates to:
  /// **'This step will return to {step} for re-check.'**
  String returnToPreviousStep(String step);

  /// No description provided for @firstStepCannotReturnFurther.
  ///
  /// In en, this message translates to:
  /// **'This is the first step. Cannot return further.'**
  String get firstStepCannotReturnFurther;

  /// No description provided for @materialOvertimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage and monitor material overtime'**
  String get materialOvertimeSubtitle;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @totalOvertimeItems.
  ///
  /// In en, this message translates to:
  /// **'Total: {total} overtime items'**
  String totalOvertimeItems(int total);

  /// No description provided for @pageIndicator.
  ///
  /// In en, this message translates to:
  /// **'Page {currentPage}/{lastPage}'**
  String pageIndicator(int currentPage, int lastPage);

  /// No description provided for @requestNo.
  ///
  /// In en, this message translates to:
  /// **'Request No.'**
  String get requestNo;

  /// No description provided for @requestDate.
  ///
  /// In en, this message translates to:
  /// **'Request Date'**
  String get requestDate;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @dayAbbreviation.
  ///
  /// In en, this message translates to:
  /// **'d'**
  String get dayAbbreviation;

  /// No description provided for @noOvertimeRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No overtime records found'**
  String get noOvertimeRecordsFound;

  /// No description provided for @currentStep.
  ///
  /// In en, this message translates to:
  /// **'Current Step'**
  String get currentStep;

  /// No description provided for @overtimeAt.
  ///
  /// In en, this message translates to:
  /// **'Overtime At'**
  String get overtimeAt;

  /// No description provided for @storageAreaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor material locations and stock in production storage'**
  String get storageAreaSubtitle;

  /// No description provided for @searchStorageAreaHint.
  ///
  /// In en, this message translates to:
  /// **'Search Request, Material, PCN, Work Order...'**
  String get searchStorageAreaHint;

  /// No description provided for @noStorageAreaData.
  ///
  /// In en, this message translates to:
  /// **'No storage area data'**
  String get noStorageAreaData;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @toProduct.
  ///
  /// In en, this message translates to:
  /// **'To Product'**
  String get toProduct;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @lastConsume.
  ///
  /// In en, this message translates to:
  /// **'Last Consume'**
  String get lastConsume;

  /// No description provided for @statusInUse.
  ///
  /// In en, this message translates to:
  /// **'In Use'**
  String get statusInUse;

  /// No description provided for @statusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get statusOpen;

  /// No description provided for @statusClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get statusClose;

  /// No description provided for @transactionLogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Consume Events History'**
  String get transactionLogSubtitle;

  /// No description provided for @noTransactionLogsFound.
  ///
  /// In en, this message translates to:
  /// **'No transaction logs found'**
  String get noTransactionLogsFound;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @materialRequestInformation.
  ///
  /// In en, this message translates to:
  /// **'Material Request'**
  String get materialRequestInformation;

  /// No description provided for @requestStatus.
  ///
  /// In en, this message translates to:
  /// **'Request Status'**
  String get requestStatus;

  /// No description provided for @workflowInformation.
  ///
  /// In en, this message translates to:
  /// **'Workflow Information'**
  String get workflowInformation;

  /// No description provided for @currentStatus.
  ///
  /// In en, this message translates to:
  /// **'Current Status'**
  String get currentStatus;

  /// No description provided for @actionDate.
  ///
  /// In en, this message translates to:
  /// **'Action Date'**
  String get actionDate;

  /// No description provided for @submittedBy.
  ///
  /// In en, this message translates to:
  /// **'Submitted By'**
  String get submittedBy;

  /// No description provided for @quantityInformation.
  ///
  /// In en, this message translates to:
  /// **'Quantity Information'**
  String get quantityInformation;

  /// No description provided for @preparedMaterialReceived.
  ///
  /// In en, this message translates to:
  /// **'Prepared Material Received'**
  String get preparedMaterialReceived;

  /// No description provided for @totalToProduction.
  ///
  /// In en, this message translates to:
  /// **'Total To Production'**
  String get totalToProduction;

  /// No description provided for @currentMaterialBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Material Balance'**
  String get currentMaterialBalance;

  /// No description provided for @lotInformation.
  ///
  /// In en, this message translates to:
  /// **'Lot Information'**
  String get lotInformation;

  /// No description provided for @specPictures.
  ///
  /// In en, this message translates to:
  /// **'Spec Pictures'**
  String get specPictures;

  /// No description provided for @verificationMethod.
  ///
  /// In en, this message translates to:
  /// **'Verification Method'**
  String get verificationMethod;

  /// No description provided for @logHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Log History'**
  String get logHistoryTitle;

  /// No description provided for @stepPlanner.
  ///
  /// In en, this message translates to:
  /// **'PLANNER'**
  String get stepPlanner;

  /// No description provided for @stepPreparer.
  ///
  /// In en, this message translates to:
  /// **'PREPARER'**
  String get stepPreparer;

  /// No description provided for @stepWarehouse.
  ///
  /// In en, this message translates to:
  /// **'WAREHOUSE'**
  String get stepWarehouse;

  /// No description provided for @stepReceiver.
  ///
  /// In en, this message translates to:
  /// **'RECEIVER'**
  String get stepReceiver;

  /// No description provided for @stepLineLeader.
  ///
  /// In en, this message translates to:
  /// **'LINE LEADER'**
  String get stepLineLeader;

  /// No description provided for @stepProduction.
  ///
  /// In en, this message translates to:
  /// **'PRODUCTION'**
  String get stepProduction;

  /// No description provided for @rolePlanner.
  ///
  /// In en, this message translates to:
  /// **'Planner'**
  String get rolePlanner;

  /// No description provided for @rolePreparer.
  ///
  /// In en, this message translates to:
  /// **'Preparer'**
  String get rolePreparer;

  /// No description provided for @roleWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get roleWarehouse;

  /// No description provided for @roleReceiver.
  ///
  /// In en, this message translates to:
  /// **'Receiver'**
  String get roleReceiver;

  /// No description provided for @roleLineLeader.
  ///
  /// In en, this message translates to:
  /// **'Line Leader'**
  String get roleLineLeader;

  /// No description provided for @systemActor.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemActor;

  /// No description provided for @payloadHeader.
  ///
  /// In en, this message translates to:
  /// **'PAYLOAD'**
  String get payloadHeader;

  /// No description provided for @boolTrue.
  ///
  /// In en, this message translates to:
  /// **'true'**
  String get boolTrue;

  /// No description provided for @boolFalse.
  ///
  /// In en, this message translates to:
  /// **'false'**
  String get boolFalse;

  /// No description provided for @errorLoadHistory.
  ///
  /// In en, this message translates to:
  /// **'Failed to load history'**
  String get errorLoadHistory;

  /// No description provided for @emptyHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get emptyHistoryTitle;

  /// No description provided for @emptyHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'This Material Request has no logs recorded yet.'**
  String get emptyHistoryDesc;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @drawerModuleMaterialRequest.
  ///
  /// In en, this message translates to:
  /// **'Material Request'**
  String get drawerModuleMaterialRequest;

  /// No description provided for @drawerModulePreparer.
  ///
  /// In en, this message translates to:
  /// **'Preparer'**
  String get drawerModulePreparer;

  /// No description provided for @drawerModuleWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get drawerModuleWarehouse;

  /// No description provided for @drawerModuleMaterialReceiver.
  ///
  /// In en, this message translates to:
  /// **'Material Receiver'**
  String get drawerModuleMaterialReceiver;

  /// No description provided for @drawerModuleLineLeader.
  ///
  /// In en, this message translates to:
  /// **'Line Leader'**
  String get drawerModuleLineLeader;

  /// No description provided for @reportMaterialRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Material Request Report'**
  String get reportMaterialRequestTitle;

  /// No description provided for @reportPreparerTitle.
  ///
  /// In en, this message translates to:
  /// **'Preparer Report'**
  String get reportPreparerTitle;

  /// No description provided for @reportWarehouseTitle.
  ///
  /// In en, this message translates to:
  /// **'Warehouse Report'**
  String get reportWarehouseTitle;

  /// No description provided for @reportMaterialReceiverTitle.
  ///
  /// In en, this message translates to:
  /// **'Material Receiver Report'**
  String get reportMaterialReceiverTitle;

  /// No description provided for @reportLineLeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Line Leader Report'**
  String get reportLineLeaderTitle;

  /// No description provided for @workflowReportList.
  ///
  /// In en, this message translates to:
  /// **'Workflow report list'**
  String get workflowReportList;

  /// No description provided for @noReportData.
  ///
  /// In en, this message translates to:
  /// **'No report data'**
  String get noReportData;

  /// No description provided for @noWorkflowReportDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No workflow report data available for this step.'**
  String get noWorkflowReportDataAvailable;

  /// No description provided for @drawerReportHeader.
  ///
  /// In en, this message translates to:
  /// **'REPORT'**
  String get drawerReportHeader;

  /// No description provided for @drawerLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get drawerLogout;

  /// No description provided for @drawerLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get drawerLanguage;

  /// No description provided for @drawerMockMode.
  ///
  /// In en, this message translates to:
  /// **'🧪 MOCK MODE'**
  String get drawerMockMode;

  /// No description provided for @drawerLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language: '**
  String get drawerLanguageLabel;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'MMS Login'**
  String get loginTitle;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @usernameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter username'**
  String get usernameEmpty;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get passwordEmpty;

  /// No description provided for @otpEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter OTP'**
  String get otpEmpty;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @materialRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Material Request'**
  String get materialRequestTitle;

  /// No description provided for @manageRequisitions.
  ///
  /// In en, this message translates to:
  /// **'Manage material requisitions'**
  String get manageRequisitions;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @searchByRequestNumber.
  ///
  /// In en, this message translates to:
  /// **'Search request number, material...'**
  String get searchByRequestNumber;

  /// No description provided for @noRequestsFound.
  ///
  /// In en, this message translates to:
  /// **'No requests found'**
  String get noRequestsFound;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @updateDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed. Please try again.'**
  String get updateDownloadFailed;

  /// No description provided for @updateDownloadStart.
  ///
  /// In en, this message translates to:
  /// **'Downloading Update...'**
  String get updateDownloadStart;

  /// No description provided for @updateNewVersionAvailable.
  ///
  /// In en, this message translates to:
  /// **'New version available'**
  String get updateNewVersionAvailable;

  /// No description provided for @updateCurrentVersion.
  ///
  /// In en, this message translates to:
  /// **'Current version'**
  String get updateCurrentVersion;

  /// No description provided for @updateLatestVersion.
  ///
  /// In en, this message translates to:
  /// **'Latest version'**
  String get updateLatestVersion;

  /// No description provided for @updateLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updateLater;

  /// No description provided for @updateUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateUpdate;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.countryCode) {
    case 'CN': return AppLocalizationsZhCn();
case 'TW': return AppLocalizationsZhTw();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
