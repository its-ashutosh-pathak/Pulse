// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'बारेमा';

  @override
  String get artistPopular => 'लोकप्रिय';

  @override
  String get artistAlbums => 'एल्बमहरू';

  @override
  String get artistSinglesAndEPs => 'सिंगल्स र EPs';

  @override
  String artistSubscribersCount(String count) {
    return '$count सदस्यहरू';
  }

  @override
  String get artistPlayAll => 'सबै प्ले गर्नुहोस्';

  @override
  String get artistLoadError => 'कलाकार लोड गर्न सकेन';

  @override
  String get artistGoBack => 'पछाडि जानुहोस्';

  @override
  String adminChatFailedToReply(String error) {
    return 'जवाफ दिन असफल: $error';
  }

  @override
  String get adminChatSupportChat => 'सपोर्ट च्याट';

  @override
  String adminChatError(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get adminChatNoHistory => 'कुनै कुराकानी इतिहास छैन।';

  @override
  String get adminChatSupportYou => 'सपोर्ट (तपाईं)';

  @override
  String get adminChatTypeReply => 'तपाईंको जवाफ टाइप गर्नुहोस्...';

  @override
  String get broadcastSuccess => 'घोषणा सफलतापूर्वक प्रसारण भयो!';

  @override
  String broadcastFailed(String error) {
    return 'प्रसारण गर्न असफल: $error';
  }

  @override
  String get broadcastTitle => 'विश्वव्यापी घोषणाहरू';

  @override
  String get broadcastSubtitle => 'सबैलाई पठाइयो';

  @override
  String get broadcastWarning => 'यहाँ पठाइएका सन्देशहरू सबैलाई देखिनेछन्।';

  @override
  String broadcastError(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get broadcastNoHistory => 'कुनै अघिल्लो घोषणा छैन।';

  @override
  String get broadcastTypeMessage => 'विश्वव्यापी घोषणा टाइप गर्नुहोस्...';

  @override
  String commFailedToSend(String error) {
    return 'पठाउन असफल: $error';
  }

  @override
  String get commAdminDashboard => 'प्रशासक ड्यासबोर्ड';

  @override
  String get commAdminSupport => 'प्रशासक सपोर्ट';

  @override
  String get commAlwaysHere => 'मद्दतको लागि सधैं यहाँ छौँ';

  @override
  String get commWelcomeTitle => 'नमस्ते! 👋 म आशुतोष पाठक हुँ';

  @override
  String get commWelcomeSubtitle => 'Pulse को विकासकर्ता';

  @override
  String get commWelcomeBody1 =>
      'मलाई आशा छ कि तपाईं कुनै पनि विज्ञापन वा सदस्यता शुल्क बिना आफ्नो मनपर्ने संगीत सुन्न रमाइलो गर्दै हुनुहुन्छ। संगीत निःशुल्क हुनुपर्छ।\n\nयो खण्ड यसको लागि हो ताकि हामी सिधै सम्पर्क गर्न सकौँ।\n\nतपाईं निर्धक्क भई:';

  @override
  String get commBullet1 => 'आफ्नो विचार साझा गर्नुहोस्';

  @override
  String get commBullet2 => 'बग रिपोर्ट गर्नुहोस्';

  @override
  String get commBullet3 => 'नयाँ सुविधाहरू सुझाव दिनुहोस्';

  @override
  String get commWelcomeBody2 =>
      'म आफैं प्रत्येक सन्देश पढ्छु र तपाईंको सुझावहरू अनुसार एप सुधार गर्ने प्रयास गर्नेछु।\n\nPulse प्रयोग गर्नुभएकोमा र यो यात्रामा सामेल हुनुभएकोमा धन्यवाद। ❤️';

  @override
  String commError(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get commNoMessages => 'अहिलेसम्म कुनै सन्देश छैन';

  @override
  String get commNoMessagesDesc =>
      'सपोर्ट टोलीलाई सन्देश पठाउनुहोस् वा घोषणाहरूको लागि पछि जाँच गर्नुहोस्।';

  @override
  String get commMessageSupportHint => 'सपोर्टलाई सन्देश पठाउनुहोस्...';

  @override
  String get commGlobalAnnouncements => 'विश्वव्यापी घोषणाहरू';

  @override
  String get commSendMessagesToAll => 'सबैलाई सन्देश पठाउनुहोस्';

  @override
  String get homeGreetingMorning => 'शुभ प्रभात,';

  @override
  String get homeGreetingAfternoon => 'शुभ दिउँसो,';

  @override
  String get homeGreetingEvening => 'शुभ सन्ध्या,';

  @override
  String get homeMember => 'सदस्य';

  @override
  String get homeRecentPlaylists => 'भर्खरका प्लेलिस्टहरू';

  @override
  String get homeRecentlyPlayed => 'भर्खरै सुनिएका';

  @override
  String get homeSpeedDial => 'द्रुत सम्पर्क';

  @override
  String get homeNoContent => 'कुनै सामग्री उपलब्ध छैन';

  @override
  String get homeRefresh => 'रिफ्रेस';

  @override
  String get homeLoadError => 'संगीत लोड गर्न सकेन।';

  @override
  String get homeRetry => 'फेरि प्रयास गर्नुहोस्';

  @override
  String get importSuccess => 'Spotify सँग सफलतापूर्वक जडान भयो!';

  @override
  String importFailed(String error) {
    return 'जडान गर्न असफल: $error';
  }

  @override
  String get importTitle => 'Spotify जडान गर्नुहोस्';

  @override
  String get importSetupTitle => 'Spotify सेटअप गर्नुहोस्';

  @override
  String get importSetupDesc =>
      'तपाईंको आफ्नै नि:शुल्क विकासकर्ता कुञ्जी प्रयोग गरेर तपाईंको सबै प्लेलिस्टहरू तुरुन्तै आयात गर्न यी सरल चरणहरू पालना गर्नुहोस्:';

  @override
  String get importStep1 => 'Spotify Developer Dashboard खोल्नुहोस्।';

  @override
  String get importStep2 =>
      'लगइन गर्नुहोस् र \'Create app\' मा क्लिक गर्नुहोस्।';

  @override
  String get importStep3 => 'एपको नाम र विवरण भर्नुहोस्।';

  @override
  String get importStep4 =>
      '\'Redirect URIs\' अन्तर्गत तल दिइएको URL टाँस्नुहोस्:';

  @override
  String get importRedirectCopied => 'Redirect URI प्रतिलिपि गरियो!';

  @override
  String get importStep5 =>
      'सेभ गर्नुहोस्, तपाईंको \'Client ID\' प्रतिलिपि गर्नुहोस् र तल टाँस्नुहोस्।';

  @override
  String get importImportant =>
      'महत्त्वपूर्ण: यस विकासकर्ता एपको लागि तपाईंसँग प्रिमियम सदस्यता हुनु आवश्यक छ।';

  @override
  String get importClientIdHint =>
      'तपाईंको Spotify Client ID यहाँ टाँस्नुहोस्...';

  @override
  String get importConnectButton =>
      'जडान गर्नुहोस् र पुस्तकालय प्राप्त गर्नुहोस्';

  @override
  String get downloadingNoActive => 'कुनै सक्रिय डाउनलोड छैन';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'डाउनलोडहरू';

  @override
  String downloadsStats(String count, String size) {
    return '$count गीतहरू • $size';
  }

  @override
  String get downloadsNoOffline => 'अहिलेसम्म कुनै अफलाइन गीतहरू छैनन्';

  @override
  String get downloadsNoOfflineDesc =>
      'तपाईंले डाउनलोड गरेका गीतहरू यहाँ देखिनेछन्';

  @override
  String get downloadsClearAllTitle => 'सबै डाउनलोडहरू मेटाउन चाहनुहुन्छ?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'यसले $count गीतहरू मेटाउनेछ र $size भण्डारण खाली गर्नेछ।';
  }

  @override
  String get downloadsCancel => 'रद्द गर्नुहोस्';

  @override
  String get downloadsClearAll => 'सबै मेटाउनुहोस्';

  @override
  String downloadsSongsCount(String count) {
    return '$count गीतहरू';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count गीत';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'मुख्य डाउनलोड प्लेलिस्टको नाम परिवर्तन गर्न सकिँदैन।';

  @override
  String get downloadsRename => 'नाम परिवर्तन गर्नुहोस्';

  @override
  String get downloadsEditSongs => 'गीतहरू सम्पादन गर्नुहोस्';

  @override
  String get downloadsDelete => 'मेटाउनुहोस्';

  @override
  String get downloadsRenamePlaylistTitle =>
      'प्लेलिस्टको नाम परिवर्तन गर्नुहोस्';

  @override
  String get downloadsRenamePlaylistDesc =>
      'तपाईंको प्लेलिस्टको लागि नयाँ नाम टाइप गर्नुहोस्।';

  @override
  String get downloadsDeletePlaylistTitle => 'प्लेलिस्ट मेटाउन चाहनुहुन्छ?';

  @override
  String get downloadsDeleteMasterDesc =>
      'के तपाईं पक्का यसलाई मेटाउन चाहनुहुन्छ? तपाईंका सबै डाउनलोड गरिएका गीतहरू र प्लेलिस्टहरू सधैंको लागि नष्ट हुनेछन्।';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'के तपाईं पक्का \'$name\' मेटाउन चाहनुहुन्छ? यो प्लेलिस्ट सधैंको लागि नष्ट हुनेछ।';
  }

  @override
  String get downloadsSave => 'सेभ गर्नुहोस्';

  @override
  String get downloadsNoSongs => 'यस प्लेलिस्टमा कुनै गीतहरू छैनन्।';

  @override
  String get libraryTitle => 'पुस्तकालय';

  @override
  String get libraryPauseAll => 'सबै रोक्नुहोस्';

  @override
  String get libraryResumeAll => 'सबै सुरु गर्नुहोस्';

  @override
  String get libraryTabPlaylists => 'प्लेलिस्टहरू';

  @override
  String get libraryTabDownloads => 'डाउनलोडहरू';

  @override
  String get libraryTabDownloading => 'डाउनलोड हुँदैछ';

  @override
  String libraryImportedTask(String name) {
    return '$name आयात गरियो';
  }

  @override
  String get libraryImportWaiting => 'पर्खिँदै...';

  @override
  String get libraryImportFetching => 'प्लेलिस्ट प्राप्त गर्दै...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total प्रोसेस गरियो · $matched भेटिए';
  }

  @override
  String get libraryImportSaving => 'पुस्तकालयमा सेभ गर्दै...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched गीतहरू थपिए';
  }

  @override
  String get libraryImportDoneAll => 'सबै गीतहरू थपिए';

  @override
  String get libraryAddButton => 'थप्नुहोस्';

  @override
  String get librarySortRecent => 'भर्खरै थपिएका';

  @override
  String get librarySortAlpha => 'वर्णमाला अनुसार';

  @override
  String get libraryEmptyTitle => 'तपाईंको पुस्तकालय खाली छ।';

  @override
  String get libraryEmptyDesc => 'सुरु गर्न \'थप्नुहोस्\' मा ट्याप गर्नुहोस्।';

  @override
  String get libraryRenameLikedError =>
      'मनपर्ने गीतहरूको प्लेलिस्टको नाम परिवर्तन गर्न सकिँदैन।';

  @override
  String get libraryRename => 'नाम परिवर्तन गर्नुहोस्';

  @override
  String get libraryEditSongs => 'गीतहरू सम्पादन गर्नुहोस्';

  @override
  String get libraryDeleteLikedError =>
      'मनपर्ने गीतहरूको प्लेलिस्ट मेटाउन सकिँदैन।';

  @override
  String get libraryDelete => 'मेटाउनुहोस्';

  @override
  String get libraryEditSongsTitle => 'गीतहरू सम्पादन गर्नुहोस्';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count गीत';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count गीतहरू';
  }

  @override
  String get libraryCancel => 'रद्द गर्नुहोस्';

  @override
  String get librarySave => 'सेभ गर्नुहोस्';

  @override
  String get libraryNoSongs => 'यस प्लेलिस्टमा कुनै गीतहरू छैनन्।';

  @override
  String get libraryAddOptionsTitle => 'पुस्तकालयमा थप्नुहोस्';

  @override
  String get libraryAddOptionsDesc =>
      'तपाईंको Pulse कसरी बढाउने छनोट गर्नुहोस्';

  @override
  String get libraryImportPulse => 'Pulse बाट आयात गर्नुहोस्';

  @override
  String get libraryImportPulseDesc => 'Pulse प्लेलिस्ट URL टाँस्नुहोस्';

  @override
  String get libraryImportYtm => 'YT Music बाट आयात गर्नुहोस्';

  @override
  String get libraryImportYtmDesc => 'सार्वजनिक प्लेलिस्ट URL टाँस्नुहोस्';

  @override
  String get libraryImportSpotify => 'Spotify बाट आयात गर्नुहोस्';

  @override
  String get libraryImportSpotifyDesc => 'तपाईंको Spotify जडान गर्नुहोस्';

  @override
  String get libraryClose => 'बन्द गर्नुहोस्';

  @override
  String get libraryImportYtmFull => 'YouTube Music बाट आयात गर्नुहोस्';

  @override
  String get libraryImportSpotifyFull => 'Spotify बाट आयात गर्नुहोस् (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'सार्वजनिक YouTube Music प्लेलिस्ट URL यहाँ टाँस्नुहोस्';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'सार्वजनिक Spotify प्लेलिस्ट URL यहाँ टाँस्नुहोस्';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Pulse प्लेलिस्ट आयात गर्न असफल';

  @override
  String get importErrorPlaylist => 'प्लेलिस्ट आयात गर्दा त्रुटि';

  @override
  String get importErrorHighlyPopulated =>
      'प्लेलिस्ट धेरै ठूलो छ, केही समय लाग्न सक्छ।';

  @override
  String get libraryImportBtn => 'आयात गर्नुहोस्';

  @override
  String get libraryCreateTitle => 'नयाँ प्लेलिस्ट';

  @override
  String get libraryCreateDesc => 'यस प्लेलिस्टको नाम के राख्ने?';

  @override
  String get libraryCreateHint => 'उदाहरण: रातको यात्रा';

  @override
  String get libraryCreateBtn => 'बनाउनुहोस्';

  @override
  String get libraryRenameTitle => 'प्लेलिस्टको नाम परिवर्तन गर्नुहोस्';

  @override
  String get libraryRenameDesc =>
      'तपाईंको प्लेलिस्टको लागि नयाँ नाम टाइप गर्नुहोस्।';

  @override
  String get libraryRenameBtn => 'नाम परिवर्तन गर्नुहोस्';

  @override
  String get libraryDeleteTitle => 'प्लेलिस्ट मेटाउन चाहनुहुन्छ?';

  @override
  String libraryDeleteDesc(String name) {
    return 'के तपाईं पक्का \'$name\' मेटाउन चाहनुहुन्छ? यो प्लेलिस्ट सधैंको लागि नष्ट हुनेछ।';
  }

  @override
  String get libraryDeleteBtn => 'मेटाउनुहोस्';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'भर्खरैको';

  @override
  String librarySongsCount(String count) {
    return '$count गीतहरू';
  }

  @override
  String get libraryComingSoon => 'चाँडै आउँदैछ';

  @override
  String get loginErrName => 'कृपया तपाईंको नाम टाइप गर्नुहोस्';

  @override
  String get loginErrEmail => 'कृपया तपाईंको ईमेल टाइप गर्नुहोस्';

  @override
  String get loginErrPassword => 'कृपया तपाईंको पासवर्ड टाइप गर्नुहोस्';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'हरेक बिट महसुस गर्नुहोस्!';

  @override
  String get loginMadeWithHeartBy => '❤️ सँग बनाइएको: ';

  @override
  String get loginAuthorName => 'आशुतोष पाठक';

  @override
  String get loginHintName => 'तपाईंको नाम';

  @override
  String get loginHintEmail => 'ईमेल ठेगाना';

  @override
  String get loginHintPassword => 'पासवर्ड';

  @override
  String get loginErrEmailReset => 'पासवर्ड रिसेट गर्न ईमेल टाइप गर्नुहोस्';

  @override
  String get loginResetSent =>
      'पासवर्ड रिसेट ईमेल पठाइयो! तपाईंको इनबक्स जाँच गर्नुहोस्।';

  @override
  String get loginForgotPwd => 'पासवर्ड बिर्सनुभयो?';

  @override
  String get loginBtnSignup => 'खाता बनाउनुहोस्';

  @override
  String get loginBtnSignin => 'साइन इन गर्नुहोस्';

  @override
  String get loginToggleHaveAccount => 'के तपाईंसँग पहिले नै Pulse खाता छ? ';

  @override
  String get loginToggleNoAccount => 'के Pulse खाता छैन? ';

  @override
  String get loginToggleSignin => 'साइन इन गर्नुहोस्';

  @override
  String get loginToggleSignup => 'साइन अप गर्नुहोस्';

  @override
  String get offlineStillOffline =>
      'अझै अफलाइन। कृपया तपाईंको जडान जाँच गर्नुहोस्।';

  @override
  String get offlineTitle => 'तपाईं अफलाइन हुनुहुन्छ';

  @override
  String get offlineSubtitle =>
      'कुनै इन्टरनेट जडान फेला परेन।\nतपाईंको नेटवर्क जाँच गर्नुहोस् र फेरि प्रयास गर्नुहोस्।';

  @override
  String get offlineChecking => 'जाँच गर्दै...';

  @override
  String get offlineRetry => 'फेरि प्रयास गर्नुहोस्';

  @override
  String get offlineGoToDownloads => 'डाउनलोडहरूमा जानुहोस्';

  @override
  String get playerMadeWithHeartBy => '❤️ सँग बनाइएको: ';

  @override
  String get playerAuthorName => 'आशुतोष पाठक';

  @override
  String get playerSwipeForLyrics => 'गीतका शब्दहरूको लागि स्वाइप गर्नुहोस्';

  @override
  String get playerNoLyrics => 'कुनै शब्दहरू उपलब्ध छैनन्';

  @override
  String get playerUpNext => 'अर्को बज्नेछ';

  @override
  String get playerNoTracksInQueue => 'लाममा कुनै गीतहरू छैनन्';

  @override
  String get playerNoMusicPlaying => 'कुनै संगीत बजिरहेको छैन';

  @override
  String get playerPickAVibe => 'तपाईंको पुस्तकालय वा होमबाट गीत छान्नुहोस्';

  @override
  String get playerGoHome => 'होममा जानुहोस्';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'इक्वेलाइजर';

  @override
  String get playerEqCustom => 'कस्टम';

  @override
  String get playlistDownloads => 'डाउनलोडहरू';

  @override
  String get playlistOffline => 'अफलाइन प्लेलिस्ट';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hoursघण्टा $minsमिनेट';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$minsमिनेट';
  }

  @override
  String get playlistFindOnPage => 'यस पृष्ठमा खोज्नुहोस्';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count गीतहरू • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'भर्खरैको';

  @override
  String get playlistNoMatches => 'कुनै नतिजा फेला परेन।';

  @override
  String get playlistNoTracks => 'यस प्लेलिस्टमा कुनै गीतहरू छैनन्।';

  @override
  String get playlistNoSongsYet => 'अहिलेसम्म कुनै गीत छैन।';

  @override
  String get playlistSortRecentlyAdded => 'भर्खरै थपिएका';

  @override
  String get playlistSortAlphabetical => 'वर्णमाला अनुसार';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'गीतहरू',
      one: 'गीत',
    );
    return '$count $_temp0 डाउनलोड हुँदैछ';
  }

  @override
  String get playlistView => 'हेर्नुहोस्';

  @override
  String get playlistAllDownloaded => 'सबै गीतहरू पहिले नै डाउनलोड भइसकेका छन्';

  @override
  String playlistShareText(String name, String url) {
    return 'Pulse मा \'$name\' हेर्नुहोस्!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'डाउनलोडहरूबाट हटाउनुहोस्';

  @override
  String get playlistRemoveFromPlaylist => 'प्लेलिस्टबाट हटाउनुहोस्';

  @override
  String get playlistLoadError => 'यो प्लेलिस्ट लोड गर्न सकेन।';

  @override
  String get playlistGoBack => '← पछाडि जानुहोस्';

  @override
  String get profileNotLoggedIn => 'लग इन गरिएको छैन';

  @override
  String get profileSignIn => 'साइन इन गर्नुहोस्';

  @override
  String get profileDefaultUser => 'Pulse प्रयोगकर्ता';

  @override
  String get profileEditProfile => 'सम्पादन गर्नुहोस्';

  @override
  String get profileTimeframeDay => 'दिन';

  @override
  String get profileTimeframeWeek => 'हप्ता';

  @override
  String get profileTimeframeMonth => 'महिना';

  @override
  String get profileTimeframeYear => 'वर्ष';

  @override
  String get profileListeningTime => 'सुन्ने समय';

  @override
  String get profileToday => 'आज';

  @override
  String get profileThisWeek => 'यस हप्ता';

  @override
  String get profileThisMonth => 'यस महिना';

  @override
  String get profileThisYear => 'यस वर्ष';

  @override
  String get profileDailyAvg => 'दैनिक औसत';

  @override
  String get profilePerDay => 'प्रति दिन';

  @override
  String get profileLifetimeListening => 'आजीवन सुन्ने समय';

  @override
  String get profileTotalTimeListened => 'Pulse मा संगीत सुनेको कुल समय';

  @override
  String get profileYourTopSongs => 'तपाईंका शीर्ष गीतहरू';

  @override
  String get profileListeningHistoryEmpty => 'सुनेको इतिहास यहाँ देखिनेछ।';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'पटक',
      one: 'पटक',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => 'तपाईंका शीर्ष कलाकारहरू';

  @override
  String get profileTopArtistsEmpty =>
      'तपाईंका शीर्ष कलाकारहरू यहाँ देखिनेछन्।';

  @override
  String get profileArtistLabel => 'कलाकार';

  @override
  String get profileSignOut => 'साइन आउट गर्नुहोस्';

  @override
  String profileVersion(String version) {
    return 'संस्करण $version';
  }

  @override
  String get profileMadeWithHeartBy => '❤️ सँग बनाइएको: ';

  @override
  String get profileAuthorName => 'आशुतोष पाठक';

  @override
  String get profileEditProfileHeader => 'सम्पादन गर्नुहोस्';

  @override
  String get profileDisplayName => 'नाम';

  @override
  String get profileCancel => 'रद्द गर्नुहोस्';

  @override
  String get profileSave => 'सेभ गर्नुहोस्';

  @override
  String get profileChooseAvatar => 'अवतार छान्नुहोस्';

  @override
  String get searchMicPermissionRequired =>
      'यस सुविधाको लागि माइक्रोफोन अनुमति आवश्यक छ';

  @override
  String get searchUnknownSong => 'अज्ञात गीत';

  @override
  String get searchUnknownArtist => 'अज्ञात कलाकार';

  @override
  String get searchNoSongDetected => 'कुनै गीत पहिचान भएन।';

  @override
  String searchError(String message) {
    return 'त्रुटि: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'आवाज पहिचान उपलब्ध छैन';

  @override
  String get searchHint => 'गीतहरू, कलाकारहरू, एल्बमहरू, प्लेलिस्टहरू…';

  @override
  String get searchRecentEmpty => 'तपाईंका भर्खरका खोजहरू यहाँ देखिनेछन्';

  @override
  String get searchRecentSearches => 'भर्खरका खोजहरू';

  @override
  String get searchClearAll => 'सबै खाली गर्नुहोस्';

  @override
  String searchNoResultsFor(String query) {
    return '\'$query\' को लागि कुनै नतिजा छैन';
  }

  @override
  String get searchTryDifferentKeywords => 'फरक शब्दहरू प्रयास गर्नुहोस्';

  @override
  String get searchTopResult => 'शीर्ष नतिजा';

  @override
  String get searchSongsLabel => 'गीतहरू';

  @override
  String get searchArtistsLabel => 'कलाकारहरू';

  @override
  String get searchAlbumsLabel => 'एल्बमहरू';

  @override
  String get searchPlaylistsLabel => 'प्लेलिस्टहरू';

  @override
  String get searchArtistLabel => 'कलाकार';

  @override
  String get searchListening => 'सुन्दैछ...';

  @override
  String get searchSpeakNow => 'खोज्नको लागि अब बोल्नुहोस्';

  @override
  String get searchCancel => 'रद्द गर्नुहोस्';

  @override
  String get searchIdentifying => 'पहिचान गर्दैछ...';

  @override
  String get searchListeningForSong => 'गीत सुन्दैछ...';

  @override
  String get settingsTitle => 'सेटिङहरू';

  @override
  String get settingsStreamingQuality => 'स्ट्रिमिङ गुणस्तर';

  @override
  String get settingsQualityAutomatic => 'स्वचालित';

  @override
  String get settingsQualityLow => 'कम';

  @override
  String get settingsQualityNormal => 'सामान्य';

  @override
  String get settingsQualityHigh => 'उच्च';

  @override
  String get settingsDownloadQuality => 'डाउनलोड गुणस्तर';

  @override
  String get settingsPlayback => 'प्लेब्याक';

  @override
  String get settingsCrossfade => 'क्रसफेड';

  @override
  String get settingsCrossfadeDesc =>
      'ग्यापलेस ट्रान्जिसनको लागि ट्र्याकहरू ओभरल्याप गर्नुहोस्';

  @override
  String get settingsDataUsage => 'डेटा प्रयोग';

  @override
  String get settingsDataSaver => 'डेटा सेभर';

  @override
  String get settingsDataSaverDesc =>
      'मोबाइल डेटामा कम गुणस्तरमा स्ट्रिम गर्नुहोस्';

  @override
  String get settingsAppearance => 'देखावट';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsCustomAccent => 'कस्टम रंग';

  @override
  String get settingsSaturation => 'स्याचुरेसन';

  @override
  String get settingsBrightness => 'उज्यालोपन';

  @override
  String get settingsResetDefault => 'पूर्वनिर्धारित रिसेट गर्नुहोस्';

  @override
  String get playlistSheetTitle => 'प्लेलिस्टमा थप्नुहोस्';

  @override
  String get playlistSheetNewPlaylist => 'नयाँ प्लेलिस्ट';

  @override
  String get playlistSheetNoPlaylists => 'अहिलेसम्म कुनै प्लेलिस्ट छैन';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'गीतहरू',
      one: 'गीत',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => 'प्लेलिस्टको नाम';

  @override
  String get playlistSheetCancel => 'रद्द गर्नुहोस्';

  @override
  String playlistSheetAddedTo(String name) {
    return '$name मा थपियो';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'प्लेलिस्ट बनाउन असफल: प्रमाणीकरण त्रुटि';

  @override
  String playlistSheetCreateFail(String error) {
    return 'प्लेलिस्ट बनाउन असफल: $error';
  }

  @override
  String get playlistSheetCreate => 'बनाउनुहोस्';

  @override
  String get appUpdateAvailable => 'अपडेट उपलब्ध छ';

  @override
  String appUpdateDesc(String version) {
    return 'संस्करण $version उपलब्ध छ! नयाँ सुविधाहरू प्राप्त गर्न अहिले नै अपडेट गर्नुहोस्।';
  }

  @override
  String get appUpdateDownload => 'अपडेट डाउनलोड गर्नुहोस्';

  @override
  String get navHome => 'होम';

  @override
  String get navLibrary => 'पुस्तकालय';

  @override
  String get navSearch => 'खोज';

  @override
  String get navSettings => 'सेटिङहरू';

  @override
  String get navProfile => 'प्रोफाइल';

  @override
  String get artistSelect => 'कलाकार छान्नुहोस्';

  @override
  String get songActionQueue => 'लाममा थप्नुहोस्';

  @override
  String get songActionPlaylist => 'प्लेलिस्टमा थप्नुहोस्';

  @override
  String get songActionFinding => 'खोज्दैछ...';

  @override
  String get songActionAlbum => 'एल्बममा जानुहोस्';

  @override
  String get songActionArtist => 'कलाकारमा जानुहोस्';

  @override
  String get songActionRemovePlaylist => 'प्लेलिस्टबाट हटाउनुहोस्';

  @override
  String get songActionRemoveDownload => 'डाउनलोडहरूबाट हटाउनुहोस्';

  @override
  String get songActionDownloadChecking => 'जाँच गर्दै...';

  @override
  String get songActionDownloading => 'डाउनलोड हुँदैछ...';

  @override
  String get songActionDownloaded => 'डाउनलोड भयो!';

  @override
  String get songActionDownloadAlready => 'पहिले नै डाउनलोड गरिएको छ';

  @override
  String get songActionDownloadFailed => 'डाउनलोड असफल';

  @override
  String get songActionDownload => 'डाउनलोड गर्नुहोस्';

  @override
  String get songActionDownloadingSnack => 'डाउनलोड गर्दै';

  @override
  String get songActionView => 'हेर्नुहोस्';

  @override
  String get spotifyImportTitle => 'Spotify बाट आयात गर्नुहोस्';

  @override
  String get spotifyImportSubtitle => 'तपाईंको प्लेलिस्टको आकार छान्नुहोस्';

  @override
  String get spotifyChoiceSmallTitle => '१०० वा कम गीतहरू';

  @override
  String get spotifyChoiceSmallDesc =>
      'सार्वजनिक Spotify प्लेलिस्ट URL टाँस्नुहोस्।';

  @override
  String get spotifyChoiceLargeTitle => '१०० भन्दा बढी गीतहरू';

  @override
  String get spotifyChoiceLargeDesc =>
      'असीमित गीतहरू आयात गर्न तपाईंको आफ्नै Spotify Developer App जडान गर्नुहोस्।';

  @override
  String get cancelButton => 'रद्द गर्नुहोस्';

  @override
  String get spotifyPlaylistsTitle => 'तपाईंका Spotify प्लेलिस्टहरू';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'त्रुटि: $error\nतपाईंको Client ID सही छ भनी सुनिश्चित गर्नुहोस्।';
  }

  @override
  String get spotifyPlaylistsEmpty =>
      'तपाईंको पुस्तकालयमा कुनै प्लेलिस्ट फेला परेन';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count ट्र्याकहरू';
  }

  @override
  String get spotifyPlaylistsImport => 'आयात गर्नुहोस्';

  @override
  String get audioPlaybackFailed =>
      'प्लेब्याक असफल। तपाईंको इन्टरनेट जडान जाँच गर्नुहोस्।';

  @override
  String get audioControlPrevious => 'अघिल्लो';

  @override
  String get audioControlPause => 'रोक्नुहोस्';

  @override
  String get audioControlPlay => 'प्ले गर्नुहोस्';

  @override
  String get audioControlNext => 'अर्को';

  @override
  String get audioControlUnlike => 'मन परेन';

  @override
  String get audioControlLike => 'मन पर्यो';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'मूल जवाफ: $data\n\nफलब्याक: $error';
  }

  @override
  String get apiErrorInvalidClient => 'अवैध क्लाइन्ट वा क्लाइन्ट गोप्य।';

  @override
  String get apiErrorBadRequest =>
      'ब्याड रिक्वेस्ट। कृपया तपाईंको विवरणहरू जाँच गर्नुहोस्।';

  @override
  String get apiErrorUnauthorized => 'अनाधिकृत। कृपया फेरि लग इन गर्नुहोस्।';

  @override
  String get apiErrorForbidden => 'निषेधित। तपाईंलाई पहुँच छैन।';

  @override
  String get apiErrorNotFound => 'स्रोत फेला परेन।';

  @override
  String get apiErrorEmailInUse => 'यो ईमेल ठेगाना पहिले नै प्रयोगमा छ।';

  @override
  String get apiErrorUserNotFound => 'यस ईमेलको साथ कुनै खाता फेला परेन।';

  @override
  String get apiErrorWrongPassword => 'गलत पासवर्ड।';

  @override
  String get apiErrorInvalidCredential =>
      'लगइन असफल। कृपया तपाईंको प्रमाणहरू जाँच गर्नुहोस्।';

  @override
  String get apiErrorNetwork =>
      'नेटवर्क त्रुटि। कृपया तपाईंको जडान जाँच गर्नुहोस्।';

  @override
  String get apiErrorSocketTimeout =>
      'जडान समय समाप्त भयो। कृपया फेरि प्रयास गर्नुहोस्।';

  @override
  String get apiErrorTooManyRequests =>
      'धेरै अनुरोधहरू। कृपया केही समय पर्खनुहोस् र फेरि प्रयास गर्नुहोस्।';

  @override
  String get apiErrorServerError =>
      'सर्भर त्रुटि। कृपया पछि फेरि प्रयास गर्नुहोस्।';

  @override
  String get apiErrorInvalidEmail => 'कृपया सही ईमेल ठेगाना टाइप गर्नुहोस्।';

  @override
  String get apiErrorWeakPassword =>
      'पासवर्ड धेरै कमजोर छ। कम्तीमा ६ वर्णहरू प्रयोग गर्नुहोस्।';

  @override
  String get apiErrorTooManyAttempts =>
      'धेरै असफल प्रयासहरू। कृपया पछि फेरि प्रयास गर्नुहोस्।';

  @override
  String get homeForgottenFavorites => 'बिर्सिएका मनपर्ने गीतहरू';

  @override
  String get artistShowAll => 'सबै देखाउनुस्';

  @override
  String get homeTopTracks => 'शीर्ष ट्र्याकहरू';
}
