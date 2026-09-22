// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'ಬಗ್ಗೆ';

  @override
  String get artistPopular => 'ಜನಪ್ರಿಯ';

  @override
  String get artistAlbums => 'ಆಲ್ಬಮ್‌ಗಳು';

  @override
  String get artistSinglesAndEPs => 'ಸಿಂಗಲ್ಸ್ ಮತ್ತು ಇಪಿ';

  @override
  String artistSubscribersCount(String count) {
    return '$count ಚಂದಾದಾರರು';
  }

  @override
  String get artistPlayAll => 'ಎಲ್ಲಾ ಪ್ಲೇ ಮಾಡಿ';

  @override
  String get artistLoadError => 'ಕಲಾವಿದರನ್ನು ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get artistGoBack => 'ಹಿಂದೆ ಹೋಗಿ';

  @override
  String adminChatFailedToReply(String error) {
    return 'ಪ್ರತಿಕ್ರಿಯಿಸಲು ವಿಫಲವಾಗಿದೆ: $error';
  }

  @override
  String get adminChatSupportChat => 'ಬೆಂಬಲ ಚಾಟ್';

  @override
  String adminChatError(String error) {
    return 'ದೋಷ: $error';
  }

  @override
  String get adminChatNoHistory => 'ಹಿಂದಿನ ಯಾವುದೇ ಸಂಭಾಷಣೆಗಳಿಲ್ಲ.';

  @override
  String get adminChatSupportYou => 'ಬೆಂಬಲ (ನೀವು)';

  @override
  String get adminChatTypeReply => 'ನಿಮ್ಮ ಪ್ರತ್ಯುತ್ತರ ಟೈಪ್ ಮಾಡಿ...';

  @override
  String get broadcastSuccess => 'ಪ್ರಕಟಣೆಯನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಪ್ರಸಾರ ಮಾಡಲಾಗಿದೆ!';

  @override
  String broadcastFailed(String error) {
    return 'ಪ್ರಸಾರ ಮಾಡಲು ವಿಫಲವಾಗಿದೆ: $error';
  }

  @override
  String get broadcastTitle => 'ಜಾಗತಿಕ ಪ್ರಕಟಣೆಗಳು';

  @override
  String get broadcastSubtitle => 'ಎಲ್ಲಾ ಬಳಕೆದಾರರಿಗೆ ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String get broadcastWarning =>
      'ಇಲ್ಲಿ ಕಳುಹಿಸುವ ಸಂದೇಶಗಳು ಎಲ್ಲರಿಗೂ ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String broadcastError(String error) {
    return 'ದೋಷ: $error';
  }

  @override
  String get broadcastNoHistory => 'ಹಿಂದಿನ ಯಾವುದೇ ಪ್ರಕಟಣೆಗಳಿಲ್ಲ.';

  @override
  String get broadcastTypeMessage => 'ಜಾಗತಿಕ ಪ್ರಕಟಣೆಯನ್ನು ಟೈಪ್ ಮಾಡಿ...';

  @override
  String commFailedToSend(String error) {
    return 'ಕಳುಹಿಸಲು ವಿಫಲವಾಗಿದೆ: $error';
  }

  @override
  String get commAdminDashboard => 'ಅಡ್ಮಿನ್ ಡ್ಯಾಶ್‌ಬೋರ್ಡ್';

  @override
  String get commAdminSupport => 'ಅಡ್ಮಿನ್ ಬೆಂಬಲ';

  @override
  String get commAlwaysHere => 'ಸಹಾಯ ಮಾಡಲು ಸದಾ ಸಿದ್ಧ';

  @override
  String get commWelcomeTitle => 'ನಮಸ್ಕಾರ! 👋 ನಾನು ಅಶುತೋಷ್ ಪಾಠಕ್';

  @override
  String get commWelcomeSubtitle => 'Pulse ಡೆವಲಪರ್';

  @override
  String get commWelcomeBody1 =>
      'ಜಾಹೀರಾತುಗಳು ಅಥವಾ ಚಂದಾದಾರಿಕೆ ತಡೆಗಳಿಲ್ಲದೆ ನಿಮ್ಮ ನೆಚ್ಚಿನ ಸಂಗೀತವನ್ನು ಆನಂದಿಸುತ್ತಿದ್ದೀರಿ ಎಂದು ಭಾವಿಸುತ್ತೇನೆ. ಸಂಗೀತವು ಕೇವಲ ಶ್ರೀಮಂತರಿಗೆ ಮಾತ್ರ ಸೀಮಿತವಾಗಿರಬಾರದು.\n\nನಾವು ನೇರವಾಗಿ ಸಂಪರ್ಕಿಸಲು ಈ ವಿಭಾಗವಿದೆ.\n\nನಿಮ್ಮ ಸಲಹೆಗಳು ಮುಕ್ತವಾಗಿವೆ:';

  @override
  String get commBullet1 => 'ನಿಮ್ಮ ಪ್ರತಿಕ್ರಿಯೆ ನೀಡಿ';

  @override
  String get commBullet2 => 'ದೋಷಗಳನ್ನು ವರದಿ ಮಾಡಿ';

  @override
  String get commBullet3 => 'ಹೊಸ ವೈಶಿಷ್ಟ್ಯಗಳನ್ನು ಸೂಚಿಸಿ';

  @override
  String get commWelcomeBody2 =>
      'ಪ್ರತಿ ಸಂದೇಶವನ್ನು ನಾನೇ ಓದುತ್ತೇನೆ ಮತ್ತು ನಿಮ್ಮ ಸಲಹೆಗಳೊಂದಿಗೆ ಅಪ್ಲಿಕೇಶನ್ ಅನ್ನು ಸುಧಾರಿಸುತ್ತೇನೆ.\n\nಚಂದಾದಾರಿಕೆಗಳಲ್ಲಿ ಸಿಲುಕಿರುವ ಹೊಸ ಅಪ್ಲಿಕೇಶನ್ ಕಲ್ಪನೆ ನಿಮ್ಮಲ್ಲಿದೆಯೇ? ನನಗೆ ತಿಳಿಸಿ! ಸಾಧ್ಯವಾದರೆ ನಾನು ಅದನ್ನು ನಿರ್ಮಿಸಿ ಎಲ್ಲರಿಗೂ ನೀಡುತ್ತೇನೆ.\n\nಈ ಪಯಣದಲ್ಲಿ ಜೊತೆಯಾಗಿರುವುದಕ್ಕೆ ಧನ್ಯವಾದಗಳು. ❤️';

  @override
  String commError(String error) {
    return 'ದೋಷ: $error';
  }

  @override
  String get commNoMessages => 'ಇನ್ನೂ ಯಾವುದೇ ಸಂದೇಶಗಳಿಲ್ಲ';

  @override
  String get commNoMessagesDesc =>
      'ನಮ್ಮ ಬೆಂಬಲ ತಂಡಕ್ಕೆ ಸಂದೇಶ ಕಳುಹಿಸಿ ಅಥವಾ ನಂತರ ಮತ್ತೆ ಪರಿಶೀಲಿಸಿ.';

  @override
  String get commMessageSupportHint => 'ಬೆಂಬಲ ತಂಡಕ್ಕೆ ಬರೆಯಿರಿ...';

  @override
  String get commGlobalAnnouncements => 'ಜಾಗತಿಕ ಪ್ರಕಟಣೆಗಳು';

  @override
  String get commSendMessagesToAll => 'ಎಲ್ಲಾ ಬಳಕೆದಾರರಿಗೆ ಕಳುಹಿಸಿ';

  @override
  String get homeGreetingMorning => 'ಶುಭೋದಯ,';

  @override
  String get homeGreetingAfternoon => 'ಶುಭ ಮಧ್ಯಾಹ್ನ,';

  @override
  String get homeGreetingEvening => 'ಶುಭ ಸಂಜೆ,';

  @override
  String get homeMember => 'ಸದಸ್ಯ';

  @override
  String get homeRecentPlaylists => 'ಇತ್ತೀಚಿನ ಪ್ಲೇಪಟ್ಟಿಗಳು';

  @override
  String get homeRecentlyPlayed => 'ಇತ್ತೀಚೆಗೆ ಪ್ಲೇ ಮಾಡಿದವು';

  @override
  String get homeSpeedDial => 'ವೇಗದ ಡಯಲ್';

  @override
  String get homeNoContent => 'ಯಾವುದೇ ವಿಷಯವಿಲ್ಲ';

  @override
  String get homeRefresh => 'ರಿಫ್ರೆಶ್';

  @override
  String get homeLoadError => 'ಸಂಗೀತ ಫೀಡ್ ಲೋಡ್ ಮಾಡಲು ವಿಫಲವಾಗಿದೆ.';

  @override
  String get homeRetry => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get importSuccess => 'Spotify ಯಶಸ್ವಿಯಾಗಿ ಸಂಪರ್ಕಗೊಂಡಿದೆ!';

  @override
  String importFailed(String error) {
    return 'ಸಂಪರ್ಕಿಸಲು ವಿಫಲವಾಗಿದೆ: $error';
  }

  @override
  String get importTitle => 'Spotify ಸಂಪರ್ಕಿಸಿ';

  @override
  String get importSetupTitle => 'Spotify ಸೆಟಪ್';

  @override
  String get importSetupDesc =>
      'Spotify ಮಿತಿಗಳನ್ನು ತಪ್ಪಿಸಿ ನಿಮ್ಮ ಪ್ಲೇಪಟ್ಟಿಗಳನ್ನು ವೇಗವಾಗಿ ಆಮದು ಮಾಡಲು ನಿಮ್ಮ ಡೆವಲಪರ್ ಕೀ ಬಳಸಿ. ಈ ಹಂತಗಳನ್ನು ಅನುಸರಿಸಿ:';

  @override
  String get importStep1 => 'Spotify Developer Dashboard ತೆರೆಯಿರಿ.';

  @override
  String get importStep2 => 'ಲಾಗಿನ್ ಮಾಡಿ ಮತ್ತು \"Create app\" ಕ್ಲಿಕ್ ಮಾಡಿ.';

  @override
  String get importStep3 => 'ಅಪ್ಲಿಕೇಶನ್ ಹೆಸರು ಮತ್ತು ವಿವರಣೆ ನೀಡಿ.';

  @override
  String get importStep4 => '\"Redirect URIs\" ಕೆಳಗೆ ಈ URL ಅನ್ನು ಅಂಟಿಸಿ:';

  @override
  String get importRedirectCopied => 'ಮರುನಿರ್ದೇಶನ URI ನಕಲಿಸಲಾಗಿದೆ!';

  @override
  String get importStep5 =>
      'ಅಪ್ಲಿಕೇಶನ್ ಉಳಿಸಿ, ಸೆಟ್ಟಿಂಗ್‌ಗಳಿಂದ ನಿಮ್ಮ \"Client ID\" ನಕಲಿಸಿ ಕೆಳಗೆ ಅಂಟಿಸಿ.';

  @override
  String get importImportant =>
      'ಪ್ರಮುಖ: ಈ ಡೆವಲಪರ್ ಅಪ್ಲಿಕೇಶನ್ ರಚಿಸಲು ಬಳಸುವ Spotify ಖಾತೆಗೆ ಸಕ್ರಿಯ ಪ್ರೀಮಿಯಂ ಚಂದಾದಾರಿಕೆ ಇರಬೇಕು.';

  @override
  String get importClientIdHint => 'ನಿಮ್ಮ Spotify Client ID ಇಲ್ಲಿ ಅಂಟಿಸಿ...';

  @override
  String get importConnectButton => 'ಸಂಪರ್ಕಿಸಿ & ಲೈಬ್ರರಿ ಲೋಡ್ ಮಾಡಿ';

  @override
  String get downloadingNoActive => 'ಯಾವುದೇ ಸಕ್ರಿಯ ಡೌನ್‌ಲೋಡ್‌ಗಳಿಲ್ಲ';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'ಡೌನ್‌ಲೋಡ್‌ಗಳು';

  @override
  String downloadsStats(String count, String size) {
    return '$count ಹಾಡುಗಳು • $size';
  }

  @override
  String get downloadsNoOffline => 'ಆಫ್‌ಲೈನ್ ಹಾಡುಗಳಿಲ್ಲ';

  @override
  String get downloadsNoOfflineDesc =>
      'ನೀವು ಡೌನ್‌ಲೋಡ್ ಮಾಡಿದ ಹಾಡುಗಳು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ';

  @override
  String get downloadsClearAllTitle => 'ಎಲ್ಲವನ್ನೂ ಅಳಿಸಬೇಕೆ?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'ಇದು $count ಹಾಡುಗಳನ್ನು ಅಳಿಸುತ್ತದೆ ಮತ್ತು $size ಜಾಗವನ್ನು ಖಾಲಿ ಮಾಡುತ್ತದೆ.';
  }

  @override
  String get downloadsCancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String get downloadsClearAll => 'ಎಲ್ಲವನ್ನೂ ಅಳಿಸಿ';

  @override
  String downloadsSongsCount(String count) {
    return '$count ಹಾಡುಗಳು';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count ಹಾಡು';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'ಮುಖ್ಯ ಡೌನ್‌ಲೋಡ್ ಪ್ಲೇಪಟ್ಟಿಯನ್ನು ಮರುಹೆಸರಿಸಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get downloadsRename => 'ಮರುಹೆಸರಿಸಿ';

  @override
  String get downloadsEditSongs => 'ಹಾಡುಗಳನ್ನು ಎಡಿಟ್ ಮಾಡಿ';

  @override
  String get downloadsDelete => 'ಅಳಿಸಿ';

  @override
  String get downloadsRenamePlaylistTitle => 'ಪ್ಲೇಪಟ್ಟಿ ಮರುಹೆಸರಿಸಿ';

  @override
  String get downloadsRenamePlaylistDesc => 'ಪ್ಲೇಪಟ್ಟಿಗೆ ಹೊಸ ಹೆಸರನ್ನು ನೀಡಿ.';

  @override
  String get downloadsDeletePlaylistTitle => 'ಪ್ಲೇಪಟ್ಟಿ ಅಳಿಸಬೇಕೆ?';

  @override
  String get downloadsDeleteMasterDesc =>
      'ನೀವು ಖಚಿತವೇ? ನೀವು ಡೌನ್‌ಲೋಡ್ ಮಾಡಿದ ಎಲ್ಲಾ ಹಾಡುಗಳು ಮತ್ತು ಪ್ಲೇಪಟ್ಟಿಗಳನ್ನು ಶಾಶ್ವತವಾಗಿ ಕಳೆದುಕೊಳ್ಳುತ್ತೀರಿ.';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return '\"$name\" ಅನ್ನು ಅಳಿಸಲು ನೀವು ಖಚಿತವೇ? ಈ ಪ್ಲೇಪಟ್ಟಿ ಶಾಶ್ವತವಾಗಿ ಅಳಿಸಲ್ಪಡುತ್ತದೆ.';
  }

  @override
  String get downloadsSave => 'ಉಳಿಸಿ';

  @override
  String get downloadsNoSongs => 'ಈ ಪ್ಲೇಪಟ್ಟಿಯಲ್ಲಿ ಯಾವುದೇ ಹಾಡುಗಳಿಲ್ಲ.';

  @override
  String get libraryTitle => 'ಲೈಬ್ರರಿ';

  @override
  String get libraryPauseAll => 'ಎಲ್ಲವನ್ನೂ ವಿರಾಮಗೊಳಿಸಿ';

  @override
  String get libraryResumeAll => 'ಎಲ್ಲವನ್ನೂ ಪುನರಾರಂಭಿಸಿ';

  @override
  String get libraryTabPlaylists => 'ಪ್ಲೇಪಟ್ಟಿಗಳು';

  @override
  String get libraryTabDownloads => 'ಡೌನ್‌ಲೋಡ್‌ಗಳು';

  @override
  String get libraryTabDownloading => 'ಡೌನ್‌ಲೋಡ್ ಆಗುತ್ತಿದೆ';

  @override
  String libraryImportedTask(String name) {
    return '$name ಆಮದು ಮಾಡಲಾಗಿದೆ';
  }

  @override
  String get libraryImportWaiting => 'ಕಾಯಲಾಗುತ್ತಿದೆ...';

  @override
  String get libraryImportFetching => 'ಪ್ಲೇಪಟ್ಟಿ ತರಲಾಗುತ್ತಿದೆ...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total ಪ್ರಕ್ರಿಯೆಗೊಳಿಸಲಾಗಿದೆ · $matched ಹೊಂದಿಕೆಯಾಗಿದೆ';
  }

  @override
  String get libraryImportSaving => 'ಲೈಬ್ರರಿಗೆ ಉಳಿಸಲಾಗುತ್ತಿದೆ...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched ಹಾಡುಗಳನ್ನು ಸೇರಿಸಲಾಗಿದೆ · ಮುಚ್ಚಲು × ಒತ್ತಿರಿ';
  }

  @override
  String get libraryImportDoneAll =>
      'ಎಲ್ಲಾ ಹಾಡುಗಳನ್ನು ಸೇರಿಸಲಾಗಿದೆ · ಮುಚ್ಚಲು × ಒತ್ತಿರಿ';

  @override
  String get libraryAddButton => 'ಸೇರಿಸಿ';

  @override
  String get librarySortRecent => 'ಇತ್ತೀಚಿನದು';

  @override
  String get librarySortAlpha => 'ಅಕ್ಷರಮಾಲೆ';

  @override
  String get libraryEmptyTitle => 'ನಿಮ್ಮ ಲೈಬ್ರರಿ ಖಾಲಿಯಾಗಿದೆ.';

  @override
  String get libraryEmptyDesc =>
      'ನಿಮ್ಮ ಮೊದಲ Pulse ಪ್ರಾರಂಭಿಸಲು \"ಸೇರಿಸಿ\" ಒತ್ತಿರಿ.';

  @override
  String get libraryRenameLikedError =>
      'Liked Songs ಪ್ಲೇಪಟ್ಟಿಯನ್ನು ಮರುಹೆಸರಿಸಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get libraryRename => 'ಮರುಹೆಸರಿಸಿ';

  @override
  String get libraryEditSongs => 'ಹಾಡುಗಳನ್ನು ಎಡಿಟ್ ಮಾಡಿ';

  @override
  String get libraryDeleteLikedError =>
      'Liked Songs ಪ್ಲೇಪಟ್ಟಿಯನ್ನು ಅಳಿಸಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get libraryDelete => 'ಅಳಿಸಿ';

  @override
  String get libraryEditSongsTitle => 'ಹಾಡುಗಳನ್ನು ಎಡಿಟ್ ಮಾಡಿ';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count ಹಾಡು';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count ಹಾಡುಗಳು';
  }

  @override
  String get libraryCancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String get librarySave => 'ಉಳಿಸಿ';

  @override
  String get libraryNoSongs => 'ಈ ಪ್ಲೇಪಟ್ಟಿಯಲ್ಲಿ ಯಾವುದೇ ಹಾಡುಗಳಿಲ್ಲ.';

  @override
  String get libraryAddOptionsTitle => 'ಲೈಬ್ರರಿಗೆ ಸೇರಿಸಿ';

  @override
  String get libraryAddOptionsDesc =>
      'ನಿಮ್ಮ Pulse ಲೈಬ್ರರಿಯನ್ನು ಹೇಗೆ ವಿಸ್ತರಿಸುವುದು ಎಂದು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get libraryImportPulse => 'Pulse ನಿಂದ ಆಮದು ಮಾಡಿ';

  @override
  String get libraryImportPulseDesc => 'Pulse ಪ್ಲೇಪಟ್ಟಿ URL ಅಂಟಿಸಿ';

  @override
  String get libraryImportYtm => 'YT Music ನಿಂದ ಆಮದು ಮಾಡಿ';

  @override
  String get libraryImportYtmDesc => 'ಸಾರ್ವಜನಿಕ ಪ್ಲೇಪಟ್ಟಿ URL ಅಂಟಿಸಿ';

  @override
  String get libraryImportSpotify => 'Spotify ನಿಂದ ಆಮದು ಮಾಡಿ';

  @override
  String get libraryImportSpotifyDesc => 'Spotify ಸಂಪರ್ಕಿಸಿ';

  @override
  String get libraryClose => 'ಮುಚ್ಚಿ';

  @override
  String get libraryImportYtmFull => 'YouTube Music ನಿಂದ ಆಮದು ಮಾಡಿ';

  @override
  String get libraryImportSpotifyFull => 'Spotify ನಿಂದ ಆಮದು ಮಾಡಿ (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'ಸಾರ್ವಜನಿಕ YouTube Music ಪ್ಲೇಪಟ್ಟಿ ಅಥವಾ ಆಲ್ಬಮ್ URL ಅಂಟಿಸಿ';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'ಸಾರ್ವಜನಿಕ Spotify ಪ್ಲೇಪಟ್ಟಿ URL ಕೆಳಗೆ ಅಂಟಿಸಿ';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Pulse ಪ್ಲೇಪಟ್ಟಿ ಆಮದು ಮಾಡಲು ವಿಫಲವಾಗಿದೆ';

  @override
  String get importErrorPlaylist => 'ಪ್ಲೇಪಟ್ಟಿ ಆಮದು ಮಾಡುವಾಗ ದೋಷ';

  @override
  String get importErrorHighlyPopulated =>
      'ಪ್ಲೇಪಟ್ಟಿ ತುಂಬಾ ದೊಡ್ಡದಾಗಿದೆ, ತರಲು ಸ್ವಲ್ಪ ಸಮಯ ತೆಗೆದುಕೊಳ್ಳಬಹುದು.';

  @override
  String get libraryImportBtn => 'ಆಮದು ಮಾಡಿ';

  @override
  String get libraryCreateTitle => 'ಹೊಸ ಪ್ಲೇಪಟ್ಟಿ';

  @override
  String get libraryCreateDesc => 'ನಿಮ್ಮ ಹೊಸ ಪ್ಲೇಪಟ್ಟಿಗೆ ಏನು ಹೆಸರಿಸೋಣ?';

  @override
  String get libraryCreateHint => 'ಉದಾ. Midnight Rides';

  @override
  String get libraryCreateBtn => 'ರಚಿಸಿ';

  @override
  String get libraryRenameTitle => 'ಪ್ಲೇಪಟ್ಟಿ ಮರುಹೆಸರಿಸಿ';

  @override
  String get libraryRenameDesc => 'ಪ್ಲೇಪಟ್ಟಿಗೆ ಹೊಸ ಹೆಸರನ್ನು ನೀಡಿ.';

  @override
  String get libraryRenameBtn => 'ಮರುಹೆಸರಿಸಿ';

  @override
  String get libraryDeleteTitle => 'ಪ್ಲೇಪಟ್ಟಿ ಅಳಿಸಬೇಕೆ?';

  @override
  String libraryDeleteDesc(String name) {
    return '\"$name\" ಅನ್ನು ಅಳಿಸಲು ನೀವು ಖಚಿತವೇ? ಈ ಪ್ಲೇಪಟ್ಟಿ ಶಾಶ್ವತವಾಗಿ ಅಳಿಸಲ್ಪಡುತ್ತದೆ.';
  }

  @override
  String get libraryDeleteBtn => 'ಅಳಿಸಿ';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'ಇತ್ತೀಚಿನದು';

  @override
  String librarySongsCount(String count) {
    return '$count ಹಾಡುಗಳು';
  }

  @override
  String get libraryComingSoon => 'ಶೀಘ್ರದಲ್ಲೇ ಬರಲಿದೆ';

  @override
  String get loginErrName => 'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಹೆಸರನ್ನು ನಮೂದಿಸಿ';

  @override
  String get loginErrEmail => 'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಇಮೇಲ್ ನಮೂದಿಸಿ';

  @override
  String get loginErrPassword => 'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಪಾಸ್‌ವರ್ಡ್ ನಮೂದಿಸಿ';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'ಪ್ರತಿ ಬೀಟ್ ಅನ್ನು ಅನುಭವಿಸಿ!';

  @override
  String get loginMadeWithHeartBy => 'ಪ್ರೀತಿಯಿಂದ ರಚಿಸಿದವರು: ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'ನಿಮ್ಮ ಹೆಸರು';

  @override
  String get loginHintEmail => 'ಇಮೇಲ್ ವಿಳಾಸ';

  @override
  String get loginHintPassword => 'ಪಾಸ್‌ವರ್ಡ್';

  @override
  String get loginErrEmailReset => 'ಪಾಸ್‌ವರ್ಡ್ ಮರುಹೊಂದಿಸಲು ಇಮೇಲ್ ನಮೂದಿಸಿ';

  @override
  String get loginResetSent =>
      'ಮರುಹೊಂದಿಸುವ ಇಮೇಲ್ ಕಳುಹಿಸಲಾಗಿದೆ! ಇನ್‌ಬಾಕ್ಸ್ ಪರಿಶೀಲಿಸಿ.';

  @override
  String get loginForgotPwd => 'ಪಾಸ್‌ವರ್ಡ್ ಮರೆತಿರಾ?';

  @override
  String get loginBtnSignup => 'ಖಾತೆ ರಚಿಸಿ';

  @override
  String get loginBtnSignin => 'ಸೈನ್ ಇನ್';

  @override
  String get loginToggleHaveAccount => 'ಈಗಾಗಲೇ Pulse ಖಾತೆ ಇದೆಯೇ? ';

  @override
  String get loginToggleNoAccount => 'Pulse ಖಾತೆ ಇಲ್ಲವೇ? ';

  @override
  String get loginToggleSignin => 'ಸೈನ್ ಇನ್';

  @override
  String get loginToggleSignup => 'ಸೈನ್ ಅಪ್';

  @override
  String get offlineStillOffline =>
      'ಇನ್ನೂ ಆಫ್‌ಲೈನ್‌ನಲ್ಲಿದ್ದೀರಿ. ನಿಮ್ಮ ಸಂಪರ್ಕ ಪರಿಶೀಲಿಸಿ.';

  @override
  String get offlineTitle => 'ನೀವು ಆಫ್‌ಲೈನ್‌ನಲ್ಲಿದ್ದೀರಿ';

  @override
  String get offlineSubtitle =>
      'ಇಂಟರ್ನೆಟ್ ಸಂಪರ್ಕವಿಲ್ಲ.\nನೆಟ್‌ವರ್ಕ್ ಪರಿಶೀಲಿಸಿ ಮತ್ತು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get offlineChecking => 'ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ...';

  @override
  String get offlineRetry => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get offlineGoToDownloads => 'ಡೌನ್‌ಲೋಡ್‌ಗಳಿಗೆ ಹೋಗಿ';

  @override
  String get playerMadeWithHeartBy => 'ಪ್ರೀತಿಯಿಂದ ರಚಿಸಿದವರು: ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'ಸಾಹಿತ್ಯಕ್ಕಾಗಿ ಸ್ವೈಪ್ ಮಾಡಿ';

  @override
  String get playerNoLyrics => 'ಸಾಹಿತ್ಯ ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get playerUpNext => 'ಮುಂದಿನದು';

  @override
  String get playerNoTracksInQueue => 'ಕ್ಯೂನಲ್ಲಿ ಯಾವುದೇ ಹಾಡುಗಳಿಲ್ಲ';

  @override
  String get playerNoMusicPlaying => 'ಯಾವುದೇ ಸಂಗೀತ ಪ್ಲೇ ಆಗುತ್ತಿಲ್ಲ';

  @override
  String get playerPickAVibe =>
      'ನಿಮ್ಮ ಲೈಬ್ರರಿ ಅಥವಾ ಹೋಮ್‌ನಿಂದ ಹಾಡನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get playerGoHome => 'ಹೋಮ್‌ಗೆ ಹೋಗಿ';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'ಈಕ್ವಲೈಜರ್';

  @override
  String get playerEqCustom => 'ಕಸ್ಟಮ್';

  @override
  String get playlistDownloads => 'ಡೌನ್‌ಲೋಡ್‌ಗಳು';

  @override
  String get playlistOffline => 'ಆಫ್‌ಲೈನ್ ಪ್ಲೇಪಟ್ಟಿ';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hoursಗಂ $minsನಿ';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$minsನಿ';
  }

  @override
  String get playlistFindOnPage => 'ಈ ಪುಟದಲ್ಲಿ ಹುಡುಕಿ';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count ಹಾಡುಗಳು • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'ಇತ್ತೀಚಿನದು';

  @override
  String get playlistNoMatches => 'ಏನೂ ಕಂಡುಬಂದಿಲ್ಲ.';

  @override
  String get playlistNoTracks => 'ಈ ಪ್ಲೇಪಟ್ಟಿಯಲ್ಲಿ ಹಾಡುಗಳಿಲ್ಲ.';

  @override
  String get playlistNoSongsYet => 'ಇನ್ನೂ ಯಾವುದೇ ಹಾಡುಗಳಿಲ್ಲ.';

  @override
  String get playlistSortRecentlyAdded => 'ಇತ್ತೀಚೆಗೆ ಸೇರಿಸಲಾಗಿದೆ';

  @override
  String get playlistSortAlphabetical => 'ಅಕ್ಷರಮಾಲೆ';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ಹಾಡುಗಳು',
      one: 'ಹಾಡು',
    );
    return '$count $_temp0 ಡೌನ್‌ಲೋಡ್ ಆಗುತ್ತಿವೆ';
  }

  @override
  String get playlistView => 'ವೀಕ್ಷಿಸಿ';

  @override
  String get playlistAllDownloaded =>
      'ಎಲ್ಲಾ ಹಾಡುಗಳನ್ನು ಈಗಾಗಲೇ ಡೌನ್‌ಲೋಡ್ ಮಾಡಲಾಗಿದೆ';

  @override
  String playlistShareText(String name, String url) {
    return 'Pulse ನಲ್ಲಿ \"$name\" ಕೇಳಿ!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'ಡೌನ್‌ಲೋಡ್‌ಗಳಿಂದ ತೆಗೆದುಹಾಕಿ';

  @override
  String get playlistRemoveFromPlaylist => 'ಪ್ಲೇಪಟ್ಟಿಯಿಂದ ತೆಗೆದುಹಾಕಿ';

  @override
  String get playlistLoadError => 'ಈ ಪ್ಲೇಪಟ್ಟಿ ಲೋಡ್ ಮಾಡಲು ವಿಫಲವಾಗಿದೆ.';

  @override
  String get playlistGoBack => '← ಹಿಂದೆ ಹೋಗಿ';

  @override
  String get profileNotLoggedIn => 'ಲಾಗಿನ್ ಆಗಿಲ್ಲ';

  @override
  String get profileSignIn => 'ಸೈನ್ ಇನ್';

  @override
  String get profileDefaultUser => 'Pulse ಬಳಕೆದಾರ';

  @override
  String get profileEditProfile => 'ಪ್ರೊಫೈಲ್ ಎಡಿಟ್ ಮಾಡಿ';

  @override
  String get profileTimeframeDay => 'ದಿನ';

  @override
  String get profileTimeframeWeek => 'ವಾರ';

  @override
  String get profileTimeframeMonth => 'ತಿಂಗಳು';

  @override
  String get profileTimeframeYear => 'ವರ್ಷ';

  @override
  String get profileListeningTime => 'ಕೇಳಿದ ಸಮಯ';

  @override
  String get profileToday => 'ಇಂದು';

  @override
  String get profileThisWeek => 'ಈ ವಾರ';

  @override
  String get profileThisMonth => 'ಈ ತಿಂಗಳು';

  @override
  String get profileThisYear => 'ಈ ವರ್ಷ';

  @override
  String get profileDailyAvg => 'ದೈನಂದಿನ ಸರಾಸರಿ';

  @override
  String get profilePerDay => 'ದಿನಕ್ಕೆ';

  @override
  String get profileLifetimeListening => 'ಒಟ್ಟು ಕೇಳಿದ ಸಮಯ';

  @override
  String get profileTotalTimeListened => 'Pulse ನಲ್ಲಿ ಒಟ್ಟು ಸಂಗೀತ ಆಲಿಸಿದ ಸಮಯ';

  @override
  String get profileYourTopSongs => 'ನಿಮ್ಮ ನೆಚ್ಚಿನ ಹಾಡುಗಳು';

  @override
  String get profileListeningHistoryEmpty =>
      'ನಿಮ್ಮ ಆಲಿಸುವಿಕೆಯ ಇತಿಹಾಸ ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String profilePlays(int count) {
    return '$count ಬಾರಿ ಪ್ಲೇ ಆಗಿದೆ';
  }

  @override
  String get profileYourTopArtists => 'ನಿಮ್ಮ ನೆಚ್ಚಿನ ಕಲಾವಿದರು';

  @override
  String get profileTopArtistsEmpty =>
      'ನಿಮ್ಮ ನೆಚ್ಚಿನ ಕಲಾವಿದರು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತಾರೆ.';

  @override
  String get profileArtistLabel => 'ಕಲಾವಿದ';

  @override
  String get profileSignOut => 'ಸೈನ್ ಔಟ್';

  @override
  String profileVersion(String version) {
    return 'ಆವೃತ್ತಿ $version';
  }

  @override
  String get profileMadeWithHeartBy => 'ಪ್ರೀತಿಯಿಂದ ರಚಿಸಿದವರು: ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'ಪ್ರೊಫೈಲ್ ಎಡಿಟ್ ಮಾಡಿ';

  @override
  String get profileDisplayName => 'ಪ್ರದರ್ಶಿಸುವ ಹೆಸರು';

  @override
  String get profileCancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String get profileSave => 'ಉಳಿಸಿ';

  @override
  String get profileChooseAvatar => 'ಅವತಾರವನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get searchMicPermissionRequired =>
      'ಈ ವೈಶಿಷ್ಟ್ಯಕ್ಕೆ ಮೈಕ್ರೊಫೋನ್ ಅನುಮತಿ ಅಗತ್ಯವಿದೆ';

  @override
  String get searchUnknownSong => 'ಅಪರಿಚಿತ ಹಾಡು';

  @override
  String get searchUnknownArtist => 'ಅಪರಿಚಿತ ಕಲಾವಿದ';

  @override
  String get searchNoSongDetected => 'ಯಾವುದೇ ಹಾಡು ಪತ್ತೆಯಾಗಿಲ್ಲ.';

  @override
  String searchError(String message) {
    return 'ದೋಷ: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'ಧ್ವನಿ ಹುಡುಕಾಟ ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get searchHint => 'ಹಾಡುಗಳು, ಕಲಾವಿದರು, ಆಲ್ಬಮ್‌ಗಳು...';

  @override
  String get searchRecentEmpty => 'ನಿಮ್ಮ ಇತ್ತೀಚಿನ ಹುಡುಕಾಟಗಳು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ';

  @override
  String get searchRecentSearches => 'ಇತ್ತೀಚಿನ ಹುಡುಕಾಟಗಳು';

  @override
  String get searchClearAll => 'ಎಲ್ಲವನ್ನೂ ಅಳಿಸಿ';

  @override
  String searchNoResultsFor(String query) {
    return '\"$query\" ಗಾಗಿ ಯಾವುದೇ ಫಲಿತಾಂಶಗಳಿಲ್ಲ';
  }

  @override
  String get searchTryDifferentKeywords => 'ವಿಭಿನ್ನ ಪದಗಳೊಂದಿಗೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get searchTopResult => 'ಉನ್ನತ ಫಲಿತಾಂಶ';

  @override
  String get searchSongsLabel => 'ಹಾಡುಗಳು';

  @override
  String get searchArtistsLabel => 'ಕಲಾವಿದರು';

  @override
  String get searchAlbumsLabel => 'ಆಲ್ಬಮ್‌ಗಳು';

  @override
  String get searchPlaylistsLabel => 'ಪ್ಲೇಪಟ್ಟಿಗಳು';

  @override
  String get searchArtistLabel => 'ಕಲಾವಿದ';

  @override
  String get searchListening => 'ಕೇಳಿಸಿಕೊಳ್ಳಲಾಗುತ್ತಿದೆ...';

  @override
  String get searchSpeakNow => 'ಹುಡುಕಲು ಈಗ ಮಾತನಾಡಿ';

  @override
  String get searchCancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String get searchIdentifying => 'ಗುರುತಿಸಲಾಗುತ್ತಿದೆ...';

  @override
  String get searchListeningForSong => 'ಹಾಡಿಗೆ ಕೇಳಿಸಿಕೊಳ್ಳಲಾಗುತ್ತಿದೆ...';

  @override
  String get settingsTitle => 'ಸೆಟ್ಟಿಂಗ್ಸ್';

  @override
  String get settingsStreamingQuality => 'ಸ್ಟ್ರೀಮಿಂಗ್ ಗುಣಮಟ್ಟ';

  @override
  String get settingsQualityAutomatic => 'ಸ್ವಯಂಚಾಲಿತ';

  @override
  String get settingsQualityLow => 'ಕಡಿಮೆ';

  @override
  String get settingsQualityNormal => 'ಸಾಮಾನ್ಯ';

  @override
  String get settingsQualityHigh => 'ಹೆಚ್ಚು';

  @override
  String get settingsDownloadQuality => 'ಡೌನ್‌ಲೋಡ್ ಗುಣಮಟ್ಟ';

  @override
  String get settingsPlayback => 'ಪ್ಲೇಬ್ಯಾಕ್';

  @override
  String get settingsCrossfade => 'ಕ್ರಾಸ್‌ಫೇಡ್';

  @override
  String get settingsCrossfadeDesc =>
      'ಅಡೆತಡೆಯಿಲ್ಲದ ಪರಿವರ್ತನೆಗಾಗಿ ಟ್ರ್ಯಾಕ್‌ಗಳನ್ನು ಓವರ್‌ಲ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get settingsDataUsage => 'ಡೇಟಾ ಬಳಕೆ';

  @override
  String get settingsDataSaver => 'ಡೇಟಾ ಸೇವರ್';

  @override
  String get settingsDataSaverDesc =>
      'ಮೊಬೈಲ್ ಡೇಟಾದಲ್ಲಿ ಕಡಿಮೆ ಗುಣಮಟ್ಟದಲ್ಲಿ ಸ್ಟ್ರೀಮ್ ಮಾಡಿ';

  @override
  String get settingsAppearance => 'ಗೋಚರತೆ';

  @override
  String get settingsLanguage => 'ಭಾಷೆ';

  @override
  String get settingsCustomAccent => 'ಕಸ್ಟಮ್ ಆಕ್ಸೆಂಟ್';

  @override
  String get settingsSaturation => 'ಸ್ಯಾಚುರೇಶನ್';

  @override
  String get settingsBrightness => 'ಪ್ರಕಾಶ';

  @override
  String get settingsResetDefault => 'ಡೀಫಾಲ್ಟ್‌ಗೆ ಮರುಹೊಂದಿಸಿ';

  @override
  String get playlistSheetTitle => 'ಪ್ಲೇಪಟ್ಟಿಗೆ ಸೇರಿಸಿ';

  @override
  String get playlistSheetNewPlaylist => 'ಹೊಸ ಪ್ಲೇಪಟ್ಟಿ';

  @override
  String get playlistSheetNoPlaylists => 'ಇನ್ನೂ ಪ್ಲೇಪಟ್ಟಿಗಳಿಲ್ಲ';

  @override
  String playlistSheetSongsCount(int count) {
    return '$count ಹಾಡುಗಳು';
  }

  @override
  String get playlistSheetNameHint => 'ಪ್ಲೇಪಟ್ಟಿ ಹೆಸರು';

  @override
  String get playlistSheetCancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String playlistSheetAddedTo(String name) {
    return '$name ಗೆ ಸೇರಿಸಲಾಗಿದೆ';
  }

  @override
  String get playlistSheetCreateFailAuth => 'ರಚಿಸಲು ವಿಫಲವಾಗಿದೆ: ದೃಢೀಕರಣ ದೋಷ';

  @override
  String playlistSheetCreateFail(String error) {
    return 'ರಚಿಸಲು ವಿಫಲವಾಗಿದೆ: $error';
  }

  @override
  String get playlistSheetCreate => 'ರಚಿಸಿ';

  @override
  String get appUpdateAvailable => 'ಅಪ್‌ಡೇಟ್ ಲಭ್ಯವಿದೆ';

  @override
  String appUpdateDesc(String version) {
    return 'ಆವೃತ್ತಿ $version ಬಂದಿದೆ! ಹೊಸ ವೈಶಿಷ್ಟ್ಯಗಳಿಗಾಗಿ ಅಪ್‌ಡೇಟ್ ಮಾಡಿ.';
  }

  @override
  String get appUpdateDownload => 'ಅಪ್‌ಡೇಟ್ ಡೌನ್‌ಲೋಡ್ ಮಾಡಿ';

  @override
  String get navHome => 'ಹೋಮ್';

  @override
  String get navLibrary => 'ಲೈಬ್ರರಿ';

  @override
  String get navSearch => 'ಹುಡುಕಾಟ';

  @override
  String get navSettings => 'ಸೆಟ್ಟಿಂಗ್ಸ್';

  @override
  String get navProfile => 'ಪ್ರೊಫೈಲ್';

  @override
  String get artistSelect => 'ಕಲಾವಿದರನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get songActionQueue => 'ಕ್ಯೂಗೆ ಸೇರಿಸಿ';

  @override
  String get songActionPlaylist => 'ಪ್ಲೇಪಟ್ಟಿಗೆ ಸೇರಿಸಿ';

  @override
  String get songActionFinding => 'ಹುಡುಕಲಾಗುತ್ತಿದೆ...';

  @override
  String get songActionAlbum => 'ಆಲ್ಬಮ್‌ಗೆ ಹೋಗಿ';

  @override
  String get songActionArtist => 'ಕಲಾವಿದರ ಬಳಿಗೆ ಹೋಗಿ';

  @override
  String get songActionRemovePlaylist => 'ಪ್ಲೇಪಟ್ಟಿಯಿಂದ ತೆಗೆದುಹಾಕಿ';

  @override
  String get songActionRemoveDownload => 'ಡೌನ್‌ಲೋಡ್‌ಗಳಿಂದ ತೆಗೆದುಹಾಕಿ';

  @override
  String get songActionDownloadChecking => 'ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ...';

  @override
  String get songActionDownloading => 'ಡೌನ್‌ಲೋಡ್ ಆಗುತ್ತಿದೆ...';

  @override
  String get songActionDownloaded => 'ಡೌನ್‌ಲೋಡ್ ಆಗಿದೆ!';

  @override
  String get songActionDownloadAlready => 'ಈಗಾಗಲೇ ಡೌನ್‌ಲೋಡ್ ಆಗಿದೆ';

  @override
  String get songActionDownloadFailed => 'ಡೌನ್‌ಲೋಡ್ ವಿಫಲವಾಗಿದೆ';

  @override
  String get songActionDownload => 'ಡೌನ್‌ಲೋಡ್';

  @override
  String get songActionDownloadingSnack => 'ಡೌನ್‌ಲೋಡ್ ಆಗುತ್ತಿದೆ';

  @override
  String get songActionView => 'ವೀಕ್ಷಿಸಿ';

  @override
  String get spotifyImportTitle => 'Spotify ನಿಂದ ಆಮದು ಮಾಡಿ';

  @override
  String get spotifyImportSubtitle => 'ಪ್ಲೇಪಟ್ಟಿ ಗಾತ್ರವನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get spotifyChoiceSmallTitle => '100 ಹಾಡುಗಳು ಅಥವಾ ಕಡಿಮೆ';

  @override
  String get spotifyChoiceSmallDesc =>
      'ಸಾರ್ವಜನಿಕ Spotify ಪ್ಲೇಪಟ್ಟಿ URL ಅಂಟಿಸಿ.';

  @override
  String get spotifyChoiceLargeTitle => '100 ಹಾಡುಗಳಿಗಿಂತ ಹೆಚ್ಚು';

  @override
  String get spotifyChoiceLargeDesc =>
      'ಅನಿಯಮಿತ ಟ್ರ್ಯಾಕ್‌ಗಳನ್ನು ಆಮದು ಮಾಡಲು ನಿಮ್ಮದೇ Spotify Developer App ಸಂಪರ್ಕಿಸಿ.';

  @override
  String get cancelButton => 'ರದ್ದುಮಾಡಿ';

  @override
  String get spotifyPlaylistsTitle => 'ನಿಮ್ಮ Spotify ಪ್ಲೇಪಟ್ಟಿಗಳು';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'ದೋಷ: $error\nನಿಮ್ಮ Client ID ಸರಿಯಾಗಿದೆಯೇ ಎಂದು ಪರಿಶೀಲಿಸಿ.';
  }

  @override
  String get spotifyPlaylistsEmpty =>
      'ನಿಮ್ಮ ಲೈಬ್ರರಿಯಲ್ಲಿ ಯಾವುದೇ ಪ್ಲೇಪಟ್ಟಿಗಳಿಲ್ಲ';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count ಟ್ರ್ಯಾಕ್‌ಗಳು';
  }

  @override
  String get spotifyPlaylistsImport => 'ಆಮದು ಮಾಡಿ';

  @override
  String get audioPlaybackFailed =>
      'ಪ್ಲೇಬ್ಯಾಕ್ ವಿಫಲವಾಗಿದೆ. ಇಂಟರ್ನೆಟ್ ಸಂಪರ್ಕವನ್ನು ಪರಿಶೀಲಿಸಿ.';

  @override
  String get audioControlPrevious => 'ಹಿಂದಿನದು';

  @override
  String get audioControlPause => 'ವಿರಾಮ';

  @override
  String get audioControlPlay => 'ಪ್ಲೇ';

  @override
  String get audioControlNext => 'ಮುಂದಿನದು';

  @override
  String get audioControlUnlike => 'ಅನ್‌ಲೈಕ್';

  @override
  String get audioControlLike => 'ಲೈಕ್';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'ಮೂಲ ಪ್ರತಿಕ್ರಿಯೆ: $data\n\nದೋಷ: $error';
  }

  @override
  String get apiErrorInvalidClient => 'ಅಮಾನ್ಯ ಕ್ಲೈಂಟ್ ಅಥವಾ ಕ್ಲೈಂಟ್ ಸೀಕ್ರೆಟ್.';

  @override
  String get apiErrorBadRequest => 'ತಪ್ಪಾದ ವಿನಂತಿ. ನಿಮ್ಮ ಇನ್‌ಪುಟ್ ಪರಿಶೀಲಿಸಿ.';

  @override
  String get apiErrorUnauthorized => 'ಅಧಿಕಾರವಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಲಾಗಿನ್ ಮಾಡಿ.';

  @override
  String get apiErrorForbidden => 'ನಿಷೇಧಿಸಲಾಗಿದೆ. ನಿಮಗೆ ಪ್ರವೇಶವಿಲ್ಲ.';

  @override
  String get apiErrorNotFound => 'ಸಂಪನ್ಮೂಲ ಕಂಡುಬಂದಿಲ್ಲ.';

  @override
  String get apiErrorEmailInUse => 'ಈ ಇಮೇಲ್ ವಿಳಾಸವನ್ನು ಈಗಾಗಲೇ ಬಳಸಲಾಗಿದೆ.';

  @override
  String get apiErrorUserNotFound => 'ಈ ಇಮೇಲ್‌ನೊಂದಿಗೆ ಯಾವುದೇ ಖಾತೆ ಕಂಡುಬಂದಿಲ್ಲ.';

  @override
  String get apiErrorWrongPassword => 'ತಪ್ಪಾದ ಪಾಸ್‌ವರ್ಡ್.';

  @override
  String get apiErrorInvalidCredential =>
      'ಲಾಗಿನ್ ವಿಫಲವಾಗಿದೆ. ನಿಮ್ಮ ರುಜುವಾತುಗಳನ್ನು ಪರಿಶೀಲಿಸಿ.';

  @override
  String get apiErrorNetwork => 'ನೆಟ್‌ವರ್ಕ್ ದೋಷ. ನಿಮ್ಮ ಸಂಪರ್ಕ ಪರಿಶೀಲಿಸಿ.';

  @override
  String get apiErrorSocketTimeout => 'ಸಂಪರ್ಕದ ಅವಧಿ ಮೀರಿದೆ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get apiErrorTooManyRequests =>
      'ತುಂಬಾ ವಿನಂತಿಗಳು. ಸ್ವಲ್ಪ ಸಮಯದ ನಂತರ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get apiErrorServerError =>
      'ಸರ್ವರ್ ದೋಷ. ಸ್ವಲ್ಪ ಸಮಯದ ನಂತರ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get apiErrorInvalidEmail =>
      'ದಯವಿಟ್ಟು ಸರಿಯಾದ ಇಮೇಲ್ ವಿಳಾಸವನ್ನು ನಮೂದಿಸಿ.';

  @override
  String get apiErrorWeakPassword =>
      'ಪಾಸ್‌ವರ್ಡ್ ತುಂಬಾ ದುರ್ಬಲವಾಗಿದೆ. ಕನಿಷ್ಠ 6 ಅಕ್ಷರಗಳನ್ನು ಬಳಸಿ.';

  @override
  String get apiErrorTooManyAttempts =>
      'ಹಲವು ಬಾರಿ ತಪ್ಪಾಗಿ ಪ್ರಯತ್ನಿಸಲಾಗಿದೆ. ನಂತರ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get homeForgottenFavorites => 'ಮರೆತ ಮೆಚ್ಚಿನ ಹಾಡುಗಳು';

  @override
  String get artistShowAll => 'ಎಲ್ಲಾ ತೋರಿಸಿ';

  @override
  String get homeTopTracks => 'ಟಾಪ್ ಟ್ರ್ಯಾಕ್‌ಗಳು';
}
