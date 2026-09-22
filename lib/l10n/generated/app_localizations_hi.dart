// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'के बारे में';

  @override
  String get artistPopular => 'लोकप्रिय';

  @override
  String get artistAlbums => 'एल्बम';

  @override
  String get artistSinglesAndEPs => 'सिंगल्स और EPs';

  @override
  String artistSubscribersCount(String count) {
    return '$count सब्सक्राइबर्स';
  }

  @override
  String get artistPlayAll => 'सभी बजाएं';

  @override
  String get artistLoadError => 'कलाकार को लोड नहीं किया जा सका';

  @override
  String get artistGoBack => 'वापस जाएं';

  @override
  String adminChatFailedToReply(String error) {
    return 'जवाब देने में विफल: $error';
  }

  @override
  String get adminChatSupportChat => 'सपोर्ट चैट';

  @override
  String adminChatError(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get adminChatNoHistory => 'कोई बातचीत का इतिहास नहीं।';

  @override
  String get adminChatSupportYou => 'सपोर्ट (आप)';

  @override
  String get adminChatTypeReply => 'अपना जवाब टाइप करें...';

  @override
  String get broadcastSuccess => 'घोषणा सफलतापूर्वक प्रसारित की गई!';

  @override
  String broadcastFailed(String error) {
    return 'प्रसारित करने में विफल: $error';
  }

  @override
  String get broadcastTitle => 'वैश्विक घोषणाएं';

  @override
  String get broadcastSubtitle => 'सभी उपयोगकर्ताओं को भेजा गया';

  @override
  String get broadcastWarning => 'यहां भेजे गए संदेश सभी को दिखाई देंगे।';

  @override
  String broadcastError(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get broadcastNoHistory => 'कोई पिछली घोषणाएं नहीं।';

  @override
  String get broadcastTypeMessage => 'एक वैश्विक प्रसारण टाइप करें...';

  @override
  String commFailedToSend(String error) {
    return 'भेजने में विफल: $error';
  }

  @override
  String get commAdminDashboard => 'एडमिन डैशबोर्ड';

  @override
  String get commAdminSupport => 'एडमिन सपोर्ट';

  @override
  String get commAlwaysHere => 'मदद के लिए हमेशा यहाँ';

  @override
  String get commWelcomeTitle => 'नमस्ते! 👋 मैं आशुतोष पाठक हूँ';

  @override
  String get commWelcomeSubtitle => 'Pulse का डेवलपर';

  @override
  String get commWelcomeBody1 =>
      'मुझे उम्मीद है कि आप बिना कष्टप्रद विज्ञापनों या सब्सक्रिप्शन बाधाओं के अपना पसंदीदा संगीत सुनने का आनंद ले रहे होंगे। आखिरकार, संगीत पेवॉल के साथ नहीं आना चाहिए सिर्फ इसलिए क्योंकि बोर्डरूम में किसी को एक और नौका की आवश्यकता थी।\n\nयह खंड यहाँ इसलिए है ताकि हम सीधे जुड़ सकें।\n\nबेझिझक:';

  @override
  String get commBullet1 => 'अपनी प्रतिक्रिया साझा करें';

  @override
  String get commBullet2 => 'बग रिपोर्ट करें';

  @override
  String get commBullet3 => 'नई सुविधाएँ सुझाएं जो आप देखना चाहते हैं';

  @override
  String get commWelcomeBody2 =>
      'मैं व्यक्तिगत रूप से हर संदेश पढ़ता हूं और आपके सुझावों के आधार पर ऐप को बेहतर बनाने की पूरी कोशिश करूंगा।\n\nक्या आपके पास किसी ऐसे ऐप का विचार है जो अभी तक मौजूद नहीं है, या जो महंगे सब्सक्रिप्शन के पीछे बंद है? मुझे इसके बारे में बताएं! यदि यह संभव है, तो मैं इसे बनाने और सभी के लिए उपलब्ध कराने का प्रयास करूंगा।\n\nमेरे ऐप का उपयोग करने और इस यात्रा का हिस्सा बनने के लिए धन्यवाद। ❤️';

  @override
  String commError(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get commNoMessages => 'अभी तक कोई संदेश नहीं';

  @override
  String get commNoMessagesDesc =>
      'हमारी सपोर्ट टीम को संदेश भेजें या घोषणाओं के लिए बाद में देखें।';

  @override
  String get commMessageSupportHint => 'सपोर्ट को संदेश भेजें...';

  @override
  String get commGlobalAnnouncements => 'वैश्विक घोषणाएं';

  @override
  String get commSendMessagesToAll => 'सभी उपयोगकर्ताओं को संदेश भेजें';

  @override
  String get homeGreetingMorning => 'सुप्रभात,';

  @override
  String get homeGreetingAfternoon => 'शुभ दोपहर,';

  @override
  String get homeGreetingEvening => 'शुभ संध्या,';

  @override
  String get homeMember => 'सदस्य';

  @override
  String get homeRecentPlaylists => 'हाल की प्लेलिस्ट';

  @override
  String get homeRecentlyPlayed => 'हाल ही में बजाया गया';

  @override
  String get homeSpeedDial => 'स्पीड डायल';

  @override
  String get homeNoContent => 'कोई सामग्री उपलब्ध नहीं';

  @override
  String get homeRefresh => 'रिफ्रेश करें';

  @override
  String get homeLoadError => 'संगीत फ़ीड लोड नहीं किया जा सका।';

  @override
  String get homeRetry => 'पुनः प्रयास करें';

  @override
  String get importSuccess => 'Spotify से सफलतापूर्वक कनेक्ट हुआ!';

  @override
  String importFailed(String error) {
    return 'कनेक्ट करने में विफल: $error';
  }

  @override
  String get importTitle => 'Spotify कनेक्ट करें';

  @override
  String get importSetupTitle => 'Spotify इंटीग्रेशन सेट करें';

  @override
  String get importSetupDesc =>
      'Spotify की सख्त दर सीमाओं को बायपास करने और अपनी सभी प्लेलिस्ट को तुरंत आयात करने के लिए, आपको अपनी खुद की मुफ्त डेवलपर कुंजी का उपयोग करना होगा। इन सरल चरणों का पालन करें:';

  @override
  String get importStep1 => 'Spotify Developer Dashboard खोलें।';

  @override
  String get importStep2 => 'लॉग इन करें और \"Create app\" पर क्लिक करें।';

  @override
  String get importStep3 => 'कोई भी ऐप नाम और विवरण भरें।';

  @override
  String get importStep4 =>
      '\"Redirect URIs\" के तहत, निम्नलिखित सटीक URL चिपकाएँ:';

  @override
  String get importRedirectCopied => 'रीडायरेक्ट URI कॉपी किया गया!';

  @override
  String get importStep5 =>
      'ऐप को सहेजें, सेटिंग्स से अपनी \"Client ID\" कॉपी करें, और इसे नीचे पेस्ट करें।';

  @override
  String get importImportant =>
      'महत्वपूर्ण: जिस Spotify खाते का उपयोग इस डेवलपर ऐप को बनाने के लिए किया गया है, उसमें एक सक्रिय Premium सब्सक्रिप्शन होना चाहिए।';

  @override
  String get importClientIdHint => 'अपनी Spotify Client ID यहाँ पेस्ट करें...';

  @override
  String get importConnectButton => 'कनेक्ट करें और लाइब्रेरी लोड करें';

  @override
  String get downloadingNoActive => 'कोई सक्रिय डाउनलोड नहीं';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'डाउनलोड';

  @override
  String downloadsStats(String count, String size) {
    return '$count गाने • $size';
  }

  @override
  String get downloadsNoOffline => 'अभी तक कोई ऑफ़लाइन गाने नहीं';

  @override
  String get downloadsNoOfflineDesc =>
      'आपके द्वारा डाउनलोड किए गए गाने यहां दिखाई देंगे';

  @override
  String get downloadsClearAllTitle => 'सभी डाउनलोड साफ़ करें?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'यह $count गानों को हटा देगा और $size स्टोरेज खाली कर देगा।';
  }

  @override
  String get downloadsCancel => 'रद्द करें';

  @override
  String get downloadsClearAll => 'सभी साफ़ करें';

  @override
  String downloadsSongsCount(String count) {
    return '$count गाने';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count गाना';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'मुख्य डाउनलोड प्लेलिस्ट का नाम नहीं बदला जा सकता।';

  @override
  String get downloadsRename => 'नाम बदलें';

  @override
  String get downloadsEditSongs => 'गाने संपादित करें';

  @override
  String get downloadsDelete => 'हटाएं';

  @override
  String get downloadsRenamePlaylistTitle => 'प्लेलिस्ट का नाम बदलें';

  @override
  String get downloadsRenamePlaylistDesc =>
      'अपनी प्लेलिस्ट के लिए एक नया नाम दर्ज करें।';

  @override
  String get downloadsDeletePlaylistTitle => 'प्लेलिस्ट हटाएं?';

  @override
  String get downloadsDeleteMasterDesc =>
      'क्या आप वाकई इसे हटाना चाहते हैं? आप सभी डाउनलोड किए गए गानों और प्लेलिस्ट को हमेशा के लिए खो देंगे।';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'क्या आप वाकई \"$name\" को हटाना चाहते हैं? यह प्लेलिस्ट हमेशा के लिए खो जाएगी।';
  }

  @override
  String get downloadsSave => 'सहेजें';

  @override
  String get downloadsNoSongs => 'इस प्लेलिस्ट में कोई गाने नहीं हैं।';

  @override
  String get libraryTitle => 'लाइब्रेरी';

  @override
  String get libraryPauseAll => 'सभी रोकें';

  @override
  String get libraryResumeAll => 'सभी फिर से शुरू करें';

  @override
  String get libraryTabPlaylists => 'प्लेलिस्ट';

  @override
  String get libraryTabDownloads => 'डाउनलोड';

  @override
  String get libraryTabDownloading => 'डाउनलोड हो रहा है';

  @override
  String libraryImportedTask(String name) {
    return '$name आयात किया गया';
  }

  @override
  String get libraryImportWaiting => 'कतार में प्रतीक्षा कर रहा है...';

  @override
  String get libraryImportFetching => 'प्लेलिस्ट प्राप्त कर रहा है...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total संसाधित · $matched मिलान हुए';
  }

  @override
  String get libraryImportSaving => 'लाइब्रेरी में सहेज रहा है...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched गाने जोड़े गए · हटाने के लिए × टैप करें';
  }

  @override
  String get libraryImportDoneAll =>
      'सभी गाने जोड़े गए · हटाने के लिए × टैप करें';

  @override
  String get libraryAddButton => 'जोड़ें';

  @override
  String get librarySortRecent => 'हाल ही में जोड़ा गया';

  @override
  String get librarySortAlpha => 'वर्णमाला के अनुसार';

  @override
  String get libraryEmptyTitle => 'आपकी लाइब्रेरी खाली है।';

  @override
  String get libraryEmptyDesc =>
      'अपना पहला पल्स शुरू करने के लिए \"जोड़ें\" पर टैप करें।';

  @override
  String get libraryRenameLikedError =>
      'पसंदीदा गानों की प्लेलिस्ट का नाम नहीं बदला जा सकता।';

  @override
  String get libraryRename => 'नाम बदलें';

  @override
  String get libraryEditSongs => 'गाने संपादित करें';

  @override
  String get libraryDeleteLikedError =>
      'पसंदीदा गानों की प्लेलिस्ट को नहीं हटाया जा सकता।';

  @override
  String get libraryDelete => 'हटाएं';

  @override
  String get libraryEditSongsTitle => 'गाने संपादित करें';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count गाना';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count गाने';
  }

  @override
  String get libraryCancel => 'रद्द करें';

  @override
  String get librarySave => 'सहेजें';

  @override
  String get libraryNoSongs => 'इस प्लेलिस्ट में कोई गाने नहीं हैं।';

  @override
  String get libraryAddOptionsTitle => 'लाइब्रेरी में जोड़ें';

  @override
  String get libraryAddOptionsDesc =>
      'चुनें कि आप अपना पल्स कैसे बढ़ाना चाहते हैं';

  @override
  String get libraryImportPulse => 'पल्स से आयात करें';

  @override
  String get libraryImportPulseDesc => 'एक पल्स प्लेलिस्ट URL पेस्ट करें';

  @override
  String get libraryImportYtm => 'YT म्यूजिक से आयात करें';

  @override
  String get libraryImportYtmDesc => 'एक सार्वजनिक प्लेलिस्ट URL पेस्ट करें';

  @override
  String get libraryImportSpotify => 'Spotify से आयात करें';

  @override
  String get libraryImportSpotifyDesc => 'अपना Spotify कनेक्ट करें';

  @override
  String get libraryClose => 'बंद करें';

  @override
  String get libraryImportYtmFull => 'YouTube म्यूजिक से आयात करें';

  @override
  String get libraryImportSpotifyFull => 'Spotify से आयात करें (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'एक सार्वजनिक YouTube म्यूजिक प्लेलिस्ट या एल्बम URL पेस्ट करें';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'नीचे एक सार्वजनिक Spotify प्लेलिस्ट URL पेस्ट करें';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'पल्स प्लेलिस्ट आयात करने में विफल';

  @override
  String get importErrorPlaylist => 'प्लेलिस्ट आयात करने में त्रुटि';

  @override
  String get importErrorHighlyPopulated =>
      'प्लेलिस्ट में बहुत सारे गाने हैं, इसे प्राप्त करने में कुछ समय लग सकता है।';

  @override
  String get libraryImportBtn => 'आयात करें';

  @override
  String get libraryCreateTitle => 'नई प्लेलिस्ट';

  @override
  String get libraryCreateDesc => 'हम आपकी नई प्लेलिस्ट को क्या नाम दें?';

  @override
  String get libraryCreateHint => 'जैसे कि मिडनाइट राइड्स';

  @override
  String get libraryCreateBtn => 'बनाएं';

  @override
  String get libraryRenameTitle => 'प्लेलिस्ट का नाम बदलें';

  @override
  String get libraryRenameDesc => 'अपनी प्लेलिस्ट के लिए एक नया नाम दर्ज करें।';

  @override
  String get libraryRenameBtn => 'नाम बदलें';

  @override
  String get libraryDeleteTitle => 'प्लेलिस्ट हटाएं?';

  @override
  String libraryDeleteDesc(String name) {
    return 'क्या आप वाकई \"$name\" को हटाना चाहते हैं? यह प्लेलिस्ट हमेशा के लिए खो जाएगी।';
  }

  @override
  String get libraryDeleteBtn => 'हटाएं';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'हाल ही के';

  @override
  String librarySongsCount(String count) {
    return '$count गाने';
  }

  @override
  String get libraryComingSoon => 'जल्द आ रहा है';

  @override
  String get loginErrName => 'कृपया अपना नाम दर्ज करें';

  @override
  String get loginErrEmail => 'कृपया अपना ईमेल पता दर्ज करें';

  @override
  String get loginErrPassword => 'कृपया अपना पासवर्ड दर्ज करें';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'हर बीट को महसूस करें!';

  @override
  String get loginMadeWithHeartBy => '❤️ से निर्माण: ';

  @override
  String get loginAuthorName => 'आशुतोष पाठक';

  @override
  String get loginHintName => 'आपका नाम';

  @override
  String get loginHintEmail => 'ईमेल पता';

  @override
  String get loginHintPassword => 'पासवर्ड';

  @override
  String get loginErrEmailReset =>
      'पासवर्ड रीसेट करने के लिए कृपया अपना ईमेल दर्ज करें';

  @override
  String get loginResetSent =>
      'पासवर्ड रीसेट ईमेल भेजा गया! अपना इनबॉक्स जांचें।';

  @override
  String get loginForgotPwd => 'पासवर्ड भूल गए?';

  @override
  String get loginBtnSignup => 'खाता बनाएं';

  @override
  String get loginBtnSignin => 'साइन इन करें';

  @override
  String get loginToggleHaveAccount =>
      'क्या आपके पास पहले से ही Pulse खाता है? ';

  @override
  String get loginToggleNoAccount => 'Pulse खाता नहीं है? ';

  @override
  String get loginToggleSignin => 'साइन इन करें';

  @override
  String get loginToggleSignup => 'साइन अप करें';

  @override
  String get offlineStillOffline =>
      'अभी भी ऑफ़लाइन है। कृपया अपना कनेक्शन जांचें।';

  @override
  String get offlineTitle => 'आप ऑफ़लाइन हैं';

  @override
  String get offlineSubtitle =>
      'कोई इंटरनेट कनेक्शन नहीं मिला।\nअपना नेटवर्क जांचें और पुनः प्रयास करें।';

  @override
  String get offlineChecking => 'जांच कर रहा है...';

  @override
  String get offlineRetry => 'पुनः प्रयास करें';

  @override
  String get offlineGoToDownloads => 'डाउनलोड पर जाएं';

  @override
  String get playerMadeWithHeartBy => '❤️ से निर्माण: ';

  @override
  String get playerAuthorName => 'आशुतोष पाठक';

  @override
  String get playerSwipeForLyrics => 'बोल के लिए स्वाइप करें';

  @override
  String get playerNoLyrics => 'कोई बोल उपलब्ध नहीं';

  @override
  String get playerUpNext => 'आगे क्या है';

  @override
  String get playerNoTracksInQueue => 'कतार में कोई ट्रैक नहीं';

  @override
  String get playerNoMusicPlaying => 'कोई संगीत नहीं बज रहा है';

  @override
  String get playerPickAVibe => 'अपनी लाइब्रेरी या होम से एक वाइब चुनें';

  @override
  String get playerGoHome => 'होम पर जाएं';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'इक्वलाइज़र';

  @override
  String get playerEqCustom => 'कस्टम';

  @override
  String get playlistDownloads => 'डाउनलोड';

  @override
  String get playlistOffline => 'ऑफ़लाइन प्लेलिस्ट';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hoursघं $minsमिन';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$minsमिन';
  }

  @override
  String get playlistFindOnPage => 'इस पेज पर खोजें';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count गाने • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'हाल ही के';

  @override
  String get playlistNoMatches => 'कोई मेल नहीं मिला।';

  @override
  String get playlistNoTracks => 'इस प्लेलिस्ट में कोई ट्रैक नहीं हैं।';

  @override
  String get playlistNoSongsYet => 'अभी तक कोई गाने नहीं।';

  @override
  String get playlistSortRecentlyAdded => 'हाल ही में जोड़ा गया';

  @override
  String get playlistSortAlphabetical => 'वर्णमाला के अनुसार';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'गाने डाउनलोड हो रहे हैं',
      one: 'गाना डाउनलोड हो रहा है',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistView => 'देखें';

  @override
  String get playlistAllDownloaded => 'सभी गाने पहले से ही डाउनलोड किए गए हैं';

  @override
  String playlistShareText(String name, String url) {
    return 'Pulse पर \"$name\" देखें!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'डाउनलोड से हटाएं';

  @override
  String get playlistRemoveFromPlaylist => 'प्लेलिस्ट से हटाएं';

  @override
  String get playlistLoadError => 'इस प्लेलिस्ट को लोड नहीं किया जा सका।';

  @override
  String get playlistGoBack => '← वापस जाएं';

  @override
  String get profileNotLoggedIn => 'लॉग इन नहीं है';

  @override
  String get profileSignIn => 'साइन इन करें';

  @override
  String get profileDefaultUser => 'Pulse उपयोगकर्ता';

  @override
  String get profileEditProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get profileTimeframeDay => 'दिन';

  @override
  String get profileTimeframeWeek => 'सप्ताह';

  @override
  String get profileTimeframeMonth => 'महीना';

  @override
  String get profileTimeframeYear => 'वर्ष';

  @override
  String get profileListeningTime => 'सुनने का समय';

  @override
  String get profileToday => 'आज';

  @override
  String get profileThisWeek => 'इस सप्ताह';

  @override
  String get profileThisMonth => 'इस महीने';

  @override
  String get profileThisYear => 'इस वर्ष';

  @override
  String get profileDailyAvg => 'दैनिक औसत';

  @override
  String get profilePerDay => 'प्रति दिन';

  @override
  String get profileLifetimeListening => 'अब तक कुल सुना गया';

  @override
  String get profileTotalTimeListened => 'Pulse पर संगीत सुनने का कुल समय';

  @override
  String get profileYourTopSongs => 'आपके शीर्ष गाने';

  @override
  String get profileListeningHistoryEmpty => 'सुनने का इतिहास यहां दिखाई देगा।';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'बार बजाया',
      one: 'बार बजाया',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => 'आपके शीर्ष कलाकार';

  @override
  String get profileTopArtistsEmpty => 'आपके पसंदीदा कलाकार यहां दिखाई देंगे।';

  @override
  String get profileArtistLabel => 'कलाकार';

  @override
  String get profileSignOut => 'साइन आउट करें';

  @override
  String profileVersion(String version) {
    return 'संस्करण $version';
  }

  @override
  String get profileMadeWithHeartBy => '❤️ से निर्माण: ';

  @override
  String get profileAuthorName => 'आशुतोष पाठक';

  @override
  String get profileEditProfileHeader => 'प्रोफ़ाइल संपादित करें';

  @override
  String get profileDisplayName => 'प्रदर्शन नाम';

  @override
  String get profileCancel => 'रद्द करें';

  @override
  String get profileSave => 'सहेजें';

  @override
  String get profileChooseAvatar => 'अवतार चुनें';

  @override
  String get searchMicPermissionRequired =>
      'इस फीचर के लिए माइक्रोफ़ोन की अनुमति ज़रूरी है';

  @override
  String get searchUnknownSong => 'अज्ञात गाना';

  @override
  String get searchUnknownArtist => 'अज्ञात कलाकार';

  @override
  String get searchNoSongDetected => 'कोई गाना नहीं मिला।';

  @override
  String searchError(String message) {
    return 'त्रुटि: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'भाषण पहचान उपलब्ध नहीं है';

  @override
  String get searchHint => 'गाने, कलाकार, एल्बम, प्लेलिस्ट…';

  @override
  String get searchRecentEmpty => 'आपकी हाल की खोजें यहां दिखाई देती हैं';

  @override
  String get searchRecentSearches => 'हाल की खोजें';

  @override
  String get searchClearAll => 'सभी साफ़ करें';

  @override
  String searchNoResultsFor(String query) {
    return '\"$query\" के लिए कोई परिणाम नहीं';
  }

  @override
  String get searchTryDifferentKeywords => 'अलग कीवर्ड आज़माएं';

  @override
  String get searchTopResult => 'शीर्ष परिणाम';

  @override
  String get searchSongsLabel => 'गाने';

  @override
  String get searchArtistsLabel => 'कलाकार';

  @override
  String get searchAlbumsLabel => 'एल्बम';

  @override
  String get searchPlaylistsLabel => 'प्लेलिस्ट';

  @override
  String get searchArtistLabel => 'कलाकार';

  @override
  String get searchListening => 'सुन रहा है...';

  @override
  String get searchSpeakNow => 'खोजने के लिए अभी बोलें';

  @override
  String get searchCancel => 'रद्द करें';

  @override
  String get searchIdentifying => 'पहचान रहा है...';

  @override
  String get searchListeningForSong => 'गाना सुन रहा है...';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsStreamingQuality => 'स्ट्रीमिंग गुणवत्ता';

  @override
  String get settingsQualityAutomatic => 'स्वचालित';

  @override
  String get settingsQualityLow => 'कम';

  @override
  String get settingsQualityNormal => 'सामान्य';

  @override
  String get settingsQualityHigh => 'उच्च';

  @override
  String get settingsDownloadQuality => 'डाउनलोड गुणवत्ता';

  @override
  String get settingsPlayback => 'प्लेबैक';

  @override
  String get settingsCrossfade => 'क्रॉसफ़ेड';

  @override
  String get settingsCrossfadeDesc =>
      'गैपलेस ट्रांज़िशन के लिए ट्रैक को ओवरलैप करें';

  @override
  String get settingsDataUsage => 'डेटा उपयोग';

  @override
  String get settingsDataSaver => 'डेटा सेवर';

  @override
  String get settingsDataSaverDesc => 'सेलुलर पर कम गुणवत्ता पर स्ट्रीम करें';

  @override
  String get settingsAppearance => 'दिखावट';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsCustomAccent => 'कस्टम एक्सेंट';

  @override
  String get settingsSaturation => 'संतृप्ति';

  @override
  String get settingsBrightness => 'चमक';

  @override
  String get settingsResetDefault => 'डिफ़ॉल्ट रीसेट करें';

  @override
  String get playlistSheetTitle => 'प्लेलिस्ट में जोड़ें';

  @override
  String get playlistSheetNewPlaylist => 'नई प्लेलिस्ट';

  @override
  String get playlistSheetNoPlaylists => 'अभी तक कोई प्लेलिस्ट नहीं';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'गाने',
      one: 'गाना',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => 'प्लेलिस्ट का नाम';

  @override
  String get playlistSheetCancel => 'रद्द करें';

  @override
  String playlistSheetAddedTo(String name) {
    return '$name में जोड़ा गया';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'प्लेलिस्ट बनाने में विफल: प्रमाणीकरण त्रुटि';

  @override
  String playlistSheetCreateFail(String error) {
    return 'प्लेलिस्ट बनाने में विफल: $error';
  }

  @override
  String get playlistSheetCreate => 'बनाएं';

  @override
  String get appUpdateAvailable => 'अद्यतन उपलब्ध';

  @override
  String appUpdateDesc(String version) {
    return 'संस्करण $version आ गया है! नवीनतम सुविधाएँ प्राप्त करने के लिए अभी अपडेट करें।';
  }

  @override
  String get appUpdateDownload => 'अद्यतन डाउनलोड करें';

  @override
  String get navHome => 'होम';

  @override
  String get navLibrary => 'लाइब्रेरी';

  @override
  String get navSearch => 'खोज';

  @override
  String get navSettings => 'सेटिंग्स';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get artistSelect => 'कलाकार चुनें';

  @override
  String get songActionQueue => 'कतार में जोड़ें';

  @override
  String get songActionPlaylist => 'प्लेलिस्ट में जोड़ें';

  @override
  String get songActionFinding => 'खोज रहा है...';

  @override
  String get songActionAlbum => 'एल्बम पर जाएं';

  @override
  String get songActionArtist => 'कलाकार पर जाएं';

  @override
  String get songActionRemovePlaylist => 'प्लेलिस्ट से हटाएं';

  @override
  String get songActionRemoveDownload => 'डाउनलोड से हटाएं';

  @override
  String get songActionDownloadChecking => 'जांच कर रहा है...';

  @override
  String get songActionDownloading => 'डाउनलोड हो रहा है...';

  @override
  String get songActionDownloaded => 'डाउनलोड किया गया!';

  @override
  String get songActionDownloadAlready => 'पहले से डाउनलोड किया गया';

  @override
  String get songActionDownloadFailed => 'डाउनलोड विफल रहा';

  @override
  String get songActionDownload => 'डाउनलोड करें';

  @override
  String get songActionDownloadingSnack => 'डाउनलोड हो रहा है';

  @override
  String get songActionView => 'देखें';

  @override
  String get spotifyImportTitle => 'Spotify से आयात करें';

  @override
  String get spotifyImportSubtitle => 'अपना प्लेलिस्ट आकार चुनें';

  @override
  String get spotifyChoiceSmallTitle => '100 गाने या उससे कम';

  @override
  String get spotifyChoiceSmallDesc =>
      'एक सार्वजनिक Spotify प्लेलिस्ट URL पेस्ट करें।';

  @override
  String get spotifyChoiceLargeTitle => '100 से अधिक गाने';

  @override
  String get spotifyChoiceLargeDesc =>
      'असीमित ट्रैक आयात करने के लिए अपना खुद का Spotify डेवलपर ऐप कनेक्ट करें।';

  @override
  String get cancelButton => 'रद्द करें';

  @override
  String get spotifyPlaylistsTitle => 'आपकी Spotify प्लेलिस्ट';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'त्रुटि: $error\nसुनिश्चित करें कि आपकी Client ID मान्य है।';
  }

  @override
  String get spotifyPlaylistsEmpty =>
      'आपकी लाइब्रेरी में कोई प्लेलिस्ट नहीं मिली';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count ट्रैक';
  }

  @override
  String get spotifyPlaylistsImport => 'आयात करें';

  @override
  String get audioPlaybackFailed =>
      'प्लेबैक विफल रहा। अपना इंटरनेट कनेक्शन जांचें।';

  @override
  String get audioControlPrevious => 'पिछला';

  @override
  String get audioControlPause => 'रोकें';

  @override
  String get audioControlPlay => 'बजाएं';

  @override
  String get audioControlNext => 'अगला';

  @override
  String get audioControlUnlike => 'नापसंद करें';

  @override
  String get audioControlLike => 'पसंद करें';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'कच्ची प्रतिक्रिया: $data\n\nफ़ॉलबैक: $error';
  }

  @override
  String get apiErrorInvalidClient => 'अमान्य क्लाइंट या क्लाइंट सीक्रेट।';

  @override
  String get apiErrorBadRequest => 'खराब अनुरोध। कृपया अपने इनपुट जांचें।';

  @override
  String get apiErrorUnauthorized => 'अनधिकृत। कृपया फिर से लॉग इन करें।';

  @override
  String get apiErrorForbidden => 'वर्जित। आपके पास पहुंच नहीं है।';

  @override
  String get apiErrorNotFound => 'संसाधन नहीं मिला।';

  @override
  String get apiErrorEmailInUse => 'यह ईमेल पता पहले से ही उपयोग में है।';

  @override
  String get apiErrorUserNotFound => 'इस ईमेल वाला कोई खाता नहीं मिला।';

  @override
  String get apiErrorWrongPassword => 'गलत पासवर्ड।';

  @override
  String get apiErrorInvalidCredential => 'लॉगिन विफल। कृपया अपनी साख जांचें।';

  @override
  String get apiErrorNetwork => 'नेटवर्क त्रुटि। कृपया अपना कनेक्शन जांचें।';

  @override
  String get apiErrorSocketTimeout =>
      'कनेक्शन का समय समाप्त हो गया। कृपया पुन: प्रयास करें।';

  @override
  String get apiErrorTooManyRequests =>
      'बहुत अधिक अनुरोध। कृपया एक क्षण प्रतीक्षा करें और पुनः प्रयास करें।';

  @override
  String get apiErrorServerError =>
      'सर्वर त्रुटि। कृपया बाद में पुनः प्रयास करें।';

  @override
  String get apiErrorInvalidEmail => 'कृपया एक मान्य ईमेल पता दर्ज करें।';

  @override
  String get apiErrorWeakPassword =>
      'पासवर्ड बहुत कमजोर है। कम से कम 6 वर्णों का उपयोग करें।';

  @override
  String get apiErrorTooManyAttempts =>
      'बहुत सारे विफल प्रयास। कृपया बाद में पुनः प्रयास करें।';

  @override
  String get homeForgottenFavorites => 'भूले हुए पसंदीदा';

  @override
  String get artistShowAll => 'सभी दिखाएं';

  @override
  String get homeTopTracks => 'टॉप ट्रैक';
}
