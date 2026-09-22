// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Maithili (`mai`).
class AppLocalizationsMai extends AppLocalizations {
  AppLocalizationsMai([String locale = 'mai']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'परिचय';

  @override
  String get artistPopular => 'लोकप्रिय';

  @override
  String get artistAlbums => 'एल्बम';

  @override
  String get artistSinglesAndEPs => 'सिंगल्स आ ईपी';

  @override
  String artistSubscribersCount(String count) {
    return '$count सदस्य';
  }

  @override
  String get artistPlayAll => 'सब बजाउ';

  @override
  String get artistLoadError => 'कलाकार लोड नइँ भ\' सकल';

  @override
  String get artistGoBack => 'पाछाँ जाउ';

  @override
  String adminChatFailedToReply(String error) {
    return 'जवाफ देबामे विफल: $error';
  }

  @override
  String get adminChatSupportChat => 'सहायता च्याट';

  @override
  String adminChatError(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get adminChatNoHistory => 'कोनो कुराकानीक इतिहास नइँ अछि।';

  @override
  String get adminChatSupportYou => 'सहायता (अहाँ)';

  @override
  String get adminChatTypeReply => 'अपन जवाफ लिखू...';

  @override
  String get broadcastSuccess => 'घोषणा सफलतापूर्वक प्रसारित भेल!';

  @override
  String broadcastFailed(String error) {
    return 'प्रसारणमे विफल: $error';
  }

  @override
  String get broadcastTitle => 'सार्वजनिक घोषणासभ';

  @override
  String get broadcastSubtitle => 'सब प्रयोगकर्तासभकेँ पठाएल गेल';

  @override
  String get broadcastWarning => 'एतय पठाएल संदेश सभकेँ देखाएत।';

  @override
  String broadcastError(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get broadcastNoHistory => 'कोनो पुरान घोषणा नइँ अछि।';

  @override
  String get broadcastTypeMessage => 'सार्वजनिक संदेश लिखू...';

  @override
  String commFailedToSend(String error) {
    return 'पठाबामे विफल: $error';
  }

  @override
  String get commAdminDashboard => 'एडमिन ड्यासबोर्ड';

  @override
  String get commAdminSupport => 'एडमिन सहायता';

  @override
  String get commAlwaysHere => 'मददक लेल हमेशा उपस्थित';

  @override
  String get commWelcomeTitle => 'नमस्कार! 👋 हम आशुतोष पाठक छी';

  @override
  String get commWelcomeSubtitle => 'Pulse क डेवलपर';

  @override
  String get commWelcomeBody1 =>
      'हमरा आशा अछि जे अहाँ बिना कोनो विज्ञापन या सब्सक्रिप्शनक अपन मनपसंद संगीत सुनबाक आनंद ल\' रहल छी। जँ कोनो बोर्डरूममे बैसल लोककेँ नवका यॉट चाही, तकर मतलब ई नइँ जे संगीतक लेल पैसा देब\' पड़य।\n\nई खण्ड अहाँसँ सीधा जुड़बाक लेल अछि।\n\nअहाँ बेझिझक:';

  @override
  String get commBullet1 => 'अपन प्रतिक्रिया दिअ';

  @override
  String get commBullet2 => 'बग रिपोर्ट करू';

  @override
  String get commBullet3 => 'नव फिचर्सक सुझाव दिअ जे अहाँ देखबाक चाहैत छी';

  @override
  String get commWelcomeBody2 =>
      'हम व्यक्तिगत रूपसँ सब संदेश पढ़ैत छी आ अहाँक सुझावसभक आधार पर एपकेँ नीक बनेबाक पूर्ण प्रयास करब।\n\nजँ अहाँ लग कोनो एहन एपक विचार अछि जे अखन धरि नइँ बनल अछि, या जे महग सब्सक्रिप्शनक पाछाँ अछि, तँ हमरा बताउ! जँ संभव हेतै, तँ हम ओकरा बनाक\' सभक लेल उपलब्ध कराएम।\n\nहमर एप उपयोग करबाक लेल आ एहि यात्राक हिस्सा बनबाक लेल धन्यवाद। ❤️';

  @override
  String commError(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get commNoMessages => 'अखन धरि कोनो संदेश नइँ';

  @override
  String get commNoMessagesDesc =>
      'हमर सहायता टिमकेँ संदेश पठाउ या घोषणासभक लेल बादमे जाँच करू।';

  @override
  String get commMessageSupportHint => 'सहायताकेँ संदेश पठाउ...';

  @override
  String get commGlobalAnnouncements => 'सार्वजनिक घोषणासभ';

  @override
  String get commSendMessagesToAll => 'सब प्रयोगकर्तासभकेँ संदेश पठाउ';

  @override
  String get homeGreetingMorning => 'सुप्रभात,';

  @override
  String get homeGreetingAfternoon => 'शुभ अपराह्न,';

  @override
  String get homeGreetingEvening => 'शुभ संध्या,';

  @override
  String get homeMember => 'सदस्य';

  @override
  String get homeRecentPlaylists => 'हालक प्लेलिस्ट';

  @override
  String get homeRecentlyPlayed => 'हालमे बजाएल';

  @override
  String get homeSpeedDial => 'शीघ्र पहुँच';

  @override
  String get homeNoContent => 'कोनो सामग्री उपलब्ध नइँ';

  @override
  String get homeRefresh => 'रिफ्रेश करू';

  @override
  String get homeLoadError => 'संगीत फिड लोड नइँ भ\' सकल।';

  @override
  String get homeRetry => 'पुनः प्रयास करू';

  @override
  String get importSuccess => 'Spotify सँ सफलतापूर्वक जुड़ल!';

  @override
  String importFailed(String error) {
    return 'जुड़बामे विफल: $error';
  }

  @override
  String get importTitle => 'Spotify सँ जोड़ू';

  @override
  String get importSetupTitle => 'Spotify एकीकरण सेटअप करू';

  @override
  String get importSetupDesc =>
      'Spotify क कठोर रेट लिमिट सँ बचबाक आ अपन सब प्लेलिस्ट तुरंत इम्पोट करबाक लेल, अहाँकेँ अपन निःशुल्क डेवलपर की उपयोग कर\' पड़त। ई आसान चरणसभक पालन करू:';

  @override
  String get importStep1 => 'Spotify डेवलपर ड्यासबोर्ड खोलू।';

  @override
  String get importStep2 => 'लग-इन करू आ \"Create app\" पर क्लिक करू।';

  @override
  String get importStep3 => 'कोनो एपक नाम आ विवरण भरू।';

  @override
  String get importStep4 => '\"Redirect URIs\" क नीचाँ, ई सटीक URL पेस्ट करू:';

  @override
  String get importRedirectCopied => 'Redirect URI कपी भेल!';

  @override
  String get importStep5 =>
      'एप सेव करू, सेटिंग्स सँ अपन \"Client ID\" कपी करू, आ ओकरा नीचाँ पेस्ट करू।';

  @override
  String get importImportant =>
      'महत्वपूर्ण: ई डेवलपर एप बनेबाक लेल उपयोग कएल गेल Spotify खातामे सक्रिय प्रीमियम सब्सक्रिप्शन होनाइ आवश्यक अछि।';

  @override
  String get importClientIdHint => 'अपन Spotify Client ID एतय पेस्ट करू...';

  @override
  String get importConnectButton => 'जोड़ू आ लाइब्रेरी लोड करू';

  @override
  String get downloadingNoActive => 'कोनो सक्रिय डाउनलोड नइँ';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'डाउनलोडसभ';

  @override
  String downloadsStats(String count, String size) {
    return '$count गीत • $size';
  }

  @override
  String get downloadsNoOffline => 'अखन धरि कोनो अफलाइन गीत नइँ';

  @override
  String get downloadsNoOfflineDesc => 'अहाँ जे गीत डाउनलोड करब ओ एतय देखाएत';

  @override
  String get downloadsClearAllTitle => 'सब डाउनलोड हटाउ?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'ई $count गीत हटा देत आ $size स्टोरेज खाली करत।';
  }

  @override
  String get downloadsCancel => 'रद्द करू';

  @override
  String get downloadsClearAll => 'सब हटाउ';

  @override
  String downloadsSongsCount(String count) {
    return '$count गीत';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count गीत';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'मुख्य डाउनलोड प्लेलिस्टक नाम नइँ बदलि सकैत छी।';

  @override
  String get downloadsRename => 'नाम बदलू';

  @override
  String get downloadsEditSongs => 'गीतसभ सम्पादन करू';

  @override
  String get downloadsDelete => 'हटाउ';

  @override
  String get downloadsRenamePlaylistTitle => 'प्लेलिस्टक नाम बदलू';

  @override
  String get downloadsRenamePlaylistDesc =>
      'अपन प्लेलिस्टक लेल नव नाम दर्ज करू।';

  @override
  String get downloadsDeletePlaylistTitle => 'प्लेलिस्ट हटाउ?';

  @override
  String get downloadsDeleteMasterDesc =>
      'की अहाँ निश्चित छी जे अहाँ एकरा हटाब\' चाहैत छी? अहाँक सब डाउनलोड कएल गीत आ प्लेलिस्ट हमेशाक लेल मेटाए जाएत।';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'की अहाँ निश्चित छी जे अहाँ \"$name\" हटाब\' चाहैत छी? ई प्लेलिस्ट हमेशाक लेल मेटाए जाएत।';
  }

  @override
  String get downloadsSave => 'सेव करू';

  @override
  String get downloadsNoSongs => 'एहि प्लेलिस्टमे कोनो गीत नइँ अछि।';

  @override
  String get libraryTitle => 'लाइब्रेरी';

  @override
  String get libraryPauseAll => 'सब रोकु';

  @override
  String get libraryResumeAll => 'सब फेरसँ सुरु करू';

  @override
  String get libraryTabPlaylists => 'प्लेलिस्टसभ';

  @override
  String get libraryTabDownloads => 'डाउनलोडसभ';

  @override
  String get libraryTabDownloading => 'डाउनलोड भ\' रहल अछि';

  @override
  String libraryImportedTask(String name) {
    return 'इम्पोट भेल $name';
  }

  @override
  String get libraryImportWaiting => 'कतारमे प्रतीक्षा भ\' रहल अछि...';

  @override
  String get libraryImportFetching => 'प्लेलिस्ट लाबि रहल अछि...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total प्रोसेस भेल · $matched मिलल';
  }

  @override
  String get libraryImportSaving => 'लाइब्रेरीमे सेव भ\' रहल अछि...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched गीत जोड़ल गेल · हटाबक लेल × दबाउ';
  }

  @override
  String get libraryImportDoneAll => 'सब गीत जोड़ल गेल · हटाबक लेल × दबाउ';

  @override
  String get libraryAddButton => 'जोड़ू';

  @override
  String get librarySortRecent => 'हालमे जोड़ल';

  @override
  String get librarySortAlpha => 'वर्णमाला अनुसार';

  @override
  String get libraryEmptyTitle => 'अहाँक लाइब्रेरी खाली अछि।';

  @override
  String get libraryEmptyDesc =>
      'अपन पहिल Pulse सुरु करबाक लेल \"जोड़ू\" पर ट्याप करू।';

  @override
  String get libraryRenameLikedError =>
      'पसंदीदा गीत प्लेलिस्टक नाम नइँ बदलि सकैत छी।';

  @override
  String get libraryRename => 'नाम बदलू';

  @override
  String get libraryEditSongs => 'गीतसभ सम्पादन करू';

  @override
  String get libraryDeleteLikedError =>
      'पसंदीदा गीत प्लेलिस्ट नइँ हटाए सकैत छी।';

  @override
  String get libraryDelete => 'हटाउ';

  @override
  String get libraryEditSongsTitle => 'गीतसभ सम्पादन करू';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count गीत';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count गीतसभ';
  }

