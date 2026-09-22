// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Assamese (`as`).
class AppLocalizationsAs extends AppLocalizations {
  AppLocalizationsAs([String locale = 'as']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'বিষয়ে';

  @override
  String get artistPopular => 'জনপ্ৰিয়';

  @override
  String get artistAlbums => 'এলবাম';

  @override
  String get artistSinglesAndEPs => 'ছিংগলচ আৰু EP';

  @override
  String artistSubscribersCount(String count) {
    return '$count চাবস্ক্ৰাইবাৰ';
  }

  @override
  String get artistPlayAll => 'সকলো বজাওক';

  @override
  String get artistLoadError => 'শিল্পী ল\'ড কৰিব পৰা নগ\'ল';

  @override
  String get artistGoBack => 'উভতি যাওক';

  @override
  String adminChatFailedToReply(String error) {
    return 'উত্তৰ দিব পৰা নগ\'ল: $error';
  }

  @override
  String get adminChatSupportChat => 'চাপোৰ্ট চেট';

  @override
  String adminChatError(String error) {
    return 'ভুল: $error';
  }

  @override
  String get adminChatNoHistory => 'কোনো আগতীয়া বাৰ্তালাপ নাই।';

  @override
  String get adminChatSupportYou => 'চাপোৰ্ট (আপুনি)';

  @override
  String get adminChatTypeReply => 'আপোনাৰ উত্তৰ লিখক...';

  @override
  String get broadcastSuccess => 'ঘোষণা সফলতাৰে প্ৰেৰণ কৰা হ\'ল!';

  @override
  String broadcastFailed(String error) {
    return 'প্ৰেৰণ কৰিব পৰা নগ\'ল: $error';
  }

  @override
  String get broadcastTitle => 'গ্ল\'বেল ঘোষণা';

  @override
  String get broadcastSubtitle => 'সকলো ব্যৱহাৰকাৰীলৈ প্ৰেৰণ কৰা হ\'ল';

  @override
  String get broadcastWarning => 'ইয়াত প্ৰেৰণ কৰা বাৰ্তা সকলোৱে দেখিবলৈ পাব।';

  @override
  String broadcastError(String error) {
    return 'ভুল: $error';
  }

  @override
  String get broadcastNoHistory => 'কোনো আগতীয়া ঘোষণা নাই।';

  @override
  String get broadcastTypeMessage => 'এটা গ্ল\'বেল ঘোষণা লিখক...';

  @override
  String commFailedToSend(String error) {
    return 'প্ৰেৰণ কৰিব পৰা নগ\'ল: $error';
  }

  @override
  String get commAdminDashboard => 'এডমিন ডেশ্ববৰ্ড';

  @override
  String get commAdminSupport => 'এডমিন চাপোৰ্ট';

  @override
  String get commAlwaysHere => 'সহায় কৰিবলৈ সদায় সাজু';

  @override
  String get commWelcomeTitle => 'নমস্কাৰ! 👋 মই আশুতোষ পাঠক';

  @override
  String get commWelcomeSubtitle => 'Pulse ৰ ডেভেলপাৰ';

  @override
  String get commWelcomeBody1 =>
      'মই আশা কৰোঁ আপুনি কোনো বিজ্ঞাপন বা চাবস্ক্ৰিপচনৰ বাধা নোহোৱাকৈ আপোনাৰ প্ৰিয় সংগীত উপভোগ কৰি আছে। সংগীত কেৱল ধনী লোকৰ বাবে সীমাবদ্ধ হ\'ব নালাগে।\n\nএই অংশটো আমাৰ পোনপটীয়া যোগাযোগৰ বাবে।\n\nআপুনি মোক জনাব পাৰে:';

  @override
  String get commBullet1 => 'আপোনাৰ মতামত';

  @override
  String get commBullet2 => 'ভুলৰ ৰিপ\'ৰ্ট';

  @override
  String get commBullet3 => 'নতুন ফিচাৰৰ পৰামৰ্শ';

  @override
  String get commWelcomeBody2 =>
      'মই নিজে প্ৰতিটো বাৰ্তা পঢ়ো আৰু আপোনাৰ পৰামৰ্শৰে এপটো অধিক উন্নত কৰিম।\n\nআপোনাৰ ওচৰত এনে কোনো এপৰ ধাৰণা আছে নেকি যিটো চাবস্ক্ৰিপচনৰ আঁৰত লুকুৱাই থোৱা আছে? মোক জনাওক! সম্ভৱ হ\'লে মই সেয়া সকলোৰে বাবে নিৰ্মাণ কৰিম।\n\nএই যাত্ৰাত সংগী হোৱাৰ বাবে ধন্যবাদ। ❤️';

  @override
  String commError(String error) {
    return 'ভুল: $error';
  }

  @override
  String get commNoMessages => 'এতিয়ালৈকে কোনো বাৰ্তা নাই';

  @override
  String get commNoMessagesDesc =>
      'আমাৰ চাপোৰ্ট টীমলৈ বাৰ্তা পঠাওক বা পিছত আকৌ চাওক।';

  @override
  String get commMessageSupportHint => 'চাপোৰ্ট টীমলৈ লিখক...';

  @override
  String get commGlobalAnnouncements => 'গ্ল\'বেল ঘোষণাসমূহ';

  @override
  String get commSendMessagesToAll => 'সকলোলৈ বাৰ্তা পঠাওক';

  @override
  String get homeGreetingMorning => 'সুপ্ৰভাত,';

  @override
  String get homeGreetingAfternoon => 'শুভ অপৰাহ্ন,';

  @override
  String get homeGreetingEvening => 'শুভ সন্ধ্যা,';

  @override
  String get homeMember => 'সদস্য';

  @override
  String get homeRecentPlaylists => 'সাম্প্ৰতিক প্লেলিষ্টসমূহ';

  @override
  String get homeRecentlyPlayed => 'শেহতীয়াকৈ বজোৱা';

  @override
  String get homeSpeedDial => 'স্পীড ডায়েল';

  @override
  String get homeNoContent => 'কোনো সমল নাই';

  @override
  String get homeRefresh => 'ৰিফ্ৰেছ';

  @override
  String get homeLoadError => 'মিউজিক ফিড ল\'ড কৰিব পৰা নগ\'ল।';

  @override
  String get homeRetry => 'পুনৰ চেষ্টা কৰক';

  @override
  String get importSuccess => 'Spotify সফলতাৰে সংযোগ কৰা হ\'ল!';

  @override
  String importFailed(String error) {
    return 'সংযোগ কৰিব পৰা নগ\'ল: $error';
  }

  @override
  String get importTitle => 'Spotify সংযোগ কৰক';

  @override
  String get importSetupTitle => 'Spotify ছেটআপ';

  @override
  String get importSetupDesc =>
      'Spotify ৰ সীমাবন্ধতাসমূহ অতিক্ৰম কৰি আপোনাৰ প্লেলিষ্টসমূহ দ্ৰুতভাৱে ইম্প\'ৰ্ট কৰিবলৈ আপোনাৰ নিজৰ ডেভেলপাৰ কী ব্যৱহাৰ কৰক। এই পদক্ষেপসমূহ অনুসৰণ কৰক:';

  @override
  String get importStep1 => 'Spotify Developer Dashboard খোলক।';

  @override
  String get importStep2 => 'লগ ইন কৰক আৰু \"Create app\" ত ক্লিক কৰক।';

  @override
  String get importStep3 => 'এপৰ এটা নাম আৰু বিৱৰণ দিয়ক।';

  @override
  String get importStep4 =>
      '\"Redirect URIs\" ৰ তলত এই নিৰ্দিষ্ট URL পেষ্ট কৰক:';

  @override
  String get importRedirectCopied => 'ৰিডাইৰেক্ট URI কপি কৰা হ\'ল!';

  @override
  String get importStep5 =>
      'এপ ছেভ কৰক, ছেটিংছৰ পৰা আপোনাৰ \"Client ID\" কপি কৰক আৰু তলত পেষ্ট কৰক।';

  @override
  String get importImportant =>
      'গুৰুত্বপূৰ্ণ: এই ডেভেলপাৰ এপটো নিৰ্মাণ কৰিবলৈ ব্যৱহাৰ কৰা Spotify একাউন্টত এক্টিভ প্ৰিমিয়াম চাবস্ক্ৰিপচন থাকিব লাগিব।';

  @override
  String get importClientIdHint =>
      'আপোনাৰ Spotify Client ID ইয়াত পেষ্ট কৰক...';

  @override
  String get importConnectButton => 'সংযোগ কৰক আৰু লাইব্ৰেৰী ল\'ড কৰক';

  @override
  String get downloadingNoActive => 'কোনো সক্ৰিয় ডাউনলোড নাই';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'ডাউনলোডসমূহ';

  @override
  String downloadsStats(String count, String size) {
    return '$count টা গান • $size';
  }

  @override
  String get downloadsNoOffline => 'কোনো অফলাইন গান নাই';

  @override
  String get downloadsNoOfflineDesc =>
      'আপুনি ডাউনলোড কৰা গানসমূহ ইয়াত দেখা যাব';

  @override
  String get downloadsClearAllTitle => 'সকলো ক্লিয়াৰ কৰিব নেকি?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'ই $count টা গান মচি পেলাব আৰু $size ষ্ট\'ৰেজ খালী কৰিব।';
  }

