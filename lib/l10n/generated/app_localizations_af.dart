// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Afrikaans (`af`).
class AppLocalizationsAf extends AppLocalizations {
  AppLocalizationsAf([String locale = 'af']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'Oor';

  @override
  String get artistPopular => 'Gewild';

  @override
  String get artistAlbums => 'Albums';

  @override
  String get artistSinglesAndEPs => 'Enkelsnitte en EP\'s';

  @override
  String artistSubscribersCount(String count) {
    return '$count intekenare';
  }

  @override
  String get artistPlayAll => 'Speel Alles';

  @override
  String get artistLoadError => 'Kon nie kunstenaar laai nie';

  @override
  String get artistGoBack => 'Gaan Terug';

  @override
  String adminChatFailedToReply(String error) {
    return 'Kon nie antwoord nie: $error';
  }

  @override
  String get adminChatSupportChat => 'Ondersteuning Klets';

  @override
  String adminChatError(String error) {
    return 'Fout: $error';
  }

  @override
  String get adminChatNoHistory => 'Geen gesprekgeskiedenis nie.';

  @override
  String get adminChatSupportYou => 'Ondersteuning (Jy)';

  @override
  String get adminChatTypeReply => 'Tik jou antwoord...';

  @override
  String get broadcastSuccess => 'Aankondiging is suksesvol uitgesaai!';

  @override
  String broadcastFailed(String error) {
    return 'Kon nie uitsaai nie: $error';
  }

  @override
  String get broadcastTitle => 'Globale aankondigings';

  @override
  String get broadcastSubtitle => 'Gestuur aan alle gebruikers';

  @override
  String get broadcastWarning =>
      'Boodskappe wat hierheen gestuur word, sal vir almal sigbaar wees.';

  @override
  String broadcastError(String error) {
    return 'Fout: $error';
  }

  @override
  String get broadcastNoHistory => 'Geen vorige aankondigings nie.';

  @override
  String get broadcastTypeMessage => 'Tik \'n wêreldwye uitsending...';

  @override
  String commFailedToSend(String error) {
    return 'Kon nie stuur nie: $error';
  }

  @override
  String get commAdminDashboard => 'Admin Dashboard';

  @override
  String get commAdminSupport => 'Admin Ondersteuning';

  @override
  String get commAlwaysHere => 'Altyd hier om te help';

  @override
  String get commWelcomeTitle => 'Haai! 👋 Ek is Ashutosh Pathak';

  @override
  String get commWelcomeSubtitle => 'Ontwikkelaar van Pulse';

  @override
  String get commWelcomeBody1 =>
      'Ek hoop jy geniet dit om na jou gunsteling musiek te luister sonder irriterende advertensies of intekeningversperrings. Musiek moet tog nie saam met \'n betaalmuur kom net omdat iemand in \'n raadsaal nog \'n seiljag nodig gehad het nie.\n\nHierdie afdeling is hier sodat ons direk kan koppel.\n\nVoel vry om:';

  @override
  String get commBullet1 => 'Deel jou terugvoer';

  @override
  String get commBullet2 => 'Rapporteer foute';

  @override
  String get commBullet3 => 'Stel nuwe kenmerke voor wat jy graag wil sien';

  @override
  String get commWelcomeBody2 =>
      'Ek lees persoonlik elke boodskap en sal my bes doen om die toepassing te verbeter op grond van jou voorstelle.\n\nHet jy \'n idee vir \'n toepassing wat nog nie bestaan ​​nie, of een wat agter duur intekeninge opgesluit is? Vertel my daarvan! As dit moontlik is, sal ek probeer om dit te bou en dit vir almal beskikbaar te stel.\n\nDankie dat jy my toepassing gebruik en dat jy deel was van hierdie reis. ❤️';

  @override
  String commError(String error) {
    return 'Fout: $error';
  }

  @override
  String get commNoMessages => 'Nog geen boodskappe nie';

  @override
  String get commNoMessagesDesc =>
      'Stuur \'n boodskap aan ons ondersteuningspan of kom kyk later vir aankondigings.';

  @override
  String get commMessageSupportHint => 'Boodskapondersteuning...';

  @override
  String get commGlobalAnnouncements => 'Globale aankondigings';

  @override
  String get commSendMessagesToAll => 'Stuur boodskappe aan alle gebruikers';

  @override
  String get homeGreetingMorning => 'Goeie môre,';

  @override
  String get homeGreetingAfternoon => 'Goeie middag,';

  @override
  String get homeGreetingEvening => 'Goeienaand,';

  @override
  String get homeMember => 'Lid';

  @override
  String get homeRecentPlaylists => 'Onlangse snitlyste';

  @override
  String get homeRecentlyPlayed => 'Onlangs gespeel';

  @override
  String get homeSpeedDial => 'Vinnige Toegang';

  @override
  String get homeNoContent => 'Geen inhoud beskikbaar nie';

  @override
  String get homeRefresh => 'Verfris';

  @override
  String get homeLoadError => 'Kon nie musiekstroom laai nie.';

  @override
  String get homeRetry => 'Probeer weer';

  @override
  String get importSuccess => 'Suksesvol aan Spotify gekoppel!';

  @override
  String importFailed(String error) {
    return 'Kon nie koppel nie: $error';
  }

  @override
  String get importTitle => 'Koppel Spotify';

  @override
  String get importSetupTitle => 'Stel Spotify-integrasie op';

  @override
  String get importSetupDesc =>
      'Om Spotify se streng tarieflimiete te omseil en al jou snitlyste onmiddellik in te voer, moet jy jou eie gratis ontwikkelaarsleutel gebruik. Volg hierdie eenvoudige stappe:';

  @override
  String get importStep1 => 'Maak die Spotify-ontwikkelaarkontroleskerm oop.';

  @override
  String get importStep2 => 'Meld aan en klik \"Skep app\".';

  @override
  String get importStep3 => 'Vul enige programnaam en -beskrywing in.';

  @override
  String get importStep4 =>
      'Onder \"Herlei URI\'s\", plak die volgende presiese URL:';

  @override
  String get importRedirectCopied => 'Herlei URI gekopieer!';

  @override
  String get importStep5 =>
      'Stoor die toepassing, kopieer jou \"kliënt-ID\" vanaf instellings, en plak dit hieronder.';

  @override
  String get importImportant =>
      'Belangrik: Die Spotify-rekening wat gebruik word om hierdie ontwikkelaarprogram te skep, moet \'n aktiewe Premium-intekening hê.';

  @override
  String get importClientIdHint => 'Plak jou Spotify-kliënt-ID hier...';

  @override
  String get importConnectButton => 'Koppel en laai biblioteek';

  @override
  String get downloadingNoActive => 'Geen aktiewe aflaaie nie';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'Aflaaie';

  @override
  String downloadsStats(String count, String size) {
    return '$count liedjies • $size';
  }

  @override
  String get downloadsNoOffline => 'Nog geen vanlyn liedjies nie';

  @override
  String get downloadsNoOfflineDesc =>
      'Liedjies wat jy aflaai, sal hier verskyn';

  @override
  String get downloadsClearAllTitle => 'Vee alle aflaaie uit?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'Dit sal $count liedjies verwyder en $size berging vrymaak.';
  }

