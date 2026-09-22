// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'সম্পর্কে';

  @override
  String get artistPopular => 'জনপ্রিয়';

  @override
  String get artistAlbums => 'অ্যালবাম';

  @override
  String get artistSinglesAndEPs => 'সিঙ্গেল ও ইপি';

  @override
  String artistSubscribersCount(String count) {
    return '$count জন সাবস্ক্রাইবার';
  }

  @override
  String get artistPlayAll => 'সব চালান';

  @override
  String get artistLoadError => 'শিল্পী লোড করা যায়নি';

  @override
  String get artistGoBack => 'ফিরে যান';

  @override
  String adminChatFailedToReply(String error) {
    return 'উত্তর দেওয়া যায়নি: $error';
  }

  @override
  String get adminChatSupportChat => 'সহায়তা চ্যাট';

  @override
  String adminChatError(String error) {
    return 'ত্রুটি: $error';
  }

  @override
  String get adminChatNoHistory => 'কোনো পূর্ববর্তী কথোপকথন নেই।';

  @override
  String get adminChatSupportYou => 'সহায়তা (আপনি)';

  @override
  String get adminChatTypeReply => 'আপনার উত্তর লিখুন...';

  @override
  String get broadcastSuccess => 'ঘোষণা সফলভাবে সম্প্রচারিত হয়েছে!';

  @override
  String broadcastFailed(String error) {
    return 'সম্প্রচার করা যায়নি: $error';
  }

  @override
  String get broadcastTitle => 'বৈশ্বিক ঘোষণা';

  @override
  String get broadcastSubtitle => 'সকল ব্যবহারকারীকে পাঠানো হয়েছে';

  @override
  String get broadcastWarning => 'এখানে পাঠানো বার্তা সবাই দেখতে পাবে।';

  @override
  String broadcastError(String error) {
    return 'ত্রুটি: $error';
  }

  @override
  String get broadcastNoHistory => 'কোনো পূর্ববর্তী ঘোষণা নেই।';

  @override
  String get broadcastTypeMessage => 'একটি বৈশ্বিক ঘোষণা লিখুন...';

  @override
  String commFailedToSend(String error) {
    return 'পাঠানো যায়নি: $error';
  }

  @override
  String get commAdminDashboard => 'অ্যাডমিন ড্যাশবোর্ড';

  @override
  String get commAdminSupport => 'অ্যাডমিন সহায়তা';

  @override
  String get commAlwaysHere => 'সাহায্য করতে সর্বদা প্রস্তুত';

  @override
  String get commWelcomeTitle => 'হ্যালো! 👋 আমি আশুতোষ পাঠক';

  @override
  String get commWelcomeSubtitle => 'Pulse এর ডেভেলপার';

  @override
  String get commWelcomeBody1 =>
      'আমি আশা করি আপনি বিরক্তিকর বিজ্ঞাপন বা সাবস্ক্রিপশন ছাড়াই আপনার প্রিয় সঙ্গীত উপভোগ করছেন। কারণ সঙ্গীত শুধুমাত্র টাকার বিনিময়ে পাওয়া উচিত নয়।\n\nএই বিভাগটি সরাসরি যোগাযোগ করার জন্য।\n\nআপনার জন্য উন্মুক্ত:';

  @override
  String get commBullet1 => 'আপনার মতামত জানান';

  @override
  String get commBullet2 => 'ত্রুটি রিপোর্ট করুন';

  @override
  String get commBullet3 => 'নতুন ফিচার প্রস্তাব করুন';

  @override
  String get commWelcomeBody2 =>
      'আমি নিজে প্রতিটি বার্তা পড়ি এবং আপনার পরামর্শ অনুযায়ী অ্যাপটি উন্নত করার চেষ্টা করি।\n\nআপনার কি এমন কোনো অ্যাপের ধারণা আছে যা এখনও নেই বা সাবস্ক্রিপশনে আটকে আছে? আমাকে জানান! সম্ভব হলে আমি তা তৈরি করব।\n\nঅ্যাপটি ব্যবহার করার জন্য ধন্যবাদ। ❤️';

  @override
  String commError(String error) {
    return 'ত্রুটি: $error';
  }

  @override
  String get commNoMessages => 'এখনও কোনো বার্তা নেই';

  @override
  String get commNoMessagesDesc =>
      'আমাদের সহায়তা দলকে বার্তা পাঠান অথবা পরে আবার চেক করুন।';

  @override
  String get commMessageSupportHint => 'সহায়তা দলকে লিখুন...';

  @override
  String get commGlobalAnnouncements => 'বৈশ্বিক ঘোষণা';

  @override
  String get commSendMessagesToAll => 'সব ব্যবহারকারীকে বার্তা পাঠান';

  @override
  String get homeGreetingMorning => 'শুভ সকাল,';

  @override
  String get homeGreetingAfternoon => 'শুভ অপরাহ্ন,';

  @override
  String get homeGreetingEvening => 'শুভ সন্ধ্যা,';

  @override
  String get homeMember => 'সদস্য';

  @override
  String get homeRecentPlaylists => 'সাম্প্রতিক প্লেলিস্ট';

  @override
  String get homeRecentlyPlayed => 'সম্প্রতি বাজানো হয়েছে';

  @override
  String get homeSpeedDial => 'দ্রুত ডায়াল';

  @override
  String get homeNoContent => 'কোনো কন্টেন্ট নেই';

  @override
  String get homeRefresh => 'রিফ্রেশ';

  @override
  String get homeLoadError => 'মিউজিক ফিড লোড করা যায়নি।';

  @override
  String get homeRetry => 'পুনরায় চেষ্টা করুন';

  @override
  String get importSuccess => 'সফলভাবে Spotify যুক্ত হয়েছে!';

  @override
  String importFailed(String error) {
    return 'যুক্ত করা যায়নি: $error';
  }

  @override
  String get importTitle => 'Spotify যুক্ত করুন';

  @override
  String get importSetupTitle => 'Spotify ইন্টিগ্রেশন সেটআপ';

  @override
  String get importSetupDesc =>
      'Spotify-এর সীমাবদ্ধতা এড়াতে এবং আপনার প্লেলিস্টগুলি দ্রুত ইমপোর্ট করতে আপনার নিজস্ব ডেভেলপার কি ব্যবহার করুন। এই ধাপগুলো অনুসরণ করুন:';

  @override
  String get importStep1 => 'Spotify Developer Dashboard খুলুন।';

  @override
  String get importStep2 => 'লগইন করুন এবং \"Create app\" এ ক্লিক করুন।';

  @override
  String get importStep3 => 'যেকোনো অ্যাপের নাম ও বিবরণ দিন।';

  @override
  String get importStep4 =>
      '\"Redirect URIs\" এর নিচে এই নির্দিষ্ট URL-টি পেস্ট করুন:';

  @override
  String get importRedirectCopied => 'রিডাইরেক্ট URI কপি করা হয়েছে!';

  @override
  String get importStep5 =>
      'অ্যাপটি সেভ করুন, সেটিংস থেকে আপনার \"Client ID\" কপি করুন এবং নিচে পেস্ট করুন।';

  @override
  String get importImportant =>
      'গুরুত্বপূর্ণ: এই অ্যাপ তৈরি করার জন্য আপনার Spotify অ্যাকাউন্টে একটি সক্রিয় প্রিমিয়াম সাবস্ক্রিপশন থাকতে হবে।';

  @override
  String get importClientIdHint =>
      'আপনার Spotify Client ID এখানে পেস্ট করুন...';

  @override
  String get importConnectButton => 'যুক্ত করুন ও লাইব্রেরি লোড করুন';

  @override
  String get downloadingNoActive => 'কোনো সক্রিয় ডাউনলোড নেই';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'ডাউনলোড';

  @override
  String downloadsStats(String count, String size) {
    return '$count গান • $size';
  }

  @override
  String get downloadsNoOffline => 'কোনো অফলাইন গান নেই';

  @override
  String get downloadsNoOfflineDesc => 'আপনার ডাউনলোড করা গান এখানে দেখাবে';

  @override
  String get downloadsClearAllTitle => 'সব ডাউনলোড মুছে ফেলবেন?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'এটি $count গান মুছে ফেলবে এবং $size স্টোরেজ খালি করবে।';
  }

  @override
  String get downloadsCancel => 'বাতিল';

  @override
  String get downloadsClearAll => 'সব মুছুন';

  @override
  String downloadsSongsCount(String count) {
    return '$count গান';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count গান';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'প্রধান ডাউনলোড প্লেলিস্টের নাম পরিবর্তন করা যাবে না।';

  @override
  String get downloadsRename => 'নাম পরিবর্তন';

  @override
  String get downloadsEditSongs => 'গান সম্পাদনা করুন';

  @override
  String get downloadsDelete => 'মুছুন';

  @override
  String get downloadsRenamePlaylistTitle => 'প্লেলিস্টের নাম পরিবর্তন';

  @override
  String get downloadsRenamePlaylistDesc =>
      'আপনার প্লেলিস্টের জন্য নতুন নাম লিখুন।';

  @override
  String get downloadsDeletePlaylistTitle => 'প্লেলিস্ট মুছবেন?';

  @override
  String get downloadsDeleteMasterDesc =>
      'আপনি কি নিশ্চিত? আপনি সব ডাউনলোড করা গান ও প্লেলিস্ট চিরতরে হারাবেন।';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'আপনি কি নিশ্চিত যে আপনি \"$name\" মুছতে চান? এই প্লেলিস্টটি চিরতরে হারিয়ে যাবে।';
  }

  @override
  String get downloadsSave => 'সেভ করুন';

  @override
  String get downloadsNoSongs => 'এই প্লেলিস্টে কোনো গান নেই।';

  @override
  String get libraryTitle => 'লাইব্রেরি';

  @override
  String get libraryPauseAll => 'সব পজ করুন';

  @override
  String get libraryResumeAll => 'সব পুনরায় চালু করুন';

  @override
  String get libraryTabPlaylists => 'প্লেলিস্ট';

  @override
  String get libraryTabDownloads => 'ডাউনলোড';

  @override
  String get libraryTabDownloading => 'ডাউনলোডিং';

  @override
  String libraryImportedTask(String name) {
    return '$name ইমপোর্ট করা হয়েছে';
  }

  @override
  String get libraryImportWaiting => 'অপেক্ষমান...';

  @override
  String get libraryImportFetching => 'প্লেলিস্ট সংগ্রহ করা হচ্ছে...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total প্রক্রিয়া করা হয়েছে · $matched মিলেছে';
  }

  @override
  String get libraryImportSaving => 'লাইব্রেরিতে সেভ করা হচ্ছে...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched গান যুক্ত হয়েছে · বন্ধ করতে × চাপুন';
  }

  @override
  String get libraryImportDoneAll => 'সব গান যুক্ত হয়েছে · বন্ধ করতে × চাপুন';

  @override
  String get libraryAddButton => 'যুক্ত করুন';

  @override
  String get librarySortRecent => 'সম্প্রতি যুক্ত';

  @override
  String get librarySortAlpha => 'বর্ণানুক্রমিক';

  @override
  String get libraryEmptyTitle => 'আপনার লাইব্রেরি খালি।';

  @override
  String get libraryEmptyDesc =>
      'আপনার প্রথম Pulse শুরু করতে \"যুক্ত করুন\" চাপুন।';

  @override
  String get libraryRenameLikedError =>
      'Liked Songs প্লেলিস্টের নাম পরিবর্তন করা যাবে না।';

  @override
  String get libraryRename => 'নাম পরিবর্তন';

  @override
  String get libraryEditSongs => 'গান সম্পাদনা করুন';

  @override
  String get libraryDeleteLikedError => 'Liked Songs প্লেলিস্ট মুছা যাবে না।';

  @override
  String get libraryDelete => 'মুছুন';

  @override
  String get libraryEditSongsTitle => 'গান সম্পাদনা করুন';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count গান';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count গান';
  }

  @override
  String get libraryCancel => 'বাতিল';

  @override
  String get librarySave => 'সেভ করুন';

  @override
  String get libraryNoSongs => 'এই প্লেলিস্টে কোনো গান নেই।';

  @override
  String get libraryAddOptionsTitle => 'লাইব্রেরিতে যুক্ত করুন';

  @override
  String get libraryAddOptionsDesc =>
      'আপনি কীভাবে আপনার Pulse প্রসারিত করবেন তা নির্বাচন করুন';

  @override
  String get libraryImportPulse => 'Pulse থেকে ইমপোর্ট করুন';

  @override
  String get libraryImportPulseDesc => 'একটি Pulse প্লেলিস্টের URL পেস্ট করুন';

  @override
  String get libraryImportYtm => 'YT Music থেকে ইমপোর্ট করুন';

  @override
  String get libraryImportYtmDesc => 'একটি পাবলিক প্লেলিস্টের URL পেস্ট করুন';

  @override
  String get libraryImportSpotify => 'Spotify থেকে ইমপোর্ট করুন';

  @override
  String get libraryImportSpotifyDesc => 'আপনার Spotify যুক্ত করুন';

  @override
  String get libraryClose => 'বন্ধ করুন';

  @override
  String get libraryImportYtmFull => 'YouTube Music থেকে ইমপোর্ট করুন';

  @override
  String get libraryImportSpotifyFull => 'Spotify থেকে ইমপোর্ট করুন (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'একটি পাবলিক YouTube Music প্লেলিস্ট বা অ্যালবামের URL পেস্ট করুন';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'একটি পাবলিক Spotify প্লেলিস্টের URL নিচে পেস্ট করুন';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Pulse প্লেলিস্ট ইমপোর্ট করা যায়নি';

  @override
  String get importErrorPlaylist => 'প্লেলিস্ট ইমপোর্ট করার সময় ত্রুটি';

  @override
  String get importErrorHighlyPopulated =>
      'প্লেলিস্ট অনেক বড়, সংগ্রহ করতে সময় লাগতে পারে।';

  @override
  String get libraryImportBtn => 'ইমপোর্ট';

  @override
  String get libraryCreateTitle => 'নতুন প্লেলিস্ট';

  @override
  String get libraryCreateDesc => 'আমরা আপনার নতুন প্লেলিস্টের কী নাম দেব?';

  @override
  String get libraryCreateHint => 'উদাঃ Midnight Rides';

  @override
  String get libraryCreateBtn => 'তৈরি করুন';

  @override
  String get libraryRenameTitle => 'প্লেলিস্টের নাম পরিবর্তন';

  @override
  String get libraryRenameDesc => 'আপনার প্লেলিস্টের জন্য নতুন নাম লিখুন।';

  @override
  String get libraryRenameBtn => 'নাম পরিবর্তন';

  @override
  String get libraryDeleteTitle => 'প্লেলিস্ট মুছবেন?';

  @override
  String libraryDeleteDesc(String name) {
    return 'আপনি কি নিশ্চিত যে আপনি \"$name\" মুছতে চান? এই প্লেলিস্টটি চিরতরে হারিয়ে যাবে।';
  }

  @override
  String get libraryDeleteBtn => 'মুছুন';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'সাম্প্রতিক';

  @override
  String librarySongsCount(String count) {
    return '$count গান';
  }

  @override
  String get libraryComingSoon => 'শীঘ্রই আসছে';

  @override
  String get loginErrName => 'দয়া করে আপনার নাম লিখুন';

  @override
  String get loginErrEmail => 'দয়া করে আপনার ইমেল লিখুন';

  @override
  String get loginErrPassword => 'দয়া করে আপনার পাসওয়ার্ড লিখুন';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'প্রতিটি সুর অনুভব করুন!';

  @override
  String get loginMadeWithHeartBy => 'ভালোবাসার সাথে তৈরি করেছেন: ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'আপনার নাম';

  @override
  String get loginHintEmail => 'ইমেল ঠিকানা';

  @override
  String get loginHintPassword => 'পাসওয়ার্ড';

  @override
  String get loginErrEmailReset => 'পাসওয়ার্ড রিসেট করতে ইমেল লিখুন';

  @override
  String get loginResetSent => 'রিসেট ইমেল পাঠানো হয়েছে! ইনবক্স চেক করুন।';

  @override
  String get loginForgotPwd => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get loginBtnSignup => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get loginBtnSignin => 'সাইন ইন';

  @override
  String get loginToggleHaveAccount => 'আগে থেকেই Pulse অ্যাকাউন্ট আছে? ';

  @override
  String get loginToggleNoAccount => 'Pulse অ্যাকাউন্ট নেই? ';

  @override
  String get loginToggleSignin => 'সাইন ইন';

  @override
  String get loginToggleSignup => 'সাইন আপ';

  @override
  String get offlineStillOffline => 'এখনও অফলাইনে আছেন। আপনার সংযোগ চেক করুন。';

  @override
  String get offlineTitle => 'আপনি অফলাইনে আছেন';

  @override
  String get offlineSubtitle =>
      'কোনো ইন্টারনেট সংযোগ নেই।\nনেটওয়ার্ক চেক করে আবার চেষ্টা করুন।';

  @override
  String get offlineChecking => 'চেক করা হচ্ছে...';

  @override
  String get offlineRetry => 'পুনরায় চেষ্টা করুন';

  @override
  String get offlineGoToDownloads => 'ডাউনলোডে যান';

  @override
  String get playerMadeWithHeartBy => 'ভালোবাসার সাথে তৈরি করেছেন: ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'লিরিক্স দেখতে সোয়াইপ করুন';

  @override
  String get playerNoLyrics => 'কোনো লিরিক্স নেই';

  @override
  String get playerUpNext => 'পরবর্তী';

  @override
  String get playerNoTracksInQueue => 'পরবর্তীতে কোনো গান নেই';

  @override
  String get playerNoMusicPlaying => 'কোনো সঙ্গীত বাজছে না';

  @override
  String get playerPickAVibe => 'আপনার লাইব্রেরি বা হোম থেকে একটি গান বেছে নিন';

  @override
  String get playerGoHome => 'হোমে যান';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'ইকুয়ালাইজার';

  @override
  String get playerEqCustom => 'কাস্টম';

  @override
  String get playlistDownloads => 'ডাউনলোড';

  @override
  String get playlistOffline => 'অফলাইন প্লেলিস্ট';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hoursঘ $minsমি';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$minsমি';
  }

  @override
  String get playlistFindOnPage => 'এই পৃষ্ঠায় খুঁজুন';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count গান • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'সাম্প্রতিক';

  @override
  String get playlistNoMatches => 'কিছুই পাওয়া যায়নি।';

  @override
  String get playlistNoTracks => 'এই প্লেলিস্টে কোনো গান নেই।';

  @override
  String get playlistNoSongsYet => 'এখনও কোনো গান নেই।';

  @override
  String get playlistSortRecentlyAdded => 'সম্প্রতি যুক্ত';

  @override
  String get playlistSortAlphabetical => 'বর্ণানুক্রমিক';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'টি গান',
      one: 'টি গান',
    );
    return '$count $_temp0 ডাউনলোড হচ্ছে';
  }

  @override
  String get playlistView => 'দেখুন';

  @override
  String get playlistAllDownloaded => 'সব গান আগে থেকেই ডাউনলোড করা আছে';

  @override
  String playlistShareText(String name, String url) {
    return 'Pulse-এ \"$name\" শুনুন!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'ডাউনলোড থেকে মুছুন';

  @override
  String get playlistRemoveFromPlaylist => 'প্লেলিস্ট থেকে মুছুন';

  @override
  String get playlistLoadError => 'এই প্লেলিস্ট লোড করা যায়নি।';

  @override
  String get playlistGoBack => '← ফিরে যান';

  @override
  String get profileNotLoggedIn => 'লগইন করা নেই';

  @override
  String get profileSignIn => 'সাইন ইন';

  @override
  String get profileDefaultUser => 'Pulse ব্যবহারকারী';

  @override
  String get profileEditProfile => 'প্রোফাইল সম্পাদনা';

  @override
  String get profileTimeframeDay => 'দিন';

  @override
  String get profileTimeframeWeek => 'সপ্তাহ';

  @override
  String get profileTimeframeMonth => 'মাস';

  @override
  String get profileTimeframeYear => 'বছর';

  @override
  String get profileListeningTime => 'শোনার সময়';

  @override
  String get profileToday => 'আজ';

  @override
  String get profileThisWeek => 'এই সপ্তাহে';

  @override
  String get profileThisMonth => 'এই মাসে';

  @override
  String get profileThisYear => 'এই বছরে';

  @override
  String get profileDailyAvg => 'দৈনিক গড়';

  @override
  String get profilePerDay => 'প্রতিদিন';

  @override
  String get profileLifetimeListening => 'সর্বমোট শোনার সময়';

  @override
  String get profileTotalTimeListened => 'Pulse-এ মোট সঙ্গীত শোনার সময়';

  @override
  String get profileYourTopSongs => 'আপনার প্রিয় গান';

  @override
  String get profileListeningHistoryEmpty => 'আপনার শোনার ইতিহাস এখানে দেখাবে।';

  @override
  String profilePlays(int count) {
    return '$count বার বাজানো হয়েছে';
  }

  @override
  String get profileYourTopArtists => 'আপনার প্রিয় শিল্পী';

  @override
  String get profileTopArtistsEmpty => 'আপনার প্রিয় শিল্পীরা এখানে দেখাবে।';

  @override
  String get profileArtistLabel => 'শিল্পী';

  @override
  String get profileSignOut => 'সাইন আউট';

  @override
  String profileVersion(String version) {
    return 'সংস্করণ $version';
  }

  @override
  String get profileMadeWithHeartBy => 'ভালোবাসার সাথে তৈরি করেছেন: ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'প্রোফাইল সম্পাদনা';

  @override
  String get profileDisplayName => 'প্রদর্শিত নাম';

  @override
  String get profileCancel => 'বাতিল';

  @override
  String get profileSave => 'সেভ করুন';

  @override
  String get profileChooseAvatar => 'অ্যাভাটার বেছে নিন';

  @override
  String get searchMicPermissionRequired =>
      'এই ফিচারের জন্য মাইক্রোফোন অনুমতি প্রয়োজন';

  @override
  String get searchUnknownSong => 'অজানা গান';

  @override
  String get searchUnknownArtist => 'অজানা শিল্পী';

  @override
  String get searchNoSongDetected => 'কোনো গান শনাক্ত করা যায়নি।';

  @override
  String searchError(String message) {
    return 'ত্রুটি: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'ভয়েস সার্চ উপলব্ধ নেই';

  @override
  String get searchHint => 'গান, শিল্পী, অ্যালবাম, প্লেলিস্ট…';

  @override
  String get searchRecentEmpty => 'আপনার সাম্প্রতিক সার্চ এখানে দেখাবে';

  @override
  String get searchRecentSearches => 'সাম্প্রতিক সার্চ';

  @override
  String get searchClearAll => 'সব মুছুন';

  @override
  String searchNoResultsFor(String query) {
    return '\"$query\"-এর জন্য কোনো ফলাফল নেই';
  }

  @override
  String get searchTryDifferentKeywords => 'অন্য শব্দ দিয়ে চেষ্টা করুন';

  @override
  String get searchTopResult => 'শীর্ষ ফলাফল';

  @override
  String get searchSongsLabel => 'গান';

  @override
  String get searchArtistsLabel => 'শিল্পী';

  @override
  String get searchAlbumsLabel => 'অ্যালবাম';

  @override
  String get searchPlaylistsLabel => 'প্লেলিস্ট';

  @override
  String get searchArtistLabel => 'শিল্পী';

  @override
  String get searchListening => 'শুনছি...';

  @override
  String get searchSpeakNow => 'সার্চ করতে এখন বলুন';

  @override
  String get searchCancel => 'বাতিল';

  @override
  String get searchIdentifying => 'শনাক্ত করা হচ্ছে...';

  @override
  String get searchListeningForSong => 'গানের জন্য শুনছি...';

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get settingsStreamingQuality => 'স্ট্রিমিং কোয়ালিটি';

  @override
  String get settingsQualityAutomatic => 'স্বয়ংক্রিয়';

  @override
  String get settingsQualityLow => 'নিম্ন';

  @override
  String get settingsQualityNormal => 'সাধারণ';

  @override
  String get settingsQualityHigh => 'উচ্চ';

  @override
  String get settingsDownloadQuality => 'ডাউনলোড কোয়ালিটি';

  @override
  String get settingsPlayback => 'প্লেব্যাক';

  @override
  String get settingsCrossfade => 'ক্রসফেড';

  @override
  String get settingsCrossfadeDesc =>
      'গ্যাপলেস ট্রানজিশনের জন্য ট্র্যাক ওভারল্যাপ করুন';

  @override
  String get settingsDataUsage => 'ডেটা ব্যবহার';

  @override
  String get settingsDataSaver => 'ডেটা সেভার';

  @override
  String get settingsDataSaverDesc =>
      'মোবাইল ডেটায় নিম্ন কোয়ালিটিতে স্ট্রিম করুন';

  @override
  String get settingsAppearance => 'অ্যাপিয়ারেন্স';

  @override
  String get settingsLanguage => 'ভাষা';

  @override
  String get settingsCustomAccent => 'কাস্টম অ্যাকসেন্ট';

  @override
  String get settingsSaturation => 'স্যাচুরেশন';

  @override
  String get settingsBrightness => 'উজ্জ্বলতা';

  @override
  String get settingsResetDefault => 'ডিফল্টে রিসেট করুন';

  @override
  String get playlistSheetTitle => 'প্লেলিস্টে যুক্ত করুন';

  @override
  String get playlistSheetNewPlaylist => 'নতুন প্লেলিস্ট';

  @override
  String get playlistSheetNoPlaylists => 'এখনও কোনো প্লেলিস্ট নেই';

  @override
  String playlistSheetSongsCount(int count) {
    return '$count গান';
  }

  @override
  String get playlistSheetNameHint => 'প্লেলিস্টের নাম';

  @override
  String get playlistSheetCancel => 'বাতিল';

  @override
  String playlistSheetAddedTo(String name) {
    return '$name-এ যুক্ত করা হয়েছে';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'প্লেলিস্ট তৈরি করা যায়নি: অথেনটিকেশন ত্রুটি';

  @override
  String playlistSheetCreateFail(String error) {
    return 'প্লেলিস্ট তৈরি করা যায়নি: $error';
  }

  @override
  String get playlistSheetCreate => 'তৈরি করুন';

  @override
  String get appUpdateAvailable => 'আপডেট উপলব্ধ';

  @override
  String appUpdateDesc(String version) {
    return 'সংস্করণ $version এসে গেছে! নতুন ফিচার পেতে আপডেট করুন।';
  }

  @override
  String get appUpdateDownload => 'আপডেট ডাউনলোড করুন';

  @override
  String get navHome => 'হোম';

  @override
  String get navLibrary => 'লাইব্রেরি';

  @override
  String get navSearch => 'সার্চ';

  @override
  String get navSettings => 'সেটিংস';

  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String get artistSelect => 'শিল্পী বেছে নিন';

  @override
  String get songActionQueue => 'পরবর্তীতে যুক্ত করুন';

  @override
  String get songActionPlaylist => 'প্লেলিস্টে যুক্ত করুন';

  @override
  String get songActionFinding => 'খোঁজা হচ্ছে...';

  @override
  String get songActionAlbum => 'অ্যালবামে যান';

  @override
  String get songActionArtist => 'শিল্পীতে যান';

  @override
  String get songActionRemovePlaylist => 'প্লেলিস্ট থেকে মুছুন';

  @override
  String get songActionRemoveDownload => 'ডাউনলোড থেকে মুছুন';

  @override
  String get songActionDownloadChecking => 'চেক করা হচ্ছে...';

  @override
  String get songActionDownloading => 'ডাউনলোড হচ্ছে...';

  @override
  String get songActionDownloaded => 'ডাউনলোড হয়েছে!';

  @override
  String get songActionDownloadAlready => 'আগে থেকেই ডাউনলোড করা আছে';

  @override
  String get songActionDownloadFailed => 'ডাউনলোড ব্যর্থ হয়েছে';

  @override
  String get songActionDownload => 'ডাউনলোড';

  @override
  String get songActionDownloadingSnack => 'ডাউনলোড হচ্ছে';

  @override
  String get songActionView => 'দেখুন';

  @override
  String get spotifyImportTitle => 'Spotify থেকে ইমপোর্ট করুন';

  @override
  String get spotifyImportSubtitle => 'প্লেলিস্টের আকার নির্বাচন করুন';

  @override
  String get spotifyChoiceSmallTitle => '১০০টি বা তার কম গান';

  @override
  String get spotifyChoiceSmallDesc =>
      'একটি পাবলিক Spotify প্লেলিস্টের URL পেস্ট করুন।';

  @override
  String get spotifyChoiceLargeTitle => '১০০টির বেশি গান';

  @override
  String get spotifyChoiceLargeDesc =>
      'সীমাহীন ট্র্যাক ইমপোর্ট করতে আপনার নিজস্ব Spotify Developer App যুক্ত করুন।';

  @override
  String get cancelButton => 'বাতিল';

  @override
  String get spotifyPlaylistsTitle => 'আপনার Spotify প্লেলিস্ট';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'ত্রুটি: $error\nআপনার Client ID সঠিক কিনা তা নিশ্চিত করুন।';
  }

  @override
  String get spotifyPlaylistsEmpty =>
      'আপনার লাইব্রেরিতে কোনো প্লেলিস্ট পাওয়া যায়নি';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count টি ট্র্যাক';
  }

  @override
  String get spotifyPlaylistsImport => 'ইমপোর্ট';

  @override
  String get audioPlaybackFailed =>
      'প্লেব্যাক ব্যর্থ হয়েছে। ইন্টারনেট সংযোগ চেক করুন।';

  @override
  String get audioControlPrevious => 'পূর্ববর্তী';

  @override
  String get audioControlPause => 'পজ';

  @override
  String get audioControlPlay => 'প্লে';

  @override
  String get audioControlNext => 'পরবর্তী';

  @override
  String get audioControlUnlike => 'আনলাইক';

  @override
  String get audioControlLike => 'লাইক';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'র রেসপন্স: $data\n\nফলব্যাক: $error';
  }

  @override
  String get apiErrorInvalidClient => 'অবৈধ ক্লায়েন্ট বা ক্লায়েন্ট সিক্রেট।';

  @override
  String get apiErrorBadRequest => 'ভুল অনুরোধ। আপনার ইনপুট চেক করুন।';

  @override
  String get apiErrorUnauthorized => 'অননুমোদিত। আবার লগইন করুন।';

  @override
  String get apiErrorForbidden => 'নিষিদ্ধ। আপনার অ্যাক্সেস নেই।';

  @override
  String get apiErrorNotFound => 'রিসোর্স পাওয়া যায়নি।';

  @override
  String get apiErrorEmailInUse => 'এই ইমেল ঠিকানা আগে থেকেই ব্যবহৃত।';

  @override
  String get apiErrorUserNotFound =>
      'এই ইমেলের সাথে কোনো অ্যাকাউন্ট পাওয়া যায়নি।';

  @override
  String get apiErrorWrongPassword => 'ভুল পাসওয়ার্ড।';

  @override
  String get apiErrorInvalidCredential =>
      'লগইন ব্যর্থ হয়েছে। আপনার ক্রেডেনশিয়াল চেক করুন।';

  @override
  String get apiErrorNetwork => 'নেটওয়ার্ক ত্রুটি। আপনার সংযোগ চেক করুন।';

  @override
  String get apiErrorSocketTimeout =>
      'সংযোগের সময় শেষ হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get apiErrorTooManyRequests =>
      'অনেক বেশি অনুরোধ। কিছুক্ষণ অপেক্ষা করে আবার চেষ্টা করুন।';

  @override
  String get apiErrorServerError =>
      'সার্ভার ত্রুটি। একটু পরে আবার চেষ্টা করুন।';

  @override
  String get apiErrorInvalidEmail => 'একটি সঠিক ইমেল ঠিকানা লিখুন।';

  @override
  String get apiErrorWeakPassword =>
      'পাসওয়ার্ড খুব দুর্বল। অন্তত ৬টি অক্ষর ব্যবহার করুন।';

  @override
  String get apiErrorTooManyAttempts =>
      'অনেকবার ভুল চেষ্টা করা হয়েছে। পরে আবার চেষ্টা করুন।';

  @override
  String get homeForgottenFavorites => 'ভুলে যাওয়া প্রিয় গান';

  @override
  String get artistShowAll => 'সব দেখুন';

  @override
  String get homeTopTracks => 'শীর্ষ ট্র্যাক';
}