  @override
  String get downloadsCancel => 'বাতিল কৰক';

  @override
  String get downloadsClearAll => 'সকলো ক্লিয়াৰ';

  @override
  String downloadsSongsCount(String count) {
    return '$count টা গান';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count টা গান';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'মূল ডাউনলোড প্লেলিষ্টৰ নাম সলনি কৰিব নোৱাৰি।';

  @override
  String get downloadsRename => 'নাম সলনি কৰক';

  @override
  String get downloadsEditSongs => 'গানসমূহ সম্পাদনা কৰক';

  @override
  String get downloadsDelete => 'মচি পেলাওক';

  @override
  String get downloadsRenamePlaylistTitle => 'প্লেলিষ্টৰ নাম সলনি কৰক';

  @override
  String get downloadsRenamePlaylistDesc =>
      'প্লেলিষ্টৰ বাবে এটা নতুন নাম লিখক।';

  @override
  String get downloadsDeletePlaylistTitle => 'প্লেলিষ্ট মচি পেলাব নেকি?';

  @override
  String get downloadsDeleteMasterDesc =>
      'আপুনি নিশ্চিতনে? আপুনি সকলো ডাউনলোড কৰা গান আৰু প্লেলিষ্ট চিৰদিনৰ বাবে হেৰুৱাব।';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'আপুনি নিশ্চিতনে যে আপুনি \"$name\" মচি পেলাব বিচাৰে? এই প্লেলিষ্টটো চিৰদিনৰ বাবে হেৰাই যাব।';
  }