  @override
  String get downloadsCancel => 'Kanselleer';

  @override
  String get downloadsClearAll => 'Vee alles uit';

  @override
  String downloadsSongsCount(String count) {
    return '$count liedjies';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count liedjie';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'Kan nie die hoofaflaai-snitlys hernoem nie.';

  @override
  String get downloadsRename => 'Hernoem';

  @override
  String get downloadsEditSongs => 'Redigeer liedjies';

  @override
  String get downloadsDelete => 'Vee uit';

  @override
  String get downloadsRenamePlaylistTitle => 'Hernoem snitlys';

  @override
  String get downloadsRenamePlaylistDesc =>
      'Voer \'n nuwe naam vir jou snitlys in.';

  @override
  String get downloadsDeletePlaylistTitle => 'Vee snitlys uit?';

  @override
  String get downloadsDeleteMasterDesc =>
      'Is jy seker jy wil dit uitvee? Jy sal alle afgelaaide liedjies en snitlyste vir ewig verloor.';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'Is jy seker jy wil \"$name\" uitvee? Hierdie snitlys sal vir altyd verlore wees.';
  }

  @override
  String get downloadsSave => 'Stoor';

  @override
  String get downloadsNoSongs => 'Geen liedjies in hierdie snitlys nie.';

  @override
  String get libraryTitle => 'Biblioteek';