  @override
  String get libraryCancel => 'रद्द करू';

  @override
  String get librarySave => 'सेव करू';

  @override
  String get libraryNoSongs => 'एहि प्लेलिस्टमे कोनो गीत नइँ अछि।';

  @override
  String get libraryAddOptionsTitle => 'लाइब्रेरीमे जोड़ू';

  @override
  String get libraryAddOptionsDesc =>
      'अपन Pulse केँ विस्तार करबाक लेल विकल्प चुनू';

  @override
  String get libraryImportPulse => 'Pulse सँ इम्पोट करू';

  @override
  String get libraryImportPulseDesc => 'Pulse प्लेलिस्ट URL पेस्ट करू';

  @override
  String get libraryImportYtm => 'YT Music सँ इम्पोट करू';

  @override
  String get libraryImportYtmDesc => 'सार्वजनिक प्लेलिस्ट URL पेस्ट करू';

  @override
  String get libraryImportSpotify => 'Spotify सँ इम्पोट करू';

  @override
  String get libraryImportSpotifyDesc => 'अपन Spotify जोड़ू';

  @override
  String get libraryClose => 'बंद करू';

  @override
  String get libraryImportYtmFull => 'YouTube Music सँ इम्पोट करू';

  @override
  String get libraryImportSpotifyFull => 'Spotify सँ इम्पोट करू (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'सार्वजनिक YouTube Music प्लेलिस्ट या एल्बम URL पेस्ट करू';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'सार्वजनिक Spotify प्लेलिस्ट URL नीचाँ पेस्ट करू';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Pulse प्लेलिस्ट इम्पोट करबामे विफल';

