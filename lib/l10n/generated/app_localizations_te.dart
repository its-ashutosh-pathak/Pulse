// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'గురించి';

  @override
  String get artistPopular => 'జనాదరణ';

  @override
  String get artistAlbums => 'ఆల్బమ్‌లు';

  @override
  String get artistSinglesAndEPs => 'సింగిల్స్ & EPలు';

  @override
  String artistSubscribersCount(String count) {
    return '$count సబ్‌స్క్రైబర్లు';
  }

  @override
  String get artistPlayAll => 'అన్నీ ప్లే చేయండి';

  @override
  String get artistLoadError => 'ఆర్టిస్ట్‌ను లోడ్ చేయలేకపోయాము';

  @override
  String get artistGoBack => 'వెనక్కి వెళ్ళండి';

  @override
  String adminChatFailedToReply(String error) {
    return 'రిప్లై ఇవ్వడం విఫలమైంది: $error';
  }

  @override
  String get adminChatSupportChat => 'సపోర్ట్ చాట్';

  @override
  String adminChatError(String error) {
    return 'లోపం: $error';
  }

  @override
  String get adminChatNoHistory => 'గత సంభాషణలు లేవు.';

  @override
  String get adminChatSupportYou => 'సపోర్ట్ (మీరు)';

  @override
  String get adminChatTypeReply => 'మీ రిప్లై రాయండి...';

  @override
  String get broadcastSuccess => 'ప్రకటన విజయవంతంగా బ్రాడ్‌కాస్ట్ చేయబడింది!';

  @override
  String broadcastFailed(String error) {
    return 'బ్రాడ్‌కాస్ట్ విఫలమైంది: $error';
  }

  @override
  String get broadcastTitle => 'గ్లోబల్ ప్రకటనలు';

  @override
  String get broadcastSubtitle => 'యూజర్లందరికీ పంపబడింది';

  @override
  String get broadcastWarning => 'ఇక్కడ పంపే సందేశాలు అందరికీ కనిపిస్తాయి.';

  @override
  String broadcastError(String error) {
    return 'లోపం: $error';
  }

  @override
  String get broadcastNoHistory => 'గత ప్రకటనలు లేవు.';

  @override
  String get broadcastTypeMessage => 'గ్లోబల్ ప్రకటన రాయండి...';

  @override
  String commFailedToSend(String error) {
    return 'పంపడం విఫలమైంది: $error';
  }

  @override
  String get commAdminDashboard => 'అడ్మిన్ డ్యాష్‌బోర్డ్';

  @override
  String get commAdminSupport => 'అడ్మిన్ సపోర్ట్';

  @override
  String get commAlwaysHere => 'సహాయం చేయడానికి ఇక్కడే ఉన్నాం';

  @override
  String get commWelcomeTitle => 'హలో! 👋 నేను ఆశుతోష్ పాఠక్';

  @override
  String get commWelcomeSubtitle => 'Pulse డెవలపర్';

  @override
  String get commWelcomeBody1 =>
      'ప్రకటనలు లేదా సబ్‌స్క్రిప్షన్ అడ్డంకులు లేకుండా మీకిష్టమైన సంగీతాన్ని ఆస్వాదిస్తున్నారని ఆశిస్తున్నాను. సంగీతం కేవలం డబ్బున్న వారికే పరిమితం కాకూడదు.\n\nమనమిద్దరం నేరుగా కనెక్ట్ అవ్వడానికి ఈ విభాగం ఉంది.\n\nమీరు ఏమైనా చెప్పాలనుకుంటే:';

  @override
  String get commBullet1 => 'మీ ఫీడ్‌బ్యాక్ ఇవ్వండి';

  @override
  String get commBullet2 => 'బగ్‌లను రిపోర్ట్ చేయండి';

  @override
  String get commBullet3 => 'కొత్త ఫీచర్లను సూచించండి';

  @override
  String get commWelcomeBody2 =>
      'ప్రతి సందేశాన్ని నేనే చదువుతాను మరియు మీ సూచనలతో యాప్‌ను మెరుగుపరుస్తాను.\n\nసబ్‌స్క్రిప్షన్లలో చిక్కుకున్న కొత్త యాప్ ఆలోచన ఉందా? నాకు చెప్పండి! వీలైతే నేను దాన్ని అందరికీ అందుబాటులోకి తెస్తాను.\n\nఈ ప్రయాణంలో భాగమైనందుకు ధన్యవాదాలు. ❤️';

  @override
  String commError(String error) {
    return 'లోపం: $error';
  }

  @override
  String get commNoMessages => 'ఇంకా సందేశాలు లేవు';

  @override
  String get commNoMessagesDesc =>
      'మా సపోర్ట్ టీమ్‌కు సందేశం పంపండి లేదా ప్రకటనల కోసం తర్వాత చూడండి.';

  @override
  String get commMessageSupportHint => 'సపోర్ట్ టీమ్‌కు రాయండి...';

  @override
  String get commGlobalAnnouncements => 'గ్లోబల్ ప్రకటనలు';

  @override
  String get commSendMessagesToAll => 'యూజర్లందరికీ సందేశాలు పంపండి';

  @override
  String get homeGreetingMorning => 'శుభోదయం,';

  @override
  String get homeGreetingAfternoon => 'శుభాహ్నం,';

  @override
  String get homeGreetingEvening => 'శుభ సాయంత్రం,';

  @override
  String get homeMember => 'సభ్యుడు';

  @override
  String get homeRecentPlaylists => 'ఇటీవలి ప్లేలిస్ట్‌లు';

  @override
  String get homeRecentlyPlayed => 'ఇటీవల ప్లే చేసినవి';

  @override
  String get homeSpeedDial => 'స్పీడ్ డయల్';

  @override
  String get homeNoContent => 'కంటెంట్ లేదు';

  @override
  String get homeRefresh => 'రిఫ్రెష్';

  @override
  String get homeLoadError => 'మ్యూజిక్ ఫీడ్ లోడ్ కాలేదు.';

  @override
  String get homeRetry => 'మళ్ళీ ప్రయత్నించండి';

  @override
  String get importSuccess => 'Spotify విజయవంతంగా కనెక్ట్ అయ్యింది!';

  @override
  String importFailed(String error) {
    return 'కనెక్ట్ చేయడం విఫలమైంది: $error';
  }

  @override
  String get importTitle => 'Spotify కనెక్ట్ చేయండి';

  @override
  String get importSetupTitle => 'Spotify సెటప్';

  @override
  String get importSetupDesc =>
      'Spotify పరిమితులను దాటవేసి మీ ప్లేలిస్ట్‌లను వెంటనే ఇంపోర్ట్ చేయడానికి మీ డెవలపర్ కీని ఉపయోగించండి. ఈ స్టెప్స్ ఫాలో అవ్వండి:';

  @override
  String get importStep1 => 'Spotify Developer Dashboard తెరవండి.';

  @override
  String get importStep2 => 'లాగిన్ చేసి \"Create app\" నొక్కండి.';

  @override
  String get importStep3 => 'యాప్ పేరు మరియు వివరణ ఇవ్వండి.';

  @override
  String get importStep4 =>
      '\"Redirect URIs\" కింద ఈ ఖచ్చితమైన URLను పేస్ట్ చేయండి:';

  @override
  String get importRedirectCopied => 'రీడైరెక్ట్ URI కాపీ అయ్యింది!';

  @override
  String get importStep5 =>
      'యాప్ సేవ్‌ చేసి, సెట్టింగ్స్ నుండి మీ \"Client ID\" కాపీ చేసి కింద పేస్ట్ చేయండి.';

  @override
  String get importImportant =>
      'ముఖ్య గమనిక: ఈ డెవలపర్ యాప్ క్రియేట్ చేయడానికి ఉపయోగించే Spotify ఖాతాకు యాక్టివ్ ప్రీమియం సబ్‌స్క్రిప్షన్ ఉండాలి.';

  @override
  String get importClientIdHint =>
      'మీ Spotify Client ID ఇక్కడ పేస్ట్ చేయండి...';

  @override
  String get importConnectButton => 'కనెక్ట్ & లైబ్రరీ లోడ్ చేయండి';

  @override
  String get downloadingNoActive => 'యాక్టివ్ డౌన్‌లోడ్స్ లేవు';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'డౌన్‌లోడ్స్';

  @override
  String downloadsStats(String count, String size) {
    return '$count పాటలు • $size';
  }

  @override
  String get downloadsNoOffline => 'ఆఫ్‌లైన్ పాటలు లేవు';

  @override
  String get downloadsNoOfflineDesc =>
      'మీరు డౌన్‌లోడ్ చేసిన పాటలు ఇక్కడ కనిపిస్తాయి';

  @override
  String get downloadsClearAllTitle => 'అన్ని డౌన్‌లోడ్స్ క్లియర్ చేయాలా?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'ఇది $count పాటలను తొలగిస్తుంది మరియు $size స్టోరేజ్ ఖాళీ చేస్తుంది.';
  }

  @override
  String get downloadsCancel => 'రద్దు చేయి';

  @override
  String get downloadsClearAll => 'అన్నీ క్లియర్ చేయి';

  @override
  String downloadsSongsCount(String count) {
    return '$count పాటలు';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count పాట';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'మెయిన్ డౌన్‌లోడ్స్ ప్లేలిస్ట్ పేరు మార్చలేరు.';

  @override
  String get downloadsRename => 'పేరు మార్చు';

  @override
  String get downloadsEditSongs => 'పాటలను ఎడిట్ చేయండి';

  @override
  String get downloadsDelete => 'తొలగించు';

  @override
  String get downloadsRenamePlaylistTitle => 'ప్లేలిస్ట్ పేరు మార్చు';

  @override
  String get downloadsRenamePlaylistDesc => 'ప్లేలిస్ట్‌కు కొత్త పేరు ఇవ్వండి.';

  @override
  String get downloadsDeletePlaylistTitle => 'ప్లేలిస్ట్ తొలగించాలా?';

  @override
  String get downloadsDeleteMasterDesc =>
      'దీన్ని నిజంగా తొలగించాలనుకుంటున్నారా? మీరు డౌన్‌లోడ్ చేసిన పాటలు మరియు ప్లేలిస్ట్‌లు శాశ్వతంగా కోల్పోతారు.';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return '\"$name\" నిజంగా తొలగించాలనుకుంటున్నారా? ఈ ప్లేలిస్ట్ శాశ్వతంగా కోల్పోతారు.';
  }

  @override
  String get downloadsSave => 'సేవ్ చేయి';

  @override
  String get downloadsNoSongs => 'ఈ ప్లేలిస్ట్‌లో పాటలు లేవు.';

  @override
  String get libraryTitle => 'లైబ్రరీ';

  @override
  String get libraryPauseAll => 'అన్నీ పాజ్ చేయి';

  @override
  String get libraryResumeAll => 'అన్నీ రెజ్యూమ్ చేయి';

  @override
  String get libraryTabPlaylists => 'ప్లేలిస్ట్‌లు';

  @override
  String get libraryTabDownloads => 'డౌన్‌లోడ్స్';

  @override
  String get libraryTabDownloading => 'డౌన్‌లోడింగ్';

  @override
  String libraryImportedTask(String name) {
    return '$name ఇంపోర్ట్ అయ్యింది';
  }

  @override
  String get libraryImportWaiting => 'వేచి ఉంది...';

  @override
  String get libraryImportFetching => 'ప్లేలిస్ట్‌ తెస్తోంది...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total ప్రాసెస్ అయ్యాయి · $matched మ్యాచ్ అయ్యాయి';
  }

  @override
  String get libraryImportSaving => 'లైబ్రరీకి సేవ్ చేస్తోంది...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched పాటలు యాడ్ అయ్యాయి · మూసివేయడానికి × నొక్కండి';
  }

  @override
  String get libraryImportDoneAll =>
      'పాటలన్నీ యాడ్ అయ్యాయి · మూసివేయడానికి × నొక్కండి';

  @override
  String get libraryAddButton => 'యాడ్ చేయి';

  @override
  String get librarySortRecent => 'ఇటీవలివి';

  @override
  String get librarySortAlpha => 'ఆల్ఫాబెటికల్';

  @override
  String get libraryEmptyTitle => 'మీ లైబ్రరీ ఖాళీగా ఉంది.';

  @override
  String get libraryEmptyDesc =>
      'మీ మొదటి Pulse ప్రారంభించడానికి \"యాడ్ చేయి\" నొక్కండి.';

  @override
  String get libraryRenameLikedError =>
      'Liked Songs ప్లేలిస్ట్ పేరు మార్చలేరు.';

  @override
  String get libraryRename => 'పేరు మార్చు';

  @override
  String get libraryEditSongs => 'పాటలను ఎడిట్ చేయండి';

  @override
  String get libraryDeleteLikedError => 'Liked Songs ప్లేలిస్ట్ తొలగించలేరు.';

  @override
  String get libraryDelete => 'తొలగించు';

  @override
  String get libraryEditSongsTitle => 'పాటలను ఎడిట్ చేయండి';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count పాట';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count పాటలు';
  }

  @override
  String get libraryCancel => 'రద్దు చేయి';

  @override
  String get librarySave => 'సేవ్ చేయి';

  @override
  String get libraryNoSongs => 'ఈ ప్లేలిస్ట్‌లో పాటలు లేవు.';

  @override
  String get libraryAddOptionsTitle => 'లైబ్రరీకి యాడ్ చేయండి';

  @override
  String get libraryAddOptionsDesc =>
      'మీ Pulse లైబ్రరీ ఎలా పెంచుకోవాలో ఎంచుకోండి';

  @override
  String get libraryImportPulse => 'Pulse నుండి ఇంపోర్ట్ చేయండి';

  @override
  String get libraryImportPulseDesc => 'Pulse ప్లేలిస్ట్ URL పేస్ట్ చేయండి';

  @override
  String get libraryImportYtm => 'YT Music నుండి ఇంపోర్ట్ చేయండి';

  @override
  String get libraryImportYtmDesc => 'పబ్లిక్ ప్లేలిస్ట్ URL పేస్ట్ చేయండి';

  @override
  String get libraryImportSpotify => 'Spotify నుండి ఇంపోర్ట్ చేయండి';

  @override
  String get libraryImportSpotifyDesc => 'Spotify కనెక్ట్ చేయండి';

  @override
  String get libraryClose => 'మూసివేయి';

  @override
  String get libraryImportYtmFull => 'YouTube Music నుండి ఇంపోర్ట్ చేయండి';

  @override
  String get libraryImportSpotifyFull => 'Spotify నుండి ఇంపోర్ట్ చేయండి (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'పబ్లిక్ YouTube Music ప్లేలిస్ట్ లేదా ఆల్బమ్ URL పేస్ట్ చేయండి';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'పబ్లిక్ Spotify ప్లేలిస్ట్ URL కింద పేస్ట్ చేయండి';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Pulse ప్లేలిస్ట్ ఇంపోర్ట్ విఫలమైంది';

  @override
  String get importErrorPlaylist => 'ప్లేలిస్ట్ ఇంపోర్ట్ చేయడంలో లోపం';

  @override
  String get importErrorHighlyPopulated =>
      'ప్లేలిస్ట్ చాలా పెద్దది, తెచ్చేందుకు సమయం పట్టవచ్చు.';

  @override
  String get libraryImportBtn => 'ఇంపోర్ట్';

  @override
  String get libraryCreateTitle => 'కొత్త ప్లేలిస్ట్';

  @override
  String get libraryCreateDesc => 'కొత్త ప్లేలిస్ట్‌కు ఏం పేరు పెడదాం?';

  @override
  String get libraryCreateHint => 'ఉదా. Midnight Rides';

  @override
  String get libraryCreateBtn => 'క్రియేట్ చేయి';

  @override
  String get libraryRenameTitle => 'ప్లేలిస్ట్ పేరు మార్చు';

  @override
  String get libraryRenameDesc => 'ప్లేలిస్ట్‌కు కొత్త పేరు ఇవ్వండి.';

  @override
  String get libraryRenameBtn => 'పేరు మార్చు';

  @override
  String get libraryDeleteTitle => 'ప్లేలిస్ట్ తొలగించాలా?';

  @override
  String libraryDeleteDesc(String name) {
    return '\"$name\" నిజంగా తొలగించాలనుకుంటున్నారా? ఈ ప్లేలిస్ట్ శాశ్వతంగా కోల్పోతారు.';
  }

  @override
  String get libraryDeleteBtn => 'తొలగించు';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'ఇటీవలివి';

  @override
  String librarySongsCount(String count) {
    return '$count పాటలు';
  }

  @override
  String get libraryComingSoon => 'త్వరలో వస్తోంది';

  @override
  String get loginErrName => 'దయచేసి మీ పేరు ఇవ్వండి';

  @override
  String get loginErrEmail => 'దయచేసి మీ ఇమెయిల్ ఇవ్వండి';

  @override
  String get loginErrPassword => 'దయచేసి మీ పాస్‌వర్డ్ ఇవ్వండి';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'ప్రతి బీట్ ఫీల్ అవ్వండి!';

  @override
  String get loginMadeWithHeartBy => 'ప్రేమతో సృష్టించినది: ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'మీ పేరు';

  @override
  String get loginHintEmail => 'ఇమెయిల్ అడ్రస్';

  @override
  String get loginHintPassword => 'పాస్‌వర్డ్';

  @override
  String get loginErrEmailReset =>
      'పాస్‌వర్డ్ రీసెట్ చేయడానికి ఇమెయిల్ ఇవ్వండి';

  @override
  String get loginResetSent =>
      'రీసెట్ ఇమెయిల్ పంపబడింది! ఇన్‌బాక్స్ చెక్ చేయండి.';

  @override
  String get loginForgotPwd => 'పాస్‌వర్డ్ మర్చిపోయారా?';

  @override
  String get loginBtnSignup => 'అకౌంట్ క్రియేట్ చేయి';

  @override
  String get loginBtnSignin => 'సైన్ ఇన్';

  @override
  String get loginToggleHaveAccount => 'ఇప్పటికే Pulse అకౌంట్ ఉందా? ';

  @override
  String get loginToggleNoAccount => 'Pulse అకౌంట్ లేదా? ';

  @override
  String get loginToggleSignin => 'సైన్ ఇన్';

  @override
  String get loginToggleSignup => 'సైన్ అప్';

  @override
  String get offlineStillOffline =>
      'ఇంకా ఆఫ్‌లైన్‌లోనే ఉన్నారు. కనెక్షన్ చెక్ చేయండి.';

  @override
  String get offlineTitle => 'మీరు ఆఫ్‌లైన్‌లో ఉన్నారు';

  @override
  String get offlineSubtitle =>
      'ఇంటర్నెట్ కనెక్షన్ లేదు.\nనెట్‌వర్క్ చెక్ చేసి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get offlineChecking => 'చెక్ చేస్తోంది...';

  @override
  String get offlineRetry => 'మళ్ళీ ప్రయత్నించండి';

  @override
  String get offlineGoToDownloads => 'డౌన్‌లోడ్స్‌కి వెళ్ళు';

  @override
  String get playerMadeWithHeartBy => 'ప్రేమతో సృష్టించినది: ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'లిరిక్స్ కోసం స్వైప్ చేయండి';

  @override
  String get playerNoLyrics => 'లిరిక్స్ అందుబాటులో లేవు';

  @override
  String get playerUpNext => 'తర్వాత రాబోయేది';

  @override
  String get playerNoTracksInQueue => 'క్యూలో ట్రాక్స్ లేవు';

  @override
  String get playerNoMusicPlaying => 'ఏ సంగీతం ప్లే అవ్వట్లేదు';

  @override
  String get playerPickAVibe => 'లైబ్రరీ లేదా హోమ్ నుండి పాటను ఎంచుకోండి';

  @override
  String get playerGoHome => 'హోమ్‌కి వెళ్ళు';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'ఈక్వలైజర్';

  @override
  String get playerEqCustom => 'కస్టమ్';

  @override
  String get playlistDownloads => 'డౌన్‌లోడ్స్';

  @override
  String get playlistOffline => 'ఆఫ్‌లైన్ ప్లేలిస్ట్';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hoursగం $minsని';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$minsని';
  }

  @override
  String get playlistFindOnPage => 'ఈ పేజీలో వెతుకు';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count పాటలు • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'ఇటీవలివి';

  @override
  String get playlistNoMatches => 'ఏమీ దొరకలేదు.';

  @override
  String get playlistNoTracks => 'ఈ ప్లేలిస్ట్‌లో ట్రాక్స్ లేవు.';

  @override
  String get playlistNoSongsYet => 'ఇంకా పాటలు లేవు.';

  @override
  String get playlistSortRecentlyAdded => 'ఇటీవల యాడ్ చేసినవి';

  @override
  String get playlistSortAlphabetical => 'ఆల్ఫాబెటికల్';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'పాటలు',
      one: 'పాట',
    );
    return '$count $_temp0 డౌన్‌లోడ్ అవుతున్నాయి';
  }

  @override
  String get playlistView => 'చూడండి';

  @override
  String get playlistAllDownloaded => 'అన్ని పాటలు ముందే డౌన్‌లోడ్ అయ్యాయి';

  @override
  String playlistShareText(String name, String url) {
    return 'Pulseలో \"$name\" వినండి!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'డౌన్‌లోడ్స్ నుండి తీసివేయి';

  @override
  String get playlistRemoveFromPlaylist => 'ప్లేలిస్ట్ నుండి తీసివేయి';

  @override
  String get playlistLoadError => 'ప్లేలిస్ట్ లోడ్ కాలేదు.';

  @override
  String get playlistGoBack => '← వెనక్కి వెళ్ళు';

  @override
  String get profileNotLoggedIn => 'లాగిన్ అవ్వలేదు';

  @override
  String get profileSignIn => 'సైన్ ఇన్';

  @override
  String get profileDefaultUser => 'Pulse యూజర్';

  @override
  String get profileEditProfile => 'ప్రొఫైల్ ఎడిట్ చేయి';

  @override
  String get profileTimeframeDay => 'రోజు';

  @override
  String get profileTimeframeWeek => 'వారం';

  @override
  String get profileTimeframeMonth => 'నెల';

  @override
  String get profileTimeframeYear => 'సంవత్సరం';

  @override
  String get profileListeningTime => 'లిజనింగ్ టైమ్';

  @override
  String get profileToday => 'ఈ రోజు';

  @override
  String get profileThisWeek => 'ఈ వారం';

  @override
  String get profileThisMonth => 'ఈ నెల';

  @override
  String get profileThisYear => 'ఈ సంవత్సరం';

  @override
  String get profileDailyAvg => 'రోజువారీ సగటు';

  @override
  String get profilePerDay => 'రోజుకు';

  @override
  String get profileLifetimeListening => 'మొత్తం లిజనింగ్ టైమ్';

  @override
  String get profileTotalTimeListened => 'Pulseలో మొత్తం పాటలు విన్న సమయం';

  @override
  String get profileYourTopSongs => 'మీ టాప్ పాటలు';

  @override
  String get profileListeningHistoryEmpty =>
      'మీ లిజనింగ్ హిస్టరీ ఇక్కడ కనిపిస్తుంది.';

  @override
  String profilePlays(int count) {
    return '$count సార్లు ప్లే అయ్యింది';
  }

  @override
  String get profileYourTopArtists => 'మీ టాప్ ఆర్టిస్ట్‌లు';

  @override
  String get profileTopArtistsEmpty =>
      'మీ ఫేవరెట్ ఆర్టిస్ట్‌లు ఇక్కడ కనిపిస్తారు.';

  @override
  String get profileArtistLabel => 'ఆర్టిస్ట్';

  @override
  String get profileSignOut => 'సైన్ అవుట్';

  @override
  String profileVersion(String version) {
    return 'వెర్షన్ $version';
  }

  @override
  String get profileMadeWithHeartBy => 'ప్రేమతో సృష్టించినది: ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'ప్రొఫైల్ ఎడిట్ చేయి';

  @override
  String get profileDisplayName => 'డిస్‌ప్లే పేరు';

  @override
  String get profileCancel => 'రద్దు చేయి';

  @override
  String get profileSave => 'సేవ్ చేయి';

  @override
  String get profileChooseAvatar => 'అవతార్ ఎంచుకోండి';

  @override
  String get searchMicPermissionRequired =>
      'ఈ ఫీచర్‌కి మైక్రోఫోన్ అనుమతి అవసరం';

  @override
  String get searchUnknownSong => 'తెలియని పాట';

  @override
  String get searchUnknownArtist => 'తెలియని ఆర్టిస్ట్';

  @override
  String get searchNoSongDetected => 'ఏ పాట గుర్తించబడలేదు.';

  @override
  String searchError(String message) {
    return 'లోపం: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'వాయిస్ సెర్చ్ అందుబాటులో లేదు';

  @override
  String get searchHint => 'పాటలు, ఆర్టిస్ట్‌లు, ఆల్బమ్‌లు...';

  @override
  String get searchRecentEmpty => 'మీ ఇటీవలి సెర్చ్‌లు ఇక్కడ కనిపిస్తాయి';

  @override
  String get searchRecentSearches => 'ఇటీవలి సెర్చ్‌లు';

  @override
  String get searchClearAll => 'అన్నీ క్లియర్ చేయి';

  @override
  String searchNoResultsFor(String query) {
    return '\"$query\"కి ఎలాంటి ఫలితాలు లేవు';
  }

  @override
  String get searchTryDifferentKeywords => 'వేరే పదాలతో ప్రయత్నించండి';

  @override
  String get searchTopResult => 'టాప్ రిజల్ట్';

  @override
  String get searchSongsLabel => 'పాటలు';

  @override
  String get searchArtistsLabel => 'ఆర్టిస్ట్‌లు';

  @override
  String get searchAlbumsLabel => 'ఆల్బమ్‌లు';

  @override
  String get searchPlaylistsLabel => 'ప్లేలిస్ట్‌లు';

  @override
  String get searchArtistLabel => 'ఆర్టిస్ట్';

  @override
  String get searchListening => 'వింటోంది...';

  @override
  String get searchSpeakNow => 'వెతకడానికి మాట్లాడండి';

  @override
  String get searchCancel => 'రద్దు చేయి';

  @override
  String get searchIdentifying => 'గుర్తిస్తోంది...';

  @override
  String get searchListeningForSong => 'పాట కోసం వింటోంది...';

  @override
  String get settingsTitle => 'సెట్టింగ్స్';

  @override
  String get settingsStreamingQuality => 'స్ట్రీమింగ్ క్వాలిటీ';

  @override
  String get settingsQualityAutomatic => 'ఆటోమేటిక్';

  @override
  String get settingsQualityLow => 'తక్కువ';

  @override
  String get settingsQualityNormal => 'సాధారణం';

  @override
  String get settingsQualityHigh => 'ఎక్కువ';

  @override
  String get settingsDownloadQuality => 'డౌన్‌లోడ్ క్వాలిటీ';

  @override
  String get settingsPlayback => 'ప్లేబ్యాక్';

  @override
  String get settingsCrossfade => 'క్రాస్‌ఫేడ్';

  @override
  String get settingsCrossfadeDesc =>
      'గ్యాప్‌లెస్ ట్రాన్సిషన్ కోసం ట్రాక్స్ ఓవర్‌లాప్ చేయండి';

  @override
  String get settingsDataUsage => 'డేటా వినియోగం';

  @override
  String get settingsDataSaver => 'డేటా సేవ‌ర్';

  @override
  String get settingsDataSaverDesc =>
      'మొబైల్ డేటాలో తక్కువ క్వాలిటీలో స్ట్రీమ్ చేయండి';

  @override
  String get settingsAppearance => 'రూపం';

  @override
  String get settingsLanguage => 'భాష';

  @override
  String get settingsCustomAccent => 'కస్టమ్ యాక్సెంట్';

  @override
  String get settingsSaturation => 'సాచురేషన్';

  @override
  String get settingsBrightness => 'బ్రైట్‌నెస్';

  @override
  String get settingsResetDefault => 'డిఫాల్ట్‌కి రీసెట్ చేయండి';

  @override
  String get playlistSheetTitle => 'ప్లేలిస్ట్‌కి యాడ్ చేయండి';

  @override
  String get playlistSheetNewPlaylist => 'కొత్త ప్లేలిస్ట్';

  @override
  String get playlistSheetNoPlaylists => 'ఇంకా ప్లేలిస్ట్‌లు లేవు';

  @override
  String playlistSheetSongsCount(int count) {
    return '$count పాటలు';
  }

  @override
  String get playlistSheetNameHint => 'ప్లేలిస్ట్ పేరు';

  @override
  String get playlistSheetCancel => 'రద్దు చేయి';

  @override
  String playlistSheetAddedTo(String name) {
    return '$nameకి యాడ్ అయ్యింది';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'క్రియేట్ చేయలేకపోయాము: అథెంటికేషన్ లోపం';

  @override
  String playlistSheetCreateFail(String error) {
    return 'క్రియేట్ చేయలేకపోయాము: $error';
  }

  @override
  String get playlistSheetCreate => 'క్రియేట్ చేయి';

  @override
  String get appUpdateAvailable => 'అప్‌డేట్ అందుబాటులో ఉంది';

  @override
  String appUpdateDesc(String version) {
    return 'వెర్షన్ $version వచ్చింది! కొత్త ఫీచర్స్ కోసం అప్‌డేట్ చేసుకోండి.';
  }

  @override
  String get appUpdateDownload => 'అప్‌డేట్ డౌన్‌లోడ్ చేయండి';

  @override
  String get navHome => 'హోమ్';

  @override
  String get navLibrary => 'లైబ్రరీ';

  @override
  String get navSearch => 'సెర్చ్';

  @override
  String get navSettings => 'సెట్టింగ్స్';

  @override
  String get navProfile => 'ప్రొఫైల్';

  @override
  String get artistSelect => 'ఆర్టిస్ట్‌ని ఎంచుకోండి';

  @override
  String get songActionQueue => 'క్యూకి యాడ్ చేయి';

  @override
  String get songActionPlaylist => 'ప్లేలిస్ట్‌కి యాడ్ చేయి';

  @override
  String get songActionFinding => 'వెతుకుతోంది...';

  @override
  String get songActionAlbum => 'ఆల్బమ్‌కి వెళ్ళు';

  @override
  String get songActionArtist => 'ఆర్టిస్ట్‌కి వెళ్ళు';

  @override
  String get songActionRemovePlaylist => 'ప్లేలిస్ట్ నుండి తీసివేయి';

  @override
  String get songActionRemoveDownload => 'డౌన్‌లోడ్స్ నుండి తీసివేయి';

  @override
  String get songActionDownloadChecking => 'చెక్ చేస్తోంది...';

  @override
  String get songActionDownloading => 'డౌన్‌లోడ్ అవుతోంది...';

  @override
  String get songActionDownloaded => 'డౌన్‌లోడ్ అయ్యింది!';

  @override
  String get songActionDownloadAlready => 'ఇంతకుముందే డౌన్‌లోడ్ అయ్యింది';

  @override
  String get songActionDownloadFailed => 'డౌన్‌లోడ్ విఫలమైంది';

  @override
  String get songActionDownload => 'డౌన్‌లోడ్';

  @override
  String get songActionDownloadingSnack => 'డౌన్‌లోడ్ అవుతోంది';

  @override
  String get songActionView => 'చూడండి';

  @override
  String get spotifyImportTitle => 'Spotify నుండి ఇంపోర్ట్ చేయండి';

  @override
  String get spotifyImportSubtitle => 'ప్లేలిస్ట్ సైజు ఎంచుకోండి';

  @override
  String get spotifyChoiceSmallTitle => '100 పాటలు లేదా అంతకంటే తక్కువ';

  @override
  String get spotifyChoiceSmallDesc =>
      'పబ్లిక్ Spotify ప్లేలిస్ట్ URL పేస్ట్ చేయండి.';

  @override
  String get spotifyChoiceLargeTitle => '100 పాటలకంటే ఎక్కువ';

  @override
  String get spotifyChoiceLargeDesc =>
      'అపరిమిత ట్రాక్స్ ఇంపోర్ట్ చేయడానికి మీ Spotify Developer App కనెక్ట్ చేయండి.';

  @override
  String get cancelButton => 'రద్దు చేయి';

  @override
  String get spotifyPlaylistsTitle => 'మీ Spotify ప్లేలిస్ట్‌లు';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'లోపం: $error\nమీ Client ID సరిగ్గా ఉందో లేదో చూసుకోండి.';
  }

  @override
  String get spotifyPlaylistsEmpty => 'మీ లైబ్రరీలో ఏ ప్లేలిస్ట్‌లు లేవు';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count ట్రాక్స్';
  }

  @override
  String get spotifyPlaylistsImport => 'ఇంపోర్ట్';

  @override
  String get audioPlaybackFailed =>
      'ప్లేబ్యాక్ విఫలమైంది. ఇంటర్నెట్ కనెక్షన్ చెక్ చేయండి.';

  @override
  String get audioControlPrevious => 'మునుపటి';

  @override
  String get audioControlPause => 'పాజ్';

  @override
  String get audioControlPlay => 'ప్లే';

  @override
  String get audioControlNext => 'తదుపరి';

  @override
  String get audioControlUnlike => 'అన్‌లైక్';

  @override
  String get audioControlLike => 'లైక్';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'రా రెస్పాన్స్: $data\n\nఫాల్‌బ్యాక్: $error';
  }

  @override
  String get apiErrorInvalidClient =>
      'ఇన్‌వాలిడ్ క్లయింట్ లేదా క్లయింట్ సీక్రెట్.';

  @override
  String get apiErrorBadRequest =>
      'బ్యాడ్ రిక్వెస్ట్. దయచేసి మీ వివరాలు చెక్ చేయండి.';

  @override
  String get apiErrorUnauthorized =>
      'అన్‌ఆథరైజ్డ్. దయచేసి మళ్ళీ లాగిన్ చేయండి.';

  @override
  String get apiErrorForbidden => 'ఫర్బిడెన్. మీకు యాక్సెస్ లేదు.';

  @override
  String get apiErrorNotFound => 'రీసోర్స్ దొరకలేదు.';

  @override
  String get apiErrorEmailInUse => 'ఈ ఇమెయిల్ అడ్రస్ ఇప్పటికే వాడుకలో ఉంది.';

  @override
  String get apiErrorUserNotFound => 'ఈ ఇమెయిల్‌తో ఏ ఖాతా కనుగొనబడలేదు.';

  @override
  String get apiErrorWrongPassword => 'తప్పు పాస్‌వర్డ్.';

  @override
  String get apiErrorInvalidCredential =>
      'లాగిన్ విఫలమైంది. మీ వివరాలు చెక్ చేయండి.';

  @override
  String get apiErrorNetwork => 'నెట్‌వర్క్ లోపం. మీ కనెక్షన్ చెక్ చేయండి.';

  @override
  String get apiErrorSocketTimeout =>
      'కనెక్షన్ టైమ్ అవుట్. దయచేసి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get apiErrorTooManyRequests =>
      'అతిగా రిక్వెస్ట్‌లు. కాసేపాగి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get apiErrorServerError =>
      'సర్వర్ లోపం. కొద్దిసేపటి తర్వాత మళ్ళీ ప్రయత్నించండి.';

  @override
  String get apiErrorInvalidEmail => 'దయచేసి సరైన ఇమెయిల్ అడ్రస్ ఇవ్వండి.';

  @override
  String get apiErrorWeakPassword =>
      'పాస్‌వర్డ్ చాలా వీక్. కనీసం 6 అక్షరాలు వాడండి.';

  @override
  String get apiErrorTooManyAttempts =>
      'అనేక విఫల ప్రయత్నాలు. తర్వాత మళ్ళీ ప్రయత్నించండి.';

  @override
  String get homeForgottenFavorites => 'మర్చిపోయిన ఇష్టాలు';

  @override
  String get artistShowAll => 'అన్నీ చూపించు';

  @override
  String get homeTopTracks => 'టాప్ ట్రాక్‌లు';
}
