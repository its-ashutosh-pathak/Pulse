// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'विषयी';

  @override
  String get artistPopular => 'लोकप्रिय';

  @override
  String get artistAlbums => 'अल्बम';

  @override
  String get artistSinglesAndEPs => 'सिंगल्स आणि EPs';

  @override
  String artistSubscribersCount(String count) {
    return '$count सदस्य';
  }

  @override
  String get artistPlayAll => 'सर्व प्ले करा';

  @override
  String get artistLoadError => 'कलाकार लोड करू शकलो नाही';

  @override
  String get artistGoBack => 'मागे जा';

  @override
  String adminChatFailedToReply(String error) {
    return 'उत्तर देण्यास अयशस्वी: $error';
  }

  @override
  String get adminChatSupportChat => 'सपोर्ट चॅट';

  @override
  String adminChatError(String error) {
    return 'त्रुटी: $error';
  }

  @override
  String get adminChatNoHistory => 'कोणताही संभाषण इतिहास नाही.';

  @override
  String get adminChatSupportYou => 'सपोर्ट (तुम्ही)';

  @override
  String get adminChatTypeReply => 'तुमचे उत्तर टाइप करा...';

  @override
  String get broadcastSuccess => 'घोषणा यशस्वीरित्या प्रसारित झाली!';

  @override
  String broadcastFailed(String error) {
    return 'प्रसारित करण्यात अयशस्वी: $error';
  }

  @override
  String get broadcastTitle => 'जागतिक घोषणा';

  @override
  String get broadcastSubtitle => 'सर्वांना पाठवले';

  @override
  String get broadcastWarning => 'येथे पाठवलेले संदेश सर्वांना दिसतील.';

  @override
  String broadcastError(String error) {
    return 'त्रुटी: $error';
  }

  @override
  String get broadcastNoHistory => 'कोणत्याही मागील घोषणा नाहीत.';

  @override
  String get broadcastTypeMessage => 'जागतिक घोषणा टाइप करा...';

  @override
  String commFailedToSend(String error) {
    return 'पाठवण्यास अयशस्वी: $error';
  }

  @override
  String get commAdminDashboard => 'प्रशासक डॅशबोर्ड';

  @override
  String get commAdminSupport => 'प्रशासक सपोर्ट';

  @override
  String get commAlwaysHere => 'मदतीसाठी नेहमी येथे';

  @override
  String get commWelcomeTitle => 'नमस्कार! 👋 मी आशुतोष पाठक आहे';

  @override
  String get commWelcomeSubtitle => 'Pulse चा डेव्हलपर';

  @override
  String get commWelcomeBody1 =>
      'मला आशा आहे की तुम्ही कोणत्याही जाहिराती किंवा सदस्यता शुल्काविना तुमचे आवडते संगीत ऐकण्याचा आनंद घेत आहात.\n\nहा विभाग यासाठी आहे जेणेकरून आपण थेट संपर्क साधू शकू.\n\nतुम्ही मोकळेपणाने:';

  @override
  String get commBullet1 => 'तुमचा अभिप्राय शेअर करा';

  @override
  String get commBullet2 => 'बग्सचा अहवाल द्या';

  @override
  String get commBullet3 => 'नवीन वैशिष्ट्ये सुचवा';

  @override
  String get commWelcomeBody2 =>
      'मी स्वतः प्रत्येक संदेश वाचतो आणि तुमच्या सूचनांनुसार अ‍ॅप सुधारण्याचा प्रयत्न करेन.\n\nPulse वापरल्याबद्दल आणि या प्रवासात सहभागी झाल्याबद्दल धन्यवाद. ❤️';

  @override
  String commError(String error) {
    return 'त्रुटी: $error';
  }

  @override
  String get commNoMessages => 'अद्याप कोणतेही संदेश नाहीत';

  @override
  String get commNoMessagesDesc =>
      'सपोर्ट टीमला संदेश पाठवा किंवा घोषणेसाठी नंतर तपासा.';

  @override
  String get commMessageSupportHint => 'सपोर्टला संदेश पाठवा...';

  @override
  String get commGlobalAnnouncements => 'जागतिक घोषणा';

  @override
  String get commSendMessagesToAll => 'सर्वांना संदेश पाठवा';

  @override
  String get homeGreetingMorning => 'शुभ सकाळ,';

  @override
  String get homeGreetingAfternoon => 'शुभ दुपार,';

  @override
  String get homeGreetingEvening => 'शुभ संध्याकाळ,';

  @override
  String get homeMember => 'सदस्य';

  @override
  String get homeRecentPlaylists => 'अलीकडील प्लेलिस्ट';

  @override
  String get homeRecentlyPlayed => 'अलीकडे ऐकलेले';

  @override
  String get homeSpeedDial => 'जलद संपर्क';

  @override
  String get homeNoContent => 'कोणतीही सामग्री उपलब्ध नाही';

  @override
  String get homeRefresh => 'रिफ्रेश';

  @override
  String get homeLoadError => 'संगीत लोड करू शकलो नाही.';

  @override
  String get homeRetry => 'पुन्हा प्रयत्न करा';

  @override
  String get importSuccess => 'Spotify शी यशस्वीरित्या जोडले!';

  @override
  String importFailed(String error) {
    return 'जोडण्यात अयशस्वी: $error';
  }

  @override
  String get importTitle => 'Spotify कनेक्ट करा';

  @override
  String get importSetupTitle => 'Spotify सेट करा';

  @override
  String get importSetupDesc =>
      'तुमची स्वतःची मोफत डेव्हलपर की वापरून तुमच्या सर्व प्लेलिस्ट त्वरित इंपोर्ट करण्यासाठी या सोप्या पायऱ्या फॉलो करा:';

  @override
  String get importStep1 => 'Spotify डेव्हलपर डॅशबोर्ड उघडा.';

  @override
  String get importStep2 => 'लॉगिन करा आणि \'Create app\' वर क्लिक करा.';

  @override
  String get importStep3 => 'अ‍ॅपचे नाव आणि वर्णन भरा.';

  @override
  String get importStep4 => '\'Redirect URIs\' अंतर्गत खालील URL पेस्ट करा:';

  @override
  String get importRedirectCopied => 'Redirect URI कॉपी केले!';

  @override
  String get importStep5 =>
      'सेव्ह करा, तुमचा \'Client ID\' कॉपी करा आणि खाली पेस्ट करा.';

  @override
  String get importImportant =>
      'महत्त्वाचे: या डेव्हलपर अ‍ॅपसाठी तुमच्याकडे प्रीमियम सदस्यता असणे आवश्यक आहे.';

  @override
  String get importClientIdHint => 'तुमचा Spotify Client ID येथे पेस्ट करा...';

  @override
  String get importConnectButton => 'कनेक्ट करा आणि लायब्ररी मिळवा';

  @override
  String get downloadingNoActive => 'कोणतेही सक्रिय डाउनलोड नाही';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'डाउनलोड्स';

  @override
  String downloadsStats(String count, String size) {
    return '$count गाणी • $size';
  }

  @override
  String get downloadsNoOffline => 'अद्याप कोणतीही ऑफलाइन गाणी नाहीत';

  @override
  String get downloadsNoOfflineDesc => 'तुम्ही डाउनलोड केलेली गाणी येथे दिसतील';

  @override
  String get downloadsClearAllTitle => 'सर्व डाउनलोड्स हटवायचे?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'हे $count गाणी हटवेल आणि $size स्टोरेज मोकळे करेल.';
  }

  @override
  String get downloadsCancel => 'रद्द करा';

  @override
  String get downloadsClearAll => 'सर्व हटवा';

  @override
  String downloadsSongsCount(String count) {
    return '$count गाणी';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count गाणे';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'मुख्य डाउनलोड प्लेलिस्टचे नाव बदलू शकत नाही.';

  @override
  String get downloadsRename => 'नाव बदला';

  @override
  String get downloadsEditSongs => 'गाणी संपादित करा';

  @override
  String get downloadsDelete => 'हटवा';

  @override
  String get downloadsRenamePlaylistTitle => 'प्लेलिस्टचे नाव बदला';

  @override
  String get downloadsRenamePlaylistDesc =>
      'तुमच्या प्लेलिस्टसाठी नवीन नाव एंटर करा.';

  @override
  String get downloadsDeletePlaylistTitle => 'प्लेलिस्ट हटवायची?';

  @override
  String get downloadsDeleteMasterDesc =>
      'तुम्हाला खात्री आहे का की तुम्हाला हे हटवायचे आहे? तुमची सर्व डाउनलोड केलेली गाणी आणि प्लेलिस्ट कायमची नष्ट होतील.';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'तुम्हाला खात्री आहे का की तुम्हाला \'$name\' हटवायचे आहे? ही प्लेलिस्ट कायमची नष्ट होईल.';
  }

  @override
  String get downloadsSave => 'सेव्ह करा';

  @override
  String get downloadsNoSongs => 'या प्लेलिस्टमध्ये कोणतीही गाणी नाहीत.';

  @override
  String get libraryTitle => 'लायब्ररी';

  @override
  String get libraryPauseAll => 'सर्व थांबवा';

  @override
  String get libraryResumeAll => 'सर्व सुरू करा';

  @override
  String get libraryTabPlaylists => 'प्लेलिस्ट';

  @override
  String get libraryTabDownloads => 'डाउनलोड्स';

  @override
  String get libraryTabDownloading => 'डाउनलोड होत आहे';

  @override
  String libraryImportedTask(String name) {
    return '$name इंपोर्ट केले';
  }

  @override
  String get libraryImportWaiting => 'प्रतीक्षा करत आहे...';

  @override
  String get libraryImportFetching => 'प्लेलिस्ट मिळवत आहे...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total प्रोसेस केले · $matched जुळले';
  }

  @override
  String get libraryImportSaving => 'लायब्ररीमध्ये सेव्ह करत आहे...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched गाणी जोडली';
  }

  @override
  String get libraryImportDoneAll => 'सर्व गाणी जोडली';

  @override
  String get libraryAddButton => 'जोडा';

  @override
  String get librarySortRecent => 'अलीकडे जोडलेले';

  @override
  String get librarySortAlpha => 'अक्षरांनुसार';

  @override
  String get libraryEmptyTitle => 'तुमची लायब्ररी रिकामी आहे.';

  @override
  String get libraryEmptyDesc => 'सुरू करण्यासाठी \'जोडा\' वर टॅप करा.';

  @override
  String get libraryRenameLikedError =>
      'आवडलेली गाणी प्लेलिस्टचे नाव बदलू शकत नाही.';

  @override
  String get libraryRename => 'नाव बदला';

  @override
  String get libraryEditSongs => 'गाणी संपादित करा';

  @override
  String get libraryDeleteLikedError => 'आवडलेली गाणी प्लेलिस्ट हटवू शकत नाही.';

  @override
  String get libraryDelete => 'हटवा';

  @override
  String get libraryEditSongsTitle => 'गाणी संपादित करा';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count गाणे';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count गाणी';
  }

  @override
  String get libraryCancel => 'रद्द करा';

  @override
  String get librarySave => 'सेव्ह करा';

  @override
  String get libraryNoSongs => 'या प्लेलिस्टमध्ये कोणतीही गाणी नाहीत.';

  @override
  String get libraryAddOptionsTitle => 'लायब्ररीमध्ये जोडा';

  @override
  String get libraryAddOptionsDesc => 'तुमचे Pulse कसे वाढवायचे ते निवडा';

  @override
  String get libraryImportPulse => 'Pulse वरून इंपोर्ट करा';

  @override
  String get libraryImportPulseDesc => 'Pulse प्लेलिस्ट URL पेस्ट करा';

  @override
  String get libraryImportYtm => 'YT Music वरून इंपोर्ट करा';

  @override
  String get libraryImportYtmDesc => 'सार्वजनिक प्लेलिस्ट URL पेस्ट करा';

  @override
  String get libraryImportSpotify => 'Spotify वरून इंपोर्ट करा';

  @override
  String get libraryImportSpotifyDesc => 'तुमचे Spotify कनेक्ट करा';

  @override
  String get libraryClose => 'बंद करा';

  @override
  String get libraryImportYtmFull => 'YouTube Music वरून इंपोर्ट करा';

  @override
  String get libraryImportSpotifyFull => 'Spotify वरून इंपोर्ट करा (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'सार्वजनिक YouTube Music प्लेलिस्ट URL येथे पेस्ट करा';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'सार्वजनिक Spotify प्लेलिस्ट URL येथे पेस्ट करा';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Pulse प्लेलिस्ट इंपोर्ट करण्यात अयशस्वी';

  @override
  String get importErrorPlaylist => 'प्लेलिस्ट इंपोर्ट करण्यात त्रुटी';

  @override
  String get importErrorHighlyPopulated =>
      'प्लेलिस्ट खूप मोठी आहे, वेळ लागू शकतो.';

  @override
  String get libraryImportBtn => 'इंपोर्ट करा';

  @override
  String get libraryCreateTitle => 'नवीन प्लेलिस्ट';

  @override
  String get libraryCreateDesc => 'या प्लेलिस्टला काय नाव द्यायचे?';

  @override
  String get libraryCreateHint => 'उदा. रात्रीचा प्रवास';

  @override
  String get libraryCreateBtn => 'तयार करा';

  @override
  String get libraryRenameTitle => 'प्लेलिस्टचे नाव बदला';

  @override
  String get libraryRenameDesc => 'तुमच्या प्लेलिस्टसाठी नवीन नाव एंटर करा.';

  @override
  String get libraryRenameBtn => 'नाव बदला';

  @override
  String get libraryDeleteTitle => 'प्लेलिस्ट हटवायची?';

  @override
  String libraryDeleteDesc(String name) {
    return 'तुम्हाला खात्री आहे का की तुम्हाला \'$name\' हटवायचे आहे? ही प्लेलिस्ट कायमची नष्ट होईल.';
  }

  @override
  String get libraryDeleteBtn => 'हटवा';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'अलीकडील';

  @override
  String librarySongsCount(String count) {
    return '$count गाणी';
  }

  @override
  String get libraryComingSoon => 'लवकरच येत आहे';

  @override
  String get loginErrName => 'कृपया तुमचे नाव एंटर करा';

  @override
  String get loginErrEmail => 'कृपया तुमचा ईमेल एंटर करा';

  @override
  String get loginErrPassword => 'कृपया तुमचा पासवर्ड एंटर करा';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'प्रत्येक बीट अनुभवा!';

  @override
  String get loginMadeWithHeartBy => '❤️ ने बनवले: ';

  @override
  String get loginAuthorName => 'आशुतोष पाठक';

  @override
  String get loginHintName => 'तुमचे नाव';

  @override
  String get loginHintEmail => 'ईमेल पत्ता';

  @override
  String get loginHintPassword => 'पासवर्ड';

  @override
  String get loginErrEmailReset => 'पासवर्ड रिसेट करण्यासाठी ईमेल एंटर करा';

  @override
  String get loginResetSent =>
      'पासवर्ड रिसेट ईमेल पाठवला! तुमचा इनबॉक्स तपासा.';

  @override
  String get loginForgotPwd => 'पासवर्ड विसरलात?';

  @override
  String get loginBtnSignup => 'अकाउंट तयार करा';

  @override
  String get loginBtnSignin => 'साइन इन करा';

  @override
  String get loginToggleHaveAccount => 'Pulse अकाउंट आधीच आहे? ';

  @override
  String get loginToggleNoAccount => 'Pulse अकाउंट नाही? ';

  @override
  String get loginToggleSignin => 'साइन इन करा';

  @override
  String get loginToggleSignup => 'साइन अप करा';

  @override
  String get offlineStillOffline => 'अजूनही ऑफलाइन. कृपया तुमचे कनेक्शन तपासा.';

  @override
  String get offlineTitle => 'तुम्ही ऑफलाइन आहात';

  @override
  String get offlineSubtitle =>
      'कोणतेही इंटरनेट कनेक्शन सापडले नाही.\nतुमचे नेटवर्क तपासा आणि पुन्हा प्रयत्न करा.';

  @override
  String get offlineChecking => 'तपासत आहे...';

  @override
  String get offlineRetry => 'पुन्हा प्रयत्न करा';

  @override
  String get offlineGoToDownloads => 'डाउनलोड्स वर जा';

  @override
  String get playerMadeWithHeartBy => '❤️ ने बनवले: ';

  @override
  String get playerAuthorName => 'आशुतोष पाठक';

  @override
  String get playerSwipeForLyrics => 'गीतांसाठी स्वाइप करा';

  @override
  String get playerNoLyrics => 'गीत उपलब्ध नाहीत';

  @override
  String get playerUpNext => 'पुढे प्ले होईल';

  @override
  String get playerNoTracksInQueue => 'रांगेत कोणतीही गाणी नाहीत';

  @override
  String get playerNoMusicPlaying => 'कोणतेही संगीत प्ले होत नाही';

  @override
  String get playerPickAVibe => 'तुमच्या लायब्ररीतून किंवा होमवरून गाणे निवडा';

  @override
  String get playerGoHome => 'होम वर जा';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'इक्वलायझर';

  @override
  String get playerEqCustom => 'कस्टम';

  @override
  String get playlistDownloads => 'डाउनलोड्स';

  @override
  String get playlistOffline => 'ऑफलाइन प्लेलिस्ट';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hoursतास $minsमिनिटे';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$minsमिनिटे';
  }

  @override
  String get playlistFindOnPage => 'या पेजवर शोधा';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count गाणी • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'अलीकडील';

  @override
  String get playlistNoMatches => 'कोणतेही परिणाम सापडले नाहीत.';

  @override
  String get playlistNoTracks => 'या प्लेलिस्टमध्ये कोणतीही गाणी नाहीत.';

  @override
  String get playlistNoSongsYet => 'अद्याप कोणतीही गाणी नाहीत.';

  @override
  String get playlistSortRecentlyAdded => 'अलीकडे जोडलेले';

  @override
  String get playlistSortAlphabetical => 'अक्षरांनुसार';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'गाणी',
      one: 'गाणे',
    );
    return '$count $_temp0 डाउनलोड होत आहे';
  }

  @override
  String get playlistView => 'पहा';

  @override
  String get playlistAllDownloaded => 'सर्व गाणी आधीच डाउनलोड केली आहेत';

  @override
  String playlistShareText(String name, String url) {
    return 'Pulse वर \'$name\' पहा!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'डाउनलोड्स मधून हटवा';

  @override
  String get playlistRemoveFromPlaylist => 'प्लेलिस्टमधून हटवा';

  @override
  String get playlistLoadError => 'ही प्लेलिस्ट लोड करू शकलो नाही.';

  @override
  String get playlistGoBack => '← मागे जा';

  @override
  String get profileNotLoggedIn => 'लॉग इन केलेले नाही';

  @override
  String get profileSignIn => 'साइन इन करा';

  @override
  String get profileDefaultUser => 'Pulse युझर';

  @override
  String get profileEditProfile => 'संपादित करा';

  @override
  String get profileTimeframeDay => 'दिवस';

  @override
  String get profileTimeframeWeek => 'आठवडा';

  @override
  String get profileTimeframeMonth => 'महिना';

  @override
  String get profileTimeframeYear => 'वर्ष';

  @override
  String get profileListeningTime => 'ऐकण्याची वेळ';

  @override
  String get profileToday => 'आज';

  @override
  String get profileThisWeek => 'या आठवड्यात';

  @override
  String get profileThisMonth => 'या महिन्यात';

  @override
  String get profileThisYear => 'या वर्षी';

  @override
  String get profileDailyAvg => 'दैनिक सरासरी';

  @override
  String get profilePerDay => 'प्रति दिन';

  @override
  String get profileLifetimeListening => 'आजीवन ऐकणे';

  @override
  String get profileTotalTimeListened => 'Pulse वर संगीत ऐकण्याची एकूण वेळ';

  @override
  String get profileYourTopSongs => 'तुमची आवडती गाणी';

  @override
  String get profileListeningHistoryEmpty => 'ऐकण्याचा इतिहास येथे दिसेल.';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'वेळा',
      one: 'वेळा',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => 'तुमचे आवडते कलाकार';

  @override
  String get profileTopArtistsEmpty => 'तुमचे आवडते कलाकार येथे दिसतील.';

  @override
  String get profileArtistLabel => 'कलाकार';

  @override
  String get profileSignOut => 'साइन आउट करा';

  @override
  String profileVersion(String version) {
    return 'आवृत्ती $version';
  }

  @override
  String get profileMadeWithHeartBy => '❤️ ने बनवले: ';

  @override
  String get profileAuthorName => 'आशुतोष पाठक';

  @override
  String get profileEditProfileHeader => 'संपादित करा';

  @override
  String get profileDisplayName => 'नाव';

  @override
  String get profileCancel => 'रद्द करा';

  @override
  String get profileSave => 'सेव्ह करा';

  @override
  String get profileChooseAvatar => 'अवतार निवडा';

  @override
  String get searchMicPermissionRequired =>
      'या वैशिष्ट्यासाठी मायक्रोफोन परवानगी आवश्यक आहे';

  @override
  String get searchUnknownSong => 'अज्ञात गाणे';

  @override
  String get searchUnknownArtist => 'अज्ञात कलाकार';

  @override
  String get searchNoSongDetected => 'कोणतेही गाणे ओळखता आले नाही.';

  @override
  String searchError(String message) {
    return 'त्रुटी: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'स्पीच रेकग्निशन उपलब्ध नाही';

  @override
  String get searchHint => 'गाणी, कलाकार, अल्बम, प्लेलिस्ट…';

  @override
  String get searchRecentEmpty => 'तुमचे अलीकडील शोध येथे दिसतील';

  @override
  String get searchRecentSearches => 'अलीकडील शोध';

  @override
  String get searchClearAll => 'सर्व साफ करा';

  @override
  String searchNoResultsFor(String query) {
    return '\'$query\' साठी कोणतेही परिणाम नाहीत';
  }

  @override
  String get searchTryDifferentKeywords => 'वेगळे शब्द वापरून पहा';

  @override
  String get searchTopResult => 'वरचा निकाल';

  @override
  String get searchSongsLabel => 'गाणी';

  @override
  String get searchArtistsLabel => 'कलाकार';

  @override
  String get searchAlbumsLabel => 'अल्बम';

  @override
  String get searchPlaylistsLabel => 'प्लेलिस्ट';

  @override
  String get searchArtistLabel => 'कलाकार';

  @override
  String get searchListening => 'ऐकत आहे...';

  @override
  String get searchSpeakNow => 'शोधण्यासाठी आता बोला';

  @override
  String get searchCancel => 'रद्द करा';

  @override
  String get searchIdentifying => 'ओळखत आहे...';

  @override
  String get searchListeningForSong => 'गाणे ऐकत आहे...';

  @override
  String get settingsTitle => 'सेटिंग्ज';

  @override
  String get settingsStreamingQuality => 'स्ट्रीमिंग क्वालिटी';

  @override
  String get settingsQualityAutomatic => 'स्वयंचलित';

  @override
  String get settingsQualityLow => 'कमी';

  @override
  String get settingsQualityNormal => 'सामान्य';

  @override
  String get settingsQualityHigh => 'उच्च';

  @override
  String get settingsDownloadQuality => 'डाउनलोड क्वालिटी';

  @override
  String get settingsPlayback => 'प्लेबॅक';

  @override
  String get settingsCrossfade => 'क्रॉसफेड';

  @override
  String get settingsCrossfadeDesc =>
      'गॅपलेस ट्रान्झिशनसाठी ट्रॅक्स ओव्हरलॅप करा';

  @override
  String get settingsDataUsage => 'डेटा वापर';

  @override
  String get settingsDataSaver => 'डेटा सेव्हर';

  @override
  String get settingsDataSaverDesc => 'मोबाइल डेटावर कमी गुणवत्तेत स्ट्रीम करा';

  @override
  String get settingsAppearance => 'देखावा';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsCustomAccent => 'कस्टम रंग';

  @override
  String get settingsSaturation => 'सॅचुरेशन';

  @override
  String get settingsBrightness => 'ब्राइटनेस';

  @override
  String get settingsResetDefault => 'डीफॉल्ट रिसेट करा';

  @override
  String get playlistSheetTitle => 'प्लेलिस्टमध्ये जोडा';

  @override
  String get playlistSheetNewPlaylist => 'नवीन प्लेलिस्ट';

  @override
  String get playlistSheetNoPlaylists => 'अद्याप कोणतीही प्लेलिस्ट नाही';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'गाणी',
      one: 'गाणे',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => 'प्लेलिस्टचे नाव';

  @override
  String get playlistSheetCancel => 'रद्द करा';

  @override
  String playlistSheetAddedTo(String name) {
    return '$name मध्ये जोडले';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'प्लेलिस्ट तयार करण्यात अयशस्वी: प्रमाणीकरण त्रुटी';

  @override
  String playlistSheetCreateFail(String error) {
    return 'प्लेलिस्ट तयार करण्यात अयशस्वी: $error';
  }

  @override
  String get playlistSheetCreate => 'तयार करा';

  @override
  String get appUpdateAvailable => 'अपडेट उपलब्ध';

  @override
  String appUpdateDesc(String version) {
    return 'आवृत्ती $version उपलब्ध आहे! नवीन वैशिष्ट्ये मिळवण्यासाठी आत्ता अपडेट करा.';
  }

  @override
  String get appUpdateDownload => 'अपडेट डाउनलोड करा';

  @override
  String get navHome => 'होम';

  @override
  String get navLibrary => 'लायब्ररी';

  @override
  String get navSearch => 'शोधा';

  @override
  String get navSettings => 'सेटिंग्ज';

  @override
  String get navProfile => 'प्रोफाइल';

  @override
  String get artistSelect => 'कलाकार निवडा';

  @override
  String get songActionQueue => 'रांगेत जोडा';

  @override
  String get songActionPlaylist => 'प्लेलिस्टमध्ये जोडा';

  @override
  String get songActionFinding => 'शोधत आहे...';

  @override
  String get songActionAlbum => 'अल्बमवर जा';

  @override
  String get songActionArtist => 'कलाकारावर जा';

  @override
  String get songActionRemovePlaylist => 'प्लेलिस्टमधून हटवा';

  @override
  String get songActionRemoveDownload => 'डाउनलोड्स मधून हटवा';

  @override
  String get songActionDownloadChecking => 'तपासत आहे...';

  @override
  String get songActionDownloading => 'डाउनलोड होत आहे...';

  @override
  String get songActionDownloaded => 'डाउनलोड झाले!';

  @override
  String get songActionDownloadAlready => 'आधीच डाउनलोड केले आहे';

  @override
  String get songActionDownloadFailed => 'डाउनलोड अयशस्वी';

  @override
  String get songActionDownload => 'डाउनलोड करा';

  @override
  String get songActionDownloadingSnack => 'डाउनलोड करत आहे';

  @override
  String get songActionView => 'पहा';

  @override
  String get spotifyImportTitle => 'Spotify वरून इंपोर्ट करा';

  @override
  String get spotifyImportSubtitle => 'तुमच्या प्लेलिस्टचा आकार निवडा';

  @override
  String get spotifyChoiceSmallTitle => '१०० किंवा कमी गाणी';

  @override
  String get spotifyChoiceSmallDesc =>
      'सार्वजनिक Spotify प्लेलिस्ट URL पेस्ट करा.';

  @override
  String get spotifyChoiceLargeTitle => '१०० पेक्षा जास्त गाणी';

  @override
  String get spotifyChoiceLargeDesc =>
      'अमर्यादित गाणी इंपोर्ट करण्यासाठी तुमचे स्वतःचे Spotify Developer App कनेक्ट करा.';

  @override
  String get cancelButton => 'रद्द करा';

  @override
  String get spotifyPlaylistsTitle => 'तुमच्या Spotify प्लेलिस्ट';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'त्रुटी: $error\nतुमचा Client ID योग्य असल्याची खात्री करा.';
  }

  @override
  String get spotifyPlaylistsEmpty =>
      'तुमच्या लायब्ररीमध्ये कोणतीही प्लेलिस्ट आढळली नाही';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count ट्रॅक्स';
  }

  @override
  String get spotifyPlaylistsImport => 'इंपोर्ट करा';

  @override
  String get audioPlaybackFailed =>
      'प्लेबॅक अयशस्वी. तुमचे इंटरनेट कनेक्शन तपासा.';

  @override
  String get audioControlPrevious => 'मागील';

  @override
  String get audioControlPause => 'थांबवा';

  @override
  String get audioControlPlay => 'प्ले करा';

  @override
  String get audioControlNext => 'पुढील';

  @override
  String get audioControlUnlike => 'नापसंत';

  @override
  String get audioControlLike => 'पसंत';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'मूळ उत्तर: $data\n\nफॉलबॅक: $error';
  }

  @override
  String get apiErrorInvalidClient => 'अवैध क्लायंट किंवा क्लायंट सिक्रेट.';

  @override
  String get apiErrorBadRequest => 'बॅड रिक्वेस्ट. कृपया तुमचे तपशील तपासा.';

  @override
  String get apiErrorUnauthorized => 'अनधिकृत. कृपया पुन्हा लॉग इन करा.';

  @override
  String get apiErrorForbidden => 'प्रतिबंधित. तुम्हाला प्रवेश नाही.';

  @override
  String get apiErrorNotFound => 'संसाधन सापडले नाही.';

  @override
  String get apiErrorEmailInUse => 'हा ईमेल पत्ता आधीच वापरात आहे.';

  @override
  String get apiErrorUserNotFound => 'या ईमेलसह कोणतेही अकाउंट सापडले नाही.';

  @override
  String get apiErrorWrongPassword => 'चुकीचा पासवर्ड.';

  @override
  String get apiErrorInvalidCredential =>
      'लॉगिन अयशस्वी. कृपया तुमचे क्रेडेंशियल्स तपासा.';

  @override
  String get apiErrorNetwork => 'नेटवर्क त्रुटी. कृपया तुमचे कनेक्शन तपासा.';

  @override
  String get apiErrorSocketTimeout =>
      'कनेक्शन कालबाह्य झाले. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get apiErrorTooManyRequests =>
      'खूप जास्त विनंत्या. कृपया थोडा वेळ थांबा आणि पुन्हा प्रयत्न करा.';

  @override
  String get apiErrorServerError =>
      'सर्व्हर त्रुटी. कृपया नंतर पुन्हा प्रयत्न करा.';

  @override
  String get apiErrorInvalidEmail => 'कृपया योग्य ईमेल पत्ता एंटर करा.';

  @override
  String get apiErrorWeakPassword =>
      'पासवर्ड खूप कमकुवत आहे. किमान ६ अक्षरे वापरा.';

  @override
  String get apiErrorTooManyAttempts =>
      'खूप जास्त अयशस्वी प्रयत्न. कृपया नंतर पुन्हा प्रयत्न करा.';

  @override
  String get homeForgottenFavorites => 'विसरलेले आवडते';

  @override
  String get artistShowAll => 'सर्व दाखवा';

  @override
  String get homeTopTracks => 'शीर्ष ट्रॅक';
}
