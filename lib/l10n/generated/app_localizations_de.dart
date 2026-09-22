// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'Über';

  @override
  String get artistPopular => 'Beliebt';

  @override
  String get artistAlbums => 'Alben';

  @override
  String get artistSinglesAndEPs => 'Singles & EPs';

  @override
  String artistSubscribersCount(String count) {
    return '$count Abonnenten';
  }

  @override
  String get artistPlayAll => 'Alle abspielen';

  @override
  String get artistLoadError => 'Künstler konnte nicht geladen werden';

  @override
  String get artistGoBack => 'Zurück';

  @override
  String adminChatFailedToReply(String error) {
    return 'Antwort fehlgeschlagen: $error';
  }

  @override
  String get adminChatSupportChat => 'Support-Chat';

  @override
  String adminChatError(String error) {
    return 'Fehler: $error';
  }

  @override
  String get adminChatNoHistory => 'Kein Nachrichtenverlauf.';

  @override
  String get adminChatSupportYou => 'Support (Du)';

  @override
  String get adminChatTypeReply => 'Antwort schreiben...';

  @override
  String get broadcastSuccess => 'Ankündigung erfolgreich gesendet!';

  @override
  String broadcastFailed(String error) {
    return 'Senden fehlgeschlagen: $error';
  }

  @override
  String get broadcastTitle => 'Globale Ankündigung';

  @override
  String get broadcastSubtitle => 'An alle Nutzer gesendet';

  @override
  String get broadcastWarning => 'Diese Nachricht wird von allen gesehen.';

  @override
  String broadcastError(String error) {
    return 'Fehler: $error';
  }

  @override
  String get broadcastNoHistory => 'Keine globalen Ankündigungen.';

  @override
  String get broadcastTypeMessage => 'Ankündigung schreiben...';

  @override
  String commFailedToSend(String error) {
    return 'Senden fehlgeschlagen: $error';
  }

  @override
  String get commAdminDashboard => 'Admin-Dashboard';

  @override
  String get commAdminSupport => 'Support';

  @override
  String get commAlwaysHere => 'Immer hier, um zu helfen';

  @override
  String get commWelcomeTitle => 'Hallo! 👋 Ich bin Ashutosh Pathak';

  @override
  String get commWelcomeSubtitle => 'Pulse Ersteller';

  @override
  String get commWelcomeBody1 =>
      'Ich hoffe, du genießt werbefreie Musik. Musik sollte keine Barrieren haben.\n\nDies ist dein Bereich, um direkt mit mir zu sprechen.\n\nDu kannst senden:';

  @override
  String get commBullet1 => 'Dein Feedback';

  @override
  String get commBullet2 => 'Fehlerberichte';

  @override
  String get commBullet3 => 'Neue Feature-Ideen';

  @override
  String get commWelcomeBody2 =>
      'Ich lese jede Nachricht persönlich.\n\nHast du Ideen für eine neue App? Lass es mich wissen! Wenn möglich, werde ich sie entwickeln.\n\nDanke, dass du ein Teil davon bist. ❤️';

  @override
  String commError(String error) {
    return 'Fehler: $error';
  }

  @override
  String get commNoMessages => 'Noch keine Nachrichten';

  @override
  String get commNoMessagesDesc =>
      'Sende eine Nachricht an den Support oder schau später nach.';

  @override
  String get commMessageSupportHint => 'Nachricht schreiben...';

  @override
  String get commGlobalAnnouncements => 'Globale Ankündigungen';

  @override
  String get commSendMessagesToAll => 'An alle senden';

  @override
  String get homeGreetingMorning => 'Guten Morgen,';

  @override
  String get homeGreetingAfternoon => 'Guten Tag,';

  @override
  String get homeGreetingEvening => 'Guten Abend,';

  @override
  String get homeMember => 'Mitglied';

  @override
  String get homeRecentPlaylists => 'Letzte Playlists';

  @override
  String get homeRecentlyPlayed => 'Zuletzt gehört';

  @override
  String get homeSpeedDial => 'Schnellzugriff';

  @override
  String get homeNoContent => 'Kein Inhalt';

  @override
  String get homeRefresh => 'Aktualisieren';

  @override
  String get homeLoadError => 'Feed konnte nicht geladen werden.';

  @override
  String get homeRetry => 'Erneut versuchen';

  @override
  String get importSuccess => 'Spotify erfolgreich verbunden!';

  @override
  String importFailed(String error) {
    return 'Verbindung fehlgeschlagen: $error';
  }

  @override
  String get importTitle => 'Spotify verbinden';

  @override
  String get importSetupTitle => 'Spotify-Einrichtung';

  @override
  String get importSetupDesc =>
      'Verwende deinen eigenen Entwicklerschlüssel, um Playlists blitzschnell zu importieren:';

  @override
  String get importStep1 => 'Öffne das Spotify Developer Dashboard.';

  @override
  String get importStep2 => 'Melde dich an und klicke auf \'Create app\'.';

  @override
  String get importStep3 => 'Gib deiner App einen Namen und eine Beschreibung.';

  @override
  String get importStep4 =>
      'Füge unter \'Redirect URIs\' diesen genauen Link ein:';

  @override
  String get importRedirectCopied => 'Redirect-URI kopiert!';

  @override
  String get importStep5 =>
      'Speichern, die \'Client ID\' kopieren und unten einfügen.';

  @override
  String get importImportant =>
      'Wichtig: Ein aktives Spotify Premium Abonnement wird benötigt.';

  @override
  String get importClientIdHint => 'Füge deine Spotify Client ID hier ein...';

  @override
  String get importConnectButton => 'Verbinden & Bibliothek laden';

  @override
  String get downloadingNoActive => 'Keine aktiven Downloads';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'Downloads';

  @override
  String downloadsStats(String count, String size) {
    return '$count Titel • $size';
  }

  @override
  String get downloadsNoOffline => 'Keine Offline-Songs';

  @override
  String get downloadsNoOfflineDesc =>
      'Deine heruntergeladenen Songs erscheinen hier';

  @override
  String get downloadsClearAllTitle => 'Alles löschen?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'Dadurch werden $count Songs gelöscht und $size Speicherplatz freigegeben.';
  }

  @override
  String get downloadsCancel => 'Abbrechen';

  @override
  String get downloadsClearAll => 'Alles löschen';

  @override
  String downloadsSongsCount(String count) {
    return '$count Titel';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count Titel';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'Die Haupt-Download-Playlist kann nicht umbenannt werden.';

  @override
  String get downloadsRename => 'Umbenennen';

  @override
  String get downloadsEditSongs => 'Songs bearbeiten';

  @override
  String get downloadsDelete => 'Löschen';

  @override
  String get downloadsRenamePlaylistTitle => 'Playlist umbenennen';

  @override
  String get downloadsRenamePlaylistDesc =>
      'Gib einen neuen Namen für die Playlist ein.';

  @override
  String get downloadsDeletePlaylistTitle => 'Playlist löschen?';

  @override
  String get downloadsDeleteMasterDesc =>
      'Bist du sicher? Du verlierst permanent alle heruntergeladenen Songs und Playlists.';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'Bist du sicher, dass du \'$name\' löschen möchtest? Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String get downloadsSave => 'Speichern';

  @override
  String get downloadsNoSongs => 'Diese Playlist hat keine Songs.';

  @override
  String get libraryTitle => 'Bibliothek';

  @override
  String get libraryPauseAll => 'Alle pausieren';

  @override
  String get libraryResumeAll => 'Alle fortsetzen';

  @override
  String get libraryTabPlaylists => 'Playlists';

  @override
  String get libraryTabDownloads => 'Downloads';

  @override
  String get libraryTabDownloading => 'Wird heruntergeladen';

  @override
  String libraryImportedTask(String name) {
    return '$name importiert';
  }

  @override
  String get libraryImportWaiting => 'Warten...';

  @override
  String get libraryImportFetching => 'Playlist wird abgerufen...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total verarbeitet · $matched Treffer';
  }

  @override
  String get libraryImportSaving => 'Wird gespeichert...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched Songs hinzugefügt · Tippe ×';
  }

  @override
  String get libraryImportDoneAll => 'Alle Songs hinzugefügt · Tippe ×';

  @override
  String get libraryAddButton => 'Hinzufügen';

  @override
  String get librarySortRecent => 'Zuletzt hinzugefügt';

  @override
  String get librarySortAlpha => 'Alphabetisch';

  @override
  String get libraryEmptyTitle => 'Deine Bibliothek ist leer.';

  @override
  String get libraryEmptyDesc => 'Tippe auf \'Hinzufügen\', um zu beginnen.';

  @override
  String get libraryRenameLikedError =>
      'Die Playlist \'Lieblingssongs\' kann nicht umbenannt werden.';

  @override
  String get libraryRename => 'Umbenennen';

  @override
  String get libraryEditSongs => 'Songs bearbeiten';

  @override
  String get libraryDeleteLikedError =>
      'Die Playlist \'Lieblingssongs\' kann nicht gelöscht werden.';

  @override
  String get libraryDelete => 'Löschen';

  @override
  String get libraryEditSongsTitle => 'Songs bearbeiten';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count Titel';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count Titel';
  }

  @override
  String get libraryCancel => 'Abbrechen';

  @override
  String get librarySave => 'Speichern';

  @override
  String get libraryNoSongs => 'Diese Playlist hat keine Songs.';

  @override
  String get libraryAddOptionsTitle => 'Zur Bibliothek hinzufügen';

  @override
  String get libraryAddOptionsDesc =>
      'Wie möchtest du deine Pulse-Bibliothek erweitern?';

  @override
  String get libraryImportPulse => 'Von Pulse importieren';

  @override
  String get libraryImportPulseDesc => 'Pulse-Playlist-URL einfügen';

  @override
  String get libraryImportYtm => 'Von YT Music importieren';

  @override
  String get libraryImportYtmDesc => 'Öffentlichen Link einfügen';

  @override
  String get libraryImportSpotify => 'Von Spotify importieren';

  @override
  String get libraryImportSpotifyDesc => 'Verbinde dein Spotify';

  @override
  String get libraryClose => 'Schließen';

  @override
  String get libraryImportYtmFull => 'Von YouTube Music importieren';

  @override
  String get libraryImportSpotifyFull => 'Von Spotify importieren (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'Füge den öffentlichen Link zu einer Playlist oder einem Album von YouTube Music hier ein';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'Füge den öffentlichen Link zu einer Spotify-Playlist hier ein';

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
      'Pulse-Playlist konnte nicht importiert werden';

  @override
  String get importErrorPlaylist => 'Importfehler';

  @override
  String get importErrorHighlyPopulated =>
      'Die Playlist ist stark gefüllt, das kann eine Weile dauern.';

  @override
  String get libraryImportBtn => 'Importieren';

  @override
  String get libraryCreateTitle => 'Neue Playlist';

  @override
  String get libraryCreateDesc => 'Wie soll deine neue Playlist heißen?';

  @override
  String get libraryCreateHint => 'Z.B. Roadtrip';

  @override
  String get libraryCreateBtn => 'Erstellen';

  @override
  String get libraryRenameTitle => 'Playlist umbenennen';

  @override
  String get libraryRenameDesc => 'Gib einen neuen Namen ein.';

  @override
  String get libraryRenameBtn => 'Umbenennen';

  @override
  String get libraryDeleteTitle => 'Playlist löschen?';

  @override
  String libraryDeleteDesc(String name) {
    return 'Bist du sicher, dass du \'$name\' löschen möchtest? Dies ist dauerhaft.';
  }

  @override
  String get libraryDeleteBtn => 'Löschen';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'Neueste';

  @override
  String librarySongsCount(String count) {
    return '$count Titel';
  }

  @override
  String get libraryComingSoon => 'Demnächst';

  @override
  String get loginErrName => 'Bitte gib deinen Namen ein';

  @override
  String get loginErrEmail => 'Bitte gib deine E-Mail ein';

  @override
  String get loginErrPassword => 'Bitte gib dein Passwort ein';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'Spüre jeden Beat!';

  @override
  String get loginMadeWithHeartBy => 'Mit ❤️ gemacht von: ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'Dein Name';

  @override
  String get loginHintEmail => 'E-Mail-Adresse';

  @override
  String get loginHintPassword => 'Passwort';

  @override
  String get loginErrEmailReset => 'Bitte gib eine E-Mail zum Zurücksetzen ein';

  @override
  String get loginResetSent => 'Gesendet! Überprüfe deinen Posteingang.';

  @override
  String get loginForgotPwd => 'Passwort vergessen?';

  @override
  String get loginBtnSignup => 'Konto erstellen';

  @override
  String get loginBtnSignin => 'Anmelden';

  @override
  String get loginToggleHaveAccount => 'Hast du bereits ein Pulse-Konto? ';

  @override
  String get loginToggleNoAccount => 'Noch kein Pulse-Konto? ';

  @override
  String get loginToggleSignin => 'Anmelden';

  @override
  String get loginToggleSignup => 'Registrieren';

  @override
  String get offlineStillOffline =>
      'Immer noch offline. Bitte überprüfe deine Verbindung.';

  @override
  String get offlineTitle => 'Du bist offline';

  @override
  String get offlineSubtitle =>
      'Keine Internetverbindung.\nÜberprüfe dein Netzwerk und versuche es erneut.';

  @override
  String get offlineChecking => 'Wird geprüft...';

  @override
  String get offlineRetry => 'Erneut versuchen';

  @override
  String get offlineGoToDownloads => 'Zu Downloads gehen';

  @override
  String get playerMadeWithHeartBy => 'Mit ❤️ gemacht von: ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'Für Songtext wischen';

  @override
  String get playerNoLyrics => 'Kein Songtext verfügbar';

  @override
  String get playerUpNext => 'Als nächstes';

  @override
  String get playerNoTracksInQueue => 'Keine Titel in der Warteschlange';

  @override
  String get playerNoMusicPlaying => 'Es wird keine Musik abgespielt';

  @override
  String get playerPickAVibe => 'Wähle einen Song aus der Bibliothek';

  @override
  String get playerGoHome => 'Zur Startseite gehen';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'Equalizer';

  @override
  String get playerEqCustom => 'Benutzerdefiniert';

  @override
  String get playlistDownloads => 'Downloads';

  @override
  String get playlistOffline => 'Offline-Playlist';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hours Std. $mins Min.';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$mins Min.';
  }

  @override
  String get playlistFindOnPage => 'Auf Seite suchen';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count Titel • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'Neueste';

  @override
  String get playlistNoMatches => 'Keine Treffer gefunden.';

  @override
  String get playlistNoTracks => 'Diese Playlist hat keine Titel.';

  @override
  String get playlistNoSongsYet => 'Noch keine Songs.';

  @override
  String get playlistSortRecentlyAdded => 'Zuletzt hinzugefügt';

  @override
  String get playlistSortAlphabetical => 'Alphabetisch';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Titel',
      one: 'Titel',
    );
    return 'Lade $count $_temp0 herunter';
  }

  @override
  String get playlistView => 'Ansehen';

  @override
  String get playlistAllDownloaded => 'Alles heruntergeladen';

  @override
  String playlistShareText(String name, String url) {
    return 'Hör dir \'$name\' auf Pulse an!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'Aus Downloads entfernen';

  @override
  String get playlistRemoveFromPlaylist => 'Aus Playlist entfernen';

  @override
  String get playlistLoadError => 'Playlist konnte nicht geladen werden.';

  @override
  String get playlistGoBack => '← Zurück';

  @override
  String get profileNotLoggedIn => 'Nicht angemeldet';

  @override
  String get profileSignIn => 'Anmelden';

  @override
  String get profileDefaultUser => 'Pulse-Nutzer';

  @override
  String get profileEditProfile => 'Profil bearbeiten';

  @override
  String get profileTimeframeDay => 'Tag';

  @override
  String get profileTimeframeWeek => 'Woche';

  @override
  String get profileTimeframeMonth => 'Monat';

  @override
  String get profileTimeframeYear => 'Jahr';

  @override
  String get profileListeningTime => 'Hörzeit';

  @override
  String get profileToday => 'Heute';

  @override
  String get profileThisWeek => 'Diese Woche';

  @override
  String get profileThisMonth => 'Diesen Monat';

  @override
  String get profileThisYear => 'Dieses Jahr';

  @override
  String get profileDailyAvg => 'Tagesdurchschnitt';

  @override
  String get profilePerDay => '/Tag';

  @override
  String get profileLifetimeListening => 'Insgesamt';

  @override
  String get profileTotalTimeListened => 'Gesamte Hörzeit auf Pulse';

  @override
  String get profileYourTopSongs => 'Deine Top-Songs';

  @override
  String get profileListeningHistoryEmpty =>
      'Dein Hörverlauf wird hier angezeigt.';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wiedergaben',
      one: 'Wiedergabe',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => 'Deine Top-Künstler';

  @override
  String get profileTopArtistsEmpty =>
      'Deine Lieblingskünstler werden hier angezeigt.';

  @override
  String get profileArtistLabel => 'Künstler';

  @override
  String get profileSignOut => 'Abmelden';

  @override
  String profileVersion(String version) {
    return 'Version $version';
  }

  @override
  String get profileMadeWithHeartBy => 'Mit ❤️ gemacht von: ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'Profil bearbeiten';

  @override
  String get profileDisplayName => 'Anzeigename';

  @override
  String get profileCancel => 'Abbrechen';

  @override
  String get profileSave => 'Speichern';

  @override
  String get profileChooseAvatar => 'Avatar wählen';

  @override
  String get searchMicPermissionRequired =>
      'Mikrofonberechtigung ist erforderlich';

  @override
  String get searchUnknownSong => 'Unbekannter Song';

  @override
  String get searchUnknownArtist => 'Unbekannter Künstler';

  @override
  String get searchNoSongDetected => 'Es wurde kein Song erkannt.';

  @override
  String searchError(String message) {
    return 'Fehler: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'Sprachsuche nicht verfügbar';

  @override
  String get searchHint => 'Song, Künstler, Album...';

  @override
  String get searchRecentEmpty => 'Deine letzten Suchen werden hier angezeigt';

  @override
  String get searchRecentSearches => 'Letzte Suchen';

  @override
  String get searchClearAll => 'Alles löschen';

  @override
  String searchNoResultsFor(String query) {
    return 'Keine Ergebnisse für \'$query\'';
  }

  @override
  String get searchTryDifferentKeywords => 'Versuche andere Suchbegriffe';

  @override
  String get searchTopResult => 'Top-Ergebnis';

  @override
  String get searchSongsLabel => 'Songs';

  @override
  String get searchArtistsLabel => 'Künstler';

  @override
  String get searchAlbumsLabel => 'Alben';

  @override
  String get searchPlaylistsLabel => 'Playlists';

  @override
  String get searchArtistLabel => 'Künstler';

  @override
  String get searchListening => 'Ich höre...';

  @override
  String get searchSpeakNow => 'Jetzt sprechen';

  @override
  String get searchCancel => 'Abbrechen';

  @override
  String get searchIdentifying => 'Wird identifiziert...';

  @override
  String get searchListeningForSong => 'Höre auf Song...';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsStreamingQuality => 'Streaming-Qualität';

  @override
  String get settingsQualityAutomatic => 'Automatisch';

  @override
  String get settingsQualityLow => 'Niedrig';

  @override
  String get settingsQualityNormal => 'Normal';

  @override
  String get settingsQualityHigh => 'Hoch';

  @override
  String get settingsDownloadQuality => 'Download-Qualität';

  @override
  String get settingsPlayback => 'Wiedergabe';

  @override
  String get settingsCrossfade => 'Crossfade';

  @override
  String get settingsCrossfadeDesc => 'Songs sanft überblenden';

  @override
  String get settingsDataUsage => 'Datennutzung';

  @override
  String get settingsDataSaver => 'Datensparmodus';

  @override
  String get settingsDataSaverDesc =>
      'In Mobilfunknetzen mit geringerer Qualität streamen';

  @override
  String get settingsAppearance => 'Erscheinungsbild';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsCustomAccent => 'Akzentfarbe';

  @override
  String get settingsSaturation => 'Sättigung';

  @override
  String get settingsBrightness => 'Helligkeit';

  @override
  String get settingsResetDefault => 'Standard wiederherstellen';

  @override
  String get playlistSheetTitle => 'Zur Playlist hinzufügen';

  @override
  String get playlistSheetNewPlaylist => 'Neue Playlist';

  @override
  String get playlistSheetNoPlaylists => 'Keine Playlists';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Titel',
      one: 'Titel',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => 'Playlist-Name';

  @override
  String get playlistSheetCancel => 'Abbrechen';

  @override
  String playlistSheetAddedTo(String name) {
    return 'Zu $name hinzugefügt';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'Erstellen fehlgeschlagen: Authentifizierungsfehler';

  @override
  String playlistSheetCreateFail(String error) {
    return 'Erstellen fehlgeschlagen: $error';
  }

  @override
  String get playlistSheetCreate => 'Erstellen';

  @override
  String get appUpdateAvailable => 'Update verfügbar';

  @override
  String appUpdateDesc(String version) {
    return 'Version $version ist da! Aktualisiere für neue Funktionen.';
  }

  @override
  String get appUpdateDownload => 'Update herunterladen';

  @override
  String get navHome => 'Start';

  @override
  String get navLibrary => 'Bibliothek';

  @override
  String get navSearch => 'Suchen';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get navProfile => 'Profil';

  @override
  String get artistSelect => 'Wähle den Künstler';

  @override
  String get songActionQueue => 'Zur Warteschlange';

  @override
  String get songActionPlaylist => 'Zur Playlist';

  @override
  String get songActionFinding => 'Suchen...';

  @override
  String get songActionAlbum => 'Zum Album';

  @override
  String get songActionArtist => 'Zum Künstler';

  @override
  String get songActionRemovePlaylist => 'Aus Playlist entfernen';

  @override
  String get songActionRemoveDownload => 'Aus Downloads entfernen';

  @override
  String get songActionDownloadChecking => 'Prüfen...';

  @override
  String get songActionDownloading => 'Herunterladen...';

  @override
  String get songActionDownloaded => 'Heruntergeladen!';

  @override
  String get songActionDownloadAlready => 'Bereits heruntergeladen';

  @override
  String get songActionDownloadFailed => 'Download fehlgeschlagen';

  @override
  String get songActionDownload => 'Herunterladen';

  @override
  String get songActionDownloadingSnack => 'Wird heruntergeladen';

  @override
  String get songActionView => 'Ansehen';

  @override
  String get spotifyImportTitle => 'Von Spotify importieren';

  @override
  String get spotifyImportSubtitle => 'Wähle die Playlist-Größe';

  @override
  String get spotifyChoiceSmallTitle => '100 Songs oder weniger';

  @override
  String get spotifyChoiceSmallDesc =>
      'Füge einen öffentlichen Spotify-Link ein.';

  @override
  String get spotifyChoiceLargeTitle => 'Mehr als 100 Songs';

  @override
  String get spotifyChoiceLargeDesc =>
      'Verbinde deine eigene Spotify Developer App.';

  @override
  String get cancelButton => 'Abbrechen';

  @override
  String get spotifyPlaylistsTitle => 'Spotify Playlists';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'Fehler: $error\nBitte überprüfe deine Client ID.';
  }

  @override
  String get spotifyPlaylistsEmpty => 'Keine Playlists in deiner Bibliothek';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count Titel';
  }

  @override
  String get spotifyPlaylistsImport => 'Importieren';

  @override
  String get audioPlaybackFailed => 'Wiedergabe fehlgeschlagen.';

  @override
  String get audioControlPrevious => 'Zurück';

  @override
  String get audioControlPause => 'Pause';

  @override
  String get audioControlPlay => 'Abspielen';

  @override
  String get audioControlNext => 'Weiter';

  @override
  String get audioControlUnlike => 'Gefällt mir nicht mehr';

  @override
  String get audioControlLike => 'Gefällt mir';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'Rohe Antwort: $data\n\nFehler: $error';
  }

  @override
  String get apiErrorInvalidClient => 'Ungültige Client ID.';

  @override
  String get apiErrorBadRequest =>
      'Ungültige Anfrage. Bitte überprüfe deine Daten.';

  @override
  String get apiErrorUnauthorized =>
      'Nicht autorisiert. Bitte melde dich erneut an.';

  @override
  String get apiErrorForbidden =>
      'Verboten. Du hast keinen Zugriff auf diese Ressource.';

  @override
  String get apiErrorNotFound =>
      'Die angeforderte Ressource wurde nicht gefunden.';

  @override
  String get apiErrorEmailInUse =>
      'Diese E-Mail-Adresse wird bereits verwendet.';

  @override
  String get apiErrorUserNotFound => 'Kein Konto mit dieser E-Mail gefunden.';

  @override
  String get apiErrorWrongPassword => 'Falsches Passwort.';

  @override
  String get apiErrorInvalidCredential =>
      'Anmeldung fehlgeschlagen. Bitte überprüfe deine Daten.';

  @override
  String get apiErrorNetwork =>
      'Netzwerkfehler. Bitte überprüfe deine Internetverbindung.';

  @override
  String get apiErrorSocketTimeout =>
      'Verbindung abgelaufen. Bitte versuche es später.';

  @override
  String get apiErrorTooManyRequests =>
      'Zu viele Anfragen. Bitte versuche es später.';

  @override
  String get apiErrorServerError => 'Serverfehler. Bitte versuche es später.';

  @override
  String get apiErrorInvalidEmail =>
      'Bitte gib eine gültige E-Mail-Adresse an.';

  @override
  String get apiErrorWeakPassword =>
      'Das Passwort ist zu schwach. Verwende mindestens 6 Zeichen.';

  @override
  String get apiErrorTooManyAttempts =>
      'Zu viele fehlgeschlagene Versuche. Bitte versuche es später.';

  @override
  String get homeForgottenFavorites => 'Vergessene Favoriten';

  @override
  String get artistShowAll => 'Alle anzeigen';

  @override
  String get homeTopTracks => 'Top-Tracks';
}
