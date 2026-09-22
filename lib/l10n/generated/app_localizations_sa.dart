// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sanskrit (`sa`).
class AppLocalizationsSa extends AppLocalizations {
  AppLocalizationsSa([String locale = 'sa']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'विषये';

  @override
  String get artistPopular => 'प्रसिद्धम्';

  @override
  String get artistAlbums => 'सङ्ग्रहाः';

  @override
  String get artistSinglesAndEPs => 'एकलगीतानि';

  @override
  String artistSubscribersCount(String count) {
    return '$count ग्राहकाः';
  }

  @override
  String get artistPlayAll => 'सर्वं वादयतु';

  @override
  String get artistLoadError => 'कलाकारं प्राप्तुं न शक्तम्';

  @override
  String get artistGoBack => 'प्रतिगच्छतु';

  @override
  String adminChatFailedToReply(String error) {
    return 'उत्तरं दातुं विफलम्: $error';
  }

  @override
  String get adminChatSupportChat => 'सहायता-संवादः';

  @override
  String adminChatError(String error) {
    return 'दोषः: $error';
  }

  @override
  String get adminChatNoHistory => 'पूर्वं कोऽपि संवादः नास्ति।';

  @override
  String get adminChatSupportYou => 'सहायता (भवान्)';

  @override
  String get adminChatTypeReply => 'उत्तरं लिखतु...';

  @override
  String get broadcastSuccess => 'उद्घोषणा सफलतापूर्वं प्रेषिता!';

  @override
  String broadcastFailed(String error) {
    return 'प्रेषणं विफलम्: $error';
  }

  @override
  String get broadcastTitle => 'सार्वभौमिक-उद्घोषणाः';

  @override
  String get broadcastSubtitle => 'सर्वेभ्यः प्रेषितम्';

  @override
  String get broadcastWarning =>
      'अत्र प्रेषिताः सन्देशाः सर्वेषां कृते दृश्यन्ते।';

  @override
  String broadcastError(String error) {
    return 'दोषः: $error';
  }

  @override
  String get broadcastNoHistory => 'पूर्वाः उद्घोषणाः न सन्ति।';

  @override
  String get broadcastTypeMessage => 'सार्वभौमिक-सन्देशं लिखतु...';

  @override
  String commFailedToSend(String error) {
    return 'प्रेषणं विफलम्: $error';
  }

  @override
  String get commAdminDashboard => 'प्रशासक-फलकम्';

  @override
  String get commAdminSupport => 'प्रशासक-सहायता';

  @override
  String get commAlwaysHere => 'सहायतार्थं सर्वदा उपस्थितः';

  @override
  String get commWelcomeTitle => 'नमस्ते! 👋 अहम् आशुतोष पाठकः अस्मि';

  @override
  String get commWelcomeSubtitle => 'Pulse इत्यस्य निर्माता';

  @override
  String get commWelcomeBody1 =>
      'आशासे यत् भवान् विज्ञापनैः विना स्वप्रियं सङ्गीतं शृण्वन् अस्ति। सङ्गीते धनवरोधः न भवेत्।\n\nअयं विभागः अस्माकं साक्षात् सम्पर्कार्थम् अस्ति।\n\nभवान् स्वेच्छया:';

  @override
  String get commBullet1 => 'स्वविचारान् प्रेषयतु';

  @override
  String get commBullet2 => 'दोषान् सूचयतु';

  @override
  String get commBullet3 => 'नूतनाः सुविधाः सूचयतु';

  @override
  String get commWelcomeBody2 =>
      'अहं व्यक्तिगततया प्रत्येकं सन्देशं पठामि, भवतः सुझावैरनुसारं ऐप-मध्ये सुधारं कर्तुं प्रयतै।\n\nधन्यवादः यत् भवान् Pulse इत्यस्य उपयोगं करोति। ❤️';

  @override
  String commError(String error) {
    return 'दोषः: $error';
  }

  @override
  String get commNoMessages => 'अद्यापि कोऽपि सन्देशः नास्ति';

  @override
  String get commNoMessagesDesc =>
      'सहायता-समूहं प्रति सन्देशं प्रेषयतु वा अनन्तरं पश्यतु।';

  @override
  String get commMessageSupportHint => 'सहायतां प्रति सन्देशः...';

  @override
  String get commGlobalAnnouncements => 'सार्वभौमिक-उद्घोषणाः';

  @override
  String get commSendMessagesToAll => 'सर्वेभ्यः सन्देशान् प्रेषयतु';

  @override
  String get homeGreetingMorning => 'सुप्रभातम्,';

  @override
  String get homeGreetingAfternoon => 'शुभमध्याह्नम्,';

  @override
  String get homeGreetingEvening => 'शुभसन्ध्या,';

  @override
  String get homeMember => 'सदस्यः';

  @override
  String get homeRecentPlaylists => 'नूतनाः वादनसूच्यः';

  @override
  String get homeRecentlyPlayed => 'सद्यः श्रुतम्';

  @override
  String get homeSpeedDial => 'शीघ्र-सम्पर्कः';

  @override
  String get homeNoContent => 'सामग्री न उपलब्धा';

  @override
  String get homeRefresh => 'पुनः लोडं करोतु';

  @override
  String get homeLoadError => 'सङ्गीतं प्राप्तुं न शक्तम्।';

  @override
  String get homeRetry => 'पुनः प्रयतताम्';

  @override
  String get importSuccess => 'Spotify सह सफलतापूर्वं सञ्जातम्!';

  @override
  String importFailed(String error) {
    return 'सम्पर्कः विफलः: $error';
  }

  @override
  String get importTitle => 'Spotify योजयतु';

  @override
  String get importSetupTitle => 'Spotify सञ्चालनम्';

  @override
  String get importSetupDesc =>
      'स्वकीयं निःशुल्कं विकासक-कुञ्जीं उपयुज्य सर्वान् वादनसूचीन् शीघ्रं प्राप्तुं एतान् पदान् अनुसरतु:';

  @override
  String get importStep1 => 'Spotify Developer Dashboard उद्घाटयतु।';

  @override
  String get importStep2 => 'लॉग-इन् कृत्वा \'Create app\' नोदयतु।';

  @override
  String get importStep3 => 'अनुप्रयोगस्य नाम विवरणं च लिखतु।';

  @override
  String get importStep4 => '\'Redirect URIs\' मध्ये अधोलिखितं URL स्थापयतु:';

  @override
  String get importRedirectCopied => 'Redirect URI प्रतिलिपितम्!';

  @override
  String get importStep5 =>
      'रक्षतु, स्वस्य \'Client ID\' प्रतिलिपिं कृत्वा अत्र स्थापयतु।';

  @override
  String get importImportant =>
      'महत्त्वपूर्णम्: अस्य विकासक-अनुप्रयोगस्य कृते प्रीमियम-सदस्यता आवश्यकी अस्ति।';

  @override
  String get importClientIdHint => 'स्वस्य Spotify Client ID अत्र स्थापयतु...';

  @override
  String get importConnectButton => 'सम्पर्कं कृत्वा सङ्ग्रहं प्राप्नोतु';

  @override
  String get downloadingNoActive => 'सक्रिय-डाउनलोड् नास्ति';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'डाउनलोड्';

  @override
  String downloadsStats(String count, String size) {
    return '$count गीतानि • $size';
  }

  @override
  String get downloadsNoOffline => 'अद्यापि अवनत-गीतानि न सन्ति';

  @override
  String get downloadsNoOfflineDesc => 'अवनतानि गीतानि अत्र दृश्यन्ते';

  @override
  String get downloadsClearAllTitle => 'सर्वान् डाउनलोड् निष्कासयतु?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'इदं $count गीतानि निष्कासयिष्यति तथा $size स्थानं मुक्तं करिष्यति।';
  }

