// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'વિશે';

  @override
  String get artistPopular => 'લોકપ્રિય';

  @override
  String get artistAlbums => 'આલ્બમ્સ';

  @override
  String get artistSinglesAndEPs => 'સિંગલ્સ અને EP';

  @override
  String artistSubscribersCount(String count) {
    return '$count સબ્સ્ક્રાઇબર્સ';
  }

  @override
  String get artistPlayAll => 'બધા વગાડો';

  @override
  String get artistLoadError => 'કલાકાર લોડ થઈ શક્યા નથી';

  @override
  String get artistGoBack => 'પાછા જાઓ';

  @override
  String adminChatFailedToReply(String error) {
    return 'જવાબ આપી શક્યા નથી: $error';
  }

  @override
  String get adminChatSupportChat => 'સપોર્ટ ચેટ';

  @override
  String adminChatError(String error) {
    return 'ભૂલ: $error';
  }

  @override
  String get adminChatNoHistory => 'કોઈ અગાઉની વાતચીત નથી.';

  @override
  String get adminChatSupportYou => 'સપોર્ટ (તમે)';

  @override
  String get adminChatTypeReply => 'તમારો જવાબ લખો...';

  @override
  String get broadcastSuccess => 'જાહેરાત સફળતાપૂર્વક મોકલાઈ!';

  @override
  String broadcastFailed(String error) {
    return 'જાહેરાત મોકલી શક્યા નથી: $error';
  }

  @override
  String get broadcastTitle => 'ગ્લોબલ જાહેરાત';

  @override
  String get broadcastSubtitle => 'બધા વપરાશકર્તાઓને મોકલવામાં આવી';

  @override
  String get broadcastWarning => 'અહીં મોકલેલો સંદેશ દરેક જણ જોઈ શકશે.';

  @override
  String broadcastError(String error) {
    return 'ભૂલ: $error';
  }

  @override
  String get broadcastNoHistory => 'કોઈ અગાઉની જાહેરાત નથી.';

  @override
  String get broadcastTypeMessage => 'ગ્લોબલ જાહેરાત લખો...';

  @override
  String commFailedToSend(String error) {
    return 'મોકલી શક્યા નથી: $error';
  }

  @override
  String get commAdminDashboard => 'એડમિન ડેશબોર્ડ';

  @override
  String get commAdminSupport => 'એડમિન સપોર્ટ';

  @override
  String get commAlwaysHere => 'મદદ કરવા માટે હંમેશાં હાજર';

  @override
  String get commWelcomeTitle => 'નમસ્તે! 👋 હું આશુતોષ પાઠક';

  @override
  String get commWelcomeSubtitle => 'Pulse ના ડેવલપર';

  @override
  String get commWelcomeBody1 =>
      'હું આશા રાખું છું કે તમે જાહેરાતો અથવા સબ્સ્ક્રિપ્શન વગર તમારા મનપસંદ સંગીતનો આનંદ માણી રહ્યા છો. સંગીત ફક્ત પૈસાદાર લોકો માટે જ સીમિત ન હોવું જોઈએ.\n\nઆ વિભાગ આપણા સીધા સંપર્ક માટે છે.\n\nતમે મને જણાવી શકો છો:';

  @override
  String get commBullet1 => 'તમારો પ્રતિભાવ';

  @override
  String get commBullet2 => 'ભૂલ રિપોર્ટ';

  @override
  String get commBullet3 => 'નવા ફીચર્સનું સૂચન';

  @override
  String get commWelcomeBody2 =>
      'હું પોતે દરેક સંદેશ વાંચું છું અને તમારા સૂચનો સાથે એપને વધુ સારી બનાવીશ.\n\nશું તમારી પાસે એવી કોઈ એપનો વિચાર છે જે સબ્સ્ક્રિપ્શન પાછળ છુપાયેલી હોય? મને જણાવો! જો શક્ય હશે તો હું તે દરેક માટે બનાવીશ.\n\nઆ યાત્રામાં સાથે રહેવા બદલ આભાર. ❤️';

  @override
  String commError(String error) {
    return 'ભૂલ: $error';
  }

  @override
  String get commNoMessages => 'હજુ સુધી કોઈ સંદેશ નથી';

  @override
  String get commNoMessagesDesc =>
      'અમારી સપોર્ટ ટીમને સંદેશ મોકલો અથવા પછી ફરી તપાસો.';

  @override
  String get commMessageSupportHint => 'સપોર્ટ ટીમને લખો...';

  @override
  String get commGlobalAnnouncements => 'ગ્લોબલ જાહેરાતો';

  @override
  String get commSendMessagesToAll => 'બધાને સંદેશ મોકલો';

  @override
  String get homeGreetingMorning => 'શુભ સવાર,';

  @override
  String get homeGreetingAfternoon => 'શુભ બપોર,';

  @override
  String get homeGreetingEvening => 'શુભ સાંજ,';

  @override
  String get homeMember => 'સભ્ય';

  @override
  String get homeRecentPlaylists => 'તાજેતરના પ્લેલિસ્ટ્સ';

  @override
  String get homeRecentlyPlayed => 'તાજેતરમાં વગાડેલા';

  @override
  String get homeSpeedDial => 'સ્પીડ ડાયલ';

  @override
  String get homeNoContent => 'કોઈ સામગ્રી નથી';

  @override
  String get homeRefresh => 'રિફ્રેશ';

  @override
  String get homeLoadError => 'મ્યુઝિક ફીડ લોડ થઈ શક્યું નથી.';

  @override
  String get homeRetry => 'ફરી પ્રયાસ કરો';

  @override
  String get importSuccess => 'Spotify સફળતાપૂર્વક કનેક્ટ થયું!';

  @override
  String importFailed(String error) {
    return 'કનેક્ટ થઈ શક્યું નથી: $error';
  }

  @override
  String get importTitle => 'Spotify કનેક્ટ કરો';

  @override
  String get importSetupTitle => 'Spotify સેટઅપ';

  @override
  String get importSetupDesc =>
      'Spotify મર્યાદાઓને દૂર કરી તમારા પ્લેલિસ્ટ્સને ઝડપથી ઈમ્પોર્ટ કરવા માટે તમારી પોતાની ડેવલપર કીનો ઉપયોગ કરો. આ પગલાં અનુસરો:';

  @override
  String get importStep1 => 'Spotify Developer Dashboard ખોલો.';

  @override
  String get importStep2 => 'લોગ ઇન કરો અને \"Create app\" પર ક્લિક કરો.';

  @override
  String get importStep3 => 'એપનું નામ અને વર્ણન આપો.';

  @override
  String get importStep4 => '\"Redirect URIs\" હેઠળ આ ચોક્કસ URL પેસ્ટ કરો:';

  @override
  String get importRedirectCopied => 'રિડાયરેક્ટ URI કૉપિ થયું!';

  @override
  String get importStep5 =>
      'એપ સેવ કરો, સેટિંગ્સમાંથી તમારી \"Client ID\" કૉપિ કરો અને નીચે પેસ્ટ કરો.';

  @override
  String get importImportant =>
      'મહત્વપૂર્ણ: આ ડેવલપર એપ બનાવવા માટે ઉપયોગમાં લેવાયેલ Spotify એકાઉન્ટમાં એક્ટિવ પ્રીમિયમ સબ્સ્ક્રિપ્શન હોવું આવશ્યક છે.';

  @override
  String get importClientIdHint => 'તમારી Spotify Client ID અહીં પેસ્ટ કરો...';

  @override
  String get importConnectButton => 'કનેક્ટ કરો અને લાઇબ્રેરી લોડ કરો';

  @override
  String get downloadingNoActive => 'કોઈ સક્રિય ડાઉનલોડ નથી';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'ડાઉનલોડ્સ';

  @override
  String downloadsStats(String count, String size) {
    return '$count ગીતો • $size';
  }

  @override
  String get downloadsNoOffline => 'કોઈ ઑફલાઇન ગીતો નથી';

  @override
  String get downloadsNoOfflineDesc => 'તમે ડાઉનલોડ કરેલા ગીતો અહીં દેખાશે';

  @override
  String get downloadsClearAllTitle => 'બધું ક્લિયર કરવું છે?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'આ $count ગીતો ડિલીટ કરશે અને $size સ્ટોરેજ ખાલી કરશે.';
  }

  @override
  String get downloadsCancel => 'રદ કરો';

  @override
  String get downloadsClearAll => 'બધું ક્લિયર';

  @override
  String downloadsSongsCount(String count) {
    return '$count ગીતો';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count ગીત';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'મુખ્ય ડાઉનલોડ પ્લેલિસ્ટનું નામ બદલી શકાતું નથી.';

  @override
  String get downloadsRename => 'નામ બદલો';

  @override
  String get downloadsEditSongs => 'ગીતો એડિટ કરો';

  @override
  String get downloadsDelete => 'ડિલીટ કરો';

  @override
  String get downloadsRenamePlaylistTitle => 'પ્લેલિસ્ટનું નામ બદલો';

  @override
  String get downloadsRenamePlaylistDesc => 'પ્લેલિસ્ટ માટે નવું નામ લખો.';

  @override
  String get downloadsDeletePlaylistTitle => 'પ્લેલિસ્ટ ડિલીટ કરવું છે?';

  @override
  String get downloadsDeleteMasterDesc =>
      'શું તમને ખાતરી છે? તમે બધા ડાઉનલોડ કરેલા ગીતો અને પ્લેલિસ્ટ્સ કાયમ માટે ગુમાવશો.';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'શું તમને ખાતરી છે કે તમે \"$name\" ડિલીટ કરવા માંગો છો? આ પ્લેલિસ્ટ કાયમ માટે જતું રહેશે.';
  }

  @override
  String get downloadsSave => 'સેવ કરો';

  @override
  String get downloadsNoSongs => 'આ પ્લેલિસ્ટમાં કોઈ ગીતો નથી.';

  @override
  String get libraryTitle => 'લાઇબ્રેરી';

  @override
  String get libraryPauseAll => 'બધું પોઝ કરો';

  @override
  String get libraryResumeAll => 'બધું ફરી શરૂ કરો';

  @override
  String get libraryTabPlaylists => 'પ્લેલિસ્ટ્સ';

  @override
  String get libraryTabDownloads => 'ડાઉનલોડ્સ';

  @override
  String get libraryTabDownloading => 'ડાઉનલોડ થઈ રહ્યું છે';

  @override
  String libraryImportedTask(String name) {
    return '$name ઈમ્પોર્ટ થયું';
  }

  @override
  String get libraryImportWaiting => 'રાહ જોઈ રહ્યું છે...';

  @override
  String get libraryImportFetching => 'પ્લેલિસ્ટ લાવી રહ્યું છે...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total પ્રોસેસ્ડ · $matched મળ્યાં';
  }

  @override
  String get libraryImportSaving => 'લાઇબ્રેરીમાં સેવ કરી રહ્યું છે...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched ગીતો ઉમેર્યા · બંધ કરવા માટે × દબાવો';
  }

  @override
  String get libraryImportDoneAll => 'બધા ગીતો ઉમેર્યા · બંધ કરવા માટે × દબાવો';

  @override
  String get libraryAddButton => 'ઉમેરો';

  @override
  String get librarySortRecent => 'તાજેતરમાં ઉમેરેલા';

  @override
  String get librarySortAlpha => 'આલ્ફાબેટિકલ';

  @override
  String get libraryEmptyTitle => 'તમારી લાઇબ્રેરી ખાલી છે.';

  @override
  String get libraryEmptyDesc =>
      'તમારું પ્રથમ Pulse શરૂ કરવા માટે \"ઉમેરો\" દબાવો.';

  @override
  String get libraryRenameLikedError =>
      'Liked Songs પ્લેલિસ્ટનું નામ બદલી શકાતું નથી.';

  @override
  String get libraryRename => 'નામ બદલો';

  @override
  String get libraryEditSongs => 'ગીતો એડિટ કરો';

  @override
  String get libraryDeleteLikedError =>
      'Liked Songs પ્લેલિસ્ટ ડિલીટ કરી શકાતું નથી.';

  @override
  String get libraryDelete => 'ડિલીટ કરો';

  @override
  String get libraryEditSongsTitle => 'ગીતો એડિટ કરો';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count ગીત';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count ગીતો';
  }

  @override
  String get libraryCancel => 'રદ કરો';

  @override
  String get librarySave => 'સેવ કરો';

  @override
  String get libraryNoSongs => 'આ પ્લેલિસ્ટમાં કોઈ ગીતો નથી.';

  @override
  String get libraryAddOptionsTitle => 'લાઇબ્રેરીમાં ઉમેરો';

  @override
  String get libraryAddOptionsDesc =>
      'તમારી Pulse લાઇબ્રેરી કેવી રીતે વધારવી તે પસંદ કરો';

  @override
  String get libraryImportPulse => 'Pulse માંથી ઈમ્પોર્ટ કરો';

  @override
  String get libraryImportPulseDesc => 'એક Pulse પ્લેલિસ્ટ URL પેસ્ટ કરો';

  @override
  String get libraryImportYtm => 'YT Music માંથી ઈમ્પોર્ટ કરો';

  @override
  String get libraryImportYtmDesc => 'એક પબ્લિક પ્લેલિસ્ટ URL પેસ્ટ કરો';

  @override
  String get libraryImportSpotify => 'Spotify માંથી ઈમ્પોર્ટ કરો';

  @override
  String get libraryImportSpotifyDesc => 'તમારું Spotify કનેક્ટ કરો';

  @override
  String get libraryClose => 'બંધ કરો';

  @override
  String get libraryImportYtmFull => 'YouTube Music માંથી ઈમ્પોર્ટ કરો';

  @override
  String get libraryImportSpotifyFull => 'Spotify માંથી ઈમ્પોર્ટ કરો (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'એક પબ્લિક YouTube Music પ્લેલિસ્ટ અથવા આલ્બમ URL પેસ્ટ કરો';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'એક પબ્લિક Spotify પ્લેલિસ્ટ URL નીચે પેસ્ટ કરો';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Pulse પ્લેલિસ્ટ ઈમ્પોર્ટ કરી શકાયું નથી';

  @override
  String get importErrorPlaylist => 'પ્લેલિસ્ટ ઈમ્પોર્ટ કરવામાં ભૂલ';

  @override
  String get importErrorHighlyPopulated =>
      'પ્લેલિસ્ટ ખૂબ મોટું છે, લાવવામાં થોડો સમય લાગી શકે છે.';

  @override
  String get libraryImportBtn => 'ઈમ્પોર્ટ કરો';

  @override
  String get libraryCreateTitle => 'નવું પ્લેલિસ્ટ';

  @override
  String get libraryCreateDesc => 'તમારા નવા પ્લેલિસ્ટનું નામ શું રાખવું છે?';

  @override
  String get libraryCreateHint => 'ઉદા. Midnight Rides';

  @override
  String get libraryCreateBtn => 'બનાવો';

  @override
  String get libraryRenameTitle => 'પ્લેલિસ્ટનું નામ બદલો';

  @override
  String get libraryRenameDesc => 'પ્લેલિસ્ટ માટે નવું નામ લખો.';

  @override
  String get libraryRenameBtn => 'નામ બદલો';

  @override
  String get libraryDeleteTitle => 'પ્લેલિસ્ટ ડિલીટ કરવું છે?';

  @override
  String libraryDeleteDesc(String name) {
    return 'શું તમને ખાતરી છે કે તમે \"$name\" ડિલીટ કરવા માંગો છો? આ પ્લેલિસ્ટ કાયમ માટે જતું રહેશે.';
  }

  @override
  String get libraryDeleteBtn => 'ડિલીટ';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'તાજેતરનું';

  @override
  String librarySongsCount(String count) {
    return '$count ગીતો';
  }

  @override
  String get libraryComingSoon => 'જલ્દી આવે છે';

  @override
  String get loginErrName => 'કૃપા કરીને તમારું નામ આપો';

  @override
  String get loginErrEmail => 'કૃપા કરીને તમારું ઈમેલ આપો';

  @override
  String get loginErrPassword => 'કૃપા કરીને તમારો પાસવર્ડ આપો';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'દરેક બીટ અનુભવો!';

  @override
  String get loginMadeWithHeartBy => 'પ્રેમથી બનાવ્યું છે: ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'તમારું નામ';

  @override
  String get loginHintEmail => 'ઈમેલ એડ્રેસ';

  @override
  String get loginHintPassword => 'પાસવર્ડ';

  @override
  String get loginErrEmailReset => 'પાસવર્ડ રીસેટ કરવા માટે ઈમેલ આપો';

  @override
  String get loginResetSent => 'રીસેટ ઈમેલ મોકલવામાં આવ્યો! ઇનબોક્સ તપાસો.';

  @override
  String get loginForgotPwd => 'પાસવર્ડ ભૂલી ગયા છો?';

  @override
  String get loginBtnSignup => 'એકાઉન્ટ બનાવો';

  @override
  String get loginBtnSignin => 'સાઇન ઇન';

  @override
  String get loginToggleHaveAccount => 'પહેલેથી જ Pulse એકાઉન્ટ છે? ';

  @override
  String get loginToggleNoAccount => 'Pulse એકાઉન્ટ નથી? ';

  @override
  String get loginToggleSignin => 'સાઇન ઇન';

  @override
  String get loginToggleSignup => 'સાઇન અપ';

  @override
  String get offlineStillOffline => 'હજુ ઑફલાઇન. કનેક્શન તપાસો.';

  @override
  String get offlineTitle => 'તમે ઑફલાઇન છો';

  @override
  String get offlineSubtitle =>
      'કોઈ ઈન્ટરનેટ કનેક્શન નથી.\nનેટવર્ક તપાસો અને ફરી પ્રયાસ કરો.';

  @override
  String get offlineChecking => 'તપાસી રહ્યું છે...';

  @override
  String get offlineRetry => 'ફરી પ્રયાસ કરો';

  @override
  String get offlineGoToDownloads => 'ડાઉનલોડ્સમાં જાઓ';

  @override
  String get playerMadeWithHeartBy => 'પ્રેમથી બનાવ્યું છે: ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'લિરિક્સ માટે સ્વાઇપ કરો';

  @override
  String get playerNoLyrics => 'કોઈ લિરિક્સ ઉપલબ્ધ નથી';

  @override
  String get playerUpNext => 'આગળ';

  @override
  String get playerNoTracksInQueue => 'કતારમાં કોઈ ગીતો નથી';

  @override
  String get playerNoMusicPlaying => 'કોઈ સંગીત વાગતું નથી';

  @override
  String get playerPickAVibe => 'તમારી લાઇબ્રેરી અથવા હોમમાંથી એક ગીત પસંદ કરો';

  @override
  String get playerGoHome => 'હોમ પર જાઓ';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'ઈક્વલાઇઝર';

  @override
  String get playerEqCustom => 'કસ્ટમ';

  @override
  String get playlistDownloads => 'ડાઉનલોડ્સ';

  @override
  String get playlistOffline => 'ઑફલાઇન પ્લેલિસ્ટ';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hoursક $minsમિ';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$minsમિ';
  }

  @override
  String get playlistFindOnPage => 'આ પેજ પર શોધો';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count ગીતો • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'તાજેતરનું';

  @override
  String get playlistNoMatches => 'કંઈ મળ્યું નથી.';

  @override
  String get playlistNoTracks => 'આ પ્લેલિસ્ટમાં કોઈ ગીતો નથી.';

  @override
  String get playlistNoSongsYet => 'હજુ સુધી કોઈ ગીતો નથી.';

  @override
  String get playlistSortRecentlyAdded => 'તાજેતરમાં ઉમેરેલા';

  @override
  String get playlistSortAlphabetical => 'આલ્ફાબેટિકલ';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ગીતો',
      one: 'ગીત',
    );
    return '$count $_temp0 ડાઉનલોડ થઈ રહ્યા છે';
  }

  @override
  String get playlistView => 'જુઓ';

  @override
  String get playlistAllDownloaded => 'બધા ગીતો પહેલેથી જ ડાઉનલોડ કરેલા છે';

  @override
  String playlistShareText(String name, String url) {
    return 'Pulse પર \"$name\" સાંભળો!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'ડાઉનલોડ્સમાંથી દૂર કરો';

  @override
  String get playlistRemoveFromPlaylist => 'પ્લેલિસ્ટમાંથી દૂર કરો';

  @override
  String get playlistLoadError => 'આ પ્લેલિસ્ટ લોડ કરી શકાયું નથી.';

  @override
  String get playlistGoBack => '← પાછા જાઓ';

  @override
  String get profileNotLoggedIn => 'લૉગ ઇન નથી';

  @override
  String get profileSignIn => 'સાઇન ઇન';

  @override
  String get profileDefaultUser => 'Pulse વપરાશકર્તા';

  @override
  String get profileEditProfile => 'પ્રોફાઇલ એડિટ';

  @override
  String get profileTimeframeDay => 'દિવસ';

  @override
  String get profileTimeframeWeek => 'અઠવાડિયું';

  @override
  String get profileTimeframeMonth => 'મહિનો';

  @override
  String get profileTimeframeYear => 'વર્ષ';

  @override
  String get profileListeningTime => 'સાંભળવાનો સમય';

  @override
  String get profileToday => 'આજે';

  @override
  String get profileThisWeek => 'આ અઠવાડિયે';

  @override
  String get profileThisMonth => 'આ મહિને';

  @override
  String get profileThisYear => 'આ વર્ષે';

  @override
  String get profileDailyAvg => 'દૈનિક સરેરાશ';

  @override
  String get profilePerDay => 'દરરોજ';

  @override
  String get profileLifetimeListening => 'કુલ સાંભળવાનો સમય';

  @override
  String get profileTotalTimeListened => 'Pulse પર સંગીત સાંભળવાનો કુલ સમય';

  @override
  String get profileYourTopSongs => 'તમારા મનપસંદ ગીતો';

  @override
  String get profileListeningHistoryEmpty =>
      'તમારી સાંભળવાની હિસ્ટ્રી અહીં દેખાશે.';

  @override
  String profilePlays(int count) {
    return '$count વખત વગાડ્યું';
  }

  @override
  String get profileYourTopArtists => 'તમારા મનપસંદ કલાકારો';

  @override
  String get profileTopArtistsEmpty => 'તમારા મનપસંદ કલાકારો અહીં દેખાશે.';

  @override
  String get profileArtistLabel => 'કલાકાર';

  @override
  String get profileSignOut => 'સાઇન આઉટ';

  @override
  String profileVersion(String version) {
    return 'વર્ઝન $version';
  }

  @override
  String get profileMadeWithHeartBy => 'પ્રેમથી બનાવ્યું છે: ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'પ્રોફાઇલ એડિટ';

  @override
  String get profileDisplayName => 'ડિસ્પ્લે નામ';

  @override
  String get profileCancel => 'રદ કરો';

  @override
  String get profileSave => 'સેવ કરો';

  @override
  String get profileChooseAvatar => 'અવતાર પસંદ કરો';

  @override
  String get searchMicPermissionRequired =>
      'આ ફીચર માટે માઇક્રોફોન પરમિશન જરૂરી છે';

  @override
  String get searchUnknownSong => 'અજાણ્યું ગીત';

  @override
  String get searchUnknownArtist => 'અજાણ્યા કલાકાર';

  @override
  String get searchNoSongDetected => 'કોઈ ગીત મળ્યું નથી.';

  @override
  String searchError(String message) {
    return 'ભૂલ: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'વૉઇસ સર્ચ ઉપલબ્ધ નથી';

  @override
  String get searchHint => 'ગીતો, કલાકારો, આલ્બમ્સ...';

  @override
  String get searchRecentEmpty => 'તમારા તાજેતરના સર્ચ અહીં દેખાશે';

  @override
  String get searchRecentSearches => 'તાજેતરના સર્ચ';

  @override
  String get searchClearAll => 'બધું ક્લિયર';

  @override
  String searchNoResultsFor(String query) {
    return '\"$query\" માટે કોઈ પરિણામો નથી';
  }

  @override
  String get searchTryDifferentKeywords => 'અલગ શબ્દો સાથે પ્રયાસ કરો';

  @override
  String get searchTopResult => 'ટોપ રિઝલ્ટ';

  @override
  String get searchSongsLabel => 'ગીતો';

  @override
  String get searchArtistsLabel => 'કલાકારો';

  @override
  String get searchAlbumsLabel => 'આલ્બમ્સ';

  @override
  String get searchPlaylistsLabel => 'પ્લેલિસ્ટ્સ';

  @override
  String get searchArtistLabel => 'કલાકાર';

  @override
  String get searchListening => 'સાંભળી રહ્યું છે...';

  @override
  String get searchSpeakNow => 'સર્ચ કરવા માટે હવે બોલો';

  @override
  String get searchCancel => 'રદ કરો';

  @override
  String get searchIdentifying => 'ઓળખી રહ્યું છે...';

  @override
  String get searchListeningForSong => 'ગીત માટે સાંભળી રહ્યું છે...';

  @override
  String get settingsTitle => 'સેટિંગ્સ';

  @override
  String get settingsStreamingQuality => 'સ્ટ્રીમિંગ ગુણવત્તા';

  @override
  String get settingsQualityAutomatic => 'ઓટોમેટિક';

  @override
  String get settingsQualityLow => 'ઓછી';

  @override
  String get settingsQualityNormal => 'સામાન્ય';

  @override
  String get settingsQualityHigh => 'ઉચ્ચ';

  @override
  String get settingsDownloadQuality => 'ડાઉનલોડ ગુણવત્તા';

  @override
  String get settingsPlayback => 'પ્લેબેક';

  @override
  String get settingsCrossfade => 'ક્રોસફેડ';

  @override
  String get settingsCrossfadeDesc => 'સ્મૂધ ટ્રાન્ઝિશન માટે ગીતો ઓવરલેપ કરો';

  @override
  String get settingsDataUsage => 'ડેટા વપરાશ';

  @override
  String get settingsDataSaver => 'ડેટા સેવર';

  @override
  String get settingsDataSaverDesc =>
      'મોબાઇલ ડેટા પર ઓછી ગુણવત્તામાં સ્ટ્રીમ કરો';

  @override
  String get settingsAppearance => 'દેખાવ';

  @override
  String get settingsLanguage => 'ભાષા';

  @override
  String get settingsCustomAccent => 'કસ્ટમ એક્સેન્ટ';

  @override
  String get settingsSaturation => 'સેચ્યુરેશન';

  @override
  String get settingsBrightness => 'બ્રાઇટનેસ';

  @override
  String get settingsResetDefault => 'ડિફોલ્ટ પર રીસેટ કરો';

  @override
  String get playlistSheetTitle => 'પ્લેલિસ્ટમાં ઉમેરો';

  @override
  String get playlistSheetNewPlaylist => 'નવું પ્લેલિસ્ટ';

  @override
  String get playlistSheetNoPlaylists => 'કોઈ પ્લેલિસ્ટ નથી';

  @override
  String playlistSheetSongsCount(int count) {
    return '$count ગીતો';
  }

  @override
  String get playlistSheetNameHint => 'પ્લેલિસ્ટનું નામ';

  @override
  String get playlistSheetCancel => 'રદ કરો';

  @override
  String playlistSheetAddedTo(String name) {
    return '$name માં ઉમેર્યું';
  }

  @override
  String get playlistSheetCreateFailAuth => 'બનાવી શકાયું નથી: ઓથેન્ટિકેશન ભૂલ';

  @override
  String playlistSheetCreateFail(String error) {
    return 'બનાવી શકાયું નથી: $error';
  }

  @override
  String get playlistSheetCreate => 'બનાવો';

  @override
  String get appUpdateAvailable => 'અપડેટ ઉપલબ્ધ';

  @override
  String appUpdateDesc(String version) {
    return 'વર્ઝન $version આવી ગયું છે! નવા ફીચર્સ માટે અપડેટ કરો.';
  }

  @override
  String get appUpdateDownload => 'અપડેટ ડાઉનલોડ કરો';

  @override
  String get navHome => 'હોમ';

  @override
  String get navLibrary => 'લાઇબ્રેરી';

  @override
  String get navSearch => 'સર્ચ';

  @override
  String get navSettings => 'સેટિંગ્સ';

  @override
  String get navProfile => 'પ્રોફાઇલ';

  @override
  String get artistSelect => 'કલાકાર પસંદ કરો';

  @override
  String get songActionQueue => 'કતારમાં ઉમેરો';

  @override
  String get songActionPlaylist => 'પ્લેલિસ્ટમાં ઉમેરો';

  @override
  String get songActionFinding => 'શોધી રહ્યું છે...';

  @override
  String get songActionAlbum => 'આલ્બમ પર જાઓ';

  @override
  String get songActionArtist => 'કલાકાર પર જાઓ';

  @override
  String get songActionRemovePlaylist => 'પ્લેલિસ્ટમાંથી દૂર કરો';

  @override
  String get songActionRemoveDownload => 'ડાઉનલોડ્સમાંથી દૂર કરો';

  @override
  String get songActionDownloadChecking => 'તપાસી રહ્યું છે...';

  @override
  String get songActionDownloading => 'ડાઉનલોડ થઈ રહ્યું છે...';

  @override
  String get songActionDownloaded => 'ડાઉનલોડ થઈ ગયું!';

  @override
  String get songActionDownloadAlready => 'પહેલેથી જ ડાઉનલોડ કરેલું છે';

  @override
  String get songActionDownloadFailed => 'ડાઉનલોડ નિષ્ફળ થયું';

  @override
  String get songActionDownload => 'ડાઉનલોડ';

  @override
  String get songActionDownloadingSnack => 'ડાઉનલોડ થઈ રહ્યું છે';

  @override
  String get songActionView => 'જુઓ';

  @override
  String get spotifyImportTitle => 'Spotify માંથી ઈમ્પોર્ટ કરો';

  @override
  String get spotifyImportSubtitle => 'પ્લેલિસ્ટનું કદ પસંદ કરો';

  @override
  String get spotifyChoiceSmallTitle => '100 ગીતો કે તેથી ઓછા';

  @override
  String get spotifyChoiceSmallDesc =>
      'એક પબ્લિક Spotify પ્લેલિસ્ટ URL પેસ્ટ કરો.';

  @override
  String get spotifyChoiceLargeTitle => '100 થી વધુ ગીતો';

  @override
  String get spotifyChoiceLargeDesc =>
      'અમર્યાદિત ટ્રેક્સ ઈમ્પોર્ટ કરવા માટે તમારી પોતાની Spotify Developer App કનેક્ટ કરો.';

  @override
  String get cancelButton => 'રદ કરો';

  @override
  String get spotifyPlaylistsTitle => 'તમારા Spotify પ્લેલિસ્ટ્સ';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'ભૂલ: $error\nતમારી Client ID સાચી છે કે કેમ તે તપાસો.';
  }

  @override
  String get spotifyPlaylistsEmpty => 'તમારી લાઇબ્રેરીમાં કોઈ પ્લેલિસ્ટ્સ નથી';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count ટ્રેક્સ';
  }

  @override
  String get spotifyPlaylistsImport => 'ઈમ્પોર્ટ';

  @override
  String get audioPlaybackFailed => 'પ્લેબેક નિષ્ફળ. ઇન્ટરનેટ કનેક્શન તપાસો.';

  @override
  String get audioControlPrevious => 'પાછલું';

  @override
  String get audioControlPause => 'પોઝ';

  @override
  String get audioControlPlay => 'પ્લે';

  @override
  String get audioControlNext => 'આગળ';

  @override
  String get audioControlUnlike => 'અનલાઇક';

  @override
  String get audioControlLike => 'લાઇક';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'મૂળ પ્રતિસાદ: $data\n\nફોલબેક: $error';
  }

  @override
  String get apiErrorInvalidClient => 'ખોટો ક્લાયન્ટ અથવા ક્લાયન્ટ સિક્રેટ.';

  @override
  String get apiErrorBadRequest =>
      'ખરાબ વિનંતી. કૃપા કરીને તમારું ઇનપુટ તપાસો.';

  @override
  String get apiErrorUnauthorized => 'અનધિકૃત. કૃપા કરીને ફરી લોગ ઇન કરો.';

  @override
  String get apiErrorForbidden => 'પ્રતિબંધિત. તમને ઍક્સેસ નથી.';

  @override
  String get apiErrorNotFound => 'સંસાધન મળ્યું નથી.';

  @override
  String get apiErrorEmailInUse => 'આ ઇમેઇલ સરનામું પહેલેથી જ ઉપયોગમાં છે.';

  @override
  String get apiErrorUserNotFound =>
      'આ ઇમેઇલ સાથે સંકળાયેલ કોઈ એકાઉન્ટ મળ્યું નથી.';

  @override
  String get apiErrorWrongPassword => 'ખોટો પાસવર્ડ.';

  @override
  String get apiErrorInvalidCredential =>
      'લોગ ઇન નિષ્ફળ થયું. તમારી માહિતી તપાસો.';

  @override
  String get apiErrorNetwork => 'નેટવર્ક ભૂલ. તમારું કનેક્શન તપાસો.';

  @override
  String get apiErrorSocketTimeout => 'કનેક્શન ટાઇમઆઉટ. ફરી પ્રયાસ કરો.';

  @override
  String get apiErrorTooManyRequests =>
      'ખૂબ બધી વિનંતીઓ. થોડીવાર પછી ફરી પ્રયાસ કરો.';

  @override
  String get apiErrorServerError => 'સર્વર ભૂલ. થોડીવાર પછી ફરી પ્રયાસ કરો.';

  @override
  String get apiErrorInvalidEmail => 'કૃપા કરીને માન્ય ઇમેઇલ સરનામું આપો.';

  @override
  String get apiErrorWeakPassword =>
      'પાસવર્ડ ખૂબ નબળો છે. ઓછામાં ઓછા 6 અક્ષરોનો ઉપયોગ કરો.';

  @override
  String get apiErrorTooManyAttempts =>
      'ઘણી બધી નિષ્ફળ પ્રયાસો. પછીથી ફરી પ્રયાસ કરો.';

  @override
  String get homeForgottenFavorites => 'ભૂલી ગયેલ મનગમતા';

  @override
  String get artistShowAll => 'બધા બતાવો';

  @override
  String get homeTopTracks => 'ટોચના ટ્રેક';
}