  @override
  String get downloadsSave => 'ছেভ কৰক';

  @override
  String get downloadsNoSongs => 'এই প্লেলিষ্টত কোনো গান নাই।';

  @override
  String get libraryTitle => 'লাইব্ৰেৰী';

  @override
  String get libraryPauseAll => 'সকলো পজ কৰক';

  @override
  String get libraryResumeAll => 'সকলো পুনৰ আৰম্ভ কৰক';

  @override
  String get libraryTabPlaylists => 'প্লেলিষ্টসমূহ';

  @override
  String get libraryTabDownloads => 'ডাউনলোডসমূহ';

  @override
  String get libraryTabDownloading => 'ডাউনলোড হৈ আছে';

  @override
  String libraryImportedTask(String name) {
    return '$name ইম্প\'ৰ্ট কৰা হ\'ল';
  }

  @override
  String get libraryImportWaiting => 'অপেক্ষা কৰি আছে...';

  @override
  String get libraryImportFetching => 'প্লেলিষ্ট আনি আছে...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total প্ৰক্ৰিয়া কৰা হ\'ল · $matched মিল পালে';
  }

  @override
  String get libraryImportSaving => 'লাইব্ৰেৰীত ছেভ কৰি আছে...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched টা গান যোগ কৰা হ\'ল · বন্ধ কৰিবলৈ × টিপক';
  }

  @override
  String get libraryImportDoneAll =>
      'সকলো গান যোগ কৰা হ\'ল · বন্ধ কৰিবলৈ × টিপক';

  @override
  String get libraryAddButton => 'যোগ কৰক';

  @override
  String get librarySortRecent => 'শেহতীয়াকৈ যোগ কৰা';

  @override
  String get librarySortAlpha => 'বৰ্ণানুক্ৰমিক';

  @override
  String get libraryEmptyTitle => 'আপোনাৰ লাইব্ৰেৰী খালী।';

  @override
  String get libraryEmptyDesc =>
      'আপোনাৰ প্ৰথম Pulse আৰম্ভ কৰিবলৈ \"যোগ কৰক\" টিপক।';

  @override
  String get libraryRenameLikedError =>
      'Liked Songs প্লেলিষ্টৰ নাম সলনি কৰিব নোৱাৰি।';

  @override
  String get libraryRename => 'নাম সলনি কৰক';

  @override
  String get libraryEditSongs => 'গানসমূহ সম্পাদনা কৰক';

  @override
  String get libraryDeleteLikedError =>
      'Liked Songs প্লেলিষ্ট মচি পেলাব নোৱাৰি।';

  @override
  String get libraryDelete => 'মচি পেলাওক';

  @override
  String get libraryEditSongsTitle => 'গানসমূহ সম্পাদনা কৰক';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count টা গান';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count টা গান';
  }

  @override
  String get libraryCancel => 'বাতিল কৰক';

  @override
  String get librarySave => 'ছেভ কৰক';

  @override
  String get libraryNoSongs => 'এই প্লেলিষ্টত কোনো গান নাই।';

  @override
  String get libraryAddOptionsTitle => 'লাইব্ৰেৰীত যোগ কৰক';

  @override
  String get libraryAddOptionsDesc =>
      'আপোনাৰ Pulse লাইব্ৰেৰী কেনেকৈ বঢ়াব বাছনি কৰক';

  @override
  String get libraryImportPulse => 'Pulse ৰ পৰা ইম্প\'ৰ্ট কৰক';

  @override
  String get libraryImportPulseDesc => 'এটা Pulse প্লেলিষ্টৰ URL পেষ্ট কৰক';

  @override
  String get libraryImportYtm => 'YT Music ৰ পৰা ইম্প\'ৰ্ট কৰক';

  @override
  String get libraryImportYtmDesc => 'এটা পাব্লিক প্লেলিষ্টৰ URL পেষ্ট কৰক';

  @override
  String get libraryImportSpotify => 'Spotify ৰ পৰা ইম্প\'ৰ্ট কৰক';

  @override
  String get libraryImportSpotifyDesc => 'আপোনাৰ Spotify সংযোগ কৰক';

  @override
  String get libraryClose => 'বন্ধ কৰক';

  @override
  String get libraryImportYtmFull => 'YouTube Music ৰ পৰা ইম্প\'ৰ্ট কৰক';

  @override
  String get libraryImportSpotifyFull => 'Spotify ৰ পৰা ইম্প\'ৰ্ট কৰক (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'এটা পাব্লিক YouTube Music প্লেলিষ্ট বা এলবামৰ URL পেষ্ট কৰক';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'এটা পাব্লিক Spotify প্লেলিষ্টৰ URL তলত পেষ্ট কৰক';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Pulse প্লেলিষ্ট ইম্প\'ৰ্ট কৰিব পৰা নগ\'ল';

  @override
  String get importErrorPlaylist => 'প্লেলিষ্ট ইম্প\'ৰ্ট কৰাত ভুল';

  @override
  String get importErrorHighlyPopulated =>
      'প্লেলিষ্টটো বহুত ডাঙৰ, আনিবলৈ কিছু সময় লাগিব পাৰে।';

  @override
  String get libraryImportBtn => 'ইম্প\'ৰ্ট কৰক';

  @override
  String get libraryCreateTitle => 'নতুন প্লেলিষ্ট';

  @override
  String get libraryCreateDesc => 'আপোনাৰ নতুন প্লেলিষ্টৰ নাম কি থ\'ব বিচাৰে?';

  @override
  String get libraryCreateHint => 'যেনে- Midnight Rides';

  @override
  String get libraryCreateBtn => 'নিৰ্মাণ কৰক';

  @override
  String get libraryRenameTitle => 'প্লেলিষ্টৰ নাম সলনি কৰক';

  @override
  String get libraryRenameDesc => 'প্লেলিষ্টৰ বাবে এটা নতুন নাম লিখক।';

  @override
  String get libraryRenameBtn => 'নাম সলনি কৰক';

  @override
  String get libraryDeleteTitle => 'প্লেলিষ্ট মচি পেলাব নেকি?';

  @override
  String libraryDeleteDesc(String name) {
    return 'আপুনি নিশ্চিতনে যে আপুনি \"$name\" মচি পেলাব বিচাৰে? এই প্লেলিষ্টটো চিৰদিনৰ বাবে হেৰাই যাব।';
  }

  @override
  String get libraryDeleteBtn => 'মচি পেলাওক';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'শেহতীয়া';

  @override
  String librarySongsCount(String count) {
    return '$count টা গান';
  }

  @override
  String get libraryComingSoon => 'অতি সোনকালেই আহি আছে';

  @override
  String get loginErrName => 'অনুগ্ৰহ কৰি আপোনাৰ নাম দিয়ক';

  @override
  String get loginErrEmail => 'অনুগ্ৰহ কৰি আপোনাৰ ইমেইল দিয়ক';

  @override
  String get loginErrPassword => 'অনুগ্ৰহ কৰি আপোনাৰ পাছৱৰ্ড দিয়ক';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'প্ৰতিটো বিট অনুভৱ কৰক!';

  @override
  String get loginMadeWithHeartBy => 'মৰমেৰে নিৰ্মাণ কৰা হৈছে: ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'আপোনাৰ নাম';

  @override
  String get loginHintEmail => 'ইমেইল ঠিকনা';

  @override
  String get loginHintPassword => 'পাছৱৰ্ড';

  @override
  String get loginErrEmailReset => 'পাছৱৰ্ড ৰিছেট কৰিবলৈ ইমেইল দিয়ক';

  @override
  String get loginResetSent => 'ৰিছেট ইমেইল পঠোৱা হ\'ল! ইনবক্স চাওক।';

  @override
  String get loginForgotPwd => 'পাছৱৰ্ড পাহৰিছে নেকি?';

  @override
  String get loginBtnSignup => 'একাউন্ট নিৰ্মাণ কৰক';

  @override
  String get loginBtnSignin => 'চাইন ইন কৰক';

  @override
  String get loginToggleHaveAccount => 'আগৰে পৰা Pulse একাউন্ট আছে নেকি? ';

  @override
  String get loginToggleNoAccount => 'Pulse একাউন্ট নাই নেকি? ';

  @override
  String get loginToggleSignin => 'চাইন ইন কৰক';

  @override
  String get loginToggleSignup => 'চাইন আপ কৰক';

  @override
  String get offlineStillOffline => 'এতিয়াও অফলাইন। সংযোগ পৰীক্ষা কৰক।';

  @override
  String get offlineTitle => 'আপুনি অফলাইন আছে';

  @override
  String get offlineSubtitle =>
      'কোনো ইণ্টাৰনেট সংযোগ নাই।\nনেটৱৰ্ক পৰীক্ষা কৰক আৰু পুনৰ চেষ্টা কৰক।';

  @override
  String get offlineChecking => 'পৰীক্ষা কৰি আছে...';

  @override
  String get offlineRetry => 'পুনৰ চেষ্টা কৰক';

  @override
  String get offlineGoToDownloads => 'ডাউনলোডসমূহলৈ যাওক';

  @override
  String get playerMadeWithHeartBy => 'মৰমেৰে নিৰ্মাণ কৰা হৈছে: ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'লিৰিক্সৰ বাবে স্বাইপ কৰক';

  @override
  String get playerNoLyrics => 'কোনো লিৰিক্স উপলব্ধ নাই';

  @override
  String get playerUpNext => 'পৰৱৰ্তী';

  @override
  String get playerNoTracksInQueue => 'শাৰীত কোনো গান নাই';

  @override
  String get playerNoMusicPlaying => 'কোনো সংগীত বাজি থকা নাই';

  @override
  String get playerPickAVibe =>
      'আপোনাৰ লাইব্ৰেৰী বা হোমৰ পৰা এটা গান বাছনি কৰক';

  @override
  String get playerGoHome => 'হোমলৈ যাওক';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'ইকুৱালাইজাৰ';

  @override
  String get playerEqCustom => 'কাষ্টম';

  @override
  String get playlistDownloads => 'ডাউনলোডসমূহ';

  @override
  String get playlistOffline => 'অফলাইন প্লেলিষ্ট';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hoursঘ $minsমি';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$minsমি';
  }

  @override
  String get playlistFindOnPage => 'এই পৃষ্ঠাত বিচাৰক';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count টা গান • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'শেহতীয়া';

  @override
  String get playlistNoMatches => 'একো পোৱা নগ\'ল।';

  @override
  String get playlistNoTracks => 'এই প্লেলিষ্টত কোনো গান নাই।';

  @override
  String get playlistNoSongsYet => 'এতিয়ালৈকে কোনো গান নাই।';

  @override
  String get playlistSortRecentlyAdded => 'শেহতীয়াকৈ যোগ কৰা';

  @override
  String get playlistSortAlphabetical => 'বৰ্ণানুক্ৰমিক';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'টা গান',
      one: 'টা গান',
    );
    return '$count $_temp0 ডাউনলোড হৈ আছে';
  }

  @override
  String get playlistView => 'চাওক';

  @override
  String get playlistAllDownloaded => 'সকলো গান আগতেই ডাউনলোড কৰা হৈছে';

  @override
  String playlistShareText(String name, String url) {
    return 'Pulse ত \"$name\" শুনক!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'ডাউনলোডৰ পৰা আঁতৰাওক';

  @override
  String get playlistRemoveFromPlaylist => 'প্লেলিষ্টৰ পৰা আঁতৰাওক';

  @override
  String get playlistLoadError => 'এই প্লেলিষ্ট ল\'ড কৰিব পৰা নগ\'ল।';

  @override
  String get playlistGoBack => '← উভতি যাওক';

  @override
  String get profileNotLoggedIn => 'লগ ইন কৰা নাই';

  @override
  String get profileSignIn => 'চাইন ইন কৰক';

  @override
  String get profileDefaultUser => 'Pulse ব্যৱহাৰকাৰী';

  @override
  String get profileEditProfile => 'প্ৰফাইল সম্পাদনা';

  @override
  String get profileTimeframeDay => 'দিন';

  @override
  String get profileTimeframeWeek => 'সপ্তাহ';

  @override
  String get profileTimeframeMonth => 'মাহ';

  @override
  String get profileTimeframeYear => 'বছৰ';

  @override
  String get profileListeningTime => 'শুনাৰ সময়';

  @override
  String get profileToday => 'আজি';

  @override
  String get profileThisWeek => 'এই সপ্তাহত';

  @override
  String get profileThisMonth => 'এই মাহত';

  @override
  String get profileThisYear => 'এই বছৰত';

  @override
  String get profileDailyAvg => 'দৈনিক গড়';

  @override
  String get profilePerDay => 'প্ৰতিদিনে';

  @override
  String get profileLifetimeListening => 'মুঠ শুনাৰ সময়';

  @override
  String get profileTotalTimeListened => 'Pulse ত সংগীত শুনাৰ মুঠ সময়';

  @override
  String get profileYourTopSongs => 'আপোনাৰ প্ৰিয় গানসমূহ';

  @override
  String get profileListeningHistoryEmpty =>
      'আপোনাৰ শুনাৰ হিষ্ট্ৰী ইয়াত দেখা যাব।';

  @override
  String profilePlays(int count) {
    return '$count বাৰ বজোৱা হৈছে';
  }

  @override
  String get profileYourTopArtists => 'আপোনাৰ প্ৰিয় শিল্পীসমূহ';

  @override
  String get profileTopArtistsEmpty =>
      'আপোনাৰ প্ৰিয় শিল্পীসমূহ ইয়াত দেখা যাব।';

  @override
  String get profileArtistLabel => 'শিল্পী';

  @override
  String get profileSignOut => 'চাইন আউট কৰক';

  @override
  String profileVersion(String version) {
    return 'ভাৰ্ছন $version';
  }

  @override
  String get profileMadeWithHeartBy => 'মৰমেৰে নিৰ্মাণ কৰা হৈছে: ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'প্ৰফাইল সম্পাদনা';

  @override
  String get profileDisplayName => 'প্ৰদৰ্শন নাম';

  @override
  String get profileCancel => 'বাতিল কৰক';

  @override
  String get profileSave => 'ছেভ কৰক';

  @override
  String get profileChooseAvatar => 'অৱতাৰ বাছনি কৰক';

  @override
  String get searchMicPermissionRequired =>
      'এই ফিচাৰৰ বাবে মাইক্ৰ\'ফোনৰ অনুমতি প্ৰয়োজন';

  @override
  String get searchUnknownSong => 'অজ্ঞাত গান';

  @override
  String get searchUnknownArtist => 'অজ্ঞাত শিল্পী';

  @override
  String get searchNoSongDetected => 'কোনো গান পোৱা নগ\'ল।';

  @override
  String searchError(String message) {
    return 'ভুল: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'ভইচ ছাৰ্চ উপলব্ধ নাই';

  @override
  String get searchHint => 'গান, শিল্পী, এলবাম...';

  @override
  String get searchRecentEmpty => 'আপোনাৰ শেহতীয়া ছাৰ্চ ইয়াত দেখা যাব';

  @override
  String get searchRecentSearches => 'শেহতীয়া ছাৰ্চ';

  @override
  String get searchClearAll => 'সকলো ক্লিয়াৰ';

  @override
  String searchNoResultsFor(String query) {
    return '\"$query\" ৰ বাবে কোনো ফলাফল নাই';
  }

  @override
  String get searchTryDifferentKeywords => 'বেলেগ শব্দৰে চেষ্টা কৰক';

  @override
  String get searchTopResult => 'টপ ৰিজাল্ট';

  @override
  String get searchSongsLabel => 'গানসমূহ';

  @override
  String get searchArtistsLabel => 'শিল্পীসমূহ';

  @override
  String get searchAlbumsLabel => 'এলবামসমূহ';

  @override
  String get searchPlaylistsLabel => 'প্লেলিষ্টসমূহ';

  @override
  String get searchArtistLabel => 'শিল্পী';

  @override
  String get searchListening => 'শুনি আছে...';

  @override
  String get searchSpeakNow => 'ছাৰ্চ কৰিবলৈ এতিয়া কওক';

  @override
  String get searchCancel => 'বাতিল কৰক';

  @override
  String get searchIdentifying => 'চিনাক্ত কৰি আছে...';

  @override
  String get searchListeningForSong => 'গানৰ বাবে শুনি আছে...';

  @override
  String get settingsTitle => 'ছেটিংছ';

  @override
  String get settingsStreamingQuality => 'ষ্ট্ৰীমিং কোৱালিটি';

  @override
  String get settingsQualityAutomatic => 'অটোমেটিক';

  @override
  String get settingsQualityLow => 'নিম্ন';

  @override
  String get settingsQualityNormal => 'সাধাৰণ';

  @override
  String get settingsQualityHigh => 'উচ্চ';

  @override
  String get settingsDownloadQuality => 'ডাউনলোড কোৱালিটি';

  @override
  String get settingsPlayback => 'প্লেবেক';

  @override
  String get settingsCrossfade => 'ক্ৰছফেড';

  @override
  String get settingsCrossfadeDesc =>
      'স্মুথ ট্ৰেনজিচনৰ বাবে গানসমূহ অভাৰলেপ কৰক';

  @override
  String get settingsDataUsage => 'ডেটা ব্যৱহাৰ';

  @override
  String get settingsDataSaver => 'ডেটা চেভাৰ';

  @override
  String get settingsDataSaverDesc =>
      'ম\'বাইল ডেটাত নিম্ন কোৱালিটিত ষ্ট্ৰীম কৰক';

  @override
  String get settingsAppearance => 'এপিয়াৰেন্স';

  @override
  String get settingsLanguage => 'ভাষা';

  @override
  String get settingsCustomAccent => 'কাষ্টম এক্সেন্ট';

  @override
  String get settingsSaturation => 'চেচুৰেচন';

  @override
  String get settingsBrightness => 'ব্ৰাইটনেছ';

  @override
  String get settingsResetDefault => 'ডিফল্টলৈ ৰিছেট কৰক';

  @override
  String get playlistSheetTitle => 'প্লেলিষ্টত যোগ কৰক';

  @override
  String get playlistSheetNewPlaylist => 'নতুন প্লেলিষ্ট';

  @override
  String get playlistSheetNoPlaylists => 'কোনো প্লেলিষ্ট নাই';

  @override
  String playlistSheetSongsCount(int count) {
    return '$count টা গান';
  }

  @override
  String get playlistSheetNameHint => 'প্লেলিষ্টৰ নাম';

  @override
  String get playlistSheetCancel => 'বাতিল কৰক';

  @override
  String playlistSheetAddedTo(String name) {
    return '$name ত যোগ কৰা হ\'ল';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'নিৰ্মাণ কৰিব পৰা নগ\'ল: অথেনটিকেচনৰ ভুল';

  @override
  String playlistSheetCreateFail(String error) {
    return 'নিৰ্মাণ কৰিব পৰা নগ\'ল: $error';
  }

  @override
  String get playlistSheetCreate => 'নিৰ্মাণ কৰক';

  @override
  String get appUpdateAvailable => 'আপডেট উপলব্ধ';

  @override
  String appUpdateDesc(String version) {
    return 'ভাৰ্ছন $version আহি গৈছে! নতুন ফিচাৰৰ বাবে আপডেট কৰক।';
  }

  @override
  String get appUpdateDownload => 'আপডেট ডাউনলোড কৰক';

  @override
  String get navHome => 'হোম';

  @override
  String get navLibrary => 'লাইব্ৰেৰী';

  @override
  String get navSearch => 'ছাৰ্চ';

  @override
  String get navSettings => 'ছেটিংছ';

  @override
  String get navProfile => 'প্ৰফাইল';

  @override
  String get artistSelect => 'শিল্পী বাছনি কৰক';

  @override
  String get songActionQueue => 'শাৰীত যোগ কৰক';

  @override
  String get songActionPlaylist => 'প্লেলিষ্টত যোগ কৰক';

  @override
  String get songActionFinding => 'বিচাৰি আছে...';

  @override
  String get songActionAlbum => 'এলবামলৈ যাওক';

  @override
  String get songActionArtist => 'শিল্পীলৈ যাওক';

  @override
  String get songActionRemovePlaylist => 'প্লেলিষ্টৰ পৰা আঁতৰাওক';

  @override
  String get songActionRemoveDownload => 'ডাউনলোডৰ পৰা আঁতৰাওক';

  @override
  String get songActionDownloadChecking => 'পৰীক্ষা কৰি আছে...';

  @override
  String get songActionDownloading => 'ডাউনলোড হৈ আছে...';

  @override
  String get songActionDownloaded => 'ডাউনলোড হ\'ল!';

  @override
  String get songActionDownloadAlready => 'আগতেই ডাউনলোড কৰা হৈছে';

  @override
  String get songActionDownloadFailed => 'ডাউনলোড বিফল হ\'ল';

  @override
  String get songActionDownload => 'ডাউনলোড';

  @override
  String get songActionDownloadingSnack => 'ডাউনলোড হৈ আছে';

  @override
  String get songActionView => 'চাওক';

  @override
  String get spotifyImportTitle => 'Spotify ৰ পৰা ইম্প\'ৰ্ট কৰক';

  @override
  String get spotifyImportSubtitle => 'প্লেলিষ্টৰ আকাৰ বাছনি কৰক';

  @override
  String get spotifyChoiceSmallTitle => '১০০ টা গান বা তাতকৈ কম';

  @override
  String get spotifyChoiceSmallDesc =>
      'এটা পাব্লিক Spotify প্লেলিষ্টৰ URL পেষ্ট কৰক।';

  @override
  String get spotifyChoiceLargeTitle => '১০০ টাতকৈ বেছি গান';

  @override
  String get spotifyChoiceLargeDesc =>
      'অসীমিত ট্ৰেকসমূহ ইম্প\'ৰ্ট কৰিবলৈ আপোনাৰ নিজৰ Spotify Developer App সংযোগ কৰক।';

  @override
  String get cancelButton => 'বাতিল কৰক';

  @override
  String get spotifyPlaylistsTitle => 'আপোনাৰ Spotify প্লেলিষ্টসমূহ';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'ভুল: $error\nআপোনাৰ Client ID শুদ্ধ হয় নে নহয় পৰীক্ষা কৰক।';
  }

  @override
  String get spotifyPlaylistsEmpty => 'আপোনাৰ লাইব্ৰেৰীত কোনো প্লেলিষ্ট নাই';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count ট্ৰেক';
  }

  @override
  String get spotifyPlaylistsImport => 'ইম্প\'ৰ্ট';

  @override
  String get audioPlaybackFailed =>
      'প্লেবেক বিফল হ\'ল। ইণ্টাৰনেট সংযোগ পৰীক্ষা কৰক।';

  @override
  String get audioControlPrevious => 'পূৰ্বৱৰ্তী';

  @override
  String get audioControlPause => 'পজ';

  @override
  String get audioControlPlay => 'প্লে';

  @override
  String get audioControlNext => 'পৰৱৰ্তী';

  @override
  String get audioControlUnlike => 'আনলাইক';

  @override
  String get audioControlLike => 'লাইক';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'মূল সঁহাৰি: $data\n\nফলবেক: $error';
  }

  @override
  String get apiErrorInvalidClient => 'ভুল ক্লায়েন্ট বা ক্লায়েন্ট চিক্ৰেট।';

  @override
  String get apiErrorBadRequest =>
      'বেয়া অনুৰোধ। অনুগ্ৰহ কৰি আপোনাৰ ইনপুট পৰীক্ষা কৰক।';

  @override
  String get apiErrorUnauthorized => 'অনুমোদনহীন। অনুগ্ৰহ কৰি পুনৰ লগ ইন কৰক।';

  @override
  String get apiErrorForbidden => 'নিষিদ্ধ। আপোনাৰ প্ৰৱেশাধিকাৰ নাই।';

  @override
  String get apiErrorNotFound => 'সম্পদ পোৱা নগ\'ল।';

  @override
  String get apiErrorEmailInUse =>
      'এই ইমেইল ঠিকনাটো ইতিমধ্যে ব্যৱহাৰ কৰা হৈছে।';

  @override
  String get apiErrorUserNotFound =>
      'এই ইমেইলৰ সৈতে জড়িত কোনো একাউন্ট পোৱা নগ\'ল।';

  @override
  String get apiErrorWrongPassword => 'ভুল পাছৱৰ্ড।';

  @override
  String get apiErrorInvalidCredential =>
      'লগ ইন বিফল হ\'ল। আপোনাৰ তথ্য পৰীক্ষা কৰক।';

  @override
  String get apiErrorNetwork => 'নেটৱৰ্কৰ ভুল। আপোনাৰ সংযোগ পৰীক্ষা কৰক।';

  @override
  String get apiErrorSocketTimeout => 'সংযোগৰ সময় উকলি গ\'ল। পুনৰ চেষ্টা কৰক।';

  @override
  String get apiErrorTooManyRequests =>
      'অত্যাধিক অনুৰোধ। কিছু সময় পাছত পুনৰ চেষ্টা কৰক।';

  @override
  String get apiErrorServerError =>
      'চাৰ্ভাৰৰ ভুল। কিছু সময় পাছত পুনৰ চেষ্টা কৰক।';

  @override
  String get apiErrorInvalidEmail => 'অনুগ্ৰহ কৰি এটা বৈধ ইমেইল ঠিকনা দিয়ক।';

  @override
  String get apiErrorWeakPassword =>
      'পাছৱৰ্ড অতি দুৰ্বল। কমেও ৬ টা আখৰ ব্যৱহাৰ কৰক।';

  @override
  String get apiErrorTooManyAttempts =>
      'অত্যাধিক বিফল প্ৰচেষ্টা। পিছত পুনৰ চেষ্টা কৰক।';

  @override
  String get homeForgottenFavorites => 'পাহৰি যোৱা প্ৰিয় গান';

  @override
  String get artistShowAll => 'সকলো দেখুৱাওক';

  @override
  String get homeTopTracks => 'শীৰ্ষ ট্ৰেক';
}