  @override
  String get downloadsCancel => 'रद्द करोतु';

  @override
  String get downloadsClearAll => 'सर्वं निष्कासयतु';

  @override
  String downloadsSongsCount(String count) {
    return '$count गीतानि';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count गीतम्';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'मुख्य-डाउनलोड्-वादनसूचीं पुनर्नामितुं न शक्यते।';

  @override
  String get downloadsRename => 'पुनर्नाम';

  @override
  String get downloadsEditSongs => 'गीतानि सम्पादयतु';

  @override
  String get downloadsDelete => 'निष्कासयतु';

  @override
  String get downloadsRenamePlaylistTitle => 'वादनसूचीं पुनर्नामतु';

  @override
  String get downloadsRenamePlaylistDesc => 'स्ववादनसूच्यै नूतनं नाम ददातु।';

  @override
  String get downloadsDeletePlaylistTitle => 'वादनसूचीं निष्कासयतु?';

  @override
  String get downloadsDeleteMasterDesc =>
      'किं भवान् निश्चितरूपेण एतत् निष्कासितुम् इच्छति? सर्वाणि अवनत-गीतानि वादनसूच्यः च सर्वदा नष्टानि भविष्यन्ति।';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'किं भवान् निश्चितरूपेण \'$name\' निष्कासितुम् इच्छति? इयं वादनसूची सर्वदा नष्टा भविष्यति।';
  }