  @override
  String get importErrorPlaylist => 'प्लेलिस्ट इम्पोट करबामे त्रुटि';

  @override
  String get importErrorHighlyPopulated =>
      'प्लेलिस्टमे बहुत गीत अछि, एकरा लाब\'मे समय लागि सकैत अछि।';

  @override
  String get libraryImportBtn => 'इम्पोट करू';

  @override
  String get libraryCreateTitle => 'नव प्लेलिस्ट';

  @override
  String get libraryCreateDesc => 'अहाँक नव प्लेलिस्टक की नाम राखल जाए?';

  @override
  String get libraryCreateHint => 'उदा. मिडनाइट राइड्स';

  @override
  String get libraryCreateBtn => 'बनाउ';

  @override
  String get libraryRenameTitle => 'प्लेलिस्टक नाम बदलू';

  @override
  String get libraryRenameDesc => 'अपन प्लेलिस्टक लेल नव नाम दर्ज करू।';

  @override
  String get libraryRenameBtn => 'नाम बदलू';

  @override
  String get libraryDeleteTitle => 'प्लेलिस्ट हटाउ?';

  @override
  String libraryDeleteDesc(String name) {
    return 'की अहाँ निश्चित छी जे अहाँ \"$name\" हटाब\' चाहैत छी? ई प्लेलिस्ट हमेशाक लेल मेटाए जाएत।';
  }

