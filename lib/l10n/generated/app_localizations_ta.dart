// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'பற்றி';

  @override
  String get artistPopular => 'பிரபலமானவை';

  @override
  String get artistAlbums => 'ஆல்பங்கள்';

  @override
  String get artistSinglesAndEPs => 'சிங்கிள்ஸ் & EP';

  @override
  String artistSubscribersCount(String count) {
    return '$count சந்தாதாரர்கள்';
  }

  @override
  String get artistPlayAll => 'அனைத்தையும் பிளே செய்';

  @override
  String get artistLoadError => 'ஆர்ட்டிஸ்ட்டை ஏற்ற முடியவில்லை';

  @override
  String get artistGoBack => 'பின் செல்';

  @override
  String adminChatFailedToReply(String error) {
    return 'பதிலளிக்க முடியவில்லை: $error';
  }

  @override
  String get adminChatSupportChat => 'சப்போர்ட் சாட்';

  @override
  String adminChatError(String error) {
    return 'பிழை: $error';
  }

  @override
  String get adminChatNoHistory => 'முந்தைய உரையாடல்கள் இல்லை.';

  @override
  String get adminChatSupportYou => 'சப்போர்ட் (நீங்கள்)';

  @override
  String get adminChatTypeReply => 'உங்கள் பதிலை உள்ளிடவும்...';

  @override
  String get broadcastSuccess => 'அறிவிப்பு வெற்றிகரமாக ஒளிபரப்பப்பட்டது!';

  @override
  String broadcastFailed(String error) {
    return 'ஒளிபரப்ப முடியவில்லை: $error';
  }

  @override
  String get broadcastTitle => 'உலகளாவிய அறிவிப்புகள்';

  @override
  String get broadcastSubtitle => 'அனைத்து பயனர்களுக்கும் அனுப்பப்பட்டது';

  @override
  String get broadcastWarning =>
      'இங்கு அனுப்பும் செய்திகள் அனைவருக்கும் தெரியும்.';

  @override
  String broadcastError(String error) {
    return 'பிழை: $error';
  }

  @override
  String get broadcastNoHistory => 'முந்தைய அறிவிப்புகள் இல்லை.';

  @override
  String get broadcastTypeMessage => 'உலகளாவிய அறிவிப்பை உள்ளிடவும்...';

  @override
  String commFailedToSend(String error) {
    return 'அனுப்ப முடியவில்லை: $error';
  }

  @override
  String get commAdminDashboard => 'அட்மின் டாஷ்போர்டு';

  @override
  String get commAdminSupport => 'அட்மின் சப்போர்ட்';

  @override
  String get commAlwaysHere => 'உதவ எப்போதும் தயாராக உள்ளோம்';

  @override
  String get commWelcomeTitle => 'ஹலோ! 👋 நான் அசுதோஷ் பதக்';

  @override
  String get commWelcomeSubtitle => 'Pulse டெவலப்பர்';

  @override
  String get commWelcomeBody1 =>
      'விளம்பரங்கள் அல்லது சந்தா தடைகள் இல்லாமல் உங்கள் விருப்பமான இசையை ரசிக்கிறீர்கள் என நம்புகிறேன். இசை பணக்காரர்களுக்கு மட்டுமே சொந்தமாக இருக்கக்கூடாது.\n\nநாம் நேரடியாகத் தொடர்புகொள்ள இந்தப் பகுதி உள்ளது.\n\nநீங்கள் என்னிடம் பகிரலாம்:';

  @override
  String get commBullet1 => 'உங்கள் கருத்துக்கள்';

  @override
  String get commBullet2 => 'பிழைகளைப் புகாரளிக்கவும்';

  @override
  String get commBullet3 => 'புதிய அம்சங்களை பரிந்துரைக்கவும்';

  @override
  String get commWelcomeBody2 =>
      'ஒவ்வொரு செய்தியையும் நான் படித்து, உங்கள் ஆலோசனைகளைக் கொண்டு செயலியை மேம்படுத்துவேன்.\n\nசந்தாக்களில் சிக்கியுள்ள ஒரு புதிய ஆப் ஐடியா உங்களிடம் உள்ளதா? எனக்கு சொல்லுங்கள்! சாத்தியமானால் அதை உருவாக்கி அனைவருக்கும் வழங்குவேன்.\n\nபயன்படுத்தியதற்கு நன்றி. ❤️';

  @override
  String commError(String error) {
    return 'பிழை: $error';
  }

  @override
  String get commNoMessages => 'இன்னும் எந்த செய்தியும் இல்லை';

  @override
  String get commNoMessagesDesc =>
      'சப்போர்ட் டீமுக்கு செய்தி அனுப்பவும் அல்லது பின்னர் சரிபார்க்கவும்.';

  @override
  String get commMessageSupportHint => 'சப்போர்ட் டீமுக்கு எழுதவும்...';

  @override
  String get commGlobalAnnouncements => 'உலகளாவிய அறிவிப்புகள்';

  @override
  String get commSendMessagesToAll => 'அனைவருக்கும் செய்தி அனுப்பு';

  @override
  String get homeGreetingMorning => 'காலை வணக்கம்,';

  @override
  String get homeGreetingAfternoon => 'மதிய வணக்கம்,';

  @override
  String get homeGreetingEvening => 'மாலை வணக்கம்,';

  @override
  String get homeMember => 'உறுப்பினர்';

  @override
  String get homeRecentPlaylists => 'சமீபத்திய பிளேலிஸ்ட்கள்';

  @override
  String get homeRecentlyPlayed => 'சமீபத்தில் கேட்டவை';

  @override
  String get homeSpeedDial => 'ஸ்பீட் டயல்';

  @override
  String get homeNoContent => 'எந்த உள்ளடக்கமும் இல்லை';

  @override
  String get homeRefresh => 'புதுப்பி';

  @override
  String get homeLoadError => 'இசையை ஏற்ற முடியவில்லை.';

  @override
  String get homeRetry => 'மீண்டும் முயல்க';

  @override
  String get importSuccess => 'Spotify வெற்றிகரமாக இணைக்கப்பட்டது!';

  @override
  String importFailed(String error) {
    return 'இணைக்க முடியவில்லை: $error';
  }

  @override
  String get importTitle => 'Spotify ஐ இணைக்கவும்';

  @override
  String get importSetupTitle => 'Spotify அமைவு';

  @override
  String get importSetupDesc =>
      'Spotify கட்டுப்பாடுகளைத் தவிர்த்து உங்கள் பிளேலிஸ்ட்களை உடனே இம்போர்ட் செய்ய உங்கள் டெவலப்பர் கீயைப் பயன்படுத்தவும். இந்தப் படிகளைப் பின்பற்றவும்:';

  @override
  String get importStep1 => 'Spotify Developer Dashboard ஐ திறக்கவும்.';

  @override
  String get importStep2 =>
      'உள்நுழைந்து \"Create app\" என்பதை கிளிக் செய்யவும்.';

  @override
  String get importStep3 => 'ஏதேனும் ஆப் பெயர் மற்றும் விளக்கத்தை உள்ளிடவும்.';

  @override
  String get importStep4 =>
      '\"Redirect URIs\" என்பதற்கு கீழே இந்தச் சரியான URL ஐ ஒட்டவும்:';

  @override
  String get importRedirectCopied => 'ரீடைரக்ட் URI நகலெடுக்கப்பட்டது!';

  @override
  String get importStep5 =>
      'ஆப்பை சேமித்து, செட்டிங்ஸில் இருந்து \"Client ID\" ஐ நகலெடுத்து கீழே ஒட்டவும்.';

  @override
  String get importImportant =>
      'முக்கிய குறிப்பு: இதை உருவாக்கப் பயன்படுத்தப்படும் Spotify கணக்கில் ஆக்டிவ் ப்ரீமியம் சந்தா இருக்க வேண்டும்.';

  @override
  String get importClientIdHint =>
      'உங்கள் Spotify Client ID ஐ இங்கு ஒட்டவும்...';

  @override
  String get importConnectButton => 'இணை & லைப்ரரியை ஏற்று';

  @override
  String get downloadingNoActive => 'பதிவிறக்கங்கள் எதுவும் இல்லை';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'பதிவிறக்கங்கள்';

  @override
  String downloadsStats(String count, String size) {
    return '$count பாடல்கள் • $size';
  }

  @override
  String get downloadsNoOffline => 'ஆஃப்லைன் பாடல்கள் இல்லை';

  @override
  String get downloadsNoOfflineDesc =>
      'நீங்கள் பதிவிறக்கிய பாடல்கள் இங்கு தோன்றும்';

  @override
  String get downloadsClearAllTitle => 'அனைத்தையும் அழிக்கவா?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'இது $count பாடல்களை நீக்கி $size ஸ்டோரேஜைக் காலி செய்யும்.';
  }

  @override
  String get downloadsCancel => 'ரத்து';

  @override
  String get downloadsClearAll => 'அனைத்தையும் அழி';

  @override
  String downloadsSongsCount(String count) {
    return '$count பாடல்கள்';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count பாடல்';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'முக்கிய பதிவிறக்கங்கள் பிளேலிஸ்ட்டின் பெயரை மாற்ற முடியாது.';

  @override
  String get downloadsRename => 'பெயர் மாற்று';

  @override
  String get downloadsEditSongs => 'பாடல்களைத் திருத்து';

  @override
  String get downloadsDelete => 'நீக்கு';

  @override
  String get downloadsRenamePlaylistTitle => 'பிளேலிஸ்ட்டின் பெயர் மாற்று';

  @override
  String get downloadsRenamePlaylistDesc =>
      'உங்கள் பிளேலிஸ்ட்டிற்கு புதிய பெயரை உள்ளிடவும்.';

  @override
  String get downloadsDeletePlaylistTitle => 'பிளேலிஸ்ட்டை நீக்கவா?';

  @override
  String get downloadsDeleteMasterDesc =>
      'இதை உறுதியாக நீக்க விரும்புகிறீர்களா? நீங்கள் பதிவிறக்கிய பாடல்கள் மற்றும் பிளேலிஸ்ட்களை நிரந்தரமாக இழக்க நேரிடும்.';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return '\"$name\" ஐ உறுதியாக நீக்க விரும்புகிறீர்களா? இந்த பிளேலிஸ்ட்டை நிரந்தரமாக இழக்க நேரிடும்.';
  }

  @override
  String get downloadsSave => 'சேமி';

  @override
  String get downloadsNoSongs => 'இந்தப் பிளேலிஸ்ட்டில் பாடல்கள் இல்லை.';

  @override
  String get libraryTitle => 'லைப்ரரி';

  @override
  String get libraryPauseAll => 'அனைத்தையும் இடைநிறுத்து';

  @override
  String get libraryResumeAll => 'அனைத்தையும் தொடர்';

  @override
  String get libraryTabPlaylists => 'பிளேலிஸ்ட்கள்';

  @override
  String get libraryTabDownloads => 'பதிவிறக்கங்கள்';

  @override
  String get libraryTabDownloading => 'பதிவிறக்குகிறது';

  @override
  String libraryImportedTask(String name) {
    return '$name இம்போர்ட் செய்யப்பட்டது';
  }

  @override
  String get libraryImportWaiting => 'காத்திருக்கிறது...';

  @override
  String get libraryImportFetching => 'பிளேலிஸ்ட்டைக் கொண்டு வருகிறது...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total செயலாக்கப்பட்டது · $matched பொருத்தமானது';
  }

  @override
  String get libraryImportSaving => 'லைப்ரரியில் சேமிக்கிறது...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched பாடல்கள் சேர்க்கப்பட்டன · மூட × ஐ அழுத்தவும்';
  }

  @override
  String get libraryImportDoneAll =>
      'அனைத்து பாடல்களும் சேர்க்கப்பட்டன · மூட × ஐ அழுத்தவும்';

  @override
  String get libraryAddButton => 'சேர்';

  @override
  String get librarySortRecent => 'சமீபத்தியவை';

  @override
  String get librarySortAlpha => 'அகரவரிசை';

  @override
  String get libraryEmptyTitle => 'உங்கள் லைப்ரரி காலியாக உள்ளது.';

  @override
  String get libraryEmptyDesc =>
      'உங்கள் முதல் Pulse ஐ தொடங்க \"சேர்\" என்பதை அழுத்தவும்.';

  @override
  String get libraryRenameLikedError =>
      'Liked Songs பிளேலிஸ்ட்டின் பெயரை மாற்ற முடியாது.';

  @override
  String get libraryRename => 'பெயர் மாற்று';

  @override
  String get libraryEditSongs => 'பாடல்களைத் திருத்து';

  @override
  String get libraryDeleteLikedError =>
      'Liked Songs பிளேலிஸ்ட்டை நீக்க முடியாது.';

  @override
  String get libraryDelete => 'நீக்கு';

  @override
  String get libraryEditSongsTitle => 'பாடல்களைத் திருத்து';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count பாடல்';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count பாடல்கள்';
  }

  @override
  String get libraryCancel => 'ரத்து';

  @override
  String get librarySave => 'சேமி';

  @override
  String get libraryNoSongs => 'இந்தப் பிளேலிஸ்ட்டில் பாடல்கள் இல்லை.';

  @override
  String get libraryAddOptionsTitle => 'லைப்ரரியில் சேர்க்கவும்';

  @override
  String get libraryAddOptionsDesc =>
      'உங்கள் Pulse லைப்ரரியை எப்படி விரிவுபடுத்துவது எனத் தேர்வு செய்யவும்';

  @override
  String get libraryImportPulse => 'Pulse இலிருந்து இம்போர்ட் செய்';

  @override
  String get libraryImportPulseDesc => 'Pulse பிளேலிஸ்ட் URL ஐ ஒட்டவும்';

  @override
  String get libraryImportYtm => 'YT Music இலிருந்து இம்போர்ட் செய்';

  @override
  String get libraryImportYtmDesc => 'பப்ளிக் பிளேலிஸ்ட் URL ஐ ஒட்டவும்';

  @override
  String get libraryImportSpotify => 'Spotify இலிருந்து இம்போர்ட் செய்';

  @override
  String get libraryImportSpotifyDesc => 'உங்கள் Spotify ஐ இணைக்கவும்';

  @override
  String get libraryClose => 'மூடு';

  @override
  String get libraryImportYtmFull => 'YouTube Music இலிருந்து இம்போர்ட் செய்';

  @override
  String get libraryImportSpotifyFull =>
      'Spotify இலிருந்து இம்போர்ட் செய் (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'பப்ளிக் YouTube Music பிளேலிஸ்ட் அல்லது ஆல்பம் URL ஐ ஒட்டவும்';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'பப்ளிக் Spotify பிளேலிஸ்ட் URL ஐ கீழே ஒட்டவும்';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed =>
      'Pulse பிளேலிஸ்ட்டை இம்போர்ட் செய்ய முடியவில்லை';

  @override
  String get importErrorPlaylist => 'பிளேலிஸ்ட்டை இம்போர்ட் செய்வதில் பிழை';

  @override
  String get importErrorHighlyPopulated =>
      'பிளேலிஸ்ட் மிகப் பெரியது, இதைக் கொண்டுவர சிறிது நேரம் ஆகலாம்.';

  @override
  String get libraryImportBtn => 'இம்போர்ட் செய்';

  @override
  String get libraryCreateTitle => 'புதிய பிளேலிஸ்ட்';

  @override
  String get libraryCreateDesc =>
      'உங்கள் புதிய பிளேலிஸ்ட்டிற்கு என்ன பெயர் வைக்கலாம்?';

  @override
  String get libraryCreateHint => 'எ.கா. Midnight Rides';

  @override
  String get libraryCreateBtn => 'உருவாக்கு';

  @override
  String get libraryRenameTitle => 'பிளேலிஸ்ட்டின் பெயர் மாற்று';

  @override
  String get libraryRenameDesc =>
      'உங்கள் பிளேலிஸ்ட்டிற்கு புதிய பெயரை உள்ளிடவும்.';

  @override
  String get libraryRenameBtn => 'பெயர் மாற்று';

  @override
  String get libraryDeleteTitle => 'பிளேலிஸ்ட்டை நீக்கவா?';

  @override
  String libraryDeleteDesc(String name) {
    return '\"$name\" ஐ உறுதியாக நீக்க விரும்புகிறீர்களா? இந்த பிளேலிஸ்ட்டை நிரந்தரமாக இழக்க நேரிடும்.';
  }

  @override
  String get libraryDeleteBtn => 'நீக்கு';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'சமீபத்தியவை';

  @override
  String librarySongsCount(String count) {
    return '$count பாடல்கள்';
  }

  @override
  String get libraryComingSoon => 'விரைவில் வருகிறது';

  @override
  String get loginErrName => 'தயவுசெய்து உங்கள் பெயரை உள்ளிடவும்';

  @override
  String get loginErrEmail => 'தயவுசெய்து உங்கள் மின்னஞ்சலை உள்ளிடவும்';

  @override
  String get loginErrPassword => 'தயவுசெய்து உங்கள் கடவுச்சொல்லை உள்ளிடவும்';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'ஒவ்வொரு பீட்டையும் உணருங்கள்!';

  @override
  String get loginMadeWithHeartBy => 'அன்புடன் உருவாக்கியவர்: ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'உங்கள் பெயர்';

  @override
  String get loginHintEmail => 'மின்னஞ்சல் முகவரி';

  @override
  String get loginHintPassword => 'கடவுச்சொல்';

  @override
  String get loginErrEmailReset =>
      'கடவுச்சொல்லை ரீசெட் செய்ய மின்னஞ்சலை உள்ளிடவும்';

  @override
  String get loginResetSent =>
      'ரீசெட் மின்னஞ்சல் அனுப்பப்பட்டது! இன்பாக்ஸை சரிபார்க்கவும்.';

  @override
  String get loginForgotPwd => 'கடவுச்சொல்லை மறந்துவிட்டீர்களா?';

  @override
  String get loginBtnSignup => 'கணக்கை உருவாக்கு';

  @override
  String get loginBtnSignin => 'உள்நுழை';

  @override
  String get loginToggleHaveAccount => 'ஏற்கனவே Pulse கணக்கு உள்ளதா? ';

  @override
  String get loginToggleNoAccount => 'Pulse கணக்கு இல்லையா? ';

  @override
  String get loginToggleSignin => 'உள்நுழை';

  @override
  String get loginToggleSignup => 'பதிவு செய்';

  @override
  String get offlineStillOffline =>
      'இன்னும் ஆஃப்லைனில் உள்ளீர்கள். இணைப்பைச் சரிபார்க்கவும்.';

  @override
  String get offlineTitle => 'நீங்கள் ஆஃப்லைனில் உள்ளீர்கள்';

  @override
  String get offlineSubtitle =>
      'இணைய இணைப்பு இல்லை.\nநெட்வொர்க்கைச் சரிபார்த்து மீண்டும் முயல்க.';

  @override
  String get offlineChecking => 'சரிபார்க்கிறது...';

  @override
  String get offlineRetry => 'மீண்டும் முயல்க';

  @override
  String get offlineGoToDownloads => 'பதிவிறக்கங்களுக்குச் செல்';

  @override
  String get playerMadeWithHeartBy => 'அன்புடன் உருவாக்கியவர்: ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'வரிகளுக்கு ஸ்வைப் செய்யவும்';

  @override
  String get playerNoLyrics => 'வரிகள் கிடைக்கவில்லை';

  @override
  String get playerUpNext => 'அடுத்து வருவது';

  @override
  String get playerNoTracksInQueue => 'வரிசையில் பாடல்கள் இல்லை';

  @override
  String get playerNoMusicPlaying => 'எந்தப் பாடலும் ஒலிக்கவில்லை';

  @override
  String get playerPickAVibe =>
      'உங்கள் லைப்ரரி அல்லது முகப்பிலிருந்து ஒரு பாடலைத் தேர்வு செய்யவும்';

  @override
  String get playerGoHome => 'முகப்பிற்குச் செல்';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'ஈக்வலைஸர்';

  @override
  String get playerEqCustom => 'கஸ்டம்';

  @override
  String get playlistDownloads => 'பதிவிறக்கங்கள்';

  @override
  String get playlistOffline => 'ஆஃப்லைன் பிளேலிஸ்ட்';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hoursம $minsநி';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$minsநி';
  }

  @override
  String get playlistFindOnPage => 'இந்தப் பக்கத்தில் தேடு';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count பாடல்கள் • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'சமீபத்தியவை';

  @override
  String get playlistNoMatches => 'எதுவும் கிடைக்கவில்லை.';

  @override
  String get playlistNoTracks => 'இந்தப் பிளேலிஸ்ட்டில் பாடல்கள் இல்லை.';

  @override
  String get playlistNoSongsYet => 'இன்னும் பாடல்கள் இல்லை.';

  @override
  String get playlistSortRecentlyAdded => 'சமீபத்தில் சேர்க்கப்பட்டவை';

  @override
  String get playlistSortAlphabetical => 'அகரவரிசை';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'பாடல்கள்',
      one: 'பாடல்',
    );
    return '$count $_temp0 பதிவிறக்குகிறது';
  }

  @override
  String get playlistView => 'காண்க';

  @override
  String get playlistAllDownloaded =>
      'அனைத்து பாடல்களும் ஏற்கனவே பதிவிறக்கப்பட்டுவிட்டன';

  @override
  String playlistShareText(String name, String url) {
    return 'Pulse இல் \"$name\" ஐ கேளுங்கள்!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'பதிவிறக்கங்களில் இருந்து நீக்கு';

  @override
  String get playlistRemoveFromPlaylist => 'பிளேலிஸ்ட்டில் இருந்து நீக்கு';

  @override
  String get playlistLoadError => 'இந்தப் பிளேலிஸ்ட்டை ஏற்ற முடியவில்லை.';

  @override
  String get playlistGoBack => '← பின் செல்';

  @override
  String get profileNotLoggedIn => 'உள்நுழையவில்லை';

  @override
  String get profileSignIn => 'உள்நுழை';

  @override
  String get profileDefaultUser => 'Pulse பயனர்';

  @override
  String get profileEditProfile => 'புரொஃபைலைத் திருத்து';

  @override
  String get profileTimeframeDay => 'நாள்';

  @override
  String get profileTimeframeWeek => 'வாரம்';

  @override
  String get profileTimeframeMonth => 'மாதம்';

  @override
  String get profileTimeframeYear => 'ஆண்டு';

  @override
  String get profileListeningTime => 'கேட்கும் நேரம்';

  @override
  String get profileToday => 'இன்று';

  @override
  String get profileThisWeek => 'இந்த வாரம்';

  @override
  String get profileThisMonth => 'இந்த மாதம்';

  @override
  String get profileThisYear => 'இந்த ஆண்டு';

  @override
  String get profileDailyAvg => 'தினசரி சராசரி';

  @override
  String get profilePerDay => 'ஒரு நாளைக்கு';

  @override
  String get profileLifetimeListening => 'மொத்தமாக கேட்ட நேரம்';

  @override
  String get profileTotalTimeListened => 'Pulse இல் இசையைக் கேட்ட மொத்த நேரம்';

  @override
  String get profileYourTopSongs => 'உங்களின் சிறந்த பாடல்கள்';

  @override
  String get profileListeningHistoryEmpty =>
      'நீங்கள் கேட்ட பாடல்களின் வரலாறு இங்கு தோன்றும்.';

  @override
  String profilePlays(int count) {
    return '$count முறை ஒலிக்கப்பட்டது';
  }

  @override
  String get profileYourTopArtists => 'உங்களின் சிறந்த கலைஞர்கள்';

  @override
  String get profileTopArtistsEmpty =>
      'உங்களுக்குப் பிடித்த கலைஞர்கள் இங்கு தோன்றுவார்கள்.';

  @override
  String get profileArtistLabel => 'கலைஞர்';

  @override
  String get profileSignOut => 'வெளியேறு';

  @override
  String profileVersion(String version) {
    return 'பதிப்பு $version';
  }

  @override
  String get profileMadeWithHeartBy => 'அன்புடன் உருவாக்கியவர்: ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'புரொஃபைலைத் திருத்து';

  @override
  String get profileDisplayName => 'காண்பிக்கும் பெயர்';

  @override
  String get profileCancel => 'ரத்து';

  @override
  String get profileSave => 'சேமி';

  @override
  String get profileChooseAvatar => 'அவதாரைத் தேர்வு செய்';

  @override
  String get searchMicPermissionRequired =>
      'இந்த அம்சத்திற்கு மைக்ரோஃபோன் அனுமதி தேவை';

  @override
  String get searchUnknownSong => 'அறியப்படாத பாடல்';

  @override
  String get searchUnknownArtist => 'அறியப்படாத கலைஞர்';

  @override
  String get searchNoSongDetected => 'எந்தப் பாடலும் கண்டறியப்படவில்லை.';

  @override
  String searchError(String message) {
    return 'பிழை: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'வாய்ஸ் சர்ச் கிடைக்கவில்லை';

  @override
  String get searchHint => 'பாடல்கள், கலைஞர்கள், ஆல்பங்கள்...';

  @override
  String get searchRecentEmpty => 'உங்கள் சமீபத்திய தேடல்கள் இங்கு தோன்றும்';

  @override
  String get searchRecentSearches => 'சமீபத்திய தேடல்கள்';

  @override
  String get searchClearAll => 'அனைத்தையும் அழி';

  @override
  String searchNoResultsFor(String query) {
    return '\"$query\" க்கான முடிவுகள் இல்லை';
  }

  @override
  String get searchTryDifferentKeywords => 'வேறு வார்த்தைகளுடன் முயலவும்';

  @override
  String get searchTopResult => 'முக்கிய முடிவு';

  @override
  String get searchSongsLabel => 'பாடல்கள்';

  @override
  String get searchArtistsLabel => 'கலைஞர்கள்';

  @override
  String get searchAlbumsLabel => 'ஆல்பங்கள்';

  @override
  String get searchPlaylistsLabel => 'பிளேலிஸ்ட்கள்';

  @override
  String get searchArtistLabel => 'கலைஞர்';

  @override
  String get searchListening => 'கேட்கிறது...';

  @override
  String get searchSpeakNow => 'தேட இப்போது பேசுங்கள்';

  @override
  String get searchCancel => 'ரத்து';

  @override
  String get searchIdentifying => 'கண்டறிகிறது...';

  @override
  String get searchListeningForSong => 'பாடல் ஒலிக்கிறதா என்று கேட்கிறது...';

  @override
  String get settingsTitle => 'செட்டிங்ஸ்';

  @override
  String get settingsStreamingQuality => 'ஸ்ட்ரீமிங் தரம்';

  @override
  String get settingsQualityAutomatic => 'ஆட்டோமேட்டிக்';

  @override
  String get settingsQualityLow => 'குறைந்த';

  @override
  String get settingsQualityNormal => 'சாதாரண';

  @override
  String get settingsQualityHigh => 'உயர்';

  @override
  String get settingsDownloadQuality => 'பதிவிறக்கத் தரம்';

  @override
  String get settingsPlayback => 'பிளேபேக்';

  @override
  String get settingsCrossfade => 'க்ராஸ்ஃபேட்';

  @override
  String get settingsCrossfadeDesc =>
      'இடையூறில்லாத மாற்றத்திற்காக டிராக்குகளை ஓவர்லேப் செய்யவும்';

  @override
  String get settingsDataUsage => 'டேட்டா பயன்பாடு';

  @override
  String get settingsDataSaver => 'டேட்டா சேவர்';

  @override
  String get settingsDataSaverDesc =>
      'மொபைல் டேட்டாவில் குறைந்த தரத்தில் ஸ்ட்ரீம் செய்யவும்';

  @override
  String get settingsAppearance => 'தோற்றம்';

  @override
  String get settingsLanguage => 'மொழி';

  @override
  String get settingsCustomAccent => 'கஸ்டம் ஆக்சென்ட்';

  @override
  String get settingsSaturation => 'சாச்சுரேஷன்';

  @override
  String get settingsBrightness => 'பிரைட்னஸ்';

  @override
  String get settingsResetDefault => 'டிஃபால்ட்டிற்கு ரீசெட் செய்';

  @override
  String get playlistSheetTitle => 'பிளேலிஸ்ட்டில் சேர்';

  @override
  String get playlistSheetNewPlaylist => 'புதிய பிளேலிஸ்ட்';

  @override
  String get playlistSheetNoPlaylists => 'இன்னும் பிளேலிஸ்ட்கள் இல்லை';

  @override
  String playlistSheetSongsCount(int count) {
    return '$count பாடல்கள்';
  }

  @override
  String get playlistSheetNameHint => 'பிளேலிஸ்ட் பெயர்';

  @override
  String get playlistSheetCancel => 'ரத்து';

  @override
  String playlistSheetAddedTo(String name) {
    return '$name இல் சேர்க்கப்பட்டது';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'உருவாக்க முடியவில்லை: அங்கீகாரப் பிழை';

  @override
  String playlistSheetCreateFail(String error) {
    return 'உருவாக்க முடியவில்லை: $error';
  }

  @override
  String get playlistSheetCreate => 'உருவாக்கு';

  @override
  String get appUpdateAvailable => 'அப்டேட் கிடைக்கிறது';

  @override
  String appUpdateDesc(String version) {
    return 'பதிப்பு $version வந்துவிட்டது! புதிய அம்சங்களுக்கு அப்டேட் செய்யவும்.';
  }

  @override
  String get appUpdateDownload => 'அப்டேட்டைப் பதிவிறக்கு';

  @override
  String get navHome => 'முகப்பு';

  @override
  String get navLibrary => 'லைப்ரரி';

  @override
  String get navSearch => 'தேடல்';

  @override
  String get navSettings => 'செட்டிங்ஸ்';

  @override
  String get navProfile => 'புரொஃபைல்';

  @override
  String get artistSelect => 'கலைஞரைத் தேர்வு செய்';

  @override
  String get songActionQueue => 'வரிசையில் சேர்';

  @override
  String get songActionPlaylist => 'பிளேலிஸ்ட்டில் சேர்';

  @override
  String get songActionFinding => 'தேடுகிறது...';

  @override
  String get songActionAlbum => 'ஆல்பத்திற்குச் செல்';

  @override
  String get songActionArtist => 'கலைஞருக்குச் செல்';

  @override
  String get songActionRemovePlaylist => 'பிளேலிஸ்ட்டில் இருந்து நீக்கு';

  @override
  String get songActionRemoveDownload => 'பதிவிறக்கங்களில் இருந்து நீக்கு';

  @override
  String get songActionDownloadChecking => 'சரிபார்க்கிறது...';

  @override
  String get songActionDownloading => 'பதிவிறக்குகிறது...';

  @override
  String get songActionDownloaded => 'பதிவிறக்கப்பட்டது!';

  @override
  String get songActionDownloadAlready => 'ஏற்கனவே பதிவிறக்கப்பட்டது';

  @override
  String get songActionDownloadFailed => 'பதிவிறக்கம் தோல்வியடைந்தது';

  @override
  String get songActionDownload => 'பதிவிறக்கு';

  @override
  String get songActionDownloadingSnack => 'பதிவிறக்குகிறது';

  @override
  String get songActionView => 'காண்க';

  @override
  String get spotifyImportTitle => 'Spotify இலிருந்து இம்போர்ட் செய்';

  @override
  String get spotifyImportSubtitle => 'பிளேலிஸ்ட் அளவைத் தேர்வு செய்யவும்';

  @override
  String get spotifyChoiceSmallTitle => '100 பாடல்கள் அல்லது அதற்குக் குறைவு';

  @override
  String get spotifyChoiceSmallDesc =>
      'பப்ளிக் Spotify பிளேலிஸ்ட் URL ஐ ஒட்டவும்.';

  @override
  String get spotifyChoiceLargeTitle => '100 பாடல்களுக்கு மேல்';

  @override
  String get spotifyChoiceLargeDesc =>
      'வரம்பற்ற டிராக்குகளை இம்போர்ட் செய்ய உங்கள் சொந்த Spotify Developer App ஐ இணைக்கவும்.';

  @override
  String get cancelButton => 'ரத்து';

  @override
  String get spotifyPlaylistsTitle => 'உங்கள் Spotify பிளேலிஸ்ட்கள்';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'பிழை: $error\nஉங்கள் Client ID சரியாக உள்ளதா எனச் சரிபார்க்கவும்.';
  }

  @override
  String get spotifyPlaylistsEmpty =>
      'உங்கள் லைப்ரரியில் எந்தப் பிளேலிஸ்ட்டும் இல்லை';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count டிராக்குகள்';
  }

  @override
  String get spotifyPlaylistsImport => 'இம்போர்ட் செய்';

  @override
  String get audioPlaybackFailed =>
      'பிளேபேக் தோல்வியடைந்தது. இணைய இணைப்பைச் சரிபார்க்கவும்.';

  @override
  String get audioControlPrevious => 'முந்தையது';

  @override
  String get audioControlPause => 'இடைநிறுத்து';

  @override
  String get audioControlPlay => 'பிளே';

  @override
  String get audioControlNext => 'அடுத்தது';

  @override
  String get audioControlUnlike => 'அன்லைக்';

  @override
  String get audioControlLike => 'லைக்';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'ரா ரெஸ்பான்ஸ்: $data\n\nஃபால்பேக்: $error';
  }

  @override
  String get apiErrorInvalidClient =>
      'தவறான கிளையண்ட் அல்லது கிளையண்ட் சீக்ரெட்.';

  @override
  String get apiErrorBadRequest =>
      'தவறான கோரிக்கை. உங்கள் உள்ளீட்டைச் சரிபார்க்கவும்.';

  @override
  String get apiErrorUnauthorized => 'அங்கீகாரமற்றது. மீண்டும் உள்நுழையவும்.';

  @override
  String get apiErrorForbidden =>
      'தடைசெய்யப்பட்டுள்ளது. உங்களுக்கு அணுகல் இல்லை.';

  @override
  String get apiErrorNotFound => 'வளம் கிடைக்கவில்லை.';

  @override
  String get apiErrorEmailInUse =>
      'இந்த மின்னஞ்சல் முகவரி ஏற்கனவே பயன்பாட்டில் உள்ளது.';

  @override
  String get apiErrorUserNotFound =>
      'இந்த மின்னஞ்சலுடன் எந்தக் கணக்கும் கிடைக்கவில்லை.';

  @override
  String get apiErrorWrongPassword => 'தவறான கடவுச்சொல்.';

  @override
  String get apiErrorInvalidCredential =>
      'உள்நுழைவு தோல்வியடைந்தது. உங்கள் விவரங்களைச் சரிபார்க்கவும்.';

  @override
  String get apiErrorNetwork =>
      'நெட்வொர்க் பிழை. உங்கள் இணைப்பைச் சரிபார்க்கவும்.';

  @override
  String get apiErrorSocketTimeout =>
      'இணைப்பு காலாவதியானது. மீண்டும் முயலவும்.';

  @override
  String get apiErrorTooManyRequests =>
      'மிக அதிகமான கோரிக்கைகள். சிறிது நேரம் கழித்து மீண்டும் முயலவும்.';

  @override
  String get apiErrorServerError =>
      'சர்வர் பிழை. சிறிது நேரம் கழித்து மீண்டும் முயலவும்.';

  @override
  String get apiErrorInvalidEmail => 'சரியான மின்னஞ்சல் முகவரியை உள்ளிடவும்.';

  @override
  String get apiErrorWeakPassword =>
      'கடவுச்சொல் மிகவும் பலவீனமாக உள்ளது. குறைந்தது 6 எழுத்துகளைப் பயன்படுத்தவும்.';

  @override
  String get apiErrorTooManyAttempts =>
      'பல முறை தவறாக முயன்றுள்ளீர்கள். பின்னர் மீண்டும் முயலவும்.';

  @override
  String get homeForgottenFavorites => 'மறந்த விருப்பங்கள்';

  @override
  String get artistShowAll => 'அனைத்தையும் காட்டு';

  @override
  String get homeTopTracks => 'சிறந்த பாடல்கள்';
}
