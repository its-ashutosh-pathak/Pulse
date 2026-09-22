// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'ਬਾਰੇ';

  @override
  String get artistPopular => 'ਪ੍ਰਸਿੱਧ';

  @override
  String get artistAlbums => 'ਐਲਬਮਾਂ';

  @override
  String get artistSinglesAndEPs => 'ਸਿੰਗਲਜ਼ ਅਤੇ EPs';

  @override
  String artistSubscribersCount(String count) {
    return '$count ਮੈਂਬਰ';
  }

  @override
  String get artistPlayAll => 'ਸਭ ਚਲਾਓ';

  @override
  String get artistLoadError => 'ਕਲਾਕਾਰ ਲੋਡ ਨਹੀਂ ਕਰ ਸਕਿਆ';

  @override
  String get artistGoBack => 'ਪਿੱਛੇ ਜਾਓ';

  @override
  String adminChatFailedToReply(String error) {
    return 'ਜਵਾਬ ਦੇਣ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String get adminChatSupportChat => 'ਸਹਾਇਤਾ ਚੈਟ';

  @override
  String adminChatError(String error) {
    return 'ਗਲਤੀ: $error';
  }

  @override
  String get adminChatNoHistory => 'ਕੋਈ ਗੱਲਬਾਤ ਦਾ ਇਤਿਹਾਸ ਨਹੀਂ।';

  @override
  String get adminChatSupportYou => 'ਸਹਾਇਤਾ (ਤੁਸੀਂ)';

  @override
  String get adminChatTypeReply => 'ਆਪਣਾ ਜਵਾਬ ਟਾਈਪ ਕਰੋ...';

  @override
  String get broadcastSuccess => 'ਘੋਸ਼ਣਾ ਸਫਲਤਾਪੂਰਵਕ ਪ੍ਰਸਾਰਿਤ ਕੀਤੀ ਗਈ!';

  @override
  String broadcastFailed(String error) {
    return 'ਪ੍ਰਸਾਰਿਤ ਕਰਨ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String get broadcastTitle => 'ਵਿਸ਼ਵਵਿਆਪੀ ਘੋਸ਼ਣਾਵਾਂ';

  @override
  String get broadcastSubtitle => 'ਸਾਰਿਆਂ ਨੂੰ ਭੇਜਿਆ';

  @override
  String get broadcastWarning => 'ਇੱਥੇ ਭੇਜੇ ਗਏ ਸੰਦੇਸ਼ ਸਾਰਿਆਂ ਨੂੰ ਦਿਖਾਈ ਦੇਣਗੇ।';

  @override
  String broadcastError(String error) {
    return 'ਗਲਤੀ: $error';
  }

  @override
  String get broadcastNoHistory => 'ਕੋਈ ਪਿਛਲੀ ਘੋਸ਼ਣਾ ਨਹੀਂ।';

  @override
  String get broadcastTypeMessage => 'ਵਿਸ਼ਵਵਿਆਪੀ ਘੋਸ਼ਣਾ ਟਾਈਪ ਕਰੋ...';

  @override
  String commFailedToSend(String error) {
    return 'ਭੇਜਣ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String get commAdminDashboard => 'ਪ੍ਰਸ਼ਾਸਕ ਡੈਸ਼ਬੋਰਡ';

  @override
  String get commAdminSupport => 'ਪ੍ਰਸ਼ਾਸਕ ਸਹਾਇਤਾ';

  @override
  String get commAlwaysHere => 'ਮਦਦ ਲਈ ਹਮੇਸ਼ਾ ਇੱਥੇ ਹਾਂ';

  @override
  String get commWelcomeTitle => 'ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ! 👋 ਮੈਂ ਆਸ਼ੂਤੋਸ਼ ਪਾਠਕ ਹਾਂ';

  @override
  String get commWelcomeSubtitle => 'Pulse ਦਾ ਡਿਵੈਲਪਰ';

  @override
  String get commWelcomeBody1 =>
      'ਮੈਨੂੰ ਉਮੀਦ ਹੈ ਕਿ ਤੁਸੀਂ ਬਿਨਾਂ ਕਿਸੇ ਇਸ਼ਤਿਹਾਰ ਜਾਂ ਗਾਹਕੀ ਦੇ ਆਪਣੇ ਮਨਪਸੰਦ ਸੰਗੀਤ ਦਾ ਆਨੰਦ ਲੈ ਰਹੇ ਹੋ। ਸੰਗੀਤ ਮੁਫ਼ਤ ਹੋਣਾ ਚਾਹੀਦਾ ਹੈ।\n\nਇਹ ਭਾਗ ਇਸ ਲਈ ਹੈ ਤਾਂ ਜੋ ਅਸੀਂ ਸਿੱਧਾ ਸੰਪਰਕ ਕਰ ਸਕੀਏ।\n\nਤੁਸੀਂ ਬਿਨਾਂ ਝਿਜਕ:';

  @override
  String get commBullet1 => 'ਆਪਣੇ ਵਿਚਾਰ ਸਾਂਝੇ ਕਰੋ';

  @override
  String get commBullet2 => 'ਬੱਗ ਰਿਪੋਰਟ ਕਰੋ';

  @override
  String get commBullet3 => 'ਨਵੀਆਂ ਵਿਸ਼ੇਸ਼ਤਾਵਾਂ ਦਾ ਸੁਝਾਅ ਦਿਓ';

  @override
  String get commWelcomeBody2 =>
      'ਮੈਂ ਖੁਦ ਹਰ ਸੰਦੇਸ਼ ਪੜ੍ਹਦਾ ਹਾਂ ਅਤੇ ਤੁਹਾਡੇ ਸੁਝਾਵਾਂ ਅਨੁਸਾਰ ਐਪ ਨੂੰ ਬਿਹਤਰ ਬਣਾਉਣ ਦੀ ਕੋਸ਼ਿਸ਼ ਕਰਾਂਗਾ।\n\nPulse ਦੀ ਵਰਤੋਂ ਕਰਨ ਲਈ ਅਤੇ ਇਸ ਸਫ਼ਰ ਵਿੱਚ ਸ਼ਾਮਲ ਹੋਣ ਲਈ ਤੁਹਾਡਾ ਧੰਨਵਾਦ। ❤️';

  @override
  String commError(String error) {
    return 'ਗਲਤੀ: $error';
  }

  @override
  String get commNoMessages => 'ਅਜੇ ਕੋਈ ਸੰਦੇਸ਼ ਨਹੀਂ';

  @override
  String get commNoMessagesDesc =>
      'ਸਹਾਇਤਾ ਟੀਮ ਨੂੰ ਸੰਦੇਸ਼ ਭੇਜੋ ਜਾਂ ਘੋਸ਼ਣਾਵਾਂ ਲਈ ਬਾਅਦ ਵਿੱਚ ਦੇਖੋ।';

  @override
  String get commMessageSupportHint => 'ਸਹਾਇਤਾ ਨੂੰ ਸੰਦੇਸ਼ ਭੇਜੋ...';

  @override
  String get commGlobalAnnouncements => 'ਵਿਸ਼ਵਵਿਆਪੀ ਘੋਸ਼ਣਾਵਾਂ';

  @override
  String get commSendMessagesToAll => 'ਸਾਰਿਆਂ ਨੂੰ ਸੰਦੇਸ਼ ਭੇਜੋ';

  @override
  String get homeGreetingMorning => 'ਸ਼ੁਭ ਸਵੇਰ,';

  @override
  String get homeGreetingAfternoon => 'ਸ਼ੁਭ ਦੁਪਹਿਰ,';

  @override
  String get homeGreetingEvening => 'ਸ਼ੁਭ ਸ਼ਾਮ,';

  @override
  String get homeMember => 'ਮੈਂਬਰ';

  @override
  String get homeRecentPlaylists => 'ਤਾਜ਼ਾ ਪਲੇਲਿਸਟਾਂ';

  @override
  String get homeRecentlyPlayed => 'ਹਾਲ ਹੀ ਵਿੱਚ ਸੁਣਿਆ';

  @override
  String get homeSpeedDial => 'ਤੇਜ਼ ਸੰਪਰਕ';

  @override
  String get homeNoContent => 'ਕੋਈ ਸਮੱਗਰੀ ਉਪਲਬਧ ਨਹੀਂ';

  @override
  String get homeRefresh => 'ਰਿਫ੍ਰੈਸ਼';

  @override
  String get homeLoadError => 'ਸੰਗੀਤ ਲੋਡ ਨਹੀਂ ਕਰ ਸਕਿਆ।';

  @override
  String get homeRetry => 'ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ';

  @override
  String get importSuccess => 'Spotify ਨਾਲ ਸਫਲਤਾਪੂਰਵਕ ਜੁੜ ਗਿਆ!';

  @override
  String importFailed(String error) {
    return 'ਜੁੜਨ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String get importTitle => 'Spotify ਕਨੈਕਟ ਕਰੋ';

  @override
  String get importSetupTitle => 'Spotify ਸੈੱਟਅੱਪ ਕਰੋ';

  @override
  String get importSetupDesc =>
      'ਆਪਣੀ ਖੁਦ ਦੀ ਮੁਫਤ ਡਿਵੈਲਪਰ ਕੁੰਜੀ ਦੀ ਵਰਤੋਂ ਕਰਕੇ ਆਪਣੀਆਂ ਸਾਰੀਆਂ ਪਲੇਲਿਸਟਾਂ ਨੂੰ ਤੁਰੰਤ ਆਯਾਤ ਕਰਨ ਲਈ ਇਨ੍ਹਾਂ ਸਧਾਰਨ ਕਦਮਾਂ ਦੀ ਪਾਲਣਾ ਕਰੋ:';

  @override
  String get importStep1 => 'Spotify Developer Dashboard ਖੋਲ੍ਹੋ।';

  @override
  String get importStep2 => 'ਲਾਗਇਨ ਕਰੋ ਅਤੇ \'Create app\' \'ਤੇ ਕਲਿੱਕ ਕਰੋ।';

  @override
  String get importStep3 => 'ਐਪ ਦਾ ਨਾਮ ਅਤੇ ਵੇਰਵਾ ਭਰੋ।';

  @override
  String get importStep4 => '\'Redirect URIs\' ਦੇ ਹੇਠਾਂ ਦਿੱਤਾ URL ਪੇਸਟ ਕਰੋ:';

  @override
  String get importRedirectCopied => 'Redirect URI ਕਾਪੀ ਕੀਤਾ ਗਿਆ!';

  @override
  String get importStep5 =>
      'ਸੇਵ ਕਰੋ, ਆਪਣਾ \'Client ID\' ਕਾਪੀ ਕਰੋ ਅਤੇ ਹੇਠਾਂ ਪੇਸਟ ਕਰੋ।';

  @override
  String get importImportant =>
      'ਮਹੱਤਵਪੂਰਨ: ਇਸ ਡਿਵੈਲਪਰ ਐਪ ਲਈ ਤੁਹਾਡੇ ਕੋਲ ਪ੍ਰੀਮੀਅਮ ਗਾਹਕੀ ਹੋਣੀ ਚਾਹੀਦੀ ਹੈ।';

  @override
  String get importClientIdHint => 'ਆਪਣਾ Spotify Client ID ਇੱਥੇ ਪੇਸਟ ਕਰੋ...';

  @override
  String get importConnectButton => 'ਕਨੈਕਟ ਕਰੋ ਅਤੇ ਲਾਇਬ੍ਰੇਰੀ ਪ੍ਰਾਪਤ ਕਰੋ';

  @override
  String get downloadingNoActive => 'ਕੋਈ ਸਰਗਰਮ ਡਾਊਨਲੋਡ ਨਹੀਂ';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'ਡਾਊਨਲੋਡਸ';

  @override
  String downloadsStats(String count, String size) {
    return '$count ਗੀਤ • $size';
  }

  @override
  String get downloadsNoOffline => 'ਅਜੇ ਕੋਈ ਔਫਲਾਈਨ ਗੀਤ ਨਹੀਂ';

  @override
  String get downloadsNoOfflineDesc =>
      'ਤੁਹਾਡੇ ਦੁਆਰਾ ਡਾਊਨਲੋਡ ਕੀਤੇ ਗੀਤ ਇੱਥੇ ਦਿਖਾਈ ਦੇਣਗੇ';

  @override
  String get downloadsClearAllTitle => 'ਸਾਰੇ ਡਾਊਨਲੋਡ ਮਿਟਾਓ?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'ਇਹ $count ਗੀਤਾਂ ਨੂੰ ਮਿਟਾ ਦੇਵੇਗਾ ਅਤੇ $size ਸਟੋਰੇਜ ਖਾਲੀ ਕਰੇਗਾ।';
  }

  @override
  String get downloadsCancel => 'ਰੱਦ ਕਰੋ';

  @override
  String get downloadsClearAll => 'ਸਭ ਮਿਟਾਓ';

  @override
  String downloadsSongsCount(String count) {
    return '$count ਗੀਤ';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count ਗੀਤ';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'ਮੁੱਖ ਡਾਊਨਲੋਡ ਪਲੇਲਿਸਟ ਦਾ ਨਾਮ ਨਹੀਂ ਬਦਲਿਆ ਜਾ ਸਕਦਾ।';

  @override
  String get downloadsRename => 'ਨਾਮ ਬਦਲੋ';

  @override
  String get downloadsEditSongs => 'ਗੀਤ ਸੰਪਾਦਿਤ ਕਰੋ';

  @override
  String get downloadsDelete => 'ਮਿਟਾਓ';

  @override
  String get downloadsRenamePlaylistTitle => 'ਪਲੇਲਿਸਟ ਦਾ ਨਾਮ ਬਦਲੋ';

  @override
  String get downloadsRenamePlaylistDesc =>
      'ਆਪਣੀ ਪਲੇਲਿਸਟ ਲਈ ਨਵਾਂ ਨਾਮ ਟਾਈਪ ਕਰੋ।';

  @override
  String get downloadsDeletePlaylistTitle => 'ਪਲੇਲਿਸਟ ਮਿਟਾਓ?';

  @override
  String get downloadsDeleteMasterDesc =>
      'ਕੀ ਤੁਸੀਂ ਯਕੀਨੀ ਤੌਰ \'ਤੇ ਇਸਨੂੰ ਮਿਟਾਉਣਾ ਚਾਹੁੰਦੇ ਹੋ? ਤੁਹਾਡੇ ਸਾਰੇ ਡਾਊਨਲੋਡ ਕੀਤੇ ਗੀਤ ਅਤੇ ਪਲੇਲਿਸਟਾਂ ਹਮੇਸ਼ਾ ਲਈ ਖਤਮ ਹੋ ਜਾਣਗੀਆਂ।';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'ਕੀ ਤੁਸੀਂ ਯਕੀਨੀ ਤੌਰ \'ਤੇ \'$name\' ਨੂੰ ਮਿਟਾਉਣਾ ਚਾਹੁੰਦੇ ਹੋ? ਇਹ ਪਲੇਲਿਸਟ ਹਮੇਸ਼ਾ ਲਈ ਖਤਮ ਹੋ ਜਾਵੇਗੀ।';
  }

  @override
  String get downloadsSave => 'ਸੇਵ ਕਰੋ';

  @override
  String get downloadsNoSongs => 'ਇਸ ਪਲੇਲਿਸਟ ਵਿੱਚ ਕੋਈ ਗੀਤ ਨਹੀਂ ਹਨ।';

  @override
  String get libraryTitle => 'ਲਾਇਬ੍ਰੇਰੀ';

  @override
  String get libraryPauseAll => 'ਸਭ ਰੋਕੋ';

  @override
  String get libraryResumeAll => 'ਸਭ ਚਾਲੂ ਕਰੋ';

  @override
  String get libraryTabPlaylists => 'ਪਲੇਲਿਸਟਾਂ';

  @override
  String get libraryTabDownloads => 'ਡਾਊਨਲੋਡਸ';

  @override
  String get libraryTabDownloading => 'ਡਾਊਨਲੋਡ ਹੋ ਰਿਹਾ ਹੈ';

  @override
  String libraryImportedTask(String name) {
    return '$name ਆਯਾਤ ਕੀਤਾ ਗਿਆ';
  }

  @override
  String get libraryImportWaiting => 'ਉਡੀਕ ਕਰ ਰਿਹਾ ਹੈ...';

  @override
  String get libraryImportFetching => 'ਪਲੇਲਿਸਟ ਪ੍ਰਾਪਤ ਕਰ ਰਿਹਾ ਹੈ...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total ਪ੍ਰੋਸੈਸ ਕੀਤਾ ਗਿਆ · $matched ਮਿਲੇ';
  }

  @override
  String get libraryImportSaving => 'ਲਾਇਬ੍ਰੇਰੀ ਵਿੱਚ ਸੇਵ ਕਰ ਰਿਹਾ ਹੈ...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched ਗੀਤ ਸ਼ਾਮਲ ਕੀਤੇ ਗਏ';
  }

  @override
  String get libraryImportDoneAll => 'ਸਾਰੇ ਗੀਤ ਸ਼ਾਮਲ ਕੀਤੇ ਗਏ';

  @override
  String get libraryAddButton => 'ਸ਼ਾਮਲ ਕਰੋ';

  @override
  String get librarySortRecent => 'ਹਾਲ ਹੀ ਵਿੱਚ ਸ਼ਾਮਲ ਕੀਤੇ';

  @override
  String get librarySortAlpha => 'ਅੱਖਰਾਂ ਅਨੁਸਾਰ';

  @override
  String get libraryEmptyTitle => 'ਤੁਹਾਡੀ ਲਾਇਬ੍ਰੇਰੀ ਖਾਲੀ ਹੈ।';

  @override
  String get libraryEmptyDesc => 'ਸ਼ੁਰੂ ਕਰਨ ਲਈ \'ਸ਼ਾਮਲ ਕਰੋ\' \'ਤੇ ਟੈਪ ਕਰੋ।';

  @override
  String get libraryRenameLikedError =>
      'ਪਸੰਦ ਕੀਤੇ ਗੀਤਾਂ ਦੀ ਪਲੇਲਿਸਟ ਦਾ ਨਾਮ ਨਹੀਂ ਬਦਲਿਆ ਜਾ ਸਕਦਾ।';

  @override
  String get libraryRename => 'ਨਾਮ ਬਦਲੋ';

  @override
  String get libraryEditSongs => 'ਗੀਤ ਸੰਪਾਦਿਤ ਕਰੋ';

  @override
  String get libraryDeleteLikedError =>
      'ਪਸੰਦ ਕੀਤੇ ਗੀਤਾਂ ਦੀ ਪਲੇਲਿਸਟ ਨੂੰ ਮਿਟਾਇਆ ਨਹੀਂ ਜਾ ਸਕਦਾ।';

  @override
  String get libraryDelete => 'ਮਿਟਾਓ';

  @override
  String get libraryEditSongsTitle => 'ਗੀਤ ਸੰਪਾਦਿਤ ਕਰੋ';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count ਗੀਤ';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count ਗੀਤ';
  }

  @override
  String get libraryCancel => 'ਰੱਦ ਕਰੋ';

  @override
  String get librarySave => 'ਸੇਵ ਕਰੋ';

  @override
  String get libraryNoSongs => 'ਇਸ ਪਲੇਲਿਸਟ ਵਿੱਚ ਕੋਈ ਗੀਤ ਨਹੀਂ ਹਨ।';

  @override
  String get libraryAddOptionsTitle => 'ਲਾਇਬ੍ਰੇਰੀ ਵਿੱਚ ਸ਼ਾਮਲ ਕਰੋ';

  @override
  String get libraryAddOptionsDesc =>
      'ਚੁਣੋ ਕਿ ਤੁਸੀਂ ਆਪਣਾ Pulse ਕਿਵੇਂ ਵਧਾਉਣਾ ਚਾਹੁੰਦੇ ਹੋ';

  @override
  String get libraryImportPulse => 'Pulse ਤੋਂ ਆਯਾਤ ਕਰੋ';

  @override
  String get libraryImportPulseDesc => 'Pulse ਪਲੇਲਿਸਟ URL ਪੇਸਟ ਕਰੋ';

  @override
  String get libraryImportYtm => 'YT Music ਤੋਂ ਆਯਾਤ ਕਰੋ';

  @override
  String get libraryImportYtmDesc => 'ਜਨਤਕ ਪਲੇਲਿਸਟ URL ਪੇਸਟ ਕਰੋ';

  @override
  String get libraryImportSpotify => 'Spotify ਤੋਂ ਆਯਾਤ ਕਰੋ';

  @override
  String get libraryImportSpotifyDesc => 'ਆਪਣਾ Spotify ਕਨੈਕਟ ਕਰੋ';

  @override
  String get libraryClose => 'ਬੰਦ ਕਰੋ';

  @override
  String get libraryImportYtmFull => 'YouTube Music ਤੋਂ ਆਯਾਤ ਕਰੋ';

  @override
  String get libraryImportSpotifyFull => 'Spotify ਤੋਂ ਆਯਾਤ ਕਰੋ (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'ਜਨਤਕ YouTube Music ਪਲੇਲਿਸਟ URL ਇੱਥੇ ਪੇਸਟ ਕਰੋ';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'ਜਨਤਕ Spotify ਪਲੇਲਿਸਟ URL ਇੱਥੇ ਪੇਸਟ ਕਰੋ';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Pulse ਪਲੇਲਿਸਟ ਆਯਾਤ ਕਰਨ ਵਿੱਚ ਅਸਫਲ';

  @override
  String get importErrorPlaylist => 'ਪਲੇਲਿਸਟ ਆਯਾਤ ਕਰਨ ਵਿੱਚ ਗਲਤੀ';

  @override
  String get importErrorHighlyPopulated =>
      'ਪਲੇਲਿਸਟ ਬਹੁਤ ਵੱਡੀ ਹੈ, ਸਮਾਂ ਲੱਗ ਸਕਦਾ ਹੈ।';

  @override
  String get libraryImportBtn => 'ਆਯਾਤ ਕਰੋ';

  @override
  String get libraryCreateTitle => 'ਨਵੀਂ ਪਲੇਲਿਸਟ';

  @override
  String get libraryCreateDesc => 'ਇਸ ਪਲੇਲਿਸਟ ਦਾ ਨਾਮ ਕੀ ਰੱਖਣਾ ਹੈ?';

  @override
  String get libraryCreateHint => 'ਉਦਾਹਰਨ: ਰਾਤ ਦਾ ਸਫ਼ਰ';

  @override
  String get libraryCreateBtn => 'ਬਣਾਓ';

  @override
  String get libraryRenameTitle => 'ਪਲੇਲਿਸਟ ਦਾ ਨਾਮ ਬਦਲੋ';

  @override
  String get libraryRenameDesc => 'ਆਪਣੀ ਪਲੇਲਿਸਟ ਲਈ ਨਵਾਂ ਨਾਮ ਟਾਈਪ ਕਰੋ।';

  @override
  String get libraryRenameBtn => 'ਨਾਮ ਬਦਲੋ';

  @override
  String get libraryDeleteTitle => 'ਪਲੇਲਿਸਟ ਮਿਟਾਓ?';

  @override
  String libraryDeleteDesc(String name) {
    return 'ਕੀ ਤੁਸੀਂ ਯਕੀਨੀ ਤੌਰ \'ਤੇ \'$name\' ਨੂੰ ਮਿਟਾਉਣਾ ਚਾਹੁੰਦੇ ਹੋ? ਇਹ ਪਲੇਲਿਸਟ ਹਮੇਸ਼ਾ ਲਈ ਖਤਮ ਹੋ ਜਾਵੇਗੀ।';
  }

  @override
  String get libraryDeleteBtn => 'ਮਿਟਾਓ';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'ਤਾਜ਼ਾ';

  @override
  String librarySongsCount(String count) {
    return '$count ਗੀਤ';
  }

  @override
  String get libraryComingSoon => 'ਜਲਦੀ ਆ ਰਿਹਾ ਹੈ';

  @override
  String get loginErrName => 'ਕਿਰਪਾ ਕਰਕੇ ਆਪਣਾ ਨਾਮ ਟਾਈਪ ਕਰੋ';

  @override
  String get loginErrEmail => 'ਕਿਰਪਾ ਕਰਕੇ ਆਪਣੀ ਈਮੇਲ ਟਾਈਪ ਕਰੋ';

  @override
  String get loginErrPassword => 'ਕਿਰਪਾ ਕਰਕੇ ਆਪਣਾ ਪਾਸਵਰਡ ਟਾਈਪ ਕਰੋ';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'ਹਰ ਬੀਟ ਨੂੰ ਮਹਿਸੂਸ ਕਰੋ!';

  @override
  String get loginMadeWithHeartBy => '❤️ ਨਾਲ ਬਣਾਇਆ: ';

  @override
  String get loginAuthorName => 'ਆਸ਼ੂਤੋਸ਼ ਪਾਠਕ';

  @override
  String get loginHintName => 'ਤੁਹਾਡਾ ਨਾਮ';

  @override
  String get loginHintEmail => 'ਈਮੇਲ ਪਤਾ';

  @override
  String get loginHintPassword => 'ਪਾਸਵਰਡ';

  @override
  String get loginErrEmailReset => 'ਪਾਸਵਰਡ ਰੀਸੈਟ ਕਰਨ ਲਈ ਈਮੇਲ ਟਾਈਪ ਕਰੋ';

  @override
  String get loginResetSent =>
      'ਪਾਸਵਰਡ ਰੀਸੈਟ ਈਮੇਲ ਭੇਜ ਦਿੱਤੀ ਗਈ! ਆਪਣਾ ਇਨਬਾਕਸ ਚੈੱਕ ਕਰੋ।';

  @override
  String get loginForgotPwd => 'ਪਾਸਵਰਡ ਭੁੱਲ ਗਏ?';

  @override
  String get loginBtnSignup => 'ਖਾਤਾ ਬਣਾਓ';

  @override
  String get loginBtnSignin => 'ਸਾਈਨ ਇਨ ਕਰੋ';

  @override
  String get loginToggleHaveAccount =>
      'ਕੀ ਤੁਹਾਡੇ ਕੋਲ ਪਹਿਲਾਂ ਹੀ Pulse ਖਾਤਾ ਹੈ? ';

  @override
  String get loginToggleNoAccount => 'ਕੀ Pulse ਖਾਤਾ ਨਹੀਂ ਹੈ? ';

  @override
  String get loginToggleSignin => 'ਸਾਈਨ ਇਨ ਕਰੋ';

  @override
  String get loginToggleSignup => 'ਸਾਈਨ ਅੱਪ ਕਰੋ';

  @override
  String get offlineStillOffline =>
      'ਅਜੇ ਵੀ ਔਫਲਾਈਨ ਹੈ। ਕਿਰਪਾ ਕਰਕੇ ਆਪਣਾ ਕਨੈਕਸ਼ਨ ਚੈੱਕ ਕਰੋ।';

  @override
  String get offlineTitle => 'ਤੁਸੀਂ ਔਫਲਾਈਨ ਹੋ';

  @override
  String get offlineSubtitle =>
      'ਕੋਈ ਇੰਟਰਨੈਟ ਕਨੈਕਸ਼ਨ ਨਹੀਂ ਮਿਲਿਆ।\nਆਪਣਾ ਨੈੱਟਵਰਕ ਚੈੱਕ ਕਰੋ ਅਤੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get offlineChecking => 'ਚੈੱਕ ਕਰ ਰਿਹਾ ਹੈ...';

  @override
  String get offlineRetry => 'ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ';

  @override
  String get offlineGoToDownloads => 'ਡਾਊਨਲੋਡਸ \'ਤੇ ਜਾਓ';

  @override
  String get playerMadeWithHeartBy => '❤️ ਨਾਲ ਬਣਾਇਆ: ';

  @override
  String get playerAuthorName => 'ਆਸ਼ੂਤੋਸ਼ ਪਾਠਕ';

  @override
  String get playerSwipeForLyrics => 'ਬੋਲਾਂ ਲਈ ਸਵਾਈਪ ਕਰੋ';

  @override
  String get playerNoLyrics => 'ਕੋਈ ਬੋਲ ਉਪਲਬਧ ਨਹੀਂ';

  @override
  String get playerUpNext => 'ਅੱਗੇ ਚੱਲੇਗਾ';

  @override
  String get playerNoTracksInQueue => 'ਕਤਾਰ ਵਿੱਚ ਕੋਈ ਗੀਤ ਨਹੀਂ';

  @override
  String get playerNoMusicPlaying => 'ਕੋਈ ਸੰਗੀਤ ਨਹੀਂ ਚੱਲ ਰਿਹਾ';

  @override
  String get playerPickAVibe => 'ਆਪਣੀ ਲਾਇਬ੍ਰੇਰੀ ਜਾਂ ਹੋਮ ਤੋਂ ਗੀਤ ਚੁਣੋ';

  @override
  String get playerGoHome => 'ਹੋਮ \'ਤੇ ਜਾਓ';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'ਇਕੁਅਲਾਈਜ਼ਰ';

  @override
  String get playerEqCustom => 'ਕਸਟਮ';

  @override
  String get playlistDownloads => 'ਡਾਊਨਲੋਡਸ';

  @override
  String get playlistOffline => 'ਔਫਲਾਈਨ ਪਲੇਲਿਸਟ';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hoursਘੰਟੇ $minsਮਿੰਟ';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$minsਮਿੰਟ';
  }

  @override
  String get playlistFindOnPage => 'ਇਸ ਪੰਨੇ \'ਤੇ ਖੋਜੋ';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count ਗੀਤ • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'ਤਾਜ਼ਾ';

  @override
  String get playlistNoMatches => 'ਕੋਈ ਨਤੀਜਾ ਨਹੀਂ ਮਿਲਿਆ।';

  @override
  String get playlistNoTracks => 'ਇਸ ਪਲੇਲਿਸਟ ਵਿੱਚ ਕੋਈ ਗੀਤ ਨਹੀਂ ਹਨ।';

  @override
  String get playlistNoSongsYet => 'ਅਜੇ ਕੋਈ ਗੀਤ ਨਹੀਂ।';

  @override
  String get playlistSortRecentlyAdded => 'ਹਾਲ ਹੀ ਵਿੱਚ ਸ਼ਾਮਲ ਕੀਤੇ';

  @override
  String get playlistSortAlphabetical => 'ਅੱਖਰਾਂ ਅਨੁਸਾਰ';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ਗੀਤ',
      one: 'ਗੀਤ',
    );
    return '$count $_temp0 ਡਾਊਨਲੋਡ ਹੋ ਰਹੇ ਹਨ';
  }

  @override
  String get playlistView => 'ਦੇਖੋ';

  @override
  String get playlistAllDownloaded => 'ਸਾਰੇ ਗੀਤ ਪਹਿਲਾਂ ਹੀ ਡਾਊਨਲੋਡ ਹੋ ਚੁੱਕੇ ਹਨ';

  @override
  String playlistShareText(String name, String url) {
    return 'Pulse \'ਤੇ \'$name\' ਦੇਖੋ!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'ਡਾਊਨਲੋਡਸ ਵਿੱਚੋਂ ਹਟਾਓ';

  @override
  String get playlistRemoveFromPlaylist => 'ਪਲੇਲਿਸਟ ਵਿੱਚੋਂ ਹਟਾਓ';

  @override
  String get playlistLoadError => 'ਇਹ ਪਲੇਲਿਸਟ ਲੋਡ ਨਹੀਂ ਕਰ ਸਕਿਆ।';

  @override
  String get playlistGoBack => '← ਪਿੱਛੇ ਜਾਓ';

  @override
  String get profileNotLoggedIn => 'ਲੌਗ ਇਨ ਨਹੀਂ ਹੈ';

  @override
  String get profileSignIn => 'ਸਾਈਨ ਇਨ ਕਰੋ';

  @override
  String get profileDefaultUser => 'Pulse ਯੂਜ਼ਰ';

  @override
  String get profileEditProfile => 'ਸੰਪਾਦਿਤ ਕਰੋ';

  @override
  String get profileTimeframeDay => 'ਦਿਨ';

  @override
  String get profileTimeframeWeek => 'ਹਫ਼ਤਾ';

  @override
  String get profileTimeframeMonth => 'ਮਹੀਨਾ';

  @override
  String get profileTimeframeYear => 'ਸਾਲ';

  @override
  String get profileListeningTime => 'ਸੁਣਨ ਦਾ ਸਮਾਂ';

  @override
  String get profileToday => 'ਅੱਜ';

  @override
  String get profileThisWeek => 'ਇਸ ਹਫ਼ਤੇ';

  @override
  String get profileThisMonth => 'ਇਸ ਮਹੀਨੇ';

  @override
  String get profileThisYear => 'ਇਸ ਸਾਲ';

  @override
  String get profileDailyAvg => 'ਰੋਜ਼ਾਨਾ ਔਸਤ';

  @override
  String get profilePerDay => 'ਪ੍ਰਤੀ ਦਿਨ';

  @override
  String get profileLifetimeListening => 'ਉਮਰ ਭਰ ਸੁਣਨਾ';

  @override
  String get profileTotalTimeListened => 'Pulse \'ਤੇ ਸੰਗੀਤ ਸੁਣਨ ਦਾ ਕੁੱਲ ਸਮਾਂ';

  @override
  String get profileYourTopSongs => 'ਤੁਹਾਡੇ ਪਸੰਦੀਦਾ ਗੀਤ';

  @override
  String get profileListeningHistoryEmpty =>
      'ਸੁਣਨ ਦਾ ਇਤਿਹਾਸ ਇੱਥੇ ਦਿਖਾਈ ਦੇਵੇਗਾ।';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ਵਾਰ',
      one: 'ਵਾਰ',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => 'ਤੁਹਾਡੇ ਪਸੰਦੀਦਾ ਕਲਾਕਾਰ';

  @override
  String get profileTopArtistsEmpty =>
      'ਤੁਹਾਡੇ ਪਸੰਦੀਦਾ ਕਲਾਕਾਰ ਇੱਥੇ ਦਿਖਾਈ ਦੇਣਗੇ।';

  @override
  String get profileArtistLabel => 'ਕਲਾਕਾਰ';

  @override
  String get profileSignOut => 'ਸਾਈਨ ਆਊਟ ਕਰੋ';

  @override
  String profileVersion(String version) {
    return 'ਵਰਜਨ $version';
  }

  @override
  String get profileMadeWithHeartBy => '❤️ ਨਾਲ ਬਣਾਇਆ: ';

  @override
  String get profileAuthorName => 'ਆਸ਼ੂਤੋਸ਼ ਪਾਠਕ';

  @override
  String get profileEditProfileHeader => 'ਸੰਪਾਦਿਤ ਕਰੋ';

  @override
  String get profileDisplayName => 'ਨਾਮ';

  @override
  String get profileCancel => 'ਰੱਦ ਕਰੋ';

  @override
  String get profileSave => 'ਸੇਵ ਕਰੋ';

  @override
  String get profileChooseAvatar => 'ਅਵਤਾਰ ਚੁਣੋ';

  @override
  String get searchMicPermissionRequired =>
      'ਇਸ ਵਿਸ਼ੇਸ਼ਤਾ ਲਈ ਮਾਈਕ੍ਰੋਫੋਨ ਦੀ ਇਜਾਜ਼ਤ ਦੀ ਲੋੜ ਹੈ';

  @override
  String get searchUnknownSong => 'ਅਣਜਾਣ ਗੀਤ';

  @override
  String get searchUnknownArtist => 'ਅਣਜਾਣ ਕਲਾਕਾਰ';

  @override
  String get searchNoSongDetected => 'ਕੋਈ ਗੀਤ ਨਹੀਂ ਪਛਾਣਿਆ ਗਿਆ।';

  @override
  String searchError(String message) {
    return 'ਗਲਤੀ: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'ਆਵਾਜ਼ ਦੀ ਪਛਾਣ ਉਪਲਬਧ ਨਹੀਂ ਹੈ';

  @override
  String get searchHint => 'ਗੀਤ, ਕਲਾਕਾਰ, ਐਲਬਮਾਂ, ਪਲੇਲਿਸਟਾਂ…';

  @override
  String get searchRecentEmpty => 'ਤੁਹਾਡੀਆਂ ਤਾਜ਼ਾ ਖੋਜਾਂ ਇੱਥੇ ਦਿਖਾਈ ਦੇਣਗੀਆਂ';

  @override
  String get searchRecentSearches => 'ਤਾਜ਼ਾ ਖੋਜਾਂ';

  @override
  String get searchClearAll => 'ਸਭ ਸਾਫ਼ ਕਰੋ';

  @override
  String searchNoResultsFor(String query) {
    return '\'$query\' ਲਈ ਕੋਈ ਨਤੀਜਾ ਨਹੀਂ';
  }

  @override
  String get searchTryDifferentKeywords => 'ਵੱਖਰੇ ਸ਼ਬਦ ਅਜ਼ਮਾਓ';

  @override
  String get searchTopResult => 'ਸਿਖਰਲਾ ਨਤੀਜਾ';

  @override
  String get searchSongsLabel => 'ਗੀਤ';

  @override
  String get searchArtistsLabel => 'ਕਲਾਕਾਰ';

  @override
  String get searchAlbumsLabel => 'ਐਲਬਮਾਂ';

  @override
  String get searchPlaylistsLabel => 'ਪਲੇਲਿਸਟਾਂ';

  @override
  String get searchArtistLabel => 'ਕਲਾਕਾਰ';

  @override
  String get searchListening => 'ਸੁਣ ਰਿਹਾ ਹੈ...';

  @override
  String get searchSpeakNow => 'ਖੋਜਣ ਲਈ ਹੁਣੇ ਬੋਲੋ';

  @override
  String get searchCancel => 'ਰੱਦ ਕਰੋ';

  @override
  String get searchIdentifying => 'ਪਛਾਣ ਕਰ ਰਿਹਾ ਹੈ...';

  @override
  String get searchListeningForSong => 'ਗੀਤ ਸੁਣ ਰਿਹਾ ਹੈ...';

  @override
  String get settingsTitle => 'ਸੈਟਿੰਗਾਂ';

  @override
  String get settingsStreamingQuality => 'ਸਟ੍ਰੀਮਿੰਗ ਕੁਆਲਿਟੀ';

  @override
  String get settingsQualityAutomatic => 'ਆਟੋਮੈਟਿਕ';

  @override
  String get settingsQualityLow => 'ਘੱਟ';

  @override
  String get settingsQualityNormal => 'ਸਧਾਰਨ';

  @override
  String get settingsQualityHigh => 'ਉੱਚ';

  @override
  String get settingsDownloadQuality => 'ਡਾਊਨਲੋਡ ਕੁਆਲਿਟੀ';

  @override
  String get settingsPlayback => 'ਪਲੇਬੈਕ';

  @override
  String get settingsCrossfade => 'ਕ੍ਰੌਸਫੇਡ';

  @override
  String get settingsCrossfadeDesc => 'ਨਿਰਵਿਘਨ ਤਬਦੀਲੀ ਲਈ ਟਰੈਕਾਂ ਨੂੰ ਓਵਰਲੈਪ ਕਰੋ';

  @override
  String get settingsDataUsage => 'ਡਾਟਾ ਵਰਤੋਂ';

  @override
  String get settingsDataSaver => 'ਡਾਟਾ ਸੇਵਰ';

  @override
  String get settingsDataSaverDesc =>
      'ਮੋਬਾਈਲ ਡਾਟਾ \'ਤੇ ਘੱਟ ਗੁਣਵੱਤਾ ਵਿੱਚ ਸਟ੍ਰੀਮ ਕਰੋ';

  @override
  String get settingsAppearance => 'ਦਿੱਖ';

  @override
  String get settingsLanguage => 'ਭਾਸ਼ਾ';

  @override
  String get settingsCustomAccent => 'ਕਸਟਮ ਰੰਗ';

  @override
  String get settingsSaturation => 'ਸੈਚੂਰੇਸ਼ਨ';

  @override
  String get settingsBrightness => 'ਬ੍ਰਾਈਟਨੈੱਸ';

  @override
  String get settingsResetDefault => 'ਡਿਫੌਲਟ ਰੀਸੈਟ ਕਰੋ';

  @override
  String get playlistSheetTitle => 'ਪਲੇਲਿਸਟ ਵਿੱਚ ਸ਼ਾਮਲ ਕਰੋ';

  @override
  String get playlistSheetNewPlaylist => 'ਨਵੀਂ ਪਲੇਲਿਸਟ';

  @override
  String get playlistSheetNoPlaylists => 'ਅਜੇ ਕੋਈ ਪਲੇਲਿਸਟ ਨਹੀਂ';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ਗੀਤ',
      one: 'ਗੀਤ',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => 'ਪਲੇਲਿਸਟ ਦਾ ਨਾਮ';

  @override
  String get playlistSheetCancel => 'ਰੱਦ ਕਰੋ';

  @override
  String playlistSheetAddedTo(String name) {
    return '$name ਵਿੱਚ ਸ਼ਾਮਲ ਕੀਤਾ';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'ਪਲੇਲਿਸਟ ਬਣਾਉਣ ਵਿੱਚ ਅਸਫਲ: ਪ੍ਰਮਾਣੀਕਰਨ ਗਲਤੀ';

  @override
  String playlistSheetCreateFail(String error) {
    return 'ਪਲੇਲਿਸਟ ਬਣਾਉਣ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String get playlistSheetCreate => 'ਬਣਾਓ';

  @override
  String get appUpdateAvailable => 'ਅੱਪਡੇਟ ਉਪਲਬਧ';

  @override
  String appUpdateDesc(String version) {
    return 'ਵਰਜਨ $version ਉਪਲਬਧ ਹੈ! ਨਵੀਆਂ ਵਿਸ਼ੇਸ਼ਤਾਵਾਂ ਪ੍ਰਾਪਤ ਕਰਨ ਲਈ ਹੁਣੇ ਅੱਪਡੇਟ ਕਰੋ।';
  }

  @override
  String get appUpdateDownload => 'ਅੱਪਡੇਟ ਡਾਊਨਲੋਡ ਕਰੋ';

  @override
  String get navHome => 'ਹੋਮ';

  @override
  String get navLibrary => 'ਲਾਇਬ੍ਰੇਰੀ';

  @override
  String get navSearch => 'ਖੋਜ';

  @override
  String get navSettings => 'ਸੈਟਿੰਗਾਂ';

  @override
  String get navProfile => 'ਪ੍ਰੋਫਾਈਲ';

  @override
  String get artistSelect => 'ਕਲਾਕਾਰ ਚੁਣੋ';

  @override
  String get songActionQueue => 'ਕਤਾਰ ਵਿੱਚ ਸ਼ਾਮਲ ਕਰੋ';

  @override
  String get songActionPlaylist => 'ਪਲੇਲਿਸਟ ਵਿੱਚ ਸ਼ਾਮਲ ਕਰੋ';

  @override
  String get songActionFinding => 'ਲੱਭ ਰਿਹਾ ਹੈ...';

  @override
  String get songActionAlbum => 'ਐਲਬਮ \'ਤੇ ਜਾਓ';

  @override
  String get songActionArtist => 'ਕਲਾਕਾਰ \'ਤੇ ਜਾਓ';

  @override
  String get songActionRemovePlaylist => 'ਪਲੇਲਿਸਟ ਵਿੱਚੋਂ ਹਟਾਓ';

  @override
  String get songActionRemoveDownload => 'ਡਾਊਨਲੋਡਸ ਵਿੱਚੋਂ ਹਟਾਓ';

  @override
  String get songActionDownloadChecking => 'ਚੈੱਕ ਕਰ ਰਿਹਾ ਹੈ...';

  @override
  String get songActionDownloading => 'ਡਾਊਨਲੋਡ ਹੋ ਰਿਹਾ ਹੈ...';

  @override
  String get songActionDownloaded => 'ਡਾਊਨਲੋਡ ਹੋ ਗਿਆ!';

  @override
  String get songActionDownloadAlready => 'ਪਹਿਲਾਂ ਹੀ ਡਾਊਨਲੋਡ ਕੀਤਾ ਹੈ';

  @override
  String get songActionDownloadFailed => 'ਡਾਊਨਲੋਡ ਅਸਫਲ';

  @override
  String get songActionDownload => 'ਡਾਊਨਲੋਡ ਕਰੋ';

  @override
  String get songActionDownloadingSnack => 'ਡਾਊਨਲੋਡ ਕਰ ਰਿਹਾ ਹੈ';

  @override
  String get songActionView => 'ਦੇਖੋ';

  @override
  String get spotifyImportTitle => 'Spotify ਤੋਂ ਆਯਾਤ ਕਰੋ';

  @override
  String get spotifyImportSubtitle => 'ਆਪਣੀ ਪਲੇਲਿਸਟ ਦਾ ਆਕਾਰ ਚੁਣੋ';

  @override
  String get spotifyChoiceSmallTitle => '੧੦੦ ਜਾਂ ਘੱਟ ਗੀਤ';

  @override
  String get spotifyChoiceSmallDesc => 'ਜਨਤਕ Spotify ਪਲੇਲਿਸਟ URL ਪੇਸਟ ਕਰੋ।';

  @override
  String get spotifyChoiceLargeTitle => '੧੦੦ ਤੋਂ ਵੱਧ ਗੀਤ';

  @override
  String get spotifyChoiceLargeDesc =>
      'ਅਸੀਮਤ ਗੀਤ ਆਯਾਤ ਕਰਨ ਲਈ ਆਪਣੀ ਖੁਦ ਦੀ Spotify Developer App ਕਨੈਕਟ ਕਰੋ।';

  @override
  String get cancelButton => 'ਰੱਦ ਕਰੋ';

  @override
  String get spotifyPlaylistsTitle => 'ਤੁਹਾਡੀਆਂ Spotify ਪਲੇਲਿਸਟਾਂ';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'ਗਲਤੀ: $error\nਯਕੀਨੀ ਬਣਾਓ ਕਿ ਤੁਹਾਡਾ Client ID ਸਹੀ ਹੈ।';
  }

  @override
  String get spotifyPlaylistsEmpty =>
      'ਤੁਹਾਡੀ ਲਾਇਬ੍ਰੇਰੀ ਵਿੱਚ ਕੋਈ ਪਲੇਲਿਸਟ ਨਹੀਂ ਮਿਲੀ';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count ਟਰੈਕ';
  }

  @override
  String get spotifyPlaylistsImport => 'ਆਯਾਤ ਕਰੋ';

  @override
  String get audioPlaybackFailed =>
      'ਪਲੇਬੈਕ ਅਸਫਲ। ਆਪਣਾ ਇੰਟਰਨੈਟ ਕਨੈਕਸ਼ਨ ਚੈੱਕ ਕਰੋ।';

  @override
  String get audioControlPrevious => 'ਪਿਛਲਾ';

  @override
  String get audioControlPause => 'ਰੋਕੋ';

  @override
  String get audioControlPlay => 'ਚਲਾਓ';

  @override
  String get audioControlNext => 'ਅਗਲਾ';

  @override
  String get audioControlUnlike => 'ਨਾਪਸੰਦ';

  @override
  String get audioControlLike => 'ਪਸੰਦ';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'ਮੂਲ ਜਵਾਬ: $data\n\nਫਾਲਬੈਕ: $error';
  }

  @override
  String get apiErrorInvalidClient => 'ਅਵੈਧ ਕਲਾਇੰਟ ਜਾਂ ਕਲਾਇੰਟ ਸੀਕਰੇਟ।';

  @override
  String get apiErrorBadRequest =>
      'ਬੈਡ ਰਿਕੁਐਸਟ। ਕਿਰਪਾ ਕਰਕੇ ਆਪਣੇ ਵੇਰਵੇ ਚੈੱਕ ਕਰੋ।';

  @override
  String get apiErrorUnauthorized => 'ਅਣਅਧਿਕਾਰਤ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਲੌਗ ਇਨ ਕਰੋ।';

  @override
  String get apiErrorForbidden => 'ਵਰਜਿਤ। ਤੁਹਾਨੂੰ ਪਹੁੰਚ ਨਹੀਂ ਹੈ।';

  @override
  String get apiErrorNotFound => 'ਸਰੋਤ ਨਹੀਂ ਮਿਲਿਆ।';

  @override
  String get apiErrorEmailInUse => 'ਇਹ ਈਮੇਲ ਪਤਾ ਪਹਿਲਾਂ ਹੀ ਵਰਤੋਂ ਵਿੱਚ ਹੈ।';

  @override
  String get apiErrorUserNotFound => 'ਇਸ ਈਮੇਲ ਨਾਲ ਕੋਈ ਖਾਤਾ ਨਹੀਂ ਮਿਲਿਆ।';

  @override
  String get apiErrorWrongPassword => 'ਗਲਤ ਪਾਸਵਰਡ।';

  @override
  String get apiErrorInvalidCredential =>
      'ਲੌਗਇਨ ਅਸਫਲ। ਕਿਰਪਾ ਕਰਕੇ ਆਪਣੇ ਪ੍ਰਮਾਣ-ਪੱਤਰ ਚੈੱਕ ਕਰੋ।';

  @override
  String get apiErrorNetwork =>
      'ਨੈੱਟਵਰਕ ਗਲਤੀ। ਕਿਰਪਾ ਕਰਕੇ ਆਪਣਾ ਕਨੈਕਸ਼ਨ ਚੈੱਕ ਕਰੋ।';

  @override
  String get apiErrorSocketTimeout =>
      'ਕਨੈਕਸ਼ਨ ਸਮਾਂ ਸਮਾਪਤ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get apiErrorTooManyRequests =>
      'ਬਹੁਤ ਜ਼ਿਆਦਾ ਬੇਨਤੀਆਂ। ਕਿਰਪਾ ਕਰਕੇ ਕੁਝ ਸਮਾਂ ਉਡੀਕ ਕਰੋ ਅਤੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get apiErrorServerError =>
      'ਸਰਵਰ ਗਲਤੀ। ਕਿਰਪਾ ਕਰਕੇ ਬਾਅਦ ਵਿੱਚ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get apiErrorInvalidEmail => 'ਕਿਰਪਾ ਕਰਕੇ ਸਹੀ ਈਮੇਲ ਪਤਾ ਟਾਈਪ ਕਰੋ।';

  @override
  String get apiErrorWeakPassword =>
      'ਪਾਸਵਰਡ ਬਹੁਤ ਕਮਜ਼ੋਰ ਹੈ। ਘੱਟੋ-ਘੱਟ ੬ ਅੱਖਰ ਵਰਤੋ।';

  @override
  String get apiErrorTooManyAttempts =>
      'ਬਹੁਤ ਜ਼ਿਆਦਾ ਅਸਫਲ ਕੋਸ਼ਿਸ਼ਾਂ। ਕਿਰਪਾ ਕਰਕੇ ਬਾਅਦ ਵਿੱਚ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get homeForgottenFavorites => 'ਭੁੱਲੇ ਹੋਏ ਮਨਪਸੰਦ';

  @override
  String get artistShowAll => 'ਸਭ ਦਿਖਾਓ';

  @override
  String get homeTopTracks => 'ਟੌਪ ਟਰੈਕ';
}
