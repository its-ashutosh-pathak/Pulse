import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_af.dart';
import 'app_localizations_ar.dart';
import 'app_localizations_as.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_mai.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ne.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sa.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ur.dart';
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
/// import 'generated/app_localizations.dart';
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
    Locale('af'),
    Locale('ar'),
    Locale('as'),
    Locale('bn'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('gu'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('kn'),
    Locale('ko'),
    Locale('mai'),
    Locale('ml'),
    Locale('mr'),
    Locale('ne'),
    Locale('or'),
    Locale('pa'),
    Locale('pt'),
    Locale('ru'),
    Locale('sa'),
    Locale('ta'),
    Locale('te'),
    Locale('tr'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Pulse'**
  String get appTitle;

  /// No description provided for @artistAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get artistAbout;

  /// No description provided for @artistPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get artistPopular;

  /// No description provided for @artistAlbums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get artistAlbums;

  /// No description provided for @artistSinglesAndEPs.
  ///
  /// In en, this message translates to:
  /// **'Singles & EPs'**
  String get artistSinglesAndEPs;

  /// No description provided for @artistSubscribersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} subscribers'**
  String artistSubscribersCount(String count);

  /// No description provided for @artistPlayAll.
  ///
  /// In en, this message translates to:
  /// **'Play All'**
  String get artistPlayAll;

  /// No description provided for @artistLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load artist'**
  String get artistLoadError;

  /// No description provided for @artistGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get artistGoBack;

  /// No description provided for @adminChatFailedToReply.
  ///
  /// In en, this message translates to:
  /// **'Failed to reply: {error}'**
  String adminChatFailedToReply(String error);

  /// No description provided for @adminChatSupportChat.
  ///
  /// In en, this message translates to:
  /// **'Support Chat'**
  String get adminChatSupportChat;

  /// No description provided for @adminChatError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String adminChatError(String error);

  /// No description provided for @adminChatNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No conversation history.'**
  String get adminChatNoHistory;

  /// No description provided for @adminChatSupportYou.
  ///
  /// In en, this message translates to:
  /// **'Support (You)'**
  String get adminChatSupportYou;

  /// No description provided for @adminChatTypeReply.
  ///
  /// In en, this message translates to:
  /// **'Type your reply...'**
  String get adminChatTypeReply;

  /// No description provided for @broadcastSuccess.
  ///
  /// In en, this message translates to:
  /// **'Announcement broadcasted successfully!'**
  String get broadcastSuccess;

  /// No description provided for @broadcastFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to broadcast: {error}'**
  String broadcastFailed(String error);

  /// No description provided for @broadcastTitle.
  ///
  /// In en, this message translates to:
  /// **'Global Announcements'**
  String get broadcastTitle;

  /// No description provided for @broadcastSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sent to all users'**
  String get broadcastSubtitle;

  /// No description provided for @broadcastWarning.
  ///
  /// In en, this message translates to:
  /// **'Messages sent here will be visible to everyone.'**
  String get broadcastWarning;

  /// No description provided for @broadcastError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String broadcastError(String error);

  /// No description provided for @broadcastNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No previous announcements.'**
  String get broadcastNoHistory;

  /// No description provided for @broadcastTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a global broadcast...'**
  String get broadcastTypeMessage;

  /// No description provided for @commFailedToSend.
  ///
  /// In en, this message translates to:
  /// **'Failed to send: {error}'**
  String commFailedToSend(String error);

  /// No description provided for @commAdminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get commAdminDashboard;

  /// No description provided for @commAdminSupport.
  ///
  /// In en, this message translates to:
  /// **'Admin Support'**
  String get commAdminSupport;

  /// No description provided for @commAlwaysHere.
  ///
  /// In en, this message translates to:
  /// **'Always here to help'**
  String get commAlwaysHere;

  /// No description provided for @commWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Hey! 👋 I\'m Ashutosh Pathak'**
  String get commWelcomeTitle;

  /// No description provided for @commWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Developer of Pulse'**
  String get commWelcomeSubtitle;

  /// No description provided for @commWelcomeBody1.
  ///
  /// In en, this message translates to:
  /// **'I hope you\'re enjoying listening to your favorite music without annoying ads or subscription barriers. After all, music shouldn\'t come with a paywall just because someone in a boardroom needed another yacht.\n\nThis section is here so we can connect directly.\n\nFeel free to:'**
  String get commWelcomeBody1;

  /// No description provided for @commBullet1.
  ///
  /// In en, this message translates to:
  /// **'Share your feedback'**
  String get commBullet1;

  /// No description provided for @commBullet2.
  ///
  /// In en, this message translates to:
  /// **'Report bugs'**
  String get commBullet2;

  /// No description provided for @commBullet3.
  ///
  /// In en, this message translates to:
  /// **'Suggest new features you\'d like to see'**
  String get commBullet3;

  /// No description provided for @commWelcomeBody2.
  ///
  /// In en, this message translates to:
  /// **'I personally read every message and will do my best to improve the app based on your suggestions.\n\nGot an idea for an app that doesn\'t exist yet, or one that\'s locked behind expensive subscriptions? Tell me about it! If it\'s possible, I\'ll try to build it and make it available for everyone.\n\nThanks for using my app and for being part of this journey. ❤️'**
  String get commWelcomeBody2;

  /// No description provided for @commError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String commError(String error);

  /// No description provided for @commNoMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get commNoMessages;

  /// No description provided for @commNoMessagesDesc.
  ///
  /// In en, this message translates to:
  /// **'Send a message to our support team or check back later for announcements.'**
  String get commNoMessagesDesc;

  /// No description provided for @commMessageSupportHint.
  ///
  /// In en, this message translates to:
  /// **'Message support...'**
  String get commMessageSupportHint;

  /// No description provided for @commGlobalAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Global Announcements'**
  String get commGlobalAnnouncements;

  /// No description provided for @commSendMessagesToAll.
  ///
  /// In en, this message translates to:
  /// **'Send messages to all users'**
  String get commSendMessagesToAll;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning,'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon,'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening,'**
  String get homeGreetingEvening;

  /// No description provided for @homeMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get homeMember;

  /// No description provided for @homeRecentPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Recent Playlists'**
  String get homeRecentPlaylists;

  /// No description provided for @homeRecentlyPlayed.
  ///
  /// In en, this message translates to:
  /// **'Recently played'**
  String get homeRecentlyPlayed;

  /// No description provided for @homeSpeedDial.
  ///
  /// In en, this message translates to:
  /// **'Speed dial'**
  String get homeSpeedDial;

  /// No description provided for @homeNoContent.
  ///
  /// In en, this message translates to:
  /// **'No content available'**
  String get homeNoContent;

  /// No description provided for @homeRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get homeRefresh;

  /// No description provided for @homeLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load music feed.'**
  String get homeLoadError;

  /// No description provided for @homeRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get homeRetry;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully Connected to Spotify!'**
  String get importSuccess;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect: {error}'**
  String importFailed(String error);

  /// No description provided for @importTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect Spotify'**
  String get importTitle;

  /// No description provided for @importSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Setup Spotify Integration'**
  String get importSetupTitle;

  /// No description provided for @importSetupDesc.
  ///
  /// In en, this message translates to:
  /// **'To bypass Spotify\'s strict rate limits and import all your playlists instantly, you must use your own free developer key. Follow these simple steps:'**
  String get importSetupDesc;

  /// No description provided for @importStep1.
  ///
  /// In en, this message translates to:
  /// **'Open the Spotify Developer Dashboard.'**
  String get importStep1;

  /// No description provided for @importStep2.
  ///
  /// In en, this message translates to:
  /// **'Log in and click \"Create app\".'**
  String get importStep2;

  /// No description provided for @importStep3.
  ///
  /// In en, this message translates to:
  /// **'Fill in any App Name and Description.'**
  String get importStep3;

  /// No description provided for @importStep4.
  ///
  /// In en, this message translates to:
  /// **'Under \"Redirect URIs\", paste the following exact URL:'**
  String get importStep4;

  /// No description provided for @importRedirectCopied.
  ///
  /// In en, this message translates to:
  /// **'Redirect URI Copied!'**
  String get importRedirectCopied;

  /// No description provided for @importStep5.
  ///
  /// In en, this message translates to:
  /// **'Save the app, copy your \"Client ID\" from settings, and paste it below.'**
  String get importStep5;

  /// No description provided for @importImportant.
  ///
  /// In en, this message translates to:
  /// **'Important: The Spotify account used to create this developer app must have an active Premium subscription.'**
  String get importImportant;

  /// No description provided for @importClientIdHint.
  ///
  /// In en, this message translates to:
  /// **'Paste your Spotify Client ID here...'**
  String get importClientIdHint;

  /// No description provided for @importConnectButton.
  ///
  /// In en, this message translates to:
  /// **'Connect & Load Library'**
  String get importConnectButton;

  /// No description provided for @downloadingNoActive.
  ///
  /// In en, this message translates to:
  /// **'No active downloads'**
  String get downloadingNoActive;

  /// No description provided for @downloadingMb.
  ///
  /// In en, this message translates to:
  /// **'{value} MB'**
  String downloadingMb(String value);

  /// No description provided for @downloadsPlaylistName.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloadsPlaylistName;

  /// No description provided for @downloadsStats.
  ///
  /// In en, this message translates to:
  /// **'{count} songs • {size}'**
  String downloadsStats(String count, String size);

  /// No description provided for @downloadsNoOffline.
  ///
  /// In en, this message translates to:
  /// **'No offline songs yet'**
  String get downloadsNoOffline;

  /// No description provided for @downloadsNoOfflineDesc.
  ///
  /// In en, this message translates to:
  /// **'Songs you download will appear here'**
  String get downloadsNoOfflineDesc;

  /// No description provided for @downloadsClearAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear All Downloads?'**
  String get downloadsClearAllTitle;

  /// No description provided for @downloadsClearAllDesc.
  ///
  /// In en, this message translates to:
  /// **'This will remove {count} songs and free up {size} of storage.'**
  String downloadsClearAllDesc(String count, String size);

  /// No description provided for @downloadsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get downloadsCancel;

  /// No description provided for @downloadsClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get downloadsClearAll;

  /// No description provided for @downloadsSongsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} songs'**
  String downloadsSongsCount(String count);

  /// No description provided for @downloadsSongCountSingle.
  ///
  /// In en, this message translates to:
  /// **'{count} song'**
  String downloadsSongCountSingle(String count);

  /// No description provided for @downloadsCannotRenameMaster.
  ///
  /// In en, this message translates to:
  /// **'Cannot rename the master downloads playlist.'**
  String get downloadsCannotRenameMaster;

  /// No description provided for @downloadsRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get downloadsRename;

  /// No description provided for @downloadsEditSongs.
  ///
  /// In en, this message translates to:
  /// **'Edit Songs'**
  String get downloadsEditSongs;

  /// No description provided for @downloadsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get downloadsDelete;

  /// No description provided for @downloadsRenamePlaylistTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename Playlist'**
  String get downloadsRenamePlaylistTitle;

  /// No description provided for @downloadsRenamePlaylistDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter a new name for your playlist.'**
  String get downloadsRenamePlaylistDesc;

  /// No description provided for @downloadsDeletePlaylistTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Playlist?'**
  String get downloadsDeletePlaylistTitle;

  /// No description provided for @downloadsDeleteMasterDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this? You will lose all downloaded songs and playlists forever.'**
  String get downloadsDeleteMasterDesc;

  /// No description provided for @downloadsDeletePlaylistDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This playlist will be lost forever.'**
  String downloadsDeletePlaylistDesc(String name);

  /// No description provided for @downloadsSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get downloadsSave;

  /// No description provided for @downloadsNoSongs.
  ///
  /// In en, this message translates to:
  /// **'No songs in this playlist.'**
  String get downloadsNoSongs;

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get libraryTitle;

  /// No description provided for @libraryPauseAll.
  ///
  /// In en, this message translates to:
  /// **'Pause all'**
  String get libraryPauseAll;

  /// No description provided for @libraryResumeAll.
  ///
  /// In en, this message translates to:
  /// **'Resume all'**
  String get libraryResumeAll;

  /// No description provided for @libraryTabPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get libraryTabPlaylists;

  /// No description provided for @libraryTabDownloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get libraryTabDownloads;

  /// No description provided for @libraryTabDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get libraryTabDownloading;

  /// No description provided for @libraryImportedTask.
  ///
  /// In en, this message translates to:
  /// **'Imported {name}'**
  String libraryImportedTask(String name);

  /// No description provided for @libraryImportWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting in queue...'**
  String get libraryImportWaiting;

  /// No description provided for @libraryImportFetching.
  ///
  /// In en, this message translates to:
  /// **'Fetching playlist...'**
  String get libraryImportFetching;

  /// No description provided for @libraryImportProcessed.
  ///
  /// In en, this message translates to:
  /// **'{processed}/{total} processed · {matched} matched'**
  String libraryImportProcessed(String processed, String total, String matched);

  /// No description provided for @libraryImportSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving to library...'**
  String get libraryImportSaving;

  /// No description provided for @libraryImportDoneSongs.
  ///
  /// In en, this message translates to:
  /// **'{matched} songs added · tap × to dismiss'**
  String libraryImportDoneSongs(String matched);

  /// No description provided for @libraryImportDoneAll.
  ///
  /// In en, this message translates to:
  /// **'All songs added · tap × to dismiss'**
  String get libraryImportDoneAll;

  /// No description provided for @libraryAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get libraryAddButton;

  /// No description provided for @librarySortRecent.
  ///
  /// In en, this message translates to:
  /// **'Recently Added'**
  String get librarySortRecent;

  /// No description provided for @librarySortAlpha.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get librarySortAlpha;

  /// No description provided for @libraryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your library is empty.'**
  String get libraryEmptyTitle;

  /// No description provided for @libraryEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add\" to start your first Pulse.'**
  String get libraryEmptyDesc;

  /// No description provided for @libraryRenameLikedError.
  ///
  /// In en, this message translates to:
  /// **'Cannot rename the Liked Songs playlist.'**
  String get libraryRenameLikedError;

  /// No description provided for @libraryRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get libraryRename;

  /// No description provided for @libraryEditSongs.
  ///
  /// In en, this message translates to:
  /// **'Edit Songs'**
  String get libraryEditSongs;

  /// No description provided for @libraryDeleteLikedError.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete the Liked Songs playlist.'**
  String get libraryDeleteLikedError;

  /// No description provided for @libraryDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get libraryDelete;

  /// No description provided for @libraryEditSongsTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Songs'**
  String get libraryEditSongsTitle;

  /// No description provided for @libraryEditSongsCountSingle.
  ///
  /// In en, this message translates to:
  /// **'{count} song'**
  String libraryEditSongsCountSingle(String count);

  /// No description provided for @libraryEditSongsCountPlural.
  ///
  /// In en, this message translates to:
  /// **'{count} songs'**
  String libraryEditSongsCountPlural(String count);

  /// No description provided for @libraryCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get libraryCancel;

  /// No description provided for @librarySave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get librarySave;

  /// No description provided for @libraryNoSongs.
  ///
  /// In en, this message translates to:
  /// **'No songs in this playlist.'**
  String get libraryNoSongs;

  /// No description provided for @libraryAddOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add to Library'**
  String get libraryAddOptionsTitle;

  /// No description provided for @libraryAddOptionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to expand your Pulse'**
  String get libraryAddOptionsDesc;

  /// No description provided for @libraryImportPulse.
  ///
  /// In en, this message translates to:
  /// **'Import from Pulse'**
  String get libraryImportPulse;

  /// No description provided for @libraryImportPulseDesc.
  ///
  /// In en, this message translates to:
  /// **'Paste a Pulse playlist URL'**
  String get libraryImportPulseDesc;

  /// No description provided for @libraryImportYtm.
  ///
  /// In en, this message translates to:
  /// **'Import from YT Music'**
  String get libraryImportYtm;

  /// No description provided for @libraryImportYtmDesc.
  ///
  /// In en, this message translates to:
  /// **'Paste a PUBLIC playlist URL'**
  String get libraryImportYtmDesc;

  /// No description provided for @libraryImportSpotify.
  ///
  /// In en, this message translates to:
  /// **'Import from Spotify'**
  String get libraryImportSpotify;

  /// No description provided for @libraryImportSpotifyDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect your Spotify'**
  String get libraryImportSpotifyDesc;

  /// No description provided for @libraryClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get libraryClose;

  /// No description provided for @libraryImportYtmFull.
  ///
  /// In en, this message translates to:
  /// **'Import from YouTube Music'**
  String get libraryImportYtmFull;

  /// No description provided for @libraryImportSpotifyFull.
  ///
  /// In en, this message translates to:
  /// **'Import from Spotify (≤100)'**
  String get libraryImportSpotifyFull;

  /// No description provided for @libraryImportYtmUrlDesc.
  ///
  /// In en, this message translates to:
  /// **'Paste a PUBLIC YouTube Music playlist or album URL'**
  String get libraryImportYtmUrlDesc;

  /// No description provided for @libraryImportSpotifyUrlDesc.
  ///
  /// In en, this message translates to:
  /// **'Paste a public Spotify playlist URL below'**
  String get libraryImportSpotifyUrlDesc;

  /// No description provided for @libraryImportPulseHint.
  ///
  /// In en, this message translates to:
  /// **'https://pulse.app/playlist/...'**
  String get libraryImportPulseHint;

  /// No description provided for @libraryImportYtmHint.
  ///
  /// In en, this message translates to:
  /// **'https://music.youtube.com/playlist?list=...'**
  String get libraryImportYtmHint;

  /// No description provided for @libraryImportSpotifyHint.
  ///
  /// In en, this message translates to:
  /// **'https://open.spotify.com/playlist/...'**
  String get libraryImportSpotifyHint;

  /// No description provided for @libraryImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to import Pulse playlist'**
  String get libraryImportFailed;

  /// No description provided for @importErrorPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Error importing playlist'**
  String get importErrorPlaylist;

  /// No description provided for @importErrorHighlyPopulated.
  ///
  /// In en, this message translates to:
  /// **'Playlist is highly populated, it might take a while to fetch.'**
  String get importErrorHighlyPopulated;

  /// No description provided for @libraryImportBtn.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get libraryImportBtn;

  /// No description provided for @libraryCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New Playlist'**
  String get libraryCreateTitle;

  /// No description provided for @libraryCreateDesc.
  ///
  /// In en, this message translates to:
  /// **'What should we call your new playlist?'**
  String get libraryCreateDesc;

  /// No description provided for @libraryCreateHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Midnight Rides'**
  String get libraryCreateHint;

  /// No description provided for @libraryCreateBtn.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get libraryCreateBtn;

  /// No description provided for @libraryRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename Playlist'**
  String get libraryRenameTitle;

  /// No description provided for @libraryRenameDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter a new name for your playlist.'**
  String get libraryRenameDesc;

  /// No description provided for @libraryRenameBtn.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get libraryRenameBtn;

  /// No description provided for @libraryDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Playlist?'**
  String get libraryDeleteTitle;

  /// No description provided for @libraryDeleteDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This playlist will be lost forever.'**
  String libraryDeleteDesc(String name);

  /// No description provided for @libraryDeleteBtn.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get libraryDeleteBtn;

  /// No description provided for @librarySortLabelAlpha.
  ///
  /// In en, this message translates to:
  /// **'A-Z'**
  String get librarySortLabelAlpha;

  /// No description provided for @librarySortLabelRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get librarySortLabelRecent;

  /// No description provided for @librarySongsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Songs'**
  String librarySongsCount(String count);

  /// No description provided for @libraryComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get libraryComingSoon;

  /// No description provided for @loginErrName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get loginErrName;

  /// No description provided for @loginErrEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get loginErrEmail;

  /// No description provided for @loginErrPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get loginErrPassword;

  /// No description provided for @loginAppName.
  ///
  /// In en, this message translates to:
  /// **'PULSE'**
  String get loginAppName;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Feel Every Beat!'**
  String get loginSubtitle;

  /// No description provided for @loginMadeWithHeartBy.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ by '**
  String get loginMadeWithHeartBy;

  /// No description provided for @loginAuthorName.
  ///
  /// In en, this message translates to:
  /// **'Ashutosh Pathak'**
  String get loginAuthorName;

  /// No description provided for @loginHintName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get loginHintName;

  /// No description provided for @loginHintEmail.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get loginHintEmail;

  /// No description provided for @loginHintPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginHintPassword;

  /// No description provided for @loginErrEmailReset.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email to reset password'**
  String get loginErrEmailReset;

  /// No description provided for @loginResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent! Check your inbox.'**
  String get loginResetSent;

  /// No description provided for @loginForgotPwd.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get loginForgotPwd;

  /// No description provided for @loginBtnSignup.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get loginBtnSignup;

  /// No description provided for @loginBtnSignin.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginBtnSignin;

  /// No description provided for @loginToggleHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an Pulse account? '**
  String get loginToggleHaveAccount;

  /// No description provided for @loginToggleNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an Pulse account? '**
  String get loginToggleNoAccount;

  /// No description provided for @loginToggleSignin.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginToggleSignin;

  /// No description provided for @loginToggleSignup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get loginToggleSignup;

  /// No description provided for @offlineStillOffline.
  ///
  /// In en, this message translates to:
  /// **'Still offline. Please check your connection.'**
  String get offlineStillOffline;

  /// No description provided for @offlineTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re Offline'**
  String get offlineTitle;

  /// No description provided for @offlineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No internet connection found.\nCheck your network and try again.'**
  String get offlineSubtitle;

  /// No description provided for @offlineChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get offlineChecking;

  /// No description provided for @offlineRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get offlineRetry;

  /// No description provided for @offlineGoToDownloads.
  ///
  /// In en, this message translates to:
  /// **'Go to Downloads'**
  String get offlineGoToDownloads;

  /// No description provided for @playerMadeWithHeartBy.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ by '**
  String get playerMadeWithHeartBy;

  /// No description provided for @playerAuthorName.
  ///
  /// In en, this message translates to:
  /// **'Ashutosh Pathak'**
  String get playerAuthorName;

  /// No description provided for @playerSwipeForLyrics.
  ///
  /// In en, this message translates to:
  /// **'Swipe for lyrics'**
  String get playerSwipeForLyrics;

  /// No description provided for @playerNoLyrics.
  ///
  /// In en, this message translates to:
  /// **'No lyrics available'**
  String get playerNoLyrics;

  /// No description provided for @playerUpNext.
  ///
  /// In en, this message translates to:
  /// **'Up Next'**
  String get playerUpNext;

  /// No description provided for @playerNoTracksInQueue.
  ///
  /// In en, this message translates to:
  /// **'No tracks in queue'**
  String get playerNoTracksInQueue;

  /// No description provided for @playerNoMusicPlaying.
  ///
  /// In en, this message translates to:
  /// **'No music playing'**
  String get playerNoMusicPlaying;

  /// No description provided for @playerPickAVibe.
  ///
  /// In en, this message translates to:
  /// **'Pick a vibe from your library or home'**
  String get playerPickAVibe;

  /// No description provided for @playerGoHome.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get playerGoHome;

  /// No description provided for @playerAppName.
  ///
  /// In en, this message translates to:
  /// **'PULSE'**
  String get playerAppName;

  /// No description provided for @playerEqualizer.
  ///
  /// In en, this message translates to:
  /// **'Equalizer'**
  String get playerEqualizer;

  /// No description provided for @playerEqCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get playerEqCustom;

  /// No description provided for @playlistDownloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get playlistDownloads;

  /// No description provided for @playlistOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline Playlist'**
  String get playlistOffline;

  /// No description provided for @playlistDurationHours.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {mins}min'**
  String playlistDurationHours(String hours, String mins);

  /// No description provided for @playlistDurationMins.
  ///
  /// In en, this message translates to:
  /// **'{mins}min'**
  String playlistDurationMins(String mins);

  /// No description provided for @playlistFindOnPage.
  ///
  /// In en, this message translates to:
  /// **'Find on this page'**
  String get playlistFindOnPage;

  /// No description provided for @playlistSongsAndDuration.
  ///
  /// In en, this message translates to:
  /// **'{count} songs • {duration}'**
  String playlistSongsAndDuration(String count, String duration);

  /// No description provided for @playlistSortAlpha.
  ///
  /// In en, this message translates to:
  /// **'A-Z'**
  String get playlistSortAlpha;

  /// No description provided for @playlistSortRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get playlistSortRecent;

  /// No description provided for @playlistNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches found.'**
  String get playlistNoMatches;

  /// No description provided for @playlistNoTracks.
  ///
  /// In en, this message translates to:
  /// **'No tracks in this playlist.'**
  String get playlistNoTracks;

  /// No description provided for @playlistNoSongsYet.
  ///
  /// In en, this message translates to:
  /// **'No songs yet.'**
  String get playlistNoSongsYet;

  /// No description provided for @playlistSortRecentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently Added'**
  String get playlistSortRecentlyAdded;

  /// No description provided for @playlistSortAlphabetical.
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get playlistSortAlphabetical;

  /// No description provided for @playlistDownloadingSongs.
  ///
  /// In en, this message translates to:
  /// **'Downloading {count} {count, plural, =1{song} other{songs}}'**
  String playlistDownloadingSongs(int count);

  /// No description provided for @playlistView.
  ///
  /// In en, this message translates to:
  /// **'VIEW'**
  String get playlistView;

  /// No description provided for @playlistAllDownloaded.
  ///
  /// In en, this message translates to:
  /// **'All songs are already downloaded'**
  String get playlistAllDownloaded;

  /// No description provided for @playlistShareText.
  ///
  /// In en, this message translates to:
  /// **'Check out \"{name}\" on Pulse!\n{url}'**
  String playlistShareText(String name, String url);

  /// No description provided for @playlistRemoveFromDownloads.
  ///
  /// In en, this message translates to:
  /// **'Remove from Downloads'**
  String get playlistRemoveFromDownloads;

  /// No description provided for @playlistRemoveFromPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Remove from Playlist'**
  String get playlistRemoveFromPlaylist;

  /// No description provided for @playlistLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this playlist.'**
  String get playlistLoadError;

  /// No description provided for @playlistGoBack.
  ///
  /// In en, this message translates to:
  /// **'← Go back'**
  String get playlistGoBack;

  /// No description provided for @profileNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get profileNotLoggedIn;

  /// No description provided for @profileSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get profileSignIn;

  /// No description provided for @profileDefaultUser.
  ///
  /// In en, this message translates to:
  /// **'Pulse User'**
  String get profileDefaultUser;

  /// No description provided for @profileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditProfile;

  /// No description provided for @profileTimeframeDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get profileTimeframeDay;

  /// No description provided for @profileTimeframeWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get profileTimeframeWeek;

  /// No description provided for @profileTimeframeMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get profileTimeframeMonth;

  /// No description provided for @profileTimeframeYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get profileTimeframeYear;

  /// No description provided for @profileListeningTime.
  ///
  /// In en, this message translates to:
  /// **'LISTENING TIME'**
  String get profileListeningTime;

  /// No description provided for @profileToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get profileToday;

  /// No description provided for @profileThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get profileThisWeek;

  /// No description provided for @profileThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get profileThisMonth;

  /// No description provided for @profileThisYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get profileThisYear;

  /// No description provided for @profileDailyAvg.
  ///
  /// In en, this message translates to:
  /// **'DAILY AVG'**
  String get profileDailyAvg;

  /// No description provided for @profilePerDay.
  ///
  /// In en, this message translates to:
  /// **'Per day'**
  String get profilePerDay;

  /// No description provided for @profileLifetimeListening.
  ///
  /// In en, this message translates to:
  /// **'LIFETIME LISTENING'**
  String get profileLifetimeListening;

  /// No description provided for @profileTotalTimeListened.
  ///
  /// In en, this message translates to:
  /// **'Total time listened to music on Pulse'**
  String get profileTotalTimeListened;

  /// No description provided for @profileYourTopSongs.
  ///
  /// In en, this message translates to:
  /// **'Your Top Songs'**
  String get profileYourTopSongs;

  /// No description provided for @profileListeningHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Listening history will appear here.'**
  String get profileListeningHistoryEmpty;

  /// No description provided for @profilePlays.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{play} other{plays}}'**
  String profilePlays(int count);

  /// No description provided for @profileYourTopArtists.
  ///
  /// In en, this message translates to:
  /// **'Your Top Artists'**
  String get profileYourTopArtists;

  /// No description provided for @profileTopArtistsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your favorite artists will appear here.'**
  String get profileTopArtistsEmpty;

  /// No description provided for @profileArtistLabel.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get profileArtistLabel;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get profileSignOut;

  /// No description provided for @profileVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String profileVersion(String version);

  /// No description provided for @profileMadeWithHeartBy.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ by '**
  String get profileMadeWithHeartBy;

  /// No description provided for @profileAuthorName.
  ///
  /// In en, this message translates to:
  /// **'Ashutosh Pathak'**
  String get profileAuthorName;

  /// No description provided for @profileEditProfileHeader.
  ///
  /// In en, this message translates to:
  /// **'EDIT PROFILE'**
  String get profileEditProfileHeader;

  /// No description provided for @profileDisplayName.
  ///
  /// In en, this message translates to:
  /// **'DISPLAY NAME'**
  String get profileDisplayName;

  /// No description provided for @profileCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileCancel;

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileSave;

  /// No description provided for @profileChooseAvatar.
  ///
  /// In en, this message translates to:
  /// **'Choose Avatar'**
  String get profileChooseAvatar;

  /// No description provided for @searchMicPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission required for this feature'**
  String get searchMicPermissionRequired;

  /// No description provided for @searchUnknownSong.
  ///
  /// In en, this message translates to:
  /// **'Unknown Song'**
  String get searchUnknownSong;

  /// No description provided for @searchUnknownArtist.
  ///
  /// In en, this message translates to:
  /// **'Unknown Artist'**
  String get searchUnknownArtist;

  /// No description provided for @searchNoSongDetected.
  ///
  /// In en, this message translates to:
  /// **'No song detected.'**
  String get searchNoSongDetected;

  /// No description provided for @searchError.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String searchError(String message);

  /// No description provided for @searchSpeechNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition not available'**
  String get searchSpeechNotAvailable;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Songs, artists, albums, playlists…'**
  String get searchHint;

  /// No description provided for @searchRecentEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your recent searches appear here'**
  String get searchRecentEmpty;

  /// No description provided for @searchRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get searchRecentSearches;

  /// No description provided for @searchClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get searchClearAll;

  /// No description provided for @searchNoResultsFor.
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\"'**
  String searchNoResultsFor(String query);

  /// No description provided for @searchTryDifferentKeywords.
  ///
  /// In en, this message translates to:
  /// **'Try different keywords'**
  String get searchTryDifferentKeywords;

  /// No description provided for @searchTopResult.
  ///
  /// In en, this message translates to:
  /// **'Top result'**
  String get searchTopResult;

  /// No description provided for @searchSongsLabel.
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get searchSongsLabel;

  /// No description provided for @searchArtistsLabel.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get searchArtistsLabel;

  /// No description provided for @searchAlbumsLabel.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get searchAlbumsLabel;

  /// No description provided for @searchPlaylistsLabel.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get searchPlaylistsLabel;

  /// No description provided for @searchArtistLabel.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get searchArtistLabel;

  /// No description provided for @searchListening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get searchListening;

  /// No description provided for @searchSpeakNow.
  ///
  /// In en, this message translates to:
  /// **'Speak now to search'**
  String get searchSpeakNow;

  /// No description provided for @searchCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get searchCancel;

  /// No description provided for @searchIdentifying.
  ///
  /// In en, this message translates to:
  /// **'Identifying...'**
  String get searchIdentifying;

  /// No description provided for @searchListeningForSong.
  ///
  /// In en, this message translates to:
  /// **'Listening for a song...'**
  String get searchListeningForSong;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsStreamingQuality.
  ///
  /// In en, this message translates to:
  /// **'Streaming Quality'**
  String get settingsStreamingQuality;

  /// No description provided for @settingsQualityAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get settingsQualityAutomatic;

  /// No description provided for @settingsQualityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get settingsQualityLow;

  /// No description provided for @settingsQualityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get settingsQualityNormal;

  /// No description provided for @settingsQualityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get settingsQualityHigh;

  /// No description provided for @settingsDownloadQuality.
  ///
  /// In en, this message translates to:
  /// **'Download Quality'**
  String get settingsDownloadQuality;

  /// No description provided for @settingsPlayback.
  ///
  /// In en, this message translates to:
  /// **'Playback'**
  String get settingsPlayback;

  /// No description provided for @settingsCrossfade.
  ///
  /// In en, this message translates to:
  /// **'Crossfade'**
  String get settingsCrossfade;

  /// No description provided for @settingsCrossfadeDesc.
  ///
  /// In en, this message translates to:
  /// **'Overlap tracks for gapless transitions'**
  String get settingsCrossfadeDesc;

  /// No description provided for @settingsDataUsage.
  ///
  /// In en, this message translates to:
  /// **'Data Usage'**
  String get settingsDataUsage;

  /// No description provided for @settingsDataSaver.
  ///
  /// In en, this message translates to:
  /// **'Data Saver'**
  String get settingsDataSaver;

  /// No description provided for @settingsDataSaverDesc.
  ///
  /// In en, this message translates to:
  /// **'Stream at lower quality over cellular'**
  String get settingsDataSaverDesc;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsCustomAccent.
  ///
  /// In en, this message translates to:
  /// **'Custom Accent'**
  String get settingsCustomAccent;

  /// No description provided for @settingsSaturation.
  ///
  /// In en, this message translates to:
  /// **'Saturation'**
  String get settingsSaturation;

  /// No description provided for @settingsBrightness.
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get settingsBrightness;

  /// No description provided for @settingsResetDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset Default'**
  String get settingsResetDefault;

  /// No description provided for @playlistSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add to Playlist'**
  String get playlistSheetTitle;

  /// No description provided for @playlistSheetNewPlaylist.
  ///
  /// In en, this message translates to:
  /// **'New Playlist'**
  String get playlistSheetNewPlaylist;

  /// No description provided for @playlistSheetNoPlaylists.
  ///
  /// In en, this message translates to:
  /// **'No playlists yet'**
  String get playlistSheetNoPlaylists;

  /// No description provided for @playlistSheetSongsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{song} other{songs}}'**
  String playlistSheetSongsCount(int count);

  /// No description provided for @playlistSheetNameHint.
  ///
  /// In en, this message translates to:
  /// **'Playlist Name'**
  String get playlistSheetNameHint;

  /// No description provided for @playlistSheetCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get playlistSheetCancel;

  /// No description provided for @playlistSheetAddedTo.
  ///
  /// In en, this message translates to:
  /// **'Added to {name}'**
  String playlistSheetAddedTo(String name);

  /// No description provided for @playlistSheetCreateFailAuth.
  ///
  /// In en, this message translates to:
  /// **'Failed to create playlist: Authentication error'**
  String get playlistSheetCreateFailAuth;

  /// No description provided for @playlistSheetCreateFail.
  ///
  /// In en, this message translates to:
  /// **'Failed to create playlist: {error}'**
  String playlistSheetCreateFail(String error);

  /// No description provided for @playlistSheetCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get playlistSheetCreate;

  /// No description provided for @appUpdateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get appUpdateAvailable;

  /// No description provided for @appUpdateDesc.
  ///
  /// In en, this message translates to:
  /// **'Version {version} is here! Update now to get the latest features.'**
  String appUpdateDesc(String version);

  /// No description provided for @appUpdateDownload.
  ///
  /// In en, this message translates to:
  /// **'Download Update'**
  String get appUpdateDownload;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @artistSelect.
  ///
  /// In en, this message translates to:
  /// **'Select Artist'**
  String get artistSelect;

  /// No description provided for @songActionQueue.
  ///
  /// In en, this message translates to:
  /// **'Add to Queue'**
  String get songActionQueue;

  /// No description provided for @songActionPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Add to Playlist'**
  String get songActionPlaylist;

  /// No description provided for @songActionFinding.
  ///
  /// In en, this message translates to:
  /// **'Finding...'**
  String get songActionFinding;

  /// No description provided for @songActionAlbum.
  ///
  /// In en, this message translates to:
  /// **'Go to Album'**
  String get songActionAlbum;

  /// No description provided for @songActionArtist.
  ///
  /// In en, this message translates to:
  /// **'Go to Artist'**
  String get songActionArtist;

  /// No description provided for @songActionRemovePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Remove from Playlist'**
  String get songActionRemovePlaylist;

  /// No description provided for @songActionRemoveDownload.
  ///
  /// In en, this message translates to:
  /// **'Remove from Downloads'**
  String get songActionRemoveDownload;

  /// No description provided for @songActionDownloadChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get songActionDownloadChecking;

  /// No description provided for @songActionDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get songActionDownloading;

  /// No description provided for @songActionDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Downloaded!'**
  String get songActionDownloaded;

  /// No description provided for @songActionDownloadAlready.
  ///
  /// In en, this message translates to:
  /// **'Already downloaded'**
  String get songActionDownloadAlready;

  /// No description provided for @songActionDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get songActionDownloadFailed;

  /// No description provided for @songActionDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get songActionDownload;

  /// No description provided for @songActionDownloadingSnack.
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get songActionDownloadingSnack;

  /// No description provided for @songActionView.
  ///
  /// In en, this message translates to:
  /// **'VIEW'**
  String get songActionView;

  /// No description provided for @spotifyImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import from Spotify'**
  String get spotifyImportTitle;

  /// No description provided for @spotifyImportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your playlist size'**
  String get spotifyImportSubtitle;

  /// No description provided for @spotifyChoiceSmallTitle.
  ///
  /// In en, this message translates to:
  /// **'100 songs or fewer'**
  String get spotifyChoiceSmallTitle;

  /// No description provided for @spotifyChoiceSmallDesc.
  ///
  /// In en, this message translates to:
  /// **'Paste a public Spotify playlist URL.'**
  String get spotifyChoiceSmallDesc;

  /// No description provided for @spotifyChoiceLargeTitle.
  ///
  /// In en, this message translates to:
  /// **'More than 100 songs'**
  String get spotifyChoiceLargeTitle;

  /// No description provided for @spotifyChoiceLargeDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect your own Spotify Developer App to import unlimited tracks.'**
  String get spotifyChoiceLargeDesc;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @spotifyPlaylistsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Spotify Playlists'**
  String get spotifyPlaylistsTitle;

  /// No description provided for @spotifyPlaylistsErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}\nMake sure your Client ID is valid.'**
  String spotifyPlaylistsErrorMsg(String error);

  /// No description provided for @spotifyPlaylistsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No playlists found in your library'**
  String get spotifyPlaylistsEmpty;

  /// No description provided for @spotifyPlaylistsTracks.
  ///
  /// In en, this message translates to:
  /// **'{count} tracks'**
  String spotifyPlaylistsTracks(String count);

  /// No description provided for @spotifyPlaylistsImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get spotifyPlaylistsImport;

  /// No description provided for @audioPlaybackFailed.
  ///
  /// In en, this message translates to:
  /// **'Playback failed. Check your internet connection.'**
  String get audioPlaybackFailed;

  /// No description provided for @audioControlPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get audioControlPrevious;

  /// No description provided for @audioControlPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get audioControlPause;

  /// No description provided for @audioControlPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get audioControlPlay;

  /// No description provided for @audioControlNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get audioControlNext;

  /// No description provided for @audioControlUnlike.
  ///
  /// In en, this message translates to:
  /// **'Unlike'**
  String get audioControlUnlike;

  /// No description provided for @audioControlLike.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get audioControlLike;

  /// No description provided for @spotifyRawResponseError.
  ///
  /// In en, this message translates to:
  /// **'Raw response: {data}\n\nFallback: {error}'**
  String spotifyRawResponseError(String data, String error);

  /// No description provided for @apiErrorInvalidClient.
  ///
  /// In en, this message translates to:
  /// **'Invalid client or client secret.'**
  String get apiErrorInvalidClient;

  /// No description provided for @apiErrorBadRequest.
  ///
  /// In en, this message translates to:
  /// **'Bad Request. Please check your inputs.'**
  String get apiErrorBadRequest;

  /// No description provided for @apiErrorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized. Please log in again.'**
  String get apiErrorUnauthorized;

  /// No description provided for @apiErrorForbidden.
  ///
  /// In en, this message translates to:
  /// **'Forbidden. You do not have access.'**
  String get apiErrorForbidden;

  /// No description provided for @apiErrorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Resource not found.'**
  String get apiErrorNotFound;

  /// No description provided for @apiErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email address is already in use.'**
  String get apiErrorEmailInUse;

  /// No description provided for @apiErrorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email.'**
  String get apiErrorUserNotFound;

  /// No description provided for @apiErrorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get apiErrorWrongPassword;

  /// No description provided for @apiErrorInvalidCredential.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials.'**
  String get apiErrorInvalidCredential;

  /// No description provided for @apiErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get apiErrorNetwork;

  /// No description provided for @apiErrorSocketTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out. Please try again.'**
  String get apiErrorSocketTimeout;

  /// No description provided for @apiErrorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a moment and try again.'**
  String get apiErrorTooManyRequests;

  /// No description provided for @apiErrorServerError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get apiErrorServerError;

  /// No description provided for @apiErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get apiErrorInvalidEmail;

  /// No description provided for @apiErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Use at least 6 characters.'**
  String get apiErrorWeakPassword;

  /// No description provided for @apiErrorTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many failed attempts. Please try again later.'**
  String get apiErrorTooManyAttempts;

  /// No description provided for @homeForgottenFavorites.
  ///
  /// In en, this message translates to:
  /// **'Forgotten Favourites'**
  String get homeForgottenFavorites;

  /// No description provided for @artistShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get artistShowAll;

  /// No description provided for @homeTopTracks.
  ///
  /// In en, this message translates to:
  /// **'Top tracks'**
  String get homeTopTracks;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'af',
    'ar',
    'as',
    'bn',
    'de',
    'en',
    'es',
    'fr',
    'gu',
    'hi',
    'id',
    'it',
    'ja',
    'kn',
    'ko',
    'mai',
    'ml',
    'mr',
    'ne',
    'or',
    'pa',
    'pt',
    'ru',
    'sa',
    'ta',
    'te',
    'tr',
    'ur',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'af':
      return AppLocalizationsAf();
    case 'ar':
      return AppLocalizationsAr();
    case 'as':
      return AppLocalizationsAs();
    case 'bn':
      return AppLocalizationsBn();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'kn':
      return AppLocalizationsKn();
    case 'ko':
      return AppLocalizationsKo();
    case 'mai':
      return AppLocalizationsMai();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'ne':
      return AppLocalizationsNe();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'sa':
      return AppLocalizationsSa();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'tr':
      return AppLocalizationsTr();
    case 'ur':
      return AppLocalizationsUr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