  @override
  String get libraryPauseAll => 'Onderbreek alles';

  @override
  String get libraryResumeAll => 'Hervat alles';

  @override
  String get libraryTabPlaylists => 'Snitlyste';

  @override
  String get libraryTabDownloads => 'Aflaaie';

  @override
  String get libraryTabDownloading => 'Laai tans af';

  @override
  String libraryImportedTask(String name) {
    return 'Ingevoer $name';
  }

  @override
  String get libraryImportWaiting => 'Wag tans in tou...';

  @override
  String get libraryImportFetching => 'Haal tans snitlys …';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total verwerk · $matched ooreenstem';
  }

  @override
  String get libraryImportSaving => 'Stoor tans na biblioteek …';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched liedjies bygevoeg · tik × om toe te maak';
  }

  @override
  String get libraryImportDoneAll =>
      'Alle liedjies bygevoeg · tik × om toe te maak';

  @override
  String get libraryAddButton => 'Voeg by';

  @override
  String get librarySortRecent => 'Onlangs bygevoeg';

  @override
  String get librarySortAlpha => 'Alfabeties';

  @override
  String get libraryEmptyTitle => 'Jou biblioteek is leeg.';

  @override
  String get libraryEmptyDesc =>
      'Tik \"Voeg by\" om jou eerste Pulse te begin.';

  @override
  String get libraryRenameLikedError =>
      'Kan nie die \'Gehou Van\' snitlys hernoem nie.';

  @override
  String get libraryRename => 'Hernoem';

  @override
  String get libraryEditSongs => 'Redigeer liedjies';

  @override
  String get libraryDeleteLikedError =>
      'Kan nie die \'Gehou Van\' snitlys uitvee nie.';

  @override
  String get libraryDelete => 'Vee uit';

  @override
  String get libraryEditSongsTitle => 'Redigeer liedjies';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count liedjie';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count liedjies';
  }

  @override
  String get libraryCancel => 'Kanselleer';

  @override
  String get librarySave => 'Stoor';

  @override
  String get libraryNoSongs => 'Geen liedjies in hierdie snitlys nie.';

  @override
  String get libraryAddOptionsTitle => 'Voeg by biblioteek';

  @override
  String get libraryAddOptionsDesc => 'Kies hoe jy jou Pulse wil uitbrei';

  @override
  String get libraryImportPulse => 'Voer in vanaf Pulse';

  @override
  String get libraryImportPulseDesc => 'Plak \'n Pulse-snitlys-URL';

  @override
  String get libraryImportYtm => 'Voer in vanaf YT Music';

  @override
  String get libraryImportYtmDesc => 'Plak \'n PUBLIEKE snitlys-URL';

  @override
  String get libraryImportSpotify => 'Voer in vanaf Spotify';

  @override
  String get libraryImportSpotifyDesc => 'Koppel jou Spotify';

  @override
  String get libraryClose => 'Maak toe';

  @override
  String get libraryImportYtmFull => 'Voer in vanaf YouTube Music';

  @override
  String get libraryImportSpotifyFull => 'Voer in vanaf Spotify (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'Plak \'n PUBLIEKE YouTube Music-snitlys of album-URL';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'Plak \'n publieke Spotify-snitlys-URL hieronder';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Kon nie Pulse-snitlys invoer nie';

  @override
  String get importErrorPlaylist => 'Kon nie snitlys invoer nie';

  @override
  String get importErrorHighlyPopulated =>
      'Snitlys is baie bevolk, dit kan \'n rukkie neem om te gaan haal.';

  @override
  String get libraryImportBtn => 'Invoer';

  @override
  String get libraryCreateTitle => 'Nuwe snitlys';

  @override
  String get libraryCreateDesc => 'Wat moet ons jou nuwe snitlys noem?';

  @override
  String get libraryCreateHint => 'bv. Middernagritte';

  @override
  String get libraryCreateBtn => 'Skep';

  @override
  String get libraryRenameTitle => 'Hernoem snitlys';

  @override
  String get libraryRenameDesc => 'Voer \'n nuwe naam vir jou snitlys in.';

  @override
  String get libraryRenameBtn => 'Hernoem';

  @override
  String get libraryDeleteTitle => 'Vee snitlys uit?';

  @override
  String libraryDeleteDesc(String name) {
    return 'Is jy seker jy wil \"$name\" uitvee? Hierdie snitlys sal vir altyd verlore wees.';
  }

  @override
  String get libraryDeleteBtn => 'Vee uit';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'Onlangs';

  @override
  String librarySongsCount(String count) {
    return '$count Liedjies';
  }

  @override
  String get libraryComingSoon => 'Binnekort';

  @override
  String get loginErrName => 'Voer asseblief jou naam in';

  @override
  String get loginErrEmail => 'Voer asseblief jou e-posadres in';

  @override
  String get loginErrPassword => 'Voer asseblief jou wagwoord in';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'Voel elke slag!';

  @override
  String get loginMadeWithHeartBy => 'Gemaak met ❤️ deur';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'Jou naam';

  @override
  String get loginHintEmail => 'E-pos adres';

  @override
  String get loginHintPassword => 'Wagwoord';

  @override
  String get loginErrEmailReset =>
      'Voer asseblief jou e-posadres in om wagwoord terug te stel';

  @override
  String get loginResetSent =>
      'Wagwoordherstel e-pos gestuur! Gaan jou inkassie na.';

  @override
  String get loginForgotPwd => 'Wagwoord vergeet?';

  @override
  String get loginBtnSignup => 'Skep rekening';

  @override
  String get loginBtnSignin => 'Meld aan';

  @override
  String get loginToggleHaveAccount => 'Het jy reeds \'n Pulse-rekening?';

  @override
  String get loginToggleNoAccount => 'Het jy nie \'n Pulse-rekening nie?';

  @override
  String get loginToggleSignin => 'Meld aan';

  @override
  String get loginToggleSignup => 'Teken in';

  @override
  String get offlineStillOffline =>
      'Nog steeds vanlyn. Gaan asseblief jou verbinding na.';

  @override
  String get offlineTitle => 'Jy is vanlyn';

  @override
  String get offlineSubtitle =>
      'Geen internetverbinding gevind nie.\nGaan jou netwerk na en probeer weer.';

  @override
  String get offlineChecking => 'Kontroleer tans …';

  @override
  String get offlineRetry => 'Probeer weer';

  @override
  String get offlineGoToDownloads => 'Gaan na Downloads';

  @override
  String get playerMadeWithHeartBy => 'Gemaak met ❤️ deur';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'Swiep vir lirieke';

  @override
  String get playerNoLyrics => 'Geen lirieke beskikbaar nie';

  @override
  String get playerUpNext => 'Volgende';

  @override
  String get playerNoTracksInQueue => 'Geen spore in die tou nie';

  @override
  String get playerNoMusicPlaying => 'Geen musiek speel nie';

  @override
  String get playerPickAVibe => 'Kies \'n atmosfeer uit jou biblioteek of huis';

  @override
  String get playerGoHome => 'Gaan Huis toe';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'Gelykmaker';

  @override
  String get playerEqCustom => 'Pasgemaak';

  @override
  String get playlistDownloads => 'Aflaaie';

  @override
  String get playlistOffline => 'Vanlyn snitlys';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '${hours}h ${mins}min';
  }

  @override
  String playlistDurationMins(String mins) {
    return '${mins}min';
  }

  @override
  String get playlistFindOnPage => 'Vind op hierdie bladsy';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count liedjies • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'Onlangs';

  @override
  String get playlistNoMatches => 'Geen passings gevind nie.';

  @override
  String get playlistNoTracks => 'Geen snitte in hierdie snitlys nie.';

  @override
  String get playlistNoSongsYet => 'Nog geen liedjies nie.';

  @override
  String get playlistSortRecentlyAdded => 'Onlangs bygevoeg';

  @override
  String get playlistSortAlphabetical => 'Alfabeties';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'liedjies',
      one: 'liedjie',
    );
    return 'Laai tans af $count $_temp0';
  }

  @override
  String get playlistView => 'BESIGTIG';

  @override
  String get playlistAllDownloaded => 'Alle liedjies is reeds afgelaai';

  @override
  String playlistShareText(String name, String url) {
    return 'Kyk na \"$name\" op Pulse!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'Verwyder van aflaaie';

  @override
  String get playlistRemoveFromPlaylist => 'Verwyder uit snitlys';

  @override
  String get playlistLoadError => 'Kon nie hierdie snitlys laai nie.';

  @override
  String get playlistGoBack => '← Gaan terug';

  @override
  String get profileNotLoggedIn => 'Nie aangemeld nie';

  @override
  String get profileSignIn => 'Meld aan';

  @override
  String get profileDefaultUser => 'Pulse-gebruiker';

  @override
  String get profileEditProfile => 'Wysig profiel';

  @override
  String get profileTimeframeDay => 'Dag';

  @override
  String get profileTimeframeWeek => 'Week';

  @override
  String get profileTimeframeMonth => 'Maand';

  @override
  String get profileTimeframeYear => 'Jaar';

  @override
  String get profileListeningTime => 'LUISTERTYD';

  @override
  String get profileToday => 'Vandag';

  @override
  String get profileThisWeek => 'Hierdie week';

  @override
  String get profileThisMonth => 'Hierdie maand';

  @override
  String get profileThisYear => 'Hierdie jaar';

  @override
  String get profileDailyAvg => 'DAAGLIKSE GEM';

  @override
  String get profilePerDay => 'Per dag';

  @override
  String get profileLifetimeListening => 'LEWENSTYD LUISTER';

  @override
  String get profileTotalTimeListened =>
      'Totale tyd geluister na musiek op Pulse';

  @override
  String get profileYourTopSongs => 'Jou Top Liedjies';

  @override
  String get profileListeningHistoryEmpty =>
      'Luistergeskiedenis sal hier verskyn.';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'kere gespeel',
      one: 'keer gespeel',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => 'Jou topkunstenaars';

  @override
  String get profileTopArtistsEmpty =>
      'Jou gunsteling kunstenaars sal hier verskyn.';

  @override
  String get profileArtistLabel => 'Kunstenaar';

  @override
  String get profileSignOut => 'Teken uit';

  @override
  String profileVersion(String version) {
    return 'Weergawe $version';
  }

  @override
  String get profileMadeWithHeartBy => 'Gemaak met ❤️ deur';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'WYSIG PROFIEL';

  @override
  String get profileDisplayName => 'VERTOONNAAM';

  @override
  String get profileCancel => 'Kanselleer';

  @override
  String get profileSave => 'Stoor';

  @override
  String get profileChooseAvatar => 'Kies Avatar';

  @override
  String get searchMicPermissionRequired =>
      'Mikrofoontoestemming word vir hierdie kenmerk vereis';

  @override
  String get searchUnknownSong => 'Onbekende liedjie';

  @override
  String get searchUnknownArtist => 'Onbekende Kunstenaar';

  @override
  String get searchNoSongDetected => 'Geen liedjie bespeur nie.';

  @override
  String searchError(String message) {
    return 'Fout: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'Spraakherkenning nie beskikbaar nie';

  @override
  String get searchHint => 'Liedjies, kunstenaars, albums, snitlyste …';

  @override
  String get searchRecentEmpty => 'Jou onlangse soektogte verskyn hier';

  @override
  String get searchRecentSearches => 'Onlangse soektogte';

  @override
  String get searchClearAll => 'Vee alles uit';

  @override
  String searchNoResultsFor(String query) {
    return 'Geen resultate vir \"$query\"';
  }

  @override
  String get searchTryDifferentKeywords => 'Probeer verskillende sleutelwoorde';

  @override
  String get searchTopResult => 'Top resultaat';

  @override
  String get searchSongsLabel => 'Liedjies';

  @override
  String get searchArtistsLabel => 'Kunstenaars';

  @override
  String get searchAlbumsLabel => 'Albums';

  @override
  String get searchPlaylistsLabel => 'Snitlyste';

  @override
  String get searchArtistLabel => 'Kunstenaar';

  @override
  String get searchListening => 'Luister tans...';

  @override
  String get searchSpeakNow => 'Praat nou om te soek';

  @override
  String get searchCancel => 'Kanselleer';

  @override
  String get searchIdentifying => 'Identifiseer tans …';

  @override
  String get searchListeningForSong => 'Luister vir \'n liedjie...';

  @override
  String get settingsTitle => 'Instellings';

  @override
  String get settingsStreamingQuality => 'Stroomkwaliteit';

  @override
  String get settingsQualityAutomatic => 'Outomaties';

  @override
  String get settingsQualityLow => 'Laag';

  @override
  String get settingsQualityNormal => 'Normaal';

  @override
  String get settingsQualityHigh => 'Hoog';

  @override
  String get settingsDownloadQuality => 'Aflaai Kwaliteit';

  @override
  String get settingsPlayback => 'Afspeel';

  @override
  String get settingsCrossfade => 'Crossfade';

  @override
  String get settingsCrossfadeDesc =>
      'Oorvleuel spore vir gapingslose oorgange';

  @override
  String get settingsDataUsage => 'Datagebruik';

  @override
  String get settingsDataSaver => 'Databespaarder';

  @override
  String get settingsDataSaverDesc => 'Stroom teen laer gehalte oor sellulêr';

  @override
  String get settingsAppearance => 'Voorkoms';

  @override
  String get settingsLanguage => 'Taal';

  @override
  String get settingsCustomAccent => 'Pasgemaakte aksent';

  @override
  String get settingsSaturation => 'Versadiging';

  @override
  String get settingsBrightness => 'Helderheid';

  @override
  String get settingsResetDefault => 'Stel verstek terug';

  @override
  String get playlistSheetTitle => 'Voeg by snitlys';

  @override
  String get playlistSheetNewPlaylist => 'Nuwe snitlys';

  @override
  String get playlistSheetNoPlaylists => 'Nog geen snitlyste nie';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'liedjies',
      one: 'liedjie',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => 'Snitlys Naam';

  @override
  String get playlistSheetCancel => 'Kanselleer';

  @override
  String playlistSheetAddedTo(String name) {
    return 'By $name gevoeg';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'Kon nie snitlys skep nie: Stawingsfout';

  @override
  String playlistSheetCreateFail(String error) {
    return 'Kon nie snitlys skep nie: $error';
  }

  @override
  String get playlistSheetCreate => 'Skep';

  @override
  String get appUpdateAvailable => 'Opdatering beskikbaar';

  @override
  String appUpdateDesc(String version) {
    return 'Weergawe $version is hier! Dateer nou op om die nuutste kenmerke te kry.';
  }

  @override
  String get appUpdateDownload => 'Laai Update af';

  @override
  String get navHome => 'Tuis';

  @override
  String get navLibrary => 'Biblioteek';

  @override
  String get navSearch => 'Soek';

  @override
  String get navSettings => 'Instellings';

  @override
  String get navProfile => 'Profiel';

  @override
  String get artistSelect => 'Kies Kunstenaar';

  @override
  String get songActionQueue => 'Voeg by waglys';

  @override
  String get songActionPlaylist => 'Voeg by snitlys';

  @override
  String get songActionFinding => 'Vind tans …';

  @override
  String get songActionAlbum => 'Gaan na Album';

  @override
  String get songActionArtist => 'Gaan na Kunstenaar';

  @override
  String get songActionRemovePlaylist => 'Verwyder uit snitlys';

  @override
  String get songActionRemoveDownload => 'Verwyder van aflaaie';

  @override
  String get songActionDownloadChecking => 'Kontroleer tans …';

  @override
  String get songActionDownloading => 'Laai tans af...';

  @override
  String get songActionDownloaded => 'Afgelaai!';

  @override
  String get songActionDownloadAlready => 'Reeds afgelaai';

  @override
  String get songActionDownloadFailed => 'Kon nie aflaai nie';

  @override
  String get songActionDownload => 'Laai af';

  @override
  String get songActionDownloadingSnack => 'Laai tans af';

  @override
  String get songActionView => 'BESIGTIG';

  @override
  String get spotifyImportTitle => 'Voer in vanaf Spotify';

  @override
  String get spotifyImportSubtitle => 'Kies jou snitlysgrootte';

  @override
  String get spotifyChoiceSmallTitle => '100 liedjies of minder';

  @override
  String get spotifyChoiceSmallDesc => 'Plak \'n publieke Spotify-snitlys-URL.';

  @override
  String get spotifyChoiceLargeTitle => 'Meer as 100 liedjies';

  @override
  String get spotifyChoiceLargeDesc =>
      'Koppel jou eie Spotify-ontwikkelaarprogram om onbeperkte snitte in te voer.';

  @override
  String get cancelButton => 'Kanselleer';

  @override
  String get spotifyPlaylistsTitle => 'Jou Spotify-snitlyste';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'Fout: $error\nMaak seker jou kliënt-ID is geldig.';
  }

  @override
  String get spotifyPlaylistsEmpty =>
      'Geen snitlyste in jou biblioteek gevind nie';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count snitte';
  }

  @override
  String get spotifyPlaylistsImport => 'Invoer';

  @override
  String get audioPlaybackFailed =>
      'Terugspeel het misluk. Gaan jou internetverbinding na.';

  @override
  String get audioControlPrevious => 'Vorige';

  @override
  String get audioControlPause => 'Pouse';

  @override
  String get audioControlPlay => 'Speel';

  @override
  String get audioControlNext => 'Volgende';

  @override
  String get audioControlUnlike => 'Verwyder Gunsteling';

  @override
  String get audioControlLike => 'Gunsteling';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'Rou reaksie: $data\n\nTerugval: $error';
  }

  @override
  String get apiErrorInvalidClient => 'Ongeldige kliënt- of kliëntgeheim.';

  @override
  String get apiErrorBadRequest =>
      'Slegte versoek. Gaan asseblief jou insette na.';

  @override
  String get apiErrorUnauthorized => 'Ongemagtig. Meld asseblief weer aan.';

  @override
  String get apiErrorForbidden => 'Verbode. Jy het nie toegang nie.';

  @override
  String get apiErrorNotFound => 'Hulpbron nie gevind nie.';

  @override
  String get apiErrorEmailInUse => 'Hierdie e-posadres is reeds in gebruik.';

  @override
  String get apiErrorUserNotFound =>
      'Geen rekening gevind met hierdie e-pos nie.';

  @override
  String get apiErrorWrongPassword => 'Verkeerde wagwoord.';

  @override
  String get apiErrorInvalidCredential =>
      'Kon nie aanmeld nie. Gaan asseblief jou geloofsbriewe na.';

  @override
  String get apiErrorNetwork =>
      'Netwerkfout. Gaan asseblief jou verbinding na.';

  @override
  String get apiErrorSocketTimeout =>
      'Verbinding het uitgetel. Probeer asseblief weer.';

  @override
  String get apiErrorTooManyRequests =>
      'Te veel versoeke. Wag asseblief \'n oomblik en probeer weer.';

  @override
  String get apiErrorServerError =>
      'Bedienerfout. Probeer asseblief later weer.';

  @override
  String get apiErrorInvalidEmail =>
      'Voer asseblief \'n geldige e-posadres in.';

  @override
  String get apiErrorWeakPassword =>
      'Wagwoord is te swak. Gebruik ten minste 6 karakters.';

  @override
  String get apiErrorTooManyAttempts =>
      'Te veel mislukte pogings. Probeer asseblief later weer.';

  @override
  String get homeForgottenFavorites => 'Vergete Gunstelinge';

  @override
  String get artistShowAll => 'Wys alles';

  @override
  String get homeTopTracks => 'Top snitte';
}