  @override
  String get libraryDeleteBtn => 'हटाउ';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'हालक';

  @override
  String librarySongsCount(String count) {
    return '$count गीत';
  }

  @override
  String get libraryComingSoon => 'जल्द आबि रहल अछि';

  @override
  String get loginErrName => 'कृपया अपन नाम दर्ज करू';

  @override
  String get loginErrEmail => 'कृपया अपन इमेल ठेगाना दर्ज करू';

  @override
  String get loginErrPassword => 'कृपया अपन पासवर्ड दर्ज करू';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'हरेक बीट महसुस करू!';

  @override
  String get loginMadeWithHeartBy => '❤️ सँ निर्माण: ';

  @override
  String get loginAuthorName => 'आशुतोष पाठक';

  @override
  String get loginHintName => 'अहाँक नाम';

  @override
  String get loginHintEmail => 'इमेल ठेगाना';

  @override
  String get loginHintPassword => 'पासवर्ड';

  @override
  String get loginErrEmailReset =>
      'पासवर्ड रिसेट करबाक लेल कृपया अपन इमेल दर्ज करू';

  @override
  String get loginResetSent =>
      'पासवर्ड रिसेट इमेल पठाएल गेल! अपन इनबक्स जाँच करू।';

  @override
  String get loginForgotPwd => 'पासवर्ड बिसरि गेलहुँ?';