  @override
  String get downloadsSave => 'रक्षतु';

  @override
  String get downloadsNoSongs => 'अस्यां वादनसूच्यां गीतानि न सन्ति।';

  @override
  String get libraryTitle => 'सङ्ग्रहः';

  @override
  String get libraryPauseAll => 'सर्वं स्थगयतु';

  @override
  String get libraryResumeAll => 'सर्वं पुनः आरभताम्';

  @override
  String get libraryTabPlaylists => 'वादनसूच्यः';

  @override
  String get libraryTabDownloads => 'डाउनलोड्';

  @override
  String get libraryTabDownloading => 'अवनम्यमानम्';

  @override
  String libraryImportedTask(String name) {
    return '$name आयातितम्';
  }

  @override
  String get libraryImportWaiting => 'प्रतीक्षा क्रियते...';

  @override
  String get libraryImportFetching => 'वादनसूचीं प्राप्नोति...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total संसाधितम् · $matched प्राप्तम्';
  }

  @override
  String get libraryImportSaving => 'सङ्ग्रहे रक्ष्यते...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched गीतानि योजितानि';
  }

  @override
  String get libraryImportDoneAll => 'सर्वाणि गीतानि योजितानि';

  @override
  String get libraryAddButton => 'योजयतु';

  @override
  String get librarySortRecent => 'सद्यः योजितम्';

  @override
  String get librarySortAlpha => 'अक्षरक्रमेण';

  @override
  String get libraryEmptyTitle => 'भवतः सङ्ग्रहः रिक्तः अस्ति।';

  @override
  String get libraryEmptyDesc => 'प्रथमं Pulse आरब्धुं \'योजयतु\' नुदतु।';

  @override
  String get libraryRenameLikedError =>
      'रोचते-वादनसूचीं पुनर्नामितुं न शक्यते।';

  @override
  String get libraryRename => 'पुनर्नाम';

  @override
  String get libraryEditSongs => 'गीतानि सम्पादयतु';

  @override
  String get libraryDeleteLikedError => 'रोचते-वादनसूचीं निष्कासितुं न शक्यते।';

  @override
  String get libraryDelete => 'निष्कासयतु';

  @override
  String get libraryEditSongsTitle => 'गीतानि सम्पादयतु';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count गीतम्';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count गीतानि';
  }

  @override
  String get libraryCancel => 'रद्द करोतु';

  @override
  String get librarySave => 'रक्षतु';

  @override
  String get libraryNoSongs => 'अस्यां वादनसूच्यां गीतानि न सन्ति।';

  @override
  String get libraryAddOptionsTitle => 'सङ्ग्रहे योजयतु';

  @override
  String get libraryAddOptionsDesc => 'स्वस्य Pulse विस्तारयितुं मार्गं चिनोतु';

  @override
  String get libraryImportPulse => 'Pulse तः आयातं करोतु';

  @override
  String get libraryImportPulseDesc => 'Pulse वादनसूची URL स्थापयतु';

  @override
  String get libraryImportYtm => 'YT Music तः आयातं करोतु';

  @override
  String get libraryImportYtmDesc => 'सार्वजनिक-वादनसूची URL स्थापयतु';

  @override
  String get libraryImportSpotify => 'Spotify तः आयातं करोतु';

  @override
  String get libraryImportSpotifyDesc => 'स्वस्य Spotify योजयतु';

  @override
  String get libraryClose => 'पिदधातु';

  @override
  String get libraryImportYtmFull => 'YouTube Music तः आयातं करोतु';

  @override
  String get libraryImportSpotifyFull => 'Spotify तः आयातं करोतु (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'सार्वजनिक YouTube Music वादनसूची वा सङ्ग्रह URL अत्र स्थापयतु';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'सार्वजनिक Spotify वादनसूची URL अत्र स्थापयतु';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Pulse वादनसूची-आयातः विफलः';

  @override
  String get importErrorPlaylist => 'वादनसूची-आयाते दोषः';

  @override
  String get importErrorHighlyPopulated =>
      'वादनसूची अत्यन्तं बृहत् अस्ति, प्राप्तुं समयः लास्यति।';

  @override
  String get libraryImportBtn => 'आयातं करोतु';

  @override
  String get libraryCreateTitle => 'नूतना वादनसूची';

  @override
  String get libraryCreateDesc => 'अस्याः नूतनवादनसूच्याः नाम किं भवेत्?';

  @override
  String get libraryCreateHint => 'उदा. सङ्गीतमयी रात्रिः';

  @override
  String get libraryCreateBtn => 'सृजतु';

  @override
  String get libraryRenameTitle => 'वादनसूचीं पुनर्नामतु';

  @override
  String get libraryRenameDesc => 'स्ववादनसूच्यै नूतनं नाम ददातु।';

  @override
  String get libraryRenameBtn => 'पुनर्नाम';

  @override
  String get libraryDeleteTitle => 'वादनसूचीं निष्कासयतु?';

  @override
  String libraryDeleteDesc(String name) {
    return 'किं भवान् निश्चितरूपेण \'$name\' निष्कासितुम् इच्छति? इयं वादनसूची सर्वदा नष्टा भविष्यति।';
  }

  @override
  String get libraryDeleteBtn => 'निष्कासयतु';

  @override
  String get librarySortLabelAlpha => 'अ-ज्ञ';

  @override
  String get librarySortLabelRecent => 'नूतनम्';

  @override
  String librarySongsCount(String count) {
    return '$count गीतानि';
  }

  @override
  String get libraryComingSoon => 'शीघ्रमेव आगच्छति';

  @override
  String get loginErrName => 'कृपया स्वनाम लिखतु';

  @override
  String get loginErrEmail => 'कृपया स्व-ईमेल-सङ्केतं लिखतु';

  @override
  String get loginErrPassword => 'कृपया कूटशब्दं लिखतु';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'प्रत्येकं तालम् अनुभवतु!';

  @override
  String get loginMadeWithHeartBy => '❤️ सह निर्मितम्: ';

  @override
  String get loginAuthorName => 'आशुतोष पाठक';

  @override
  String get loginHintName => 'भवतः नाम';

  @override
  String get loginHintEmail => 'ईमेल-सङ्केतः';

  @override
  String get loginHintPassword => 'कूटशब्दः';

  @override
  String get loginErrEmailReset =>
      'कूटशब्दं परिवर्तयितुं स्व-ईमेल-सङ्केतं लिखतु';

  @override
  String get loginResetSent =>
      'कूटशब्द-परिवर्तन-ईमेल प्रेषितम्! स्व-इनबॉक्स पश्यतु।';

  @override
  String get loginForgotPwd => 'किं कूटशब्दं विस्मृतवान्?';

  @override
  String get loginBtnSignup => 'खातं सृजतु';

  @override
  String get loginBtnSignin => 'प्रविशतु';

  @override
  String get loginToggleHaveAccount => 'किं पूर्वमेव Pulse खातम् अस्ति? ';

  @override
  String get loginToggleNoAccount => 'किं Pulse खातं नास्ति? ';

  @override
  String get loginToggleSignin => 'प्रविशतु';

  @override
  String get loginToggleSignup => 'खातं सृजतु';

  @override
  String get offlineStillOffline =>
      'अद्यापि अन्तर्जालसम्पर्कः नास्ति। कृपया पश्यतु।';

  @override
  String get offlineTitle => 'अन्तर्जालसम्पर्कः विच्छिन्नः';

  @override
  String get offlineSubtitle =>
      'अन्तर्जालसम्पर्कः न प्राप्तः।\nस्वजालपुटं दृष्ट्वा पुनः प्रयतताम्।';

  @override
  String get offlineChecking => 'परीक्ष्यते...';

  @override
  String get offlineRetry => 'पुनः प्रयतताम्';

  @override
  String get offlineGoToDownloads => 'डाउनलोड्-मध्ये गच्छतु';

  @override
  String get playerMadeWithHeartBy => '❤️ सह निर्मितम्: ';

  @override
  String get playerAuthorName => 'आशुतोष पाठक';

  @override
  String get playerSwipeForLyrics => 'गीतपदार्थं स्वाइप् करोतु';

  @override
  String get playerNoLyrics => 'गीतपदानि न उपलब्धानि';

  @override
  String get playerUpNext => 'अग्रिमम्';

  @override
  String get playerNoTracksInQueue => 'कतारमध्ये गीतानि न सन्ति';

  @override
  String get playerNoMusicPlaying => 'सङ्गीतं न वाद्यते';

  @override
  String get playerPickAVibe => 'सङ्ग्रहात् वा मुखपृष्ठात् कमपि भावं चिनोतु';

  @override
  String get playerGoHome => 'मुखपृष्ठं गच्छतु';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'ईक्वलाइजर';

  @override
  String get playerEqCustom => 'स्वच्छन्दानुसारम्';

  @override
  String get playlistDownloads => 'डाउनलोड्';

  @override
  String get playlistOffline => 'अवनत-वादनसूची';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hoursहोरा $minsनिमेषाः';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$minsनिमेषाः';
  }

  @override
  String get playlistFindOnPage => 'अस्मिन् पुटे अन्विष्यतु';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count गीतानि • $duration';
  }

  @override
  String get playlistSortAlpha => 'अ-ज्ञ';

  @override
  String get playlistSortRecent => 'नूतनम्';

  @override
  String get playlistNoMatches => 'कोऽपि मेलः न प्राप्तः।';

  @override
  String get playlistNoTracks => 'अस्यां वादनसूच्यां गीतानि न सन्ति।';

  @override
  String get playlistNoSongsYet => 'अद्यापि गीतानि न सन्ति।';

  @override
  String get playlistSortRecentlyAdded => 'सद्यः योजितम्';

  @override
  String get playlistSortAlphabetical => 'अक्षरक्रमेण';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'गीतानि',
      one: 'गीतम्',
    );
    return '$count $_temp0 अवनम्यन्ते';
  }

  @override
  String get playlistView => 'पश्यतु';

  @override
  String get playlistAllDownloaded => 'सर्वाणि गीतानि पूर्वमेव अवनतानि सन्ति';

  @override
  String playlistShareText(String name, String url) {
    return 'Pulse इत्यत्र \'$name\' पश्यतु!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'डाउनलोड्-तः निष्कासयतु';

  @override
  String get playlistRemoveFromPlaylist => 'वादनसूच्याः निष्कासयतु';

  @override
  String get playlistLoadError => 'इमां वादनसूचीं प्राप्तुं न शक्तम्।';

  @override
  String get playlistGoBack => '← प्रतिगच्छतु';

  @override
  String get profileNotLoggedIn => 'प्रवेशः न कृतः';

  @override
  String get profileSignIn => 'प्रविशतु';

  @override
  String get profileDefaultUser => 'Pulse उपयोक्ता';

  @override
  String get profileEditProfile => 'सम्पादनम्';

  @override
  String get profileTimeframeDay => 'दिनम्';

  @override
  String get profileTimeframeWeek => 'सप्ताहः';

  @override
  String get profileTimeframeMonth => 'मासः';

  @override
  String get profileTimeframeYear => 'वर्षम्';

  @override
  String get profileListeningTime => 'श्रवणसमयः';

  @override
  String get profileToday => 'अद्य';

  @override
  String get profileThisWeek => 'अस्मिन् सप्ताहे';

  @override
  String get profileThisMonth => 'अस्मिन् मासे';

  @override
  String get profileThisYear => 'अस्मिन् वर्षे';

  @override
  String get profileDailyAvg => 'दैनिक-औसतम्';

  @override
  String get profilePerDay => 'प्रतिदिनम्';

  @override
  String get profileLifetimeListening => 'आजीवनश्रवणम्';

  @override
  String get profileTotalTimeListened => 'Pulse इत्यत्र सङ्गीतश्रवणस्य कुलसमयः';

  @override
  String get profileYourTopSongs => 'भवतः प्रमुखगीतानि';

  @override
  String get profileListeningHistoryEmpty => 'श्रवण-इतिहासः अत्र दृश्यते।';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'वाराः',
      one: 'वारम्',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => 'भवतः प्रमुखकलाकाराः';

  @override
  String get profileTopArtistsEmpty => 'भवतः प्रियम-कलाकाराः अत्र दृश्यन्ते।';

  @override
  String get profileArtistLabel => 'कलाकारः';

  @override
  String get profileSignOut => 'बहिर्गच्छतु';

  @override
  String profileVersion(String version) {
    return 'संस्करणम् $version';
  }

  @override
  String get profileMadeWithHeartBy => '❤️ सह निर्मितम्: ';

  @override
  String get profileAuthorName => 'आशुतोष पाठक';

  @override
  String get profileEditProfileHeader => 'सम्पादनम्';

  @override
  String get profileDisplayName => 'प्रदर्शितनाम';

  @override
  String get profileCancel => 'रद्द करोतु';

  @override
  String get profileSave => 'रक्षतु';

  @override
  String get profileChooseAvatar => 'चित्रं चिनोतु';

  @override
  String get searchMicPermissionRequired =>
      'अस्यै सुविधायै ध्वनिग्राहकस्य अनुमतिः आवश्यकी अस्ति';

  @override
  String get searchUnknownSong => 'अज्ञातगीतम्';

  @override
  String get searchUnknownArtist => 'अज्ञातकलाकारः';

  @override
  String get searchNoSongDetected => 'कोऽपि गीतं न ज्ञातम्।';

  @override
  String searchError(String message) {
    return 'दोषः: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'ध्वनि-अभिज्ञानं न उपलब्धम्';

  @override
  String get searchHint => 'गीतानि, कलाकाराः, सङ्ग्रहाः, वादनसूच्यः…';

  @override
  String get searchRecentEmpty => 'भवतः सद्यः अन्वेषणानि अत्र दृश्यन्ते';

  @override
  String get searchRecentSearches => 'सद्यः अन्वेषणानि';

  @override
  String get searchClearAll => 'सर्वं मार्जयतु';

  @override
  String searchNoResultsFor(String query) {
    return '\'$query\' कृते कोऽपि परिणामः नास्ति';
  }

  @override
  String get searchTryDifferentKeywords => 'भिन्नान् शब्दान् प्रयुङ्क्त';

  @override
  String get searchTopResult => 'प्रथमपरिणामः';

  @override
  String get searchSongsLabel => 'गीतानि';

  @override
  String get searchArtistsLabel => 'कलाकाराः';

  @override
  String get searchAlbumsLabel => 'सङ्ग्रहाः';

  @override
  String get searchPlaylistsLabel => 'वादनसूच्यः';

  @override
  String get searchArtistLabel => 'कलाकारः';

  @override
  String get searchListening => 'शृणोति...';

  @override
  String get searchSpeakNow => 'अन्वेष्टुं इदानीं वदतु';

  @override
  String get searchCancel => 'रद्द करोतु';

  @override
  String get searchIdentifying => 'अभिज्ञानं करोति...';

  @override
  String get searchListeningForSong => 'गीतं शृणोति...';

  @override
  String get settingsTitle => 'व्यवस्थाः';

  @override
  String get settingsStreamingQuality => 'श्रवणगुणवत्ता';

  @override
  String get settingsQualityAutomatic => 'स्वचालितम्';

  @override
  String get settingsQualityLow => 'निम्नम्';

  @override
  String get settingsQualityNormal => 'सामान्यम्';

  @override
  String get settingsQualityHigh => 'उच्चम्';

  @override
  String get settingsDownloadQuality => 'अवनमनगुणवत्ता';

  @override
  String get settingsPlayback => 'वादनम्';

  @override
  String get settingsCrossfade => 'क्रॉसफेड';

  @override
  String get settingsCrossfadeDesc => 'निर्बाधवादनार्थं गीतानां अतिव्यापनम्';

  @override
  String get settingsDataUsage => 'डाटा-उपयोगः';

  @override
  String get settingsDataSaver => 'डाटा-रक्षकः';

  @override
  String get settingsDataSaverDesc => 'सेल्यूलर-मध्ये निम्नगुणवत्तायां वादयतु';

  @override
  String get settingsAppearance => 'दृश्यम्';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsCustomAccent => 'स्वच्छन्दवर्णः';

  @override
  String get settingsSaturation => 'सन्तृप्तिः';

  @override
  String get settingsBrightness => 'प्रकाशः';

  @override
  String get settingsResetDefault => 'पूर्ववत् करोतु';

  @override
  String get playlistSheetTitle => 'वादनसूच्यां योजयतु';

  @override
  String get playlistSheetNewPlaylist => 'नूतना वादनसूची';

  @override
  String get playlistSheetNoPlaylists => 'अद्यापि वादनसूच्यः न सन्ति';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'गीतानि',
      one: 'गीतम्',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => 'वादनसूची-नाम';

  @override
  String get playlistSheetCancel => 'रद्द करोतु';

  @override
  String playlistSheetAddedTo(String name) {
    return '$name इत्यत्र योजितम्';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'वादनसूचीसृजने विफलम्: प्रमाणीकरणदोषः';

  @override
  String playlistSheetCreateFail(String error) {
    return 'वादनसूचीसृजने विफलम्: $error';
  }

  @override
  String get playlistSheetCreate => 'सृजतु';

  @override
  String get appUpdateAvailable => 'अद्यतनम् उपलब्धम्';

  @override
  String appUpdateDesc(String version) {
    return 'संस्करणम् $version अत्र अस्ति! नूतनाः सुविधाः प्राप्तुं इदानीम् अद्यतनं करोतु।';
  }

  @override
  String get appUpdateDownload => 'अद्यतनं डाउनलोड् करोतु';

  @override
  String get navHome => 'मुखपृष्ठम्';

  @override
  String get navLibrary => 'सङ्ग्रहः';

  @override
  String get navSearch => 'अन्वेषणम्';

  @override
  String get navSettings => 'व्यवस्थाः';

  @override
  String get navProfile => 'प्रोफाइल';

  @override
  String get artistSelect => 'कलाकारं चिनोतु';

  @override
  String get songActionQueue => 'कतारे योजयतु';

  @override
  String get songActionPlaylist => 'वादनसूच्यां योजयतु';

  @override
  String get songActionFinding => 'अन्विष्यति...';

  @override
  String get songActionAlbum => 'सङ्ग्रहं गच्छतु';

  @override
  String get songActionArtist => 'कलाकारं गच्छतु';

  @override
  String get songActionRemovePlaylist => 'वादनसूच्याः निष्कासयतु';

  @override
  String get songActionRemoveDownload => 'डाउनलोड्-तः निष्कासयतु';

  @override
  String get songActionDownloadChecking => 'परीक्ष्यते...';

  @override
  String get songActionDownloading => 'अवनम्यते...';

  @override
  String get songActionDownloaded => 'अवनतम्!';

  @override
  String get songActionDownloadAlready => 'पूर्वमेव अवनतम्';

  @override
  String get songActionDownloadFailed => 'डाउनलोड् विफलम्';

  @override
  String get songActionDownload => 'डाउनलोड् करोतु';

  @override
  String get songActionDownloadingSnack => 'डाउनलोड् करोति';

  @override
  String get songActionView => 'पश्यतु';

  @override
  String get spotifyImportTitle => 'Spotify तः आयातं करोतु';

  @override
  String get spotifyImportSubtitle => 'स्ववादनसूच्याः आकारं चिनोतु';

  @override
  String get spotifyChoiceSmallTitle => '१०० गीतानि वा ततः न्यूनानि';

  @override
  String get spotifyChoiceSmallDesc =>
      'सार्वजनिक-Spotify-वादनसूची-URL स्थापयतु।';

  @override
  String get spotifyChoiceLargeTitle => '१०० गीतेभ्यः अधिकम्';

  @override
  String get spotifyChoiceLargeDesc =>
      'असीमितगीतानि प्राप्तुं स्वकीयं Spotify Developer App योजयतु।';

  @override
  String get cancelButton => 'रद्द करोतु';

  @override
  String get spotifyPlaylistsTitle => 'भवतः Spotify वादनसूच्यः';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'दोषः: $error\nClient ID सम्यक् अस्ति वा इति पश्यतु।';
  }

  @override
  String get spotifyPlaylistsEmpty => 'भवतः सङ्ग्रहे वादनसूच्यः न प्राप्ताः';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count गीतानि';
  }

  @override
  String get spotifyPlaylistsImport => 'आयातम';

  @override
  String get audioPlaybackFailed => 'वादनं विफलम्। अन्तर्जालसम्पर्कं पश्यतु।';

  @override
  String get audioControlPrevious => 'पूर्वम्';

  @override
  String get audioControlPause => 'स्थगयतु';

  @override
  String get audioControlPlay => 'वादयतु';

  @override
  String get audioControlNext => 'अग्रिमम्';

  @override
  String get audioControlUnlike => 'न रोचते';

  @override
  String get audioControlLike => 'रोचते';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'मूल-उत्तरम्: $data\n\nविकल्पः: $error';
  }

  @override
  String get apiErrorInvalidClient => 'अमान्य-क्लायंट् वा क्लायंट्-गुप्तशब्दः।';

  @override
  String get apiErrorBadRequest => 'अमान्य-अनुरोधः। कृपया स्व-विवरणं पश्यतु।';

  @override
  String get apiErrorUnauthorized => 'अनाधिकृतम्। कृपया पुनः प्रविशतु।';

  @override
  String get apiErrorForbidden => 'निषिद्धम्। भवतः अनुमतिः नास्ति।';

  @override
  String get apiErrorNotFound => 'संसाधनं न प्राप्तम्।';

  @override
  String get apiErrorEmailInUse => 'अयं ईमेल-सङ्केतः पूर्वमेव प्रयुक्तः अस्ति।';

  @override
  String get apiErrorUserNotFound =>
      'अनेन ईमेल-सङ्केतेन कोऽपि खाता न प्राप्तः।';

  @override
  String get apiErrorWrongPassword => 'अशुद्ध-कूटशब्दः।';

  @override
  String get apiErrorInvalidCredential =>
      'प्रवेशः विफलः। कृपया स्व-प्रमाणपत्राणि पश्यतु।';

  @override
  String get apiErrorNetwork => 'जालदोषः। कृपया अन्तर्जालसम्पर्कं पश्यतु।';

  @override
  String get apiErrorSocketTimeout =>
      'सम्पर्कसमयः अतीतः। कृपया पुनः प्रयतताम्।';

  @override
  String get apiErrorTooManyRequests =>
      'अत्यधिकाः अनुरोधाः। कृपया किञ्चित्कालं प्रतीक्ष्य पुनः प्रयतताम्।';

  @override
  String get apiErrorServerError =>
      'सर्वर-दोषः। कृपया किञ्चित्कालानन्तरं प्रयतताम्।';

  @override
  String get apiErrorInvalidEmail => 'कृपया मान्य-ईमेल-सङ्केतं लिखतु।';

  @override
  String get apiErrorWeakPassword =>
      'कूटशब्दः दुर्बलः अस्ति। न्यूनातिन्यूनं ६ अक्षराणि प्रयुङ्क्त।';

  @override
  String get apiErrorTooManyAttempts =>
      'अत्यधिकाः विफलाः प्रयासाः। कृपया किञ्चित्कालानन्तरं प्रयतताम्।';

  @override
  String get homeForgottenFavorites => 'विस्मृताः प्रियगानानि';

  @override
  String get artistShowAll => 'सर्वाणि दर्शयन्तु';

  @override
  String get homeTopTracks => 'शीर्षगानानि';
}
