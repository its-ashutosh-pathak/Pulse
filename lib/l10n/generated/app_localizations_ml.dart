// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'കുറിച്ച്';

  @override
  String get artistPopular => 'ജനപ്രിയമായവ';

  @override
  String get artistAlbums => 'ആൽബങ്ങൾ';

  @override
  String get artistSinglesAndEPs => 'സിംഗിൾസ് & EP';

  @override
  String artistSubscribersCount(String count) {
    return '$count സബ്‌സ്‌ക്രൈബർമാർ';
  }

  @override
  String get artistPlayAll => 'എല്ലാം പ്ലേ ചെയ്യുക';

  @override
  String get artistLoadError => 'ആർട്ടിസ്റ്റിനെ ലോഡ് ചെയ്യാനായില്ല';

  @override
  String get artistGoBack => 'പുറകോട്ട് പോകുക';

  @override
  String adminChatFailedToReply(String error) {
    return 'മറുപടി നൽകാനായില്ല: $error';
  }

  @override
  String get adminChatSupportChat => 'സപ്പോർട്ട് ചാറ്റ്';

  @override
  String adminChatError(String error) {
    return 'പിശക്: $error';
  }

  @override
  String get adminChatNoHistory => 'മുൻ സംഭാഷണങ്ങളൊന്നുമില്ല.';

  @override
  String get adminChatSupportYou => 'സപ്പോർട്ട് (നിങ്ങൾ)';

  @override
  String get adminChatTypeReply => 'നിങ്ങളുടെ മറുപടി ടൈപ്പ് ചെയ്യുക...';

  @override
  String get broadcastSuccess => 'അറിയിപ്പ് വിജയകരമായി സംപ്രേക്ഷണം ചെയ്തു!';

  @override
  String broadcastFailed(String error) {
    return 'സംപ്രേക്ഷണം ചെയ്യാനായില്ല: $error';
  }

  @override
  String get broadcastTitle => 'ആഗോള അറിയിപ്പുകൾ';

  @override
  String get broadcastSubtitle => 'എല്ലാ ഉപയോക്താക്കൾക്കും അയച്ചു';

  @override
  String get broadcastWarning =>
      'ഇവിടെ അയയ്ക്കുന്ന സന്ദേശങ്ങൾ എല്ലാവർക്കും ദൃശ്യമാകും.';

  @override
  String broadcastError(String error) {
    return 'പിശക്: $error';
  }

  @override
  String get broadcastNoHistory => 'മുൻ അറിയിപ്പുകളൊന്നുമില്ല.';

  @override
  String get broadcastTypeMessage => 'ഒരു ആഗോള അറിയിപ്പ് ടൈപ്പ് ചെയ്യുക...';

  @override
  String commFailedToSend(String error) {
    return 'അയയ്ക്കാനായില്ല: $error';
  }

  @override
  String get commAdminDashboard => 'അഡ്മിൻ ഡാഷ്‌ബോർഡ്';

  @override
  String get commAdminSupport => 'അഡ്മിൻ സപ്പോർട്ട്';

  @override
  String get commAlwaysHere => 'സഹായിക്കാൻ എപ്പോഴും തയ്യാറാണ്';

  @override
  String get commWelcomeTitle => 'നമസ്കാരം! 👋 ഞാൻ അശുതೋಷ് പാഠക്';

  @override
  String get commWelcomeSubtitle => 'Pulse ഡെവಲപ്പർ';

  @override
  String get commWelcomeBody1 =>
      'പരസ്യങ്ങളോ സബ്‌സ്‌ക്രിപ്‌ഷൻ തടസ്സങ്ങളോ ഇല്ലാതെ നിങ്ങളുടെ പ്രിയപ്പെട്ട സംഗീതം നിങ്ങൾ ആസ്വദിക്കുന്നുണ്ടെന്ന് ഞാൻ കരുതുന്നു. സംഗീതം പണക്കാർക്ക് മാത്രം സ്വന്തമാകാൻ പാടില്ല.\n\nനമുക്ക് നേരിട്ട് ബന്ധപ്പെടാനാണ് ഈ വിഭാഗം.\n\nനിങ്ങൾക്ക് പറയാനുള്ളത്:';

  @override
  String get commBullet1 => 'നിങ്ങളുടെ അഭിപ്രായങ്ങൾ';

  @override
  String get commBullet2 => 'പിശകുകൾ റിപ്പോർട്ട് ചെയ്യുക';

  @override
  String get commBullet3 => 'പുതിയ ഫീച്ചറുകൾ നിർദ്ദേശിക്കുക';

  @override
  String get commWelcomeBody2 =>
      'ഓരോ സന്ദേശവും ഞാൻ വായിക്കുകയും നിങ്ങളുടെ നിർദ്ദേശങ്ങൾക്കനുസരിച്ച് ആപ്പ് മെച്ചപ്പെടുത്തുകയും ചെയ്യും.\n\nസബ്‌സ്‌ക്രിപ്‌ഷനുകളിൽ കുടുങ്ങിക്കിടക്കുന്ന പുതിയ ആപ്പ് ആശയങ്ങൾ നിങ്ങൾക്കുണ്ടോ? എന്നെ അറിയിക്കുക! സാധ്യമെങ്കിൽ ഞാൻ അത് എല്ലാവർക്കുമായി നിർമ്മിക്കും.\n\nഈ യാത്രയിൽ ഒപ്പമുള്ളതിന് നന്ദി. ❤️';

  @override
  String commError(String error) {
    return 'പിശക്: $error';
  }

  @override
  String get commNoMessages => 'ഇതുവരെ സന്ദേശങ്ങളൊന്നുമില്ല';

  @override
  String get commNoMessagesDesc =>
      'ഞങ്ങളുടെ സപ്പോർട്ട് ടീമിന് സന്ദേശമയയ്‌ക്കുക അല്ലെങ്കിൽ പിന്നീട് പരിശോധിക്കുക.';

  @override
  String get commMessageSupportHint => 'സപ്പോർട്ട് ടീമിന് എഴുതുക...';

  @override
  String get commGlobalAnnouncements => 'ആഗോള അറിയിപ്പുകൾ';

  @override
  String get commSendMessagesToAll => 'എല്ലാവർക്കും സന്ദേശമയയ്‌ക്കുക';

  @override
  String get homeGreetingMorning => 'സുപ്രഭാതം,';

  @override
  String get homeGreetingAfternoon => 'ശുഭ ഉച്ചതിരിഞ്ഞ്,';

  @override
  String get homeGreetingEvening => 'ശുഭ സായാഹ്നം,';

  @override
  String get homeMember => 'അംഗം';

  @override
  String get homeRecentPlaylists => 'സമീപകാല പ്ലേലിസ്റ്റുകൾ';

  @override
  String get homeRecentlyPlayed => 'സമീപകാലത്ത് പ്ലേ ചെയ്തവ';

  @override
  String get homeSpeedDial => 'സ്പീഡ് ഡയൽ';

  @override
  String get homeNoContent => 'ഉള്ളടക്കമില്ല';

  @override
  String get homeRefresh => 'റിഫ്രഷ്';

  @override
  String get homeLoadError => 'സംഗീതം ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get homeRetry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get importSuccess => 'Spotify വിജയകരമായി കണക്‌റ്റ് ചെയ്‌തു!';

  @override
  String importFailed(String error) {
    return 'കണക്‌റ്റ് ചെയ്യാനായില്ല: $error';
  }

  @override
  String get importTitle => 'Spotify കണക്റ്റ് ചെയ്യുക';

  @override
  String get importSetupTitle => 'Spotify സജ്ജീകരണം';

  @override
  String get importSetupDesc =>
      'Spotify പരിമിതികൾ ഒഴിവാക്കി നിങ്ങളുടെ പ്ലേലിസ്റ്റുകൾ വേഗത്തിൽ ഇംപോർട്ട് ചെയ്യാൻ നിങ്ങളുടെ ഡെവലപ്പർ കീ ഉപയോഗിക്കുക. ഈ ഘട്ടങ്ങൾ പാലിക്കുക:';

  @override
  String get importStep1 => 'Spotify Developer Dashboard തുറക്കുക.';

  @override
  String get importStep2 => 'ലോഗിൻ ചെയ്ത് \"Create app\" ക്ലിക്ക് ചെയ്യുക.';

  @override
  String get importStep3 => 'ആപ്പിന് ഒരു പേരും വിവരണവും നൽകുക.';

  @override
  String get importStep4 => '\"Redirect URIs\" താഴെ ഈ URL ഒട്ടിക്കുക:';

  @override
  String get importRedirectCopied => 'റീഡയറക്റ്റ് URI പകർത്തി!';

  @override
  String get importStep5 =>
      'ആപ്പ് സേവ് ചെയ്ത്, ക്രമീകരണങ്ങളിൽ നിന്നും നിങ്ങളുടെ \"Client ID\" പകർത്തി താഴെ ഒട്ടിക്കുക.';

  @override
  String get importImportant =>
      'പ്രധാനപ്പെട്ടത്: ഈ ഡെവലപ്പർ ആപ്പ് നിർമ്മിക്കാൻ ഉപയോഗിക്കുന്ന Spotify അക്കൗണ്ടിന് ഒരു ആക്റ്റീവ് പ്രീമിയം സബ്‌സ്‌ക്രിപ്‌ഷൻ ഉണ്ടായിരിക്കണം.';

  @override
  String get importClientIdHint =>
      'നിങ്ങളുടെ Spotify Client ID ഇവിടെ ഒട്ടിക്കുക...';

  @override
  String get importConnectButton => 'കണക്റ്റ് & ലൈബ്രറി ലോഡ് ചെയ്യുക';

  @override
  String get downloadingNoActive => 'സജീവ ഡൗൺലോഡുകളൊന്നുമില്ല';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'ഡൗൺലോഡുകൾ';

  @override
  String downloadsStats(String count, String size) {
    return '$count ഗാനങ്ങൾ • $size';
  }

  @override
  String get downloadsNoOffline => 'ഓഫ്‌ലൈൻ ഗാനങ്ങളില്ല';

  @override
  String get downloadsNoOfflineDesc =>
      'നിങ്ങൾ ഡൗൺലോഡ് ചെയ്ത ഗാനങ്ങൾ ഇവിടെ കാണിക്കും';

  @override
  String get downloadsClearAllTitle => 'എല്ലാം മായ്‌ക്കണോ?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'ഇത് $count ഗാനങ്ങൾ ഇല്ലാതാക്കുകയും $size സ്റ്റോറേജ് ശൂന്യമാക്കുകയും ചെയ്യും.';
  }

  @override
  String get downloadsCancel => 'റദ്ദാക്കുക';

  @override
  String get downloadsClearAll => 'എല്ലാം മായ്‌ക്കുക';

  @override
  String downloadsSongsCount(String count) {
    return '$count ഗാനങ്ങൾ';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count ഗാനം';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'പ്രധാന ഡൗൺലോഡ് പ്ലേലിസ്റ്റിന്റെ പേരുമാറ്റാൻ കഴിയില്ല.';

  @override
  String get downloadsRename => 'പേരുമാറ്റുക';

  @override
  String get downloadsEditSongs => 'ഗാനങ്ങൾ എഡിറ്റ് ചെയ്യുക';

  @override
  String get downloadsDelete => 'ഇല്ലാതാക്കുക';

  @override
  String get downloadsRenamePlaylistTitle => 'പ്ലേലിസ്റ്റിന്റെ പേരുമാറ്റുക';

  @override
  String get downloadsRenamePlaylistDesc =>
      'നിങ്ങളുടെ പ്ലേലിസ്റ്റിന് പുതിയ പേര് നൽകുക.';

  @override
  String get downloadsDeletePlaylistTitle => 'പ്ലേലിസ്റ്റ് ഇല്ലാതാക്കണോ?';

  @override
  String get downloadsDeleteMasterDesc =>
      'തീർച്ചയാണോ? ഡൗൺലോഡ് ചെയ്ത എല്ലാ ഗാനങ്ങളും പ്ലേലിസ്റ്റുകളും ശാശ്വതമായി നഷ്‌ടപ്പെടും.';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return '\"$name\" ഇല്ലാതാക്കണമെന്ന് ഉറപ്പാണോ? ഈ പ്ലേലിസ്റ്റ് ശാശ്വതമായി നഷ്‌ടപ്പെടും.';
  }

  @override
  String get downloadsSave => 'സേവ് ചെയ്യുക';

  @override
  String get downloadsNoSongs => 'ഈ പ്ലേലിസ്റ്റിൽ ഗാനങ്ങളൊന്നുമില്ല.';

  @override
  String get libraryTitle => 'ലൈബ്രറി';

  @override
  String get libraryPauseAll => 'എല്ലാം താൽക്കാലികമായി നിർത്തുക';

  @override
  String get libraryResumeAll => 'എല്ലാം പുനരാരംഭിക്കുക';

  @override
  String get libraryTabPlaylists => 'പ്ലേലിസ്റ്റുകൾ';

  @override
  String get libraryTabDownloads => 'ഡൗൺലോഡുകൾ';

  @override
  String get libraryTabDownloading => 'ഡൗൺലോഡ് ചെയ്യുന്നു';

  @override
  String libraryImportedTask(String name) {
    return '$name ഇംപോർട്ട് ചെയ്തു';
  }

  @override
  String get libraryImportWaiting => 'കാത്തിരിക്കുന്നു...';

  @override
  String get libraryImportFetching => 'പ്ലേലിസ്റ്റ് എടുക്കുന്നു...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total പ്രോസസ്സ് ചെയ്തു · $matched മാച്ച് ചെയ്തു';
  }

  @override
  String get libraryImportSaving => 'ലൈബ്രറിയിലേക്ക് സേവ് ചെയ്യുന്നു...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched ഗാനങ്ങൾ ചേർത്തു · അടയ്ക്കാൻ × അമർത്തുക';
  }

  @override
  String get libraryImportDoneAll =>
      'എല്ലാ ഗാനങ്ങളും ചേർത്തു · അടയ്ക്കാൻ × അമർത്തുക';

  @override
  String get libraryAddButton => 'ചേർക്കുക';

  @override
  String get librarySortRecent => 'സമീപകാലത്ത് ചേർത്തവ';

  @override
  String get librarySortAlpha => 'അക്ഷരമാലാക്രമം';

  @override
  String get libraryEmptyTitle => 'നിങ്ങളുടെ ലൈബ്രറി ശൂന്യമാണ്.';

  @override
  String get libraryEmptyDesc =>
      'നിങ്ങളുടെ ആദ്യത്തെ Pulse ആരംഭിക്കാൻ \"ചേർക്കുക\" അമർത്തുക.';

  @override
  String get libraryRenameLikedError =>
      'Liked Songs പ്ലേലിസ്റ്റിന്റെ പേരുമാറ്റാൻ കഴിയില്ല.';

  @override
  String get libraryRename => 'പേരുമാറ്റുക';

  @override
  String get libraryEditSongs => 'ഗാനങ്ങൾ എഡിറ്റ് ചെയ്യുക';

  @override
  String get libraryDeleteLikedError =>
      'Liked Songs പ്ലേലിസ്റ്റ് ഇല്ലാതാക്കാൻ കഴിയില്ല.';

  @override
  String get libraryDelete => 'ഇല്ലാതാക്കുക';

  @override
  String get libraryEditSongsTitle => 'ഗാനങ്ങൾ എഡിറ്റ് ചെയ്യുക';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count ഗാനം';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count ഗാനങ്ങൾ';
  }

  @override
  String get libraryCancel => 'റദ്ദാക്കുക';

  @override
  String get librarySave => 'സേവ് ചെയ്യുക';

  @override
  String get libraryNoSongs => 'ഈ പ്ലേലിസ്റ്റിൽ ഗാനങ്ങളൊന്നുമില്ല.';

  @override
  String get libraryAddOptionsTitle => 'ലൈബ്രറിയിലേക്ക് ചേർക്കുക';

  @override
  String get libraryAddOptionsDesc =>
      'നിങ്ങളുടെ Pulse ലൈബ്രറി എങ്ങനെ വിപുലീകരിക്കാമെന്ന് തിരഞ്ഞെടുക്കുക';

  @override
  String get libraryImportPulse => 'Pulse-ൽ നിന്ന് ഇംപോർട്ട് ചെയ്യുക';

  @override
  String get libraryImportPulseDesc => 'ഒരു Pulse പ്ലേലിസ്റ്റ് URL ഒട്ടിക്കുക';

  @override
  String get libraryImportYtm => 'YT Music-ൽ നിന്ന് ഇംപോർട്ട് ചെയ്യുക';

  @override
  String get libraryImportYtmDesc => 'ഒരു പബ്ലിക് പ്ലേലിസ്റ്റ് URL ഒട്ടിക്കുക';

  @override
  String get libraryImportSpotify => 'Spotify-ൽ നിന്ന് ഇംപോർട്ട് ചെയ്യുക';

  @override
  String get libraryImportSpotifyDesc => 'നിങ്ങളുടെ Spotify കണക്റ്റ് ചെയ്യുക';

  @override
  String get libraryClose => 'അടയ്ക്കുക';

  @override
  String get libraryImportYtmFull => 'YouTube Music-ൽ നിന്ന് ഇംപോർട്ട് ചെയ്യുക';

  @override
  String get libraryImportSpotifyFull =>
      'Spotify-ൽ നിന്ന് ഇംപോർട്ട് ചെയ്യുക (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'ഒരു പബ്ലic YouTube Music പ്ലേലിസ്റ്റ് അല്ലെങ്കിൽ ആൽബം URL ഒട്ടിക്കുക';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'ഒരു പബ്ലിക് Spotify പ്ലേലിസ്റ്റ് URL താഴെ ഒട്ടിക്കുക';

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
      'Pulse പ്ലേലിസ്റ്റ് ഇംപോർട്ട് ചെയ്യാനായില്ല';

  @override
  String get importErrorPlaylist => 'പ്ലേലിസ്റ്റ് ഇംപോർട്ട് ചെയ്യുന്നതിൽ പിശക്';

  @override
  String get importErrorHighlyPopulated =>
      'പ്ലേലിസ്റ്റ് വളരെ വലുതാണ്, എടുക്കാൻ സമയമെടുത്തേക്കാം.';

  @override
  String get libraryImportBtn => 'ഇംപോർട്ട്';

  @override
  String get libraryCreateTitle => 'പുതിയ പ്ലേലിസ്റ്റ്';

  @override
  String get libraryCreateDesc => 'പുതിയ പ്ലേലിസ്റ്റിന് എന്ത് പേര് നൽകാം?';

  @override
  String get libraryCreateHint => 'ഉദാ. Midnight Rides';

  @override
  String get libraryCreateBtn => 'രൂപീകരിക്കുക';

  @override
  String get libraryRenameTitle => 'പ്ലേലിസ്റ്റിന്റെ പേരുമാറ്റുക';

  @override
  String get libraryRenameDesc => 'നിങ്ങളുടെ പ്ലേലിസ്റ്റിന് പുതിയ പേര് നൽകുക.';

  @override
  String get libraryRenameBtn => 'പേരുമാറ്റുക';

  @override
  String get libraryDeleteTitle => 'പ്ലേലിസ്റ്റ് ഇല്ലാതാക്കണോ?';

  @override
  String libraryDeleteDesc(String name) {
    return '\"$name\" ഇല്ലാതാക്കണമെന്ന് ഉറപ്പാണോ? ഈ പ്ലേലിസ്റ്റ് ശാശ്വതമായി നഷ്‌ടപ്പെടും.';
  }

  @override
  String get libraryDeleteBtn => 'ഇല്ലാതാക്കുക';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'സമീപകാലം';

  @override
  String librarySongsCount(String count) {
    return '$count ഗാനങ്ങൾ';
  }

  @override
  String get libraryComingSoon => 'ഉടൻ വരുന്നു';

  @override
  String get loginErrName => 'ദയവായി നിങ്ങളുടെ പേര് നൽകുക';

  @override
  String get loginErrEmail => 'ദയവായി നിങ്ങളുടെ ഇമെയിൽ നൽകുക';

  @override
  String get loginErrPassword => 'ദയവായി നിങ്ങളുടെ പാസ്‌വേഡ് നൽകുക';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'ഓരോ ബീറ്റും അനുഭവിക്കുക!';

  @override
  String get loginMadeWithHeartBy => 'സ്നേഹത്തോടെ നിർമ്മിച്ചത്: ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'നിങ്ങളുടെ പേര്';

  @override
  String get loginHintEmail => 'ഇമെയിൽ വിലാസം';

  @override
  String get loginHintPassword => 'പാസ്‌വേഡ്';

  @override
  String get loginErrEmailReset => 'പാസ്‌വേഡ് റീസെറ്റ് ചെയ്യാൻ ഇമെയിൽ നൽകുക';

  @override
  String get loginResetSent => 'റീസെറ്റ് ഇമെയിൽ അയച്ചു! ഇൻബോക്സ് പരിശോധിക്കുക.';

  @override
  String get loginForgotPwd => 'പാസ്‌വേഡ് മറന്നോ?';

  @override
  String get loginBtnSignup => 'അക്കൗണ്ട് നിർമ്മിക്കുക';

  @override
  String get loginBtnSignin => 'സൈൻ ഇൻ';

  @override
  String get loginToggleHaveAccount => 'നേരത്തെ Pulse അക്കൗണ്ട് ഉണ്ടോ? ';

  @override
  String get loginToggleNoAccount => 'Pulse അക്കൗണ്ട് ഇല്ലേ? ';

  @override
  String get loginToggleSignin => 'സൈൻ ഇൻ';

  @override
  String get loginToggleSignup => 'സൈൻ അപ്പ്';

  @override
  String get offlineStillOffline =>
      'ഇപ്പോഴും ഓഫ്‌ലൈനിലാണ്. കണക്ഷൻ പരിശോധിക്കുക.';

  @override
  String get offlineTitle => 'നിങ്ങൾ ഓഫ്‌ലൈനിലാണ്';

  @override
  String get offlineSubtitle =>
      'ഇന്റർനെറ്റ് കണക്ഷനില്ല.\nനെറ്റ്‌വർക്ക് പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get offlineChecking => 'പരിശോധിക്കുന്നു...';

  @override
  String get offlineRetry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get offlineGoToDownloads => 'ഡൗൺലോഡുകളിലേക്ക് പോകുക';

  @override
  String get playerMadeWithHeartBy => 'സ്നേഹത്തോടെ നിർമ്മിച്ചത്: ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'വരികൾക്കായി സ്വൈപ്പ് ചെയ്യുക';

  @override
  String get playerNoLyrics => 'വരികളൊന്നും ലഭ്യമല്ല';

  @override
  String get playerUpNext => 'അടുത്തത്';

  @override
  String get playerNoTracksInQueue => 'ക്യൂവിൽ ഗാനങ്ങളൊന്നുമില്ല';

  @override
  String get playerNoMusicPlaying => 'സംഗീതമൊന്നും പ്ലേ ചെയ്യുന്നില്ല';

  @override
  String get playerPickAVibe =>
      'നിങ്ങളുടെ ലൈബ്രറിയിൽ നിന്നോ ഹോമിൽ നിന്നോ ഒരു ഗാനം തിരഞ്ഞെടുക്കുക';

  @override
  String get playerGoHome => 'ഹോമിലേക്ക് പോകുക';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'ഇക്വലൈസർ';

  @override
  String get playerEqCustom => 'കസ്റ്റം';

  @override
  String get playlistDownloads => 'ഡൗൺലോഡുകൾ';

  @override
  String get playlistOffline => 'ഓഫ്‌ലൈൻ പ്ലേലിസ്റ്റ്';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hoursമ $minsമി';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$minsമി';
  }

  @override
  String get playlistFindOnPage => 'ഈ പേജിൽ തിരയുക';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count ഗാനങ്ങൾ • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'സമീപകാലം';

  @override
  String get playlistNoMatches => 'ഒന്നും കണ്ടെത്തിയില്ല.';

  @override
  String get playlistNoTracks => 'ഈ പ്ലേലിസ്റ്റിൽ ഗാനങ്ങളൊന്നുമില്ല.';

  @override
  String get playlistNoSongsYet => 'ഇതുവരെ ഗാനങ്ങളൊന്നുമില്ല.';

  @override
  String get playlistSortRecentlyAdded => 'സമീപകാലത്ത് ചേർത്തവ';

  @override
  String get playlistSortAlphabetical => 'അക്ഷരമാലാക്രമം';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ഗാനങ്ങൾ',
      one: 'ഗാനം',
    );
    return '$count $_temp0 ഡൗൺലോഡ് ചെയ്യുന്നു';
  }

  @override
  String get playlistView => 'കാണുക';

  @override
  String get playlistAllDownloaded => 'എല്ലാ ഗാനങ്ങളും ഇതിനകം ഡൗൺലോഡ് ചെയ്തു';

  @override
  String playlistShareText(String name, String url) {
    return 'Pulse-ൽ \"$name\" കേൾക്കൂ!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'ഡൗൺലോഡുകളിൽ നിന്ന് നീക്കം ചെയ്യുക';

  @override
  String get playlistRemoveFromPlaylist =>
      'പ്ലേലിസ്റ്റിൽ നിന്ന് നീക്കം ചെയ്യുക';

  @override
  String get playlistLoadError => 'ഈ പ്ലേലിസ്റ്റ് ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get playlistGoBack => '← പുറകോട്ട് പോകുക';

  @override
  String get profileNotLoggedIn => 'ലോഗിൻ ചെയ്തിട്ടില്ല';

  @override
  String get profileSignIn => 'സൈൻ ഇൻ';

  @override
  String get profileDefaultUser => 'Pulse ഉപയോക്താവ്';

  @override
  String get profileEditProfile => 'പ്രൊഫൈൽ എഡിറ്റ് ചെയ്യുക';

  @override
  String get profileTimeframeDay => 'ദിവസം';

  @override
  String get profileTimeframeWeek => 'ആഴ്ച';

  @override
  String get profileTimeframeMonth => 'മാസം';

  @override
  String get profileTimeframeYear => 'വർഷം';

  @override
  String get profileListeningTime => 'കേട്ട സമയം';

  @override
  String get profileToday => 'ഇന്ന്';

  @override
  String get profileThisWeek => 'ഈ ആഴ്ച';

  @override
  String get profileThisMonth => 'ഈ മാസം';

  @override
  String get profileThisYear => 'ഈ വർഷം';

  @override
  String get profileDailyAvg => 'പ്രതിദിന ശരാശരി';

  @override
  String get profilePerDay => 'ഒരു ദിവസം';

  @override
  String get profileLifetimeListening => 'ആകെ കേട്ട സമയം';

  @override
  String get profileTotalTimeListened => 'Pulse-ൽ മൊത്തം സംഗീതം കേട്ട സമയം';

  @override
  String get profileYourTopSongs => 'നിങ്ങളുടെ മികച്ച ഗാനങ്ങൾ';

  @override
  String get profileListeningHistoryEmpty =>
      'നിങ്ങൾ കേട്ട ഗാനങ്ങളുടെ ചരിത്രം ഇവിടെ കാണിക്കും.';

  @override
  String profilePlays(int count) {
    return '$count തവണ പ്ലേ ചെയ്തു';
  }

  @override
  String get profileYourTopArtists => 'നിങ്ങളുടെ മികച്ച ആർട്ടിസ്റ്റുകൾ';

  @override
  String get profileTopArtistsEmpty =>
      'നിങ്ങളുടെ പ്രിയപ്പെട്ട ആർട്ടിസ്റ്റുകൾ ഇവിടെ കാണിക്കും.';

  @override
  String get profileArtistLabel => 'ആർട്ടിസ്റ്റ്';

  @override
  String get profileSignOut => 'സൈൻ ഔട്ട്';

  @override
  String profileVersion(String version) {
    return 'പതിപ്പ് $version';
  }

  @override
  String get profileMadeWithHeartBy => 'സ്നേഹത്തോടെ നിർമ്മിച്ചത്: ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'പ്രൊഫൈൽ എഡിറ്റ് ചെയ്യുക';

  @override
  String get profileDisplayName => 'പ്രദർശിപ്പിക്കുന്ന പേര്';

  @override
  String get profileCancel => 'റദ്ദാക്കുക';

  @override
  String get profileSave => 'സേവ് ചെയ്യുക';

  @override
  String get profileChooseAvatar => 'അവതാർ തിരഞ്ഞെടുക്കുക';

  @override
  String get searchMicPermissionRequired =>
      'ഈ ഫീച്ചറിന് മൈക്രോഫോൺ അനുമതി ആവശ്യമാണ്';

  @override
  String get searchUnknownSong => 'അറിയപ്പെടാത്ത ഗാനം';

  @override
  String get searchUnknownArtist => 'അറിയപ്പെടാത്ത ആർട്ടിസ്റ്റ്';

  @override
  String get searchNoSongDetected => 'ഗാനമൊന്നും കണ്ടെത്തിയില്ല.';

  @override
  String searchError(String message) {
    return 'പിശക്: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'വോയ്‌സ് സെർച്ച് ലഭ്യമല്ല';

  @override
  String get searchHint => 'ഗാനങ്ങൾ, ആർട്ടിസ്റ്റുകൾ, ആൽബങ്ങൾ...';

  @override
  String get searchRecentEmpty => 'നിങ്ങളുടെ സമീപകാല തിരയലുകൾ ഇവിടെ കാണിക്കും';

  @override
  String get searchRecentSearches => 'സമീപകാല തിരയലുകൾ';

  @override
  String get searchClearAll => 'എല്ലാം മായ്‌ക്കുക';

  @override
  String searchNoResultsFor(String query) {
    return '\"$query\"-ന് ഫലങ്ങളൊന്നുമില്ല';
  }

  @override
  String get searchTryDifferentKeywords =>
      'മറ്റ് വാക്കുകൾ ഉപയോഗിച്ച് ശ്രമിക്കുക';

  @override
  String get searchTopResult => 'മികച്ച ഫലം';

  @override
  String get searchSongsLabel => 'ഗാനങ്ങൾ';

  @override
  String get searchArtistsLabel => 'ആർട്ടിസ്റ്റുകൾ';

  @override
  String get searchAlbumsLabel => 'ആൽബങ്ങൾ';

  @override
  String get searchPlaylistsLabel => 'പ്ലേലിസ്റ്റുകൾ';

  @override
  String get searchArtistLabel => 'ആർട്ടിസ്റ്റ്';

  @override
  String get searchListening => 'കേൾക്കുന്നു...';

  @override
  String get searchSpeakNow => 'തിരയാൻ സംസാരിക്കുക';

  @override
  String get searchCancel => 'റദ്ദാക്കുക';

  @override
  String get searchIdentifying => 'തിരിച്ചറിയുന്നു...';

  @override
  String get searchListeningForSong => 'ഗാനത്തിനായി കേൾക്കുന്നു...';

  @override
  String get settingsTitle => 'ക്രമീകരണങ്ങൾ';

  @override
  String get settingsStreamingQuality => 'സ്ട്രീമിംഗ് നിലവാരം';

  @override
  String get settingsQualityAutomatic => 'ഓട്ടോമാറ്റിക്';

  @override
  String get settingsQualityLow => 'കുറഞ്ഞത്';

  @override
  String get settingsQualityNormal => 'സാധാരണം';

  @override
  String get settingsQualityHigh => 'കൂടിയത്';

  @override
  String get settingsDownloadQuality => 'ഡൗൺലോഡ് നിലവാരം';

  @override
  String get settingsPlayback => 'പ്ലേബാക്ക്';

  @override
  String get settingsCrossfade => 'ക്രോസ്ഫേഡ്';

  @override
  String get settingsCrossfadeDesc =>
      'തടസ്സമില്ലാത്ത മാറ്റത്തിനായി ട്രാക്കുകൾ ഓവർലാപ്പ് ചെയ്യുക';

  @override
  String get settingsDataUsage => 'ഡാറ്റാ ഉപയോഗം';

  @override
  String get settingsDataSaver => 'ഡാറ്റ സേവർ';

  @override
  String get settingsDataSaverDesc =>
      'മൊബൈൽ ഡാറ്റയിൽ കുറഞ്ഞ നിലവാരത്തിൽ സ്ട്രീം ചെയ്യുക';

  @override
  String get settingsAppearance => 'രൂപം';

  @override
  String get settingsLanguage => 'ഭാഷ';

  @override
  String get settingsCustomAccent => 'കസ്റ്റം ആക്സന്റ്';

  @override
  String get settingsSaturation => 'സാച്ചുറേഷൻ';

  @override
  String get settingsBrightness => 'തെളിച്ചം';

  @override
  String get settingsResetDefault => 'ഡിഫോൾട്ടിലേക്ക് റീസെറ്റ് ചെയ്യുക';

  @override
  String get playlistSheetTitle => 'പ്ലേലിസ്റ്റിലേക്ക് ചേർക്കുക';

  @override
  String get playlistSheetNewPlaylist => 'പുതിയ പ്ലേലിസ്റ്റ്';

  @override
  String get playlistSheetNoPlaylists => 'പ്ലേലിസ്റ്റുകളൊന്നുമില്ല';

  @override
  String playlistSheetSongsCount(int count) {
    return '$count ഗാനങ്ങൾ';
  }

  @override
  String get playlistSheetNameHint => 'പ്ലേലിസ്റ്റിന്റെ പേര്';

  @override
  String get playlistSheetCancel => 'റദ്ദാക്കുക';

  @override
  String playlistSheetAddedTo(String name) {
    return '$name-ലേക്ക് ചേർത്തു';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'രൂപീകരിക്കാനായില്ല: ഓതന്റിക്കേഷൻ പിശക്';

  @override
  String playlistSheetCreateFail(String error) {
    return 'രൂപീകരിക്കാനായില്ല: $error';
  }

  @override
  String get playlistSheetCreate => 'രൂപീകരിക്കുക';

  @override
  String get appUpdateAvailable => 'അപ്ഡേറ്റ് ലഭ്യമാണ്';

  @override
  String appUpdateDesc(String version) {
    return 'പതിപ്പ് $version എത്തി! പുതിയ ഫീച്ചറുകൾക്കായി അപ്‌ഡേറ്റ് ചെയ്യുക.';
  }

  @override
  String get appUpdateDownload => 'അപ്ഡേറ്റ് ഡൗൺലോഡ് ചെയ്യുക';

  @override
  String get navHome => 'ഹോം';

  @override
  String get navLibrary => 'ലൈബ്രറി';

  @override
  String get navSearch => 'തിരയുക';

  @override
  String get navSettings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get navProfile => 'പ്രൊഫൈൽ';

  @override
  String get artistSelect => 'ആർട്ടിസ്റ്റിനെ തിരഞ്ഞെടുക്കുക';

  @override
  String get songActionQueue => 'ക്യൂവിലേക്ക് ചേർക്കുക';

  @override
  String get songActionPlaylist => 'പ്ലേലിസ്റ്റിലേക്ക് ചേർക്കുക';

  @override
  String get songActionFinding => 'കണ്ടെത്തുന്നു...';

  @override
  String get songActionAlbum => 'ആൽബത്തിലേക്ക് പോകുക';

  @override
  String get songActionArtist => 'ആർട്ടിസ്റ്റിന്റെ അടുത്തേക്ക് പോകുക';

  @override
  String get songActionRemovePlaylist => 'പ്ലേലിസ്റ്റിൽ നിന്ന് നീക്കം ചെയ്യുക';

  @override
  String get songActionRemoveDownload => 'ഡൗൺലോഡുകളിൽ നിന്ന് നീക്കം ചെയ്യുക';

  @override
  String get songActionDownloadChecking => 'പരിശോധിക്കുന്നു...';

  @override
  String get songActionDownloading => 'ഡൗൺലോഡ് ചെയ്യുന്നു...';

  @override
  String get songActionDownloaded => 'ഡൗൺലോഡ് ചെയ്തു!';

  @override
  String get songActionDownloadAlready => 'ഇതിനകം ഡൗൺലോഡ് ചെയ്തു';

  @override
  String get songActionDownloadFailed => 'ഡൗൺലോഡ് പരാജയപ്പെട്ടു';

  @override
  String get songActionDownload => 'ഡൗൺലോഡ്';

  @override
  String get songActionDownloadingSnack => 'ഡൗൺലോഡ് ചെയ്യുന്നു';

  @override
  String get songActionView => 'കാണുക';

  @override
  String get spotifyImportTitle => 'Spotify-ൽ നിന്ന് ഇംപോർട്ട് ചെയ്യുക';

  @override
  String get spotifyImportSubtitle => 'പ്ലേലിസ്റ്റ് വലിപ്പം തിരഞ്ഞെടുക്കുക';

  @override
  String get spotifyChoiceSmallTitle => '100 ഗാനങ്ങളോ അതിൽ താഴെയോ';

  @override
  String get spotifyChoiceSmallDesc =>
      'ഒരു പബ്ലിക് Spotify പ്ലേലിസ്റ്റ് URL ഒട്ടിക്കുക.';

  @override
  String get spotifyChoiceLargeTitle => '100 ഗാനങ്ങളിൽ കൂടുതൽ';

  @override
  String get spotifyChoiceLargeDesc =>
      'പരിധിയില്ലാത്ത ട്രാക്കുകൾ ഇംപോർട്ട് ചെയ്യാൻ നിങ്ങളുടെ സ്വന്തം Spotify Developer App കണക്റ്റ് ചെയ്യുക.';

  @override
  String get cancelButton => 'റദ്ദാക്കുക';

  @override
  String get spotifyPlaylistsTitle => 'നിങ്ങളുടെ Spotify പ്ലേലിസ്റ്റുകൾ';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'പിശക്: $error\nനിങ്ങളുടെ Client ID ശരിയാണോയെന്ന് പരിശോധിക്കുക.';
  }

  @override
  String get spotifyPlaylistsEmpty =>
      'നിങ്ങളുടെ ലൈബ്രറിയിൽ പ്ലേലിസ്റ്റുകളൊന്നുമില്ല';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count ട്രാക്കുകൾ';
  }

  @override
  String get spotifyPlaylistsImport => 'ഇംപോർട്ട്';

  @override
  String get audioPlaybackFailed =>
      'പ്ലേബാക്ക് പരാജയപ്പെട്ടു. ഇന്റർനെറ്റ് കണക്ഷൻ പരിശോധിക്കുക.';

  @override
  String get audioControlPrevious => 'മുമ്പത്തേത്';

  @override
  String get audioControlPause => 'പോസ്';

  @override
  String get audioControlPlay => 'പ്ലേ';

  @override
  String get audioControlNext => 'അടുത്തത്';

  @override
  String get audioControlUnlike => 'അൺലൈക്ക്';

  @override
  String get audioControlLike => 'ലൈക്ക്';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'യഥാർത്ഥ റെസ്പോൺസ്: $data\n\nഫോൾബാക്ക്: $error';
  }

  @override
  String get apiErrorInvalidClient =>
      'തെറ്റായ ക്ലയന്റ് അല്ലെങ്കിൽ ക്ലയന്റ് രഹസ്യം.';

  @override
  String get apiErrorBadRequest =>
      'തെറ്റായ അഭ്യർത്ഥന. നിങ്ങളുടെ ഇൻപുട്ട് പരിശോധിക്കുക.';

  @override
  String get apiErrorUnauthorized =>
      'അധികാരമില്ല. ദയവായി വീണ്ടും ലോഗിൻ ചെയ്യുക.';

  @override
  String get apiErrorForbidden =>
      'വിലക്കപ്പെട്ടിരിക്കുന്നു. നിങ്ങൾക്ക് പ്രവേശനമില്ല.';

  @override
  String get apiErrorNotFound => 'വിഭവം കണ്ടെത്താനായില്ല.';

  @override
  String get apiErrorEmailInUse => 'ഈ ഇമെയിൽ വിലാസം ഇതിനകം ഉപയോഗത്തിലാണ്.';

  @override
  String get apiErrorUserNotFound =>
      'ഈ ഇമെയിലുമായി ബന്ധപ്പെട്ട അക്കൗണ്ട് കണ്ടെത്തിയില്ല.';

  @override
  String get apiErrorWrongPassword => 'തെറ്റായ പാസ്‌വേഡ്.';

  @override
  String get apiErrorInvalidCredential =>
      'ലോഗിൻ പരാജയപ്പെട്ടു. നിങ്ങളുടെ വിവരങ്ങൾ പരിശോധിക്കുക.';

  @override
  String get apiErrorNetwork =>
      'നെറ്റ്‌വർക്ക് പിശക്. നിങ്ങളുടെ കണക്ഷൻ പരിശോധിക്കുക.';

  @override
  String get apiErrorSocketTimeout =>
      'കണക്ഷൻ സമയപരിധി കഴിഞ്ഞു. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get apiErrorTooManyRequests =>
      'വളരെ കൂടുതൽ അഭ്യർത്ഥനകൾ. കുറച്ച് കഴിഞ്ഞ് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get apiErrorServerError =>
      'സെർവർ പിശക്. കുറച്ച് കഴിഞ്ഞ് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get apiErrorInvalidEmail => 'ദയവായി ശരിയായ ഇമെയിൽ വിലാസം നൽകുക.';

  @override
  String get apiErrorWeakPassword =>
      'പാസ്‌വേഡ് വളരെ ദുർബലമാണ്. കുറഞ്ഞത് 6 അക്ഷരങ്ങളെങ്കിലും ഉപയോഗിക്കുക.';

  @override
  String get apiErrorTooManyAttempts =>
      'നിരവധി തവണ തെറ്റായി ശ്രമിച്ചു. പിന്നീട് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get homeForgottenFavorites => 'മറന്നുപോയ പ്രിയഗാനങ്ങൾ';

  @override
  String get artistShowAll => 'എല്ലാം കാണുക';

  @override
  String get homeTopTracks => 'ടോപ്പ് ട്രാക്കുകൾ';
}