  @override
  String get loginBtnSignup => 'खाता बनाउ';

  @override
  String get loginBtnSignin => 'साइन इन';

  @override
  String get loginToggleHaveAccount => 'की अहाँ लग पहिनेसँ Pulse खाता अछि? ';

  @override
  String get loginToggleNoAccount => 'Pulse खाता नइँ अछि? ';

  @override
  String get loginToggleSignin => 'साइन इन';

  @override
  String get loginToggleSignup => 'साइन अप';

  @override
  String get offlineStillOffline =>
      'अखनो अफलाइन अछि। कृपया अपन कनेक्सन जाँच करू।';

  @override
  String get offlineTitle => 'अहाँ अफलाइन छी';

  @override
  String get offlineSubtitle =>
      'कोनो इन्टरनेट कनेक्सन नइँ भेटल।\nअपन नेटवर्क जाँच करू आ पुनः प्रयास करू।';

  @override
  String get offlineChecking => 'जाँच भ\' रहल अछि...';

  @override
  String get offlineRetry => 'पुनः प्रयास करू';

  @override
  String get offlineGoToDownloads => 'डाउनलोडसभमे जाउ';

  @override
  String get playerMadeWithHeartBy => '❤️ सँ निर्माण: ';

  @override
  String get playerAuthorName => 'आशुतोष पाठक';

  @override
  String get playerSwipeForLyrics => 'गीतक बोल लेल स्वाइप करू';

  @override
  String get playerNoLyrics => 'कोनो बोल उपलब्ध नइँ';

  @override
  String get playerUpNext => 'अगला गीत';

  @override
  String get playerNoTracksInQueue => 'कतारमे कोनो गीत नइँ';

  @override
  String get playerNoMusicPlaying => 'कोनो संगीत नइँ बजि रहल अछि';

  @override
  String get playerPickAVibe => 'अपन लाइब्रेरी या होम सँ कोनो भाइब चुनू';

  @override
  String get playerGoHome => 'होम पर जाउ';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'इक्वलाइजर';

  @override
  String get playerEqCustom => 'कस्टम';

  @override
  String get playlistDownloads => 'डाउनलोडसभ';

