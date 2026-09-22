// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'متعلق';

  @override
  String get artistPopular => 'مقبول';

  @override
  String get artistAlbums => 'البمز';

  @override
  String get artistSinglesAndEPs => 'سنگلز اور EP';

  @override
  String artistSubscribersCount(String count) {
    return '$count سبسکرائبرز';
  }

  @override
  String get artistPlayAll => 'سب چلائیں';

  @override
  String get artistLoadError => 'فنکار لوڈ نہیں ہو سکا';

  @override
  String get artistGoBack => 'واپس جائیں';

  @override
  String adminChatFailedToReply(String error) {
    return 'جواب دینے میں ناکام: $error';
  }

  @override
  String get adminChatSupportChat => 'سپورٹ چیٹ';

  @override
  String adminChatError(String error) {
    return 'خرابی: $error';
  }

  @override
  String get adminChatNoHistory => 'کوئی پچھلی بات چیت نہیں ہے۔';

  @override
  String get adminChatSupportYou => 'سپورٹ (آپ)';

  @override
  String get adminChatTypeReply => 'اپنا جواب ٹائپ کریں...';

  @override
  String get broadcastSuccess => 'اعلان کامیابی سے نشر ہو گیا!';

  @override
  String broadcastFailed(String error) {
    return 'نشر کرنے میں ناکام: $error';
  }

  @override
  String get broadcastTitle => 'عالمی اعلان';

  @override
  String get broadcastSubtitle => 'تمام صارفین کو بھیجا گیا';

  @override
  String get broadcastWarning => 'یہاں بھیجا گیا پیغام ہر کوئی دیکھ سکے گا۔';

  @override
  String broadcastError(String error) {
    return 'خرابی: $error';
  }

  @override
  String get broadcastNoHistory => 'کوئی پچھلا اعلان نہیں ہے۔';

  @override
  String get broadcastTypeMessage => 'عالمی اعلان ٹائپ کریں...';

  @override
  String commFailedToSend(String error) {
    return 'بھیجنے میں ناکام: $error';
  }

  @override
  String get commAdminDashboard => 'ایڈمن ڈیش بورڈ';

  @override
  String get commAdminSupport => 'ایڈمن سپورٹ';

  @override
  String get commAlwaysHere => 'مدد کے لیے ہمیشہ حاضر ہیں';

  @override
  String get commWelcomeTitle => 'ہیلو! 👋 میں آشوتوش پاٹھک ہوں';

  @override
  String get commWelcomeSubtitle => 'Pulse کا ڈیولپر';

  @override
  String get commWelcomeBody1 =>
      'مجھے امید ہے کہ آپ اشتہارات یا سبسکرپشن کی رکاوٹوں کے بغیر اپنی پسندیدہ موسیقی سے لطف اندوز ہو رہے ہیں۔ موسیقی صرف امیروں تک محدود نہیں ہونی چاہیے۔\n\nیہ سیکشن ہمارے براہ راست رابطے کے لیے ہے۔\n\nآپ مجھے بتا سکتے ہیں:';

  @override
  String get commBullet1 => 'آپ کی رائے';

  @override
  String get commBullet2 => 'خرابی کی رپورٹیں';

  @override
  String get commBullet3 => 'نئے فیچرز کی تجاویز';

  @override
  String get commWelcomeBody2 =>
      'میں خود ہر پیغام پڑھتا ہوں اور آپ کی تجاویز سے ایپ کو مزید بہتر بناؤں گا۔\n\nکیا آپ کے پاس کسی ایسی ایپ کا آئیڈیا ہے جو سبسکرپشن کے پیچھے چھپی ہو؟ مجھے بتائیں! اگر ممکن ہوا تو میں اسے سب کے لیے بناؤں گا۔\n\nاس سفر میں ساتھ رہنے کے لیے شکریہ۔ ❤️';

  @override
  String commError(String error) {
    return 'خرابی: $error';
  }

  @override
  String get commNoMessages => 'ابھی تک کوئی پیغام نہیں';

  @override
  String get commNoMessagesDesc =>
      'ہماری سپورٹ ٹیم کو پیغام بھیجیں یا بعد میں دوبارہ چیک کریں۔';

  @override
  String get commMessageSupportHint => 'سپورٹ ٹیم کو لکھیں...';

  @override
  String get commGlobalAnnouncements => 'عالمی اعلانات';

  @override
  String get commSendMessagesToAll => 'سب کو پیغام بھیجیں';

  @override
  String get homeGreetingMorning => 'صبح بخیر،';

  @override
  String get homeGreetingAfternoon => 'دوپہر بخیر،';

  @override
  String get homeGreetingEvening => 'شام بخیر،';

  @override
  String get homeMember => 'رکن';

  @override
  String get homeRecentPlaylists => 'حالیہ پلے لسٹس';

  @override
  String get homeRecentlyPlayed => 'حال ہی میں چلائے گئے';

  @override
  String get homeSpeedDial => 'اسپیڈ ڈائل';

  @override
  String get homeNoContent => 'کوئی مواد نہیں';

  @override
  String get homeRefresh => 'ریفریش';

  @override
  String get homeLoadError => 'موسیقی لوڈ نہیں ہو سکی۔';

  @override
  String get homeRetry => 'دوبارہ کوشش کریں';

  @override
  String get importSuccess => 'Spotify کامیابی کے ساتھ منسلک ہو گیا!';

  @override
  String importFailed(String error) {
    return 'منسلک کرنے میں ناکام: $error';
  }

  @override
  String get importTitle => 'Spotify منسلک کریں';

  @override
  String get importSetupTitle => 'Spotify سیٹ اپ';

  @override
  String get importSetupDesc =>
      'Spotify کی پابندیوں کو دور کر کے اپنی پلے لسٹس جلدی امپورٹ کرنے کے لیے اپنی ڈیولپر کی (key) استعمال کریں۔ ان مراحل پر عمل کریں:';

  @override
  String get importStep1 => 'Spotify Developer Dashboard کھولیں۔';

  @override
  String get importStep2 => 'لاگ ان کریں اور \"Create app\" پر کلک کریں۔';

  @override
  String get importStep3 => 'ایپ کا نام اور تفصیل دیں۔';

  @override
  String get importStep4 => '\"Redirect URIs\" کے نیچے یہ مخصوص URL پیسٹ کریں:';

  @override
  String get importRedirectCopied => 'ری ڈائریکٹ URI کاپی ہو گیا!';

  @override
  String get importStep5 =>
      'ایپ محفوظ کریں، سیٹنگز سے اپنی \"Client ID\" کاپی کریں اور نیچے پیسٹ کریں۔';

  @override
  String get importImportant =>
      'اہم: اس ڈیولپر ایپ کو بنانے کے لیے استعمال ہونے والے Spotify اکاؤنٹ میں فعال پریمیم سبسکرپشن ہونا ضروری ہے۔';

  @override
  String get importClientIdHint => 'اپنی Spotify Client ID یہاں پیسٹ کریں...';

  @override
  String get importConnectButton => 'منسلک کریں اور لائبریری لوڈ کریں';

  @override
  String get downloadingNoActive => 'کوئی فعال ڈاؤن لوڈ نہیں ہے';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'ڈاؤن لوڈز';

  @override
  String downloadsStats(String count, String size) {
    return '$count گانے • $size';
  }

  @override
  String get downloadsNoOffline => 'کوئی آف لائن گانے نہیں ہیں';

  @override
  String get downloadsNoOfflineDesc =>
      'آپ کے ڈاؤن لوڈ کردہ گانے یہاں ظاہر ہوں گے';

  @override
  String get downloadsClearAllTitle => 'سب کچھ صاف کریں؟';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'یہ $count گانوں کو ڈیلیٹ کر دے گا اور $size اسٹوریج خالی کر دے گا۔';
  }

  @override
  String get downloadsCancel => 'منسوخ کریں';

  @override
  String get downloadsClearAll => 'سب صاف کریں';

  @override
  String downloadsSongsCount(String count) {
    return '$count گانے';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count گانا';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'مین ڈاؤن لوڈ پلے لسٹ کا نام نہیں بدلا جا سکتا۔';

  @override
  String get downloadsRename => 'نام تبدیل کریں';

  @override
  String get downloadsEditSongs => 'گانے ایڈٹ کریں';

  @override
  String get downloadsDelete => 'ڈیلیٹ کریں';

  @override
  String get downloadsRenamePlaylistTitle => 'پلے لسٹ کا نام تبدیل کریں';

  @override
  String get downloadsRenamePlaylistDesc => 'پلے لسٹ کا نیا نام لکھیں۔';

  @override
  String get downloadsDeletePlaylistTitle => 'پلے لسٹ ڈیلیٹ کریں؟';

  @override
  String get downloadsDeleteMasterDesc =>
      'کیا آپ کو یقین ہے؟ آپ اپنے تمام ڈاؤن لوڈ کردہ گانے اور پلے لسٹس ہمیشہ کے لیے کھو دیں گے۔';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'کیا آپ واقعی \"$name\" کو ڈیلیٹ کرنا چاہتے ہیں؟ یہ پلے لسٹ ہمیشہ کے لیے ختم ہو جائے گی۔';
  }

  @override
  String get downloadsSave => 'محفوظ کریں';

  @override
  String get downloadsNoSongs => 'اس پلے لسٹ میں کوئی گانے نہیں ہیں۔';

  @override
  String get libraryTitle => 'لائبریری';

  @override
  String get libraryPauseAll => 'سب روکیں';

  @override
  String get libraryResumeAll => 'سب دوبارہ شروع کریں';

  @override
  String get libraryTabPlaylists => 'پلے لسٹس';

  @override
  String get libraryTabDownloads => 'ڈاؤن لوڈز';

  @override
  String get libraryTabDownloading => 'ڈاؤن لوڈ ہو رہا ہے';

  @override
  String libraryImportedTask(String name) {
    return '$name امپورٹ ہو گیا';
  }

  @override
  String get libraryImportWaiting => 'انتظار کر رہا ہے...';

  @override
  String get libraryImportFetching => 'پلے لسٹ لا رہا ہے...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total پروسیس ہو گئے · $matched ملے';
  }

  @override
  String get libraryImportSaving => 'لائبریری میں محفوظ کر رہا ہے...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched گانے شامل کیے گئے · بند کرنے کے لیے × دبائیں';
  }

  @override
  String get libraryImportDoneAll =>
      'تمام گانے شامل کر دیے گئے · بند کرنے کے لیے × دبائیں';

  @override
  String get libraryAddButton => 'شامل کریں';

  @override
  String get librarySortRecent => 'حال ہی میں شامل کیے گئے';

  @override
  String get librarySortAlpha => 'حروف تہجی کے لحاظ سے';

  @override
  String get libraryEmptyTitle => 'آپ کی لائبریری خالی ہے۔';

  @override
  String get libraryEmptyDesc =>
      'اپنی پہلی Pulse شروع کرنے کے لیے \"شامل کریں\" پر کلک کریں۔';

  @override
  String get libraryRenameLikedError =>
      'Liked Songs پلے لسٹ کا نام نہیں بدلا جا سکتا۔';

  @override
  String get libraryRename => 'نام تبدیل کریں';

  @override
  String get libraryEditSongs => 'گانے ایڈٹ کریں';

  @override
  String get libraryDeleteLikedError =>
      'Liked Songs پلے لسٹ کو ڈیلیٹ نہیں کیا جا سکتا۔';

  @override
  String get libraryDelete => 'ڈیلیٹ کریں';

  @override
  String get libraryEditSongsTitle => 'گانے ایڈٹ کریں';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count گانا';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count گانے';
  }

  @override
  String get libraryCancel => 'منسوخ کریں';

  @override
  String get librarySave => 'محفوظ کریں';

  @override
  String get libraryNoSongs => 'اس پلے لسٹ میں کوئی گانے نہیں ہیں۔';

  @override
  String get libraryAddOptionsTitle => 'لائبریری میں شامل کریں';

  @override
  String get libraryAddOptionsDesc =>
      'اپنی Pulse لائبریری کو بڑھانے کا طریقہ منتخب کریں';

  @override
  String get libraryImportPulse => 'Pulse سے امپورٹ کریں';

  @override
  String get libraryImportPulseDesc => 'Pulse پلے لسٹ کا URL پیسٹ کریں';

  @override
  String get libraryImportYtm => 'YT Music سے امپورٹ کریں';

  @override
  String get libraryImportYtmDesc => 'پبلک پلے لسٹ کا URL پیسٹ کریں';

  @override
  String get libraryImportSpotify => 'Spotify سے امپورٹ کریں';

  @override
  String get libraryImportSpotifyDesc => 'اپنا Spotify منسلک کریں';

  @override
  String get libraryClose => 'بند کریں';

  @override
  String get libraryImportYtmFull => 'YouTube Music سے امپورٹ کریں';

  @override
  String get libraryImportSpotifyFull => 'Spotify سے امپورٹ کریں (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'پبلک YouTube Music پلے لسٹ یا البم کا URL پیسٹ کریں';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'نیچے پبلک Spotify پلے لسٹ کا URL پیسٹ کریں';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Pulse پلے لسٹ امپورٹ نہیں کی جا سکی';

  @override
  String get importErrorPlaylist => 'پلے لسٹ امپورٹ کرنے میں خرابی';

  @override
  String get importErrorHighlyPopulated =>
      'پلے لسٹ بہت بڑی ہے، لانے میں کچھ وقت لگ سکتا ہے۔';

  @override
  String get libraryImportBtn => 'امپورٹ کریں';

  @override
  String get libraryCreateTitle => 'نئی پلے لسٹ';

  @override
  String get libraryCreateDesc =>
      'آپ اپنی نئی پلے لسٹ کا کیا نام رکھنا چاہیں گے؟';

  @override
  String get libraryCreateHint => 'مثال کے طور پر: Midnight Rides';

  @override
  String get libraryCreateBtn => 'بنائیں';

  @override
  String get libraryRenameTitle => 'پلے لسٹ کا نام تبدیل کریں';

  @override
  String get libraryRenameDesc => 'پلے لسٹ کا نیا نام لکھیں۔';

  @override
  String get libraryRenameBtn => 'نام تبدیل کریں';

  @override
  String get libraryDeleteTitle => 'پلے لسٹ ڈیلیٹ کریں؟';

  @override
  String libraryDeleteDesc(String name) {
    return 'کیا آپ واقعی \"$name\" کو ڈیلیٹ کرنا چاہتے ہیں؟ یہ پلے لسٹ ہمیشہ کے لیے ختم ہو جائے گی۔';
  }

  @override
  String get libraryDeleteBtn => 'ڈیلیٹ کریں';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'حالیہ';

  @override
  String librarySongsCount(String count) {
    return '$count گانے';
  }

  @override
  String get libraryComingSoon => 'جلد آرہا ہے';

  @override
  String get loginErrName => 'براہ کرم اپنا نام درج کریں';

  @override
  String get loginErrEmail => 'براہ کرم اپنا ای میل درج کریں';

  @override
  String get loginErrPassword => 'براہ کرم اپنا پاس ورڈ درج کریں';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'ہر بیٹ کو محسوس کریں!';

  @override
  String get loginMadeWithHeartBy => 'محبت سے بنایا ہے: ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'آپ کا نام';

  @override
  String get loginHintEmail => 'ای میل ایڈریس';

  @override
  String get loginHintPassword => 'پاس ورڈ';

  @override
  String get loginErrEmailReset => 'پاس ورڈ ری سیٹ کرنے کے لیے ای میل درج کریں';

  @override
  String get loginResetSent =>
      'ری سیٹ ای میل بھیج دی گئی! اپنا ان باکس چیک کریں۔';

  @override
  String get loginForgotPwd => 'پاس ورڈ بھول گئے؟';

  @override
  String get loginBtnSignup => 'اکاؤنٹ بنائیں';

  @override
  String get loginBtnSignin => 'سائن ان کریں';

  @override
  String get loginToggleHaveAccount => 'کیا آپ کا پہلے سے Pulse اکاؤنٹ ہے؟ ';

  @override
  String get loginToggleNoAccount => 'کیا آپ کا Pulse اکاؤنٹ نہیں ہے؟ ';

  @override
  String get loginToggleSignin => 'سائن ان کریں';

  @override
  String get loginToggleSignup => 'سائن اپ کریں';

  @override
  String get offlineStillOffline => 'ابھی تک آف لائن ہیں۔ کنکشن چیک کریں۔';

  @override
  String get offlineTitle => 'آپ آف لائن ہیں';

  @override
  String get offlineSubtitle =>
      'کوئی انٹرنیٹ کنکشن نہیں ہے۔\nاپنا نیٹ ورک چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get offlineChecking => 'چیک کر رہا ہے...';

  @override
  String get offlineRetry => 'دوبارہ کوشش کریں';

  @override
  String get offlineGoToDownloads => 'ڈاؤن لوڈز پر جائیں';

  @override
  String get playerMadeWithHeartBy => 'محبت سے بنایا ہے: ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'لیرکس کے لیے سوائپ کریں';

  @override
  String get playerNoLyrics => 'کوئی لیرکس دستیاب نہیں ہیں';

  @override
  String get playerUpNext => 'اگلا';

  @override
  String get playerNoTracksInQueue => 'قطار میں کوئی گانے نہیں ہیں';

  @override
  String get playerNoMusicPlaying => 'کوئی موسیقی نہیں چل رہی ہے';

  @override
  String get playerPickAVibe => 'اپنی لائبریری یا ہوم سے ایک گانا منتخب کریں';

  @override
  String get playerGoHome => 'ہوم پر جائیں';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'ایکوئلائزر';

  @override
  String get playerEqCustom => 'اپنی مرضی کے مطابق';

  @override
  String get playlistDownloads => 'ڈاؤن لوڈز';

  @override
  String get playlistOffline => 'آف لائن پلے لسٹ';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hoursگھنٹے $minsمنٹ';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$minsمنٹ';
  }

  @override
  String get playlistFindOnPage => 'اس صفحے پر تلاش کریں';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count گانے • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'حالیہ';

  @override
  String get playlistNoMatches => 'کچھ نہیں ملا۔';

  @override
  String get playlistNoTracks => 'اس پلے لسٹ میں کوئی گانے نہیں ہیں۔';

  @override
  String get playlistNoSongsYet => 'ابھی تک کوئی گانے نہیں ہیں۔';

  @override
  String get playlistSortRecentlyAdded => 'حال ہی میں شامل کیے گئے';

  @override
  String get playlistSortAlphabetical => 'حروف تہجی کے لحاظ سے';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'گانے',
      one: 'گانا',
    );
    return '$count $_temp0 ڈاؤن لوڈ ہو رہے ہیں';
  }

  @override
  String get playlistView => 'دیکھیں';

  @override
  String get playlistAllDownloaded => 'تمام گانے پہلے ہی ڈاؤن لوڈ ہو چکے ہیں';

  @override
  String playlistShareText(String name, String url) {
    return 'Pulse پر \"$name\" سنیں!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'ڈاؤن لوڈز سے ہٹائیں';

  @override
  String get playlistRemoveFromPlaylist => 'پلے لسٹ سے ہٹائیں';

  @override
  String get playlistLoadError => 'یہ پلے لسٹ لوڈ نہیں کی جا سکی۔';

  @override
  String get playlistGoBack => '← واپس جائیں';

  @override
  String get profileNotLoggedIn => 'لاگ ان نہیں ہیں';

  @override
  String get profileSignIn => 'سائن ان کریں';

  @override
  String get profileDefaultUser => 'Pulse صارف';

  @override
  String get profileEditProfile => 'پروفائل ایڈٹ کریں';

  @override
  String get profileTimeframeDay => 'دن';

  @override
  String get profileTimeframeWeek => 'ہفتہ';

  @override
  String get profileTimeframeMonth => 'مہینہ';

  @override
  String get profileTimeframeYear => 'سال';

  @override
  String get profileListeningTime => 'سننے کا وقت';

  @override
  String get profileToday => 'آج';

  @override
  String get profileThisWeek => 'اس ہفتے';

  @override
  String get profileThisMonth => 'اس مہینے';

  @override
  String get profileThisYear => 'اس سال';

  @override
  String get profileDailyAvg => 'روزانہ کی اوسط';

  @override
  String get profilePerDay => 'فی دن';

  @override
  String get profileLifetimeListening => 'سننے کا کل وقت';

  @override
  String get profileTotalTimeListened => 'Pulse پر موسیقی سننے کا کل وقت';

  @override
  String get profileYourTopSongs => 'آپ کے پسندیدہ گانے';

  @override
  String get profileListeningHistoryEmpty =>
      'آپ کے سننے کی ہسٹری یہاں ظاہر ہوگی۔';

  @override
  String profilePlays(int count) {
    return '$count بار چلایا گیا';
  }

  @override
  String get profileYourTopArtists => 'آپ کے پسندیدہ فنکار';

  @override
  String get profileTopArtistsEmpty => 'آپ کے پسندیدہ فنکار یہاں ظاہر ہوں گے۔';

  @override
  String get profileArtistLabel => 'فنکار';

  @override
  String get profileSignOut => 'سائن آؤٹ کریں';

  @override
  String profileVersion(String version) {
    return 'ورژن $version';
  }

  @override
  String get profileMadeWithHeartBy => 'محبت سے بنایا ہے: ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'پروفائل ایڈٹ کریں';

  @override
  String get profileDisplayName => 'ڈسپلے کا نام';

  @override
  String get profileCancel => 'منسوخ کریں';

  @override
  String get profileSave => 'محفوظ کریں';

  @override
  String get profileChooseAvatar => 'اوتار منتخب کریں';

  @override
  String get searchMicPermissionRequired =>
      'اس فیچر کے لیے مائیکروفون کی اجازت درکار ہے';

  @override
  String get searchUnknownSong => 'نامعلوم گانا';

  @override
  String get searchUnknownArtist => 'نامعلوم فنکار';

  @override
  String get searchNoSongDetected => 'کوئی گانا نہیں ملا۔';

  @override
  String searchError(String message) {
    return 'خرابی: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'وائس سرچ دستیاب نہیں ہے';

  @override
  String get searchHint => 'گانے، فنکار، البمز...';

  @override
  String get searchRecentEmpty => 'آپ کی حالیہ تلاشیں یہاں ظاہر ہوں گی';

  @override
  String get searchRecentSearches => 'حالیہ تلاشیں';

  @override
  String get searchClearAll => 'سب صاف کریں';

  @override
  String searchNoResultsFor(String query) {
    return '\"$query\" کے لیے کوئی نتائج نہیں ہیں';
  }

  @override
  String get searchTryDifferentKeywords => 'مختلف الفاظ کے ساتھ کوشش کریں';

  @override
  String get searchTopResult => 'ٹاپ رزلٹ';

  @override
  String get searchSongsLabel => 'گانے';

  @override
  String get searchArtistsLabel => 'فنکار';

  @override
  String get searchAlbumsLabel => 'البمز';

  @override
  String get searchPlaylistsLabel => 'پلے لسٹس';

  @override
  String get searchArtistLabel => 'فنکار';

  @override
  String get searchListening => 'سن رہا ہے...';

  @override
  String get searchSpeakNow => 'تلاش کرنے کے لیے اب بولیں';

  @override
  String get searchCancel => 'منسوخ کریں';

  @override
  String get searchIdentifying => 'پہچان رہا ہے...';

  @override
  String get searchListeningForSong => 'گانے کے لیے سن رہا ہے...';

  @override
  String get settingsTitle => 'سیٹنگز';

  @override
  String get settingsStreamingQuality => 'سٹریمنگ کوالٹی';

  @override
  String get settingsQualityAutomatic => 'خودکار';

  @override
  String get settingsQualityLow => 'کم';

  @override
  String get settingsQualityNormal => 'نارمل';

  @override
  String get settingsQualityHigh => 'زیادہ';

  @override
  String get settingsDownloadQuality => 'ڈاؤن لوڈ کوالٹی';

  @override
  String get settingsPlayback => 'پلے بیک';

  @override
  String get settingsCrossfade => 'کراس فیڈ';

  @override
  String get settingsCrossfadeDesc =>
      'آسان منتقلی کے لیے گانوں کو اوورلیپ کریں';

  @override
  String get settingsDataUsage => 'ڈیٹا کا استعمال';

  @override
  String get settingsDataSaver => 'ڈیٹا سیور';

  @override
  String get settingsDataSaverDesc =>
      'موبائل ڈیٹا پر کم کوالٹی میں اسٹریم کریں';

  @override
  String get settingsAppearance => 'ظاہری شکل';

  @override
  String get settingsLanguage => 'زبان';

  @override
  String get settingsCustomAccent => 'کسٹم ایکسنٹ';

  @override
  String get settingsSaturation => 'سیچوریشن';

  @override
  String get settingsBrightness => 'برائٹنس';

  @override
  String get settingsResetDefault => 'ڈیفالٹ پر ری سیٹ کریں';

  @override
  String get playlistSheetTitle => 'پلے لسٹ میں شامل کریں';

  @override
  String get playlistSheetNewPlaylist => 'نئی پلے لسٹ';

  @override
  String get playlistSheetNoPlaylists => 'کوئی پلے لسٹس نہیں ہیں';

  @override
  String playlistSheetSongsCount(int count) {
    return '$count گانے';
  }

  @override
  String get playlistSheetNameHint => 'پلے لسٹ کا نام';

  @override
  String get playlistSheetCancel => 'منسوخ کریں';

  @override
  String playlistSheetAddedTo(String name) {
    return '$name میں شامل کر دیا گیا';
  }

  @override
  String get playlistSheetCreateFailAuth => 'بنانے میں ناکام: تصدیق کی خرابی';

  @override
  String playlistSheetCreateFail(String error) {
    return 'بنانے میں ناکام: $error';
  }

  @override
  String get playlistSheetCreate => 'بنائیں';

  @override
  String get appUpdateAvailable => 'اپ ڈیٹ دستیاب ہے';

  @override
  String appUpdateDesc(String version) {
    return 'ورژن $version آ گیا ہے! نئے فیچرز کے لیے اپ ڈیٹ کریں۔';
  }

  @override
  String get appUpdateDownload => 'اپ ڈیٹ ڈاؤن لوڈ کریں';

  @override
  String get navHome => 'ہوم';

  @override
  String get navLibrary => 'لائبریری';

  @override
  String get navSearch => 'تلاش';

  @override
  String get navSettings => 'سیٹنگز';

  @override
  String get navProfile => 'پروفائل';

  @override
  String get artistSelect => 'فنکار منتخب کریں';

  @override
  String get songActionQueue => 'قطار میں شامل کریں';

  @override
  String get songActionPlaylist => 'پلے لسٹ میں شامل کریں';

  @override
  String get songActionFinding => 'تلاش کر رہا ہے...';

  @override
  String get songActionAlbum => 'البم پر جائیں';

  @override
  String get songActionArtist => 'فنکار پر جائیں';

  @override
  String get songActionRemovePlaylist => 'پلے لسٹ سے ہٹائیں';

  @override
  String get songActionRemoveDownload => 'ڈاؤن لوڈز سے ہٹائیں';

  @override
  String get songActionDownloadChecking => 'چیک کر رہا ہے...';

  @override
  String get songActionDownloading => 'ڈاؤن لوڈ ہو رہا ہے...';

  @override
  String get songActionDownloaded => 'ڈاؤن لوڈ ہو گیا!';

  @override
  String get songActionDownloadAlready => 'پہلے ہی ڈاؤن لوڈ کیا جا چکا ہے';

  @override
  String get songActionDownloadFailed => 'ڈاؤن لوڈ ناکام ہو گیا';

  @override
  String get songActionDownload => 'ڈاؤن لوڈ';

  @override
  String get songActionDownloadingSnack => 'ڈاؤن لوڈ ہو رہا ہے';

  @override
  String get songActionView => 'دیکھیں';

  @override
  String get spotifyImportTitle => 'Spotify سے امپورٹ کریں';

  @override
  String get spotifyImportSubtitle => 'پلے لسٹ کا سائز منتخب کریں';

  @override
  String get spotifyChoiceSmallTitle => '100 گانے یا اس سے کم';

  @override
  String get spotifyChoiceSmallDesc => 'پبلک Spotify پلے لسٹ کا URL پیسٹ کریں۔';

  @override
  String get spotifyChoiceLargeTitle => '100 سے زیادہ گانے';

  @override
  String get spotifyChoiceLargeDesc =>
      'لامحدود ٹریکس امپورٹ کرنے کے لیے اپنی Spotify Developer App منسلک کریں۔';

  @override
  String get cancelButton => 'منسوخ کریں';

  @override
  String get spotifyPlaylistsTitle => 'آپ کی Spotify پلے لسٹس';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'خرابی: $error\nچیک کریں کہ کیا آپ کی Client ID درست ہے۔';
  }

  @override
  String get spotifyPlaylistsEmpty =>
      'آپ کی لائبریری میں کوئی پلے لسٹس نہیں ہیں';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count ٹریکس';
  }

  @override
  String get spotifyPlaylistsImport => 'امپورٹ';

  @override
  String get audioPlaybackFailed =>
      'پلے بیک ناکام ہو گیا۔ انٹرنیٹ کنکشن چیک کریں۔';

  @override
  String get audioControlPrevious => 'پچھلا';

  @override
  String get audioControlPause => 'پاز';

  @override
  String get audioControlPlay => 'پلے';

  @override
  String get audioControlNext => 'اگلا';

  @override
  String get audioControlUnlike => 'ان لائک';

  @override
  String get audioControlLike => 'لائک';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'اصلی جواب: $data\n\nفال بیک: $error';
  }

  @override
  String get apiErrorInvalidClient => 'غلط کلائنٹ یا کلائنٹ سیکرٹ۔';

  @override
  String get apiErrorBadRequest =>
      'خراب درخواست۔ براہ کرم اپنا ان پٹ چیک کریں۔';

  @override
  String get apiErrorUnauthorized => 'غیر مجاز۔ براہ کرم دوبارہ لاگ ان کریں۔';

  @override
  String get apiErrorForbidden => 'ممنوع۔ آپ کو رسائی حاصل نہیں ہے۔';

  @override
  String get apiErrorNotFound => 'وسیلہ نہیں ملا۔';

  @override
  String get apiErrorEmailInUse => 'یہ ای میل ایڈریس پہلے ہی استعمال میں ہے۔';

  @override
  String get apiErrorUserNotFound => 'اس ای میل سے منسلک کوئی اکاؤنٹ نہیں ملا۔';

  @override
  String get apiErrorWrongPassword => 'غلط پاس ورڈ۔';

  @override
  String get apiErrorInvalidCredential =>
      'لاگ ان ناکام ہو گیا۔ اپنی معلومات چیک کریں۔';

  @override
  String get apiErrorNetwork => 'نیٹ ورک کی خرابی۔ اپنا کنکشن چیک کریں۔';

  @override
  String get apiErrorSocketTimeout =>
      'کنکشن ٹائم آؤٹ ہو گیا۔ دوبارہ کوشش کریں۔';

  @override
  String get apiErrorTooManyRequests =>
      'بہت زیادہ درخواستیں۔ تھوڑی دیر بعد دوبارہ کوشش کریں۔';

  @override
  String get apiErrorServerError =>
      'سرور کی خرابی۔ تھوڑی دیر بعد دوبارہ کوشش کریں۔';

  @override
  String get apiErrorInvalidEmail =>
      'براہ کرم ایک درست ای میل ایڈریس درج کریں۔';

  @override
  String get apiErrorWeakPassword =>
      'پاس ورڈ بہت کمزور ہے۔ کم از کم 6 حروف استعمال کریں۔';

  @override
  String get apiErrorTooManyAttempts =>
      'بہت زیادہ ناکام کوششیں۔ بعد میں دوبارہ کوشش کریں۔';

  @override
  String get homeForgottenFavorites => 'بھولے ہوئے پسندیدہ';

  @override
  String get artistShowAll => 'سب دیکھیں';

  @override
  String get homeTopTracks => 'ٹاپ ٹریکس';
}