  @override
  String get playlistOffline => 'अफलाइन प्लेलिस्ट';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hoursघं $minsमि';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$minsमि';
  }

  @override
  String get playlistFindOnPage => 'एहि पृष्ठ पर खोजू';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count गीत • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'हालक';

  @override
  String get playlistNoMatches => 'कोनो मिलान नइँ भेटल।';

  @override
  String get playlistNoTracks => 'एहि प्लेलिस्टमे कोनो गीत नइँ अछि।';

  @override
  String get playlistNoSongsYet => 'अखन धरि कोनो गीत नइँ।';

  @override
  String get playlistSortRecentlyAdded => 'हालमे जोड़ल गेल';

  @override
  String get playlistSortAlphabetical => 'वर्णमाला अनुसार';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'गीतसभ',
      one: 'गीत',
    );
    return 'डाउनलोड भ\' रहल अछि $count $_temp0';
  }

  @override
  String get playlistView => 'देखू';

  @override
  String get playlistAllDownloaded => 'सब गीत पहिनेसँ डाउनलोड अछि';

  @override
  String playlistShareText(String name, String url) {
    return 'Pulse पर \"$name\" देखू!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'डाउनलोड सँ हटाउ';

  @override
  String get playlistRemoveFromPlaylist => 'प्लेलिस्ट सँ हटाउ';

  @override
  String get playlistLoadError => 'ई प्लेलिस्ट लोड नइँ भ\' सकल।';

  @override
  String get playlistGoBack => '← पाछाँ जाउ';

  @override
  String get profileNotLoggedIn => 'लग इन नइँ अछि';

  @override
  String get profileSignIn => 'साइन इन';

  @override
  String get profileDefaultUser => 'Pulse प्रयोगकर्ता';

  @override
  String get profileEditProfile => 'सम्पादन';

  @override
  String get profileTimeframeDay => 'दिन';

  @override
  String get profileTimeframeWeek => 'सप्ताह';

  @override
  String get profileTimeframeMonth => 'महीना';

  @override
  String get profileTimeframeYear => 'वर्ष';

  @override
  String get profileListeningTime => 'सुनबाक समय';

  @override
  String get profileToday => 'आइ';

  @override
  String get profileThisWeek => 'ई सप्ताह';

  @override
  String get profileThisMonth => 'ई महीना';

  @override
  String get profileThisYear => 'ई वर्ष';

  @override
  String get profileDailyAvg => 'दैनिक औसत';

  @override
  String get profilePerDay => 'प्रति दिन';

  @override
  String get profileLifetimeListening => 'आजीवन सुनबाक समय';

  @override
  String get profileTotalTimeListened => 'Pulse पर संगीत सुनल गेल कुल समय';

  @override
  String get profileYourTopSongs => 'अहाँक शीर्ष गीत';

  @override
  String get profileListeningHistoryEmpty => 'सुनबाक इतिहास एतय देखाएत।';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'बेर बजाएल',
      one: 'बेर बजाएल',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => 'अहाँक शीर्ष कलाकार';

  @override
  String get profileTopArtistsEmpty => 'अहाँक पसंदीदा कलाकार एतय देखाएत।';

  @override
  String get profileArtistLabel => 'कलाकार';

  @override
  String get profileSignOut => 'साइन आउट';

  @override
  String profileVersion(String version) {
    return 'संस्करण $version';
  }

  @override
  String get profileMadeWithHeartBy => '❤️ सँ निर्माण: ';

  @override
  String get profileAuthorName => 'आशुतोष पाठक';

  @override
  String get profileEditProfileHeader => 'प्रोफाइल सम्पादन';

  @override
  String get profileDisplayName => 'प्रदर्शन नाम';

  @override
  String get profileCancel => 'रद्द करू';

  @override
  String get profileSave => 'सेव करू';

  @override
  String get profileChooseAvatar => 'अवतार चुनू';

  @override
  String get searchMicPermissionRequired =>
      'एहि फिचरक लेल माइक्रोफोन अनुमति आवश्यक अछि';

  @override
  String get searchUnknownSong => 'अज्ञात गीत';

  @override
  String get searchUnknownArtist => 'अज्ञात कलाकार';

  @override
  String get searchNoSongDetected => 'कोनो गीत नइँ भेटल।';

  @override
  String searchError(String message) {
    return 'त्रुटि: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'स्पिच रिकग्निशन उपलब्ध नइँ अछि';

  @override
  String get searchHint => 'गीत, कलाकार, एल्बम, प्लेलिस्ट...';

  @override
  String get searchRecentEmpty => 'अहाँक हालक खोज एतय देखाएत';

  @override
  String get searchRecentSearches => 'हालक खोज';

  @override
  String get searchClearAll => 'सब हटाउ';

  @override
  String searchNoResultsFor(String query) {
    return '\"$query\" लेल कोनो परिणाम नइँ';
  }

  @override
  String get searchTryDifferentKeywords => 'भिन्न कीवर्डक प्रयास करू';

  @override
  String get searchTopResult => 'शीर्ष परिणाम';

  @override
  String get searchSongsLabel => 'गीतसभ';

  @override
  String get searchArtistsLabel => 'कलाकारसभ';

  @override
  String get searchAlbumsLabel => 'एल्बमसभ';

  @override
  String get searchPlaylistsLabel => 'प्लेलिस्टसभ';

  @override
  String get searchArtistLabel => 'कलाकार';

  @override
  String get searchListening => 'सुनि रहल अछि...';

  @override
  String get searchSpeakNow => 'खोजबाक लेल अखन बाजु';

  @override
  String get searchCancel => 'रद्द करू';

  @override
  String get searchIdentifying => 'पहिचान भ\' रहल अछि...';

  @override
  String get searchListeningForSong => 'गीत सुनि रहल अछि...';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsStreamingQuality => 'स्ट्रिमिङ क्वालिटी';

  @override
  String get settingsQualityAutomatic => 'स्वचालित';

  @override
  String get settingsQualityLow => 'कम';

  @override
  String get settingsQualityNormal => 'सामान्य';

  @override
  String get settingsQualityHigh => 'उच्च';

  @override
  String get settingsDownloadQuality => 'डाउनलोड क्वालिटी';

  @override
  String get settingsPlayback => 'प्लेब्याक';

  @override
  String get settingsCrossfade => 'क्रसफेड';

  @override
  String get settingsCrossfadeDesc =>
      'ग्यापलेस ट्रान्जिसनक लेल ट्रयाकसभ ओभरल्याप करू';

  @override
  String get settingsDataUsage => 'डेटा उपयोग';

  @override
  String get settingsDataSaver => 'डेटा सेभर';

  @override
  String get settingsDataSaverDesc => 'सेल्युलर पर कम क्वालिटीमे स्ट्रिम करू';

  @override
  String get settingsAppearance => 'देखावट';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsCustomAccent => 'कस्टम एक्सेन्ट';

  @override
  String get settingsSaturation => 'स्याचुरेसन';

  @override
  String get settingsBrightness => 'उज्ज्वलपन';

  @override
  String get settingsResetDefault => 'पूर्वनिर्धारितमे रिसेट करू';

  @override
  String get playlistSheetTitle => 'प्लेलिस्टमे जोड़ू';

  @override
  String get playlistSheetNewPlaylist => 'नव प्लेलिस्ट';

  @override
  String get playlistSheetNoPlaylists => 'अखन धरि कोनो प्लेलिस्ट नइँ';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'गीतसभ',
      one: 'गीत',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => 'प्लेलिस्टक नाम';

  @override
  String get playlistSheetCancel => 'रद्द करू';

  @override
  String playlistSheetAddedTo(String name) {
    return '$name मे जोड़ल गेल';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'प्लेलिस्ट बनेबामे विफल: प्रमाणीकरण त्रुटि';

  @override
  String playlistSheetCreateFail(String error) {
    return 'प्लेलिस्ट बनेबामे विफल: $error';
  }

  @override
  String get playlistSheetCreate => 'बनाउ';

  @override
  String get appUpdateAvailable => 'अपडेट उपलब्ध अछि';

  @override
  String appUpdateDesc(String version) {
    return 'संस्करण $version एतय अछि! नव फिचर्स पाब\'क लेल अखन अपडेट करू।';
  }

  @override
  String get appUpdateDownload => 'अपडेट डाउनलोड करू';

  @override
  String get navHome => 'होम';

  @override
  String get navLibrary => 'लाइब्रेरी';

  @override
  String get navSearch => 'खोजू';

  @override
  String get navSettings => 'सेटिंग्स';

  @override
  String get navProfile => 'प्रोफाइल';

  @override
  String get artistSelect => 'कलाकार चुनू';

  @override
  String get songActionQueue => 'कतारमे जोड़ू';

  @override
  String get songActionPlaylist => 'प्लेलिस्टमे जोड़ू';

  @override
  String get songActionFinding => 'खोजि रहल अछि...';

  @override
  String get songActionAlbum => 'एल्बम पर जाउ';

  @override
  String get songActionArtist => 'कलाकार पर जाउ';

  @override
  String get songActionRemovePlaylist => 'प्लेलिस्ट सँ हटाउ';

  @override
  String get songActionRemoveDownload => 'डाउनलोड सँ हटाउ';

  @override
  String get songActionDownloadChecking => 'जाँच भ\' रहल अछि...';

  @override
  String get songActionDownloading => 'डाउनलोड भ\' रहल अछि...';

  @override
  String get songActionDownloaded => 'डाउनलोड भ\' गेल!';

  @override
  String get songActionDownloadAlready => 'पहिनेसँ डाउनलोड अछि';

  @override
  String get songActionDownloadFailed => 'डाउनलोड विफल';

  @override
  String get songActionDownload => 'डाउनलोड';

  @override
  String get songActionDownloadingSnack => 'डाउनलोड भ\' रहल अछि';

  @override
  String get songActionView => 'देखू';

  @override
  String get spotifyImportTitle => 'Spotify सँ इम्पोट करू';

  @override
  String get spotifyImportSubtitle => 'अपन प्लेलिस्टक आकार चुनू';

  @override
  String get spotifyChoiceSmallTitle => '१०० गीत या ओहि सँ कम';

  @override
  String get spotifyChoiceSmallDesc =>
      'सार्वजनिक Spotify प्लेलिस्ट URL पेस्ट करू।';

  @override
  String get spotifyChoiceLargeTitle => '१०० सँ बेसी गीत';

  @override
  String get spotifyChoiceLargeDesc =>
      'असीमित ट्रयाकसभ इम्पोट करबाक लेल अपन Spotify डेवलपर एप जोड़ू।';

  @override
  String get cancelButton => 'रद्द करू';

  @override
  String get spotifyPlaylistsTitle => 'अहाँक Spotify प्लेलिस्टसभ';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'त्रुटि: $error\nसुनिश्चित करू जे अहाँक Client ID मान्य अछि।';
  }

  @override
  String get spotifyPlaylistsEmpty =>
      'अहाँक लाइब्रेरीमे कोनो प्लेलिस्ट नइँ भेटल';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count ट्रयाक';
  }

  @override
  String get spotifyPlaylistsImport => 'इम्पोट';

  @override
  String get audioPlaybackFailed =>
      'प्लेब्याक विफल। अपन इन्टरनेट कनेक्सन जाँच करू।';

  @override
  String get audioControlPrevious => 'पछिला';

  @override
  String get audioControlPause => 'रोकु';

  @override
  String get audioControlPlay => 'बजाउ';

  @override
  String get audioControlNext => 'अगला';

  @override
  String get audioControlUnlike => 'पसंदीदा सँ हटाउ';

  @override
  String get audioControlLike => 'पसंदीदा';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'मूल प्रतिक्रिया: $data\n\nत्रुटि: $error';
  }

  @override
  String get apiErrorInvalidClient => 'अमान्य Client या Client Secret।';

  @override
  String get apiErrorBadRequest => 'गलत अनुरोध। कृपया अपन इनपुट जाँच करू।';

  @override
  String get apiErrorUnauthorized => 'अनधिकृत। कृपया फेरसँ लग-इन करू।';

  @override
  String get apiErrorForbidden => 'निषिद्ध। अहाँकेँ पहुँच नइँ अछि।';

  @override
  String get apiErrorNotFound => 'संसाधन नइँ भेटल।';

  @override
  String get apiErrorEmailInUse => 'ई इमेल ठेगाना पहिनेसँ प्रयोगमे अछि।';

  @override
  String get apiErrorUserNotFound => 'एहि इमेलक लेल कोनो खाता नइँ भेटल।';

  @override
  String get apiErrorWrongPassword => 'गलत पासवर्ड।';

  @override
  String get apiErrorInvalidCredential =>
      'लग-इन विफल। कृपया अपन विवरण जाँच करू।';

  @override
  String get apiErrorNetwork => 'नेटवर्क त्रुटि। कृपया अपन कनेक्सन जाँच करू।';

  @override
  String get apiErrorSocketTimeout =>
      'कनेक्सन टाइमआउट भ\' गेल। कृपया पुनः प्रयास करू।';

  @override
  String get apiErrorTooManyRequests =>
      'बहुत बेसी अनुरोध। कृपया कनी काल प्रतीक्षा करू आ पुनः प्रयास करू।';

  @override
  String get apiErrorServerError =>
      'सर्भर त्रुटि। कृपया बादमे पुनः प्रयास करू।';

  @override
  String get apiErrorInvalidEmail => 'कृपया मान्य इमेल ठेगाना दर्ज करू।';

  @override
  String get apiErrorWeakPassword =>
      'पासवर्ड बहुत कमजोर अछि। कम सँ कम ६ क्यारेक्टरक उपयोग करू।';

  @override
  String get apiErrorTooManyAttempts =>
      'बहुत बेसी विफल प्रयास। कृपया बादमे पुनः प्रयास करू।';

  @override
  String get homeForgottenFavorites => 'बिसराएल पसंदीदा';

  @override
  String get artistShowAll => 'सब देखू';

  @override
  String get homeTopTracks => 'टॉप ट्रैक';
}
