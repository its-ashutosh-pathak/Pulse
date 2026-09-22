// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'Informazioni';

  @override
  String get artistPopular => 'Popolari';

  @override
  String get artistAlbums => 'Album';

  @override
  String get artistSinglesAndEPs => 'Singoli e EP';

  @override
  String artistSubscribersCount(String count) {
    return '$count iscritti';
  }

  @override
  String get artistPlayAll => 'Riproduci Tutto';

  @override
  String get artistLoadError => 'Impossibile caricare l\'artista';

  @override
  String get artistGoBack => 'Indietro';

  @override
  String adminChatFailedToReply(String error) {
    return 'Impossibile rispondere: $error';
  }

  @override
  String get adminChatSupportChat => 'Chat di Supporto';

  @override
  String adminChatError(String error) {
    return 'Errore: $error';
  }

  @override
  String get adminChatNoHistory => 'Nessuna cronologia chat.';

  @override
  String get adminChatSupportYou => 'Supporto (Tu)';

  @override
  String get adminChatTypeReply => 'Scrivi la tua risposta...';

  @override
  String get broadcastSuccess => 'Annuncio trasmesso con successo!';

  @override
  String broadcastFailed(String error) {
    return 'Impossibile trasmettere: $error';
  }

  @override
  String get broadcastTitle => 'Annunci Globali';

  @override
  String get broadcastSubtitle => 'Inviato a tutti gli utenti';

  @override
  String get broadcastWarning =>
      'I messaggi inviati qui saranno visibili a tutti.';

  @override
  String broadcastError(String error) {
    return 'Errore: $error';
  }

  @override
  String get broadcastNoHistory => 'Nessun annuncio precedente.';

  @override
  String get broadcastTypeMessage => 'Scrivi un annuncio globale...';

  @override
  String commFailedToSend(String error) {
    return 'Impossibile inviare: $error';
  }

  @override
  String get commAdminDashboard => 'Dashboard Amministratore';

  @override
  String get commAdminSupport => 'Supporto Amministratore';

  @override
  String get commAlwaysHere => 'Sempre qui per aiutarti';

  @override
  String get commWelcomeTitle => 'Ehi! 👋 Sono Ashutosh Pathak';

  @override
  String get commWelcomeSubtitle => 'Sviluppatore di Pulse';

  @override
  String get commWelcomeBody1 =>
      'Spero ti stia godendo la tua musica preferita senza fastidiose pubblicità o barriere di abbonamento. Dopotutto, la musica non dovrebbe avere un paywall solo perché qualcuno in una sala riunioni aveva bisogno di un altro yacht.\n\nQuesta sezione è qui per permetterci di connetterci direttamente.\n\nSentiti libero di:';

  @override
  String get commBullet1 => 'Condividere il tuo feedback';

  @override
  String get commBullet2 => 'Segnalare bug';

  @override
  String get commBullet3 => 'Suggerire nuove funzionalità che vorresti vedere';

  @override
  String get commWelcomeBody2 =>
      'Leggo personalmente ogni messaggio e farò del mio meglio per migliorare l\'app in base ai tuoi suggerimenti.\n\nHai un\'idea per un\'app che non esiste ancora, o una che è bloccata dietro abbonamenti costosi? Parlamene! Se è possibile, proverò a costruirla e a renderla disponibile per tutti.\n\nGrazie per usare la mia app e per far parte di questo viaggio. ❤️';

  @override
  String commError(String error) {
    return 'Errore: $error';
  }

  @override
  String get commNoMessages => 'Nessun messaggio ancora';

  @override
  String get commNoMessagesDesc =>
      'Invia un messaggio al nostro team di supporto o torna più tardi per gli annunci.';

  @override
  String get commMessageSupportHint => 'Invia un messaggio al supporto...';

  @override
  String get commGlobalAnnouncements => 'Annunci Globali';

  @override
  String get commSendMessagesToAll => 'Invia messaggi a tutti gli utenti';

  @override
  String get homeGreetingMorning => 'Buongiorno,';

  @override
  String get homeGreetingAfternoon => 'Buon pomeriggio,';

  @override
  String get homeGreetingEvening => 'Buonasera,';

  @override
  String get homeMember => 'Membro';

  @override
  String get homeRecentPlaylists => 'Playlist Recenti';

  @override
  String get homeRecentlyPlayed => 'Ascoltati di recente';

  @override
  String get homeSpeedDial => 'Accesso Rapido';

  @override
  String get homeNoContent => 'Nessun contenuto disponibile';

  @override
  String get homeRefresh => 'Aggiorna';

  @override
  String get homeLoadError => 'Impossibile caricare il feed musicale.';

  @override
  String get homeRetry => 'Riprova';

  @override
  String get importSuccess => 'Connesso a Spotify con successo!';

  @override
  String importFailed(String error) {
    return 'Impossibile connettersi: $error';
  }

  @override
  String get importTitle => 'Connetti Spotify';

  @override
  String get importSetupTitle => 'Configura Integrazione Spotify';

  @override
  String get importSetupDesc =>
      'Per bypassare i severi limiti di velocità di Spotify e importare tutte le tue playlist all\'istante, devi usare la tua chiave sviluppatore gratuita. Segui questi semplici passaggi:';

  @override
  String get importStep1 => 'Apri la Dashboard Sviluppatori di Spotify.';

  @override
  String get importStep2 => 'Accedi e clicca su \"Create app\".';

  @override
  String get importStep3 =>
      'Inserisci un Nome e una Descrizione qualsiasi per l\'app.';

  @override
  String get importStep4 =>
      'Sotto \"Redirect URIs\", incollare l\'URL esatto seguente:';

  @override
  String get importRedirectCopied => 'URI di reindirizzamento copiato!';

  @override
  String get importStep5 =>
      'Salva l\'app, copia il tuo \"Client ID\" dalle impostazioni e incollalo qui sotto.';

  @override
  String get importImportant =>
      'Importante: L\'account Spotify utilizzato per creare questa app sviluppatore deve avere un abbonamento Premium attivo.';

  @override
  String get importClientIdHint => 'Incolla qui il tuo Client ID di Spotify...';

  @override
  String get importConnectButton => 'Connetti e Carica Libreria';

  @override
  String get downloadingNoActive => 'Nessun download attivo';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'Download';

  @override
  String downloadsStats(String count, String size) {
    return '$count brani • $size';
  }

  @override
  String get downloadsNoOffline => 'Nessun brano offline ancora';

  @override
  String get downloadsNoOfflineDesc => 'I brani che scarichi appariranno qui';

  @override
  String get downloadsClearAllTitle => 'Cancellare tutti i download?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'Questo rimuoverà $count brani e libererà $size di spazio di archiviazione.';
  }

  @override
  String get downloadsCancel => 'Annulla';

  @override
  String get downloadsClearAll => 'Cancella Tutto';

  @override
  String downloadsSongsCount(String count) {
    return '$count brani';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count brano';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'Impossibile rinominare la playlist principale dei download.';

  @override
  String get downloadsRename => 'Rinomina';

  @override
  String get downloadsEditSongs => 'Modifica Brani';

  @override
  String get downloadsDelete => 'Elimina';

  @override
  String get downloadsRenamePlaylistTitle => 'Rinomina Playlist';

  @override
  String get downloadsRenamePlaylistDesc =>
      'Inserisci un nuovo nome per la tua playlist.';

  @override
  String get downloadsDeletePlaylistTitle => 'Eliminare Playlist?';

  @override
  String get downloadsDeleteMasterDesc =>
      'Sei sicuro di voler eliminare questo? Perderai per sempre tutti i brani e le playlist scaricate.';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'Sei sicuro di voler eliminare \"$name\"? Questa playlist andrà persa per sempre.';
  }

  @override
  String get downloadsSave => 'Salva';

  @override
  String get downloadsNoSongs => 'Nessun brano in questa playlist.';

  @override
  String get libraryTitle => 'Libreria';

  @override
  String get libraryPauseAll => 'Metti tutto in pausa';

  @override
  String get libraryResumeAll => 'Riprendi tutto';

  @override
  String get libraryTabPlaylists => 'Playlist';

  @override
  String get libraryTabDownloads => 'Download';

  @override
  String get libraryTabDownloading => 'In download';

  @override
  String libraryImportedTask(String name) {
    return 'Importato $name';
  }

  @override
  String get libraryImportWaiting => 'In attesa in coda...';

  @override
  String get libraryImportFetching => 'Recupero playlist in corso...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total elaborati · $matched corrispondenti';
  }

  @override
  String get libraryImportSaving => 'Salvataggio nella libreria...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched brani aggiunti · tocca × per chiudere';
  }

  @override
  String get libraryImportDoneAll =>
      'Tutti i brani aggiunti · tocca × per chiudere';

  @override
  String get libraryAddButton => 'Aggiungi';

  @override
  String get librarySortRecent => 'Aggiunti di Recente';

  @override
  String get librarySortAlpha => 'Alfabetico';

  @override
  String get libraryEmptyTitle => 'La tua libreria è vuota.';

  @override
  String get libraryEmptyDesc =>
      'Tocca \"Aggiungi\" per iniziare il tuo primo Pulse.';

  @override
  String get libraryRenameLikedError =>
      'Impossibile rinominare la playlist Brani che ti piacciono.';

  @override
  String get libraryRename => 'Rinomina';

  @override
  String get libraryEditSongs => 'Modifica Brani';

  @override
  String get libraryDeleteLikedError =>
      'Impossibile eliminare la playlist Brani che ti piacciono.';

  @override
  String get libraryDelete => 'Elimina';

  @override
  String get libraryEditSongsTitle => 'Modifica Brani';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count brano';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count brani';
  }

  @override
  String get libraryCancel => 'Annulla';

  @override
  String get librarySave => 'Salva';

  @override
  String get libraryNoSongs => 'Nessun brano in questa playlist.';

  @override
  String get libraryAddOptionsTitle => 'Aggiungi alla Libreria';

  @override
  String get libraryAddOptionsDesc => 'Scegli come vuoi espandere il tuo Pulse';

  @override
  String get libraryImportPulse => 'Importa da Pulse';

  @override
  String get libraryImportPulseDesc => 'Incolla un URL playlist Pulse';

  @override
  String get libraryImportYtm => 'Importa da YT Music';

  @override
  String get libraryImportYtmDesc => 'Incolla un URL playlist PUBBLICA';

  @override
  String get libraryImportSpotify => 'Importa da Spotify';

  @override
  String get libraryImportSpotifyDesc => 'Connetti il tuo Spotify';

  @override
  String get libraryClose => 'Chiudi';

  @override
  String get libraryImportYtmFull => 'Importa da YouTube Music';

  @override
  String get libraryImportSpotifyFull => 'Importa da Spotify (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'Incolla l\'URL di una playlist o di un album PUBBLICO di YouTube Music';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'Incolla l\'URL di una playlist pubblica di Spotify qui sotto';

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
      'Impossibile importare la playlist di Pulse';

  @override
  String get importErrorPlaylist =>
      'Errore durante l\'importazione della playlist';

  @override
  String get importErrorHighlyPopulated =>
      'La playlist è molto grande, il recupero potrebbe richiedere un po\' di tempo.';

  @override
  String get libraryImportBtn => 'Importa';

  @override
  String get libraryCreateTitle => 'Nuova Playlist';

  @override
  String get libraryCreateDesc =>
      'Come dovremmo chiamare la tua nuova playlist?';

  @override
  String get libraryCreateHint => 'es. Viaggio Notturno';

  @override
  String get libraryCreateBtn => 'Crea';

  @override
  String get libraryRenameTitle => 'Rinomina Playlist';

  @override
  String get libraryRenameDesc =>
      'Inserisci un nuovo nome per la tua playlist.';

  @override
  String get libraryRenameBtn => 'Rinomina';

  @override
  String get libraryDeleteTitle => 'Eliminare Playlist?';

  @override
  String libraryDeleteDesc(String name) {
    return 'Sei sicuro di voler eliminare \"$name\"? Questa playlist andrà persa per sempre.';
  }

  @override
  String get libraryDeleteBtn => 'Elimina';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'Recenti';

  @override
  String librarySongsCount(String count) {
    return '$count Brani';
  }

  @override
  String get libraryComingSoon => 'Prossimamente';

  @override
  String get loginErrName => 'Inserisci il tuo nome';

  @override
  String get loginErrEmail => 'Inserisci il tuo indirizzo email';

  @override
  String get loginErrPassword => 'Inserisci la tua password';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'Senti Ogni Battito!';

  @override
  String get loginMadeWithHeartBy => 'Fatto con ❤️ da ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'Il tuo nome';

  @override
  String get loginHintEmail => 'Indirizzo email';

  @override
  String get loginHintPassword => 'Password';

  @override
  String get loginErrEmailReset =>
      'Inserisci la tua email per reimpostare la password';

  @override
  String get loginResetSent =>
      'Email per il ripristino della password inviata! Controlla la tua casella di posta.';

  @override
  String get loginForgotPwd => 'Hai dimenticato la password?';

  @override
  String get loginBtnSignup => 'Crea un Account';

  @override
  String get loginBtnSignin => 'Accedi';

  @override
  String get loginToggleHaveAccount => 'Hai già un account Pulse? ';

  @override
  String get loginToggleNoAccount => 'Non hai un account Pulse? ';

  @override
  String get loginToggleSignin => 'Accedi';

  @override
  String get loginToggleSignup => 'Iscriviti';

  @override
  String get offlineStillOffline =>
      'Ancora offline. Controlla la tua connessione.';

  @override
  String get offlineTitle => 'Sei Offline';

  @override
  String get offlineSubtitle =>
      'Nessuna connessione internet trovata.\nControlla la tua rete e riprova.';

  @override
  String get offlineChecking => 'Controllo in corso...';

  @override
  String get offlineRetry => 'Riprova';

  @override
  String get offlineGoToDownloads => 'Vai ai Download';

  @override
  String get playerMadeWithHeartBy => 'Fatto con ❤️ da ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'Scorri per i testi';

  @override
  String get playerNoLyrics => 'Nessun testo disponibile';

  @override
  String get playerUpNext => 'Prossimi brani';

  @override
  String get playerNoTracksInQueue => 'Nessun brano in coda';

  @override
  String get playerNoMusicPlaying => 'Nessuna musica in riproduzione';

  @override
  String get playerPickAVibe =>
      'Scegli un\'atmosfera dalla tua libreria o dalla home';

  @override
  String get playerGoHome => 'Vai alla Home';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'Equalizzatore';

  @override
  String get playerEqCustom => 'Personalizzato';

  @override
  String get playlistDownloads => 'Download';

  @override
  String get playlistOffline => 'Playlist Offline';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '${hours}o ${mins}min';
  }

  @override
  String playlistDurationMins(String mins) {
    return '${mins}min';
  }

  @override
  String get playlistFindOnPage => 'Trova in questa pagina';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count brani • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'Recenti';

  @override
  String get playlistNoMatches => 'Nessuna corrispondenza trovata.';

  @override
  String get playlistNoTracks => 'Nessun brano in questa playlist.';

  @override
  String get playlistNoSongsYet => 'Nessun brano ancora.';

  @override
  String get playlistSortRecentlyAdded => 'Aggiunti di Recente';

  @override
  String get playlistSortAlphabetical => 'Alfabetico';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'brani',
      one: 'brano',
    );
    return 'Download di $count $_temp0 in corso';
  }

  @override
  String get playlistView => 'VISUALIZZA';

  @override
  String get playlistAllDownloaded => 'Tutti i brani sono già stati scaricati';

  @override
  String playlistShareText(String name, String url) {
    return 'Dai un\'occhiata a \"$name\" su Pulse!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'Rimuovi dai Download';

  @override
  String get playlistRemoveFromPlaylist => 'Rimuovi dalla Playlist';

  @override
  String get playlistLoadError => 'Impossibile caricare questa playlist.';

  @override
  String get playlistGoBack => '← Torna indietro';

  @override
  String get profileNotLoggedIn => 'Non hai effettuato l\'accesso';

  @override
  String get profileSignIn => 'Accedi';

  @override
  String get profileDefaultUser => 'Utente Pulse';

  @override
  String get profileEditProfile => 'Modifica Profilo';

  @override
  String get profileTimeframeDay => 'Giorno';

  @override
  String get profileTimeframeWeek => 'Settimana';

  @override
  String get profileTimeframeMonth => 'Mese';

  @override
  String get profileTimeframeYear => 'Anno';

  @override
  String get profileListeningTime => 'TEMPO DI ASCOLTO';

  @override
  String get profileToday => 'Oggi';

  @override
  String get profileThisWeek => 'Questa settimana';

  @override
  String get profileThisMonth => 'Questo mese';

  @override
  String get profileThisYear => 'Quest\'anno';

  @override
  String get profileDailyAvg => 'MEDIA GIORNALIERA';

  @override
  String get profilePerDay => 'Al giorno';

  @override
  String get profileLifetimeListening => 'ASCOLTO TOTALE';

  @override
  String get profileTotalTimeListened =>
      'Tempo totale di ascolto della musica su Pulse';

  @override
  String get profileYourTopSongs => 'I Tuoi Brani Migliori';

  @override
  String get profileListeningHistoryEmpty =>
      'La cronologia di ascolto apparirà qui.';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'riproduzioni',
      one: 'riproduzione',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => 'I Tuoi Artisti Migliori';

  @override
  String get profileTopArtistsEmpty =>
      'I tuoi artisti preferiti appariranno qui.';

  @override
  String get profileArtistLabel => 'Artista';

  @override
  String get profileSignOut => 'Esci';

  @override
  String profileVersion(String version) {
    return 'Versione $version';
  }

  @override
  String get profileMadeWithHeartBy => 'Fatto con ❤️ da ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'MODIFICA PROFILO';

  @override
  String get profileDisplayName => 'NOME VISUALIZZATO';

  @override
  String get profileCancel => 'Annulla';

  @override
  String get profileSave => 'Salva';

  @override
  String get profileChooseAvatar => 'Scegli Avatar';

  @override
  String get searchMicPermissionRequired =>
      'Autorizzazione del microfono necessaria per questa funzione';

  @override
  String get searchUnknownSong => 'Brano Sconosciuto';

  @override
  String get searchUnknownArtist => 'Artista Sconosciuto';

  @override
  String get searchNoSongDetected => 'Nessun brano rilevato.';

  @override
  String searchError(String message) {
    return 'Errore: $message';
  }

  @override
  String get searchSpeechNotAvailable =>
      'Riconoscimento vocale non disponibile';

  @override
  String get searchHint => 'Brani, artisti, album...';

  @override
  String get searchRecentEmpty => 'Le tue ricerche recenti appaiono qui';

  @override
  String get searchRecentSearches => 'Ricerche Recenti';

  @override
  String get searchClearAll => 'Cancella tutto';

  @override
  String searchNoResultsFor(String query) {
    return 'Nessun risultato per \"$query\"';
  }

  @override
  String get searchTryDifferentKeywords => 'Prova con parole chiave diverse';

  @override
  String get searchTopResult => 'Miglior risultato';

  @override
  String get searchSongsLabel => 'Brani';

  @override
  String get searchArtistsLabel => 'Artisti';

  @override
  String get searchAlbumsLabel => 'Album';

  @override
  String get searchPlaylistsLabel => 'Playlist';

  @override
  String get searchArtistLabel => 'Artista';

  @override
  String get searchListening => 'In ascolto...';

  @override
  String get searchSpeakNow => 'Parla ora per cercare';

  @override
  String get searchCancel => 'Annulla';

  @override
  String get searchIdentifying => 'Identificazione...';

  @override
  String get searchListeningForSong => 'Ascoltando un brano...';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsStreamingQuality => 'Qualità Streaming';

  @override
  String get settingsQualityAutomatic => 'Automatica';

  @override
  String get settingsQualityLow => 'Bassa';

  @override
  String get settingsQualityNormal => 'Normale';

  @override
  String get settingsQualityHigh => 'Alta';

  @override
  String get settingsDownloadQuality => 'Qualità Download';

  @override
  String get settingsPlayback => 'Riproduzione';

  @override
  String get settingsCrossfade => 'Dissolvenza Incrociata';

  @override
  String get settingsCrossfadeDesc =>
      'Sovrapponi le tracce per transizioni senza pause';

  @override
  String get settingsDataUsage => 'Utilizzo Dati';

  @override
  String get settingsDataSaver => 'Risparmio Dati';

  @override
  String get settingsDataSaverDesc =>
      'Esegui lo streaming a qualità inferiore su rete cellulare';

  @override
  String get settingsAppearance => 'Aspetto';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsCustomAccent => 'Colore di Accento Personalizzato';

  @override
  String get settingsSaturation => 'Saturazione';

  @override
  String get settingsBrightness => 'Luminosità';

  @override
  String get settingsResetDefault => 'Ripristina Predefinito';

  @override
  String get playlistSheetTitle => 'Aggiungi alla Playlist';

  @override
  String get playlistSheetNewPlaylist => 'Nuova Playlist';

  @override
  String get playlistSheetNoPlaylists => 'Ancora nessuna playlist';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'brani',
      one: 'brano',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => 'Nome Playlist';

  @override
  String get playlistSheetCancel => 'Annulla';

  @override
  String playlistSheetAddedTo(String name) {
    return 'Aggiunto a $name';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'Impossibile creare la playlist: Errore di autenticazione';

  @override
  String playlistSheetCreateFail(String error) {
    return 'Impossibile creare la playlist: $error';
  }

  @override
  String get playlistSheetCreate => 'Crea';

  @override
  String get appUpdateAvailable => 'Aggiornamento Disponibile';

  @override
  String appUpdateDesc(String version) {
    return 'La versione $version è qui! Aggiorna ora per avere le ultime funzionalità.';
  }

  @override
  String get appUpdateDownload => 'Scarica Aggiornamento';

  @override
  String get navHome => 'Home';

  @override
  String get navLibrary => 'Libreria';

  @override
  String get navSearch => 'Cerca';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get navProfile => 'Profilo';

  @override
  String get artistSelect => 'Seleziona Artista';

  @override
  String get songActionQueue => 'Aggiungi in Coda';

  @override
  String get songActionPlaylist => 'Aggiungi alla Playlist';

  @override
  String get songActionFinding => 'Ricerca in corso...';

  @override
  String get songActionAlbum => 'Vai all\'Album';

  @override
  String get songActionArtist => 'Vai all\'Artista';

  @override
  String get songActionRemovePlaylist => 'Rimuovi dalla Playlist';

  @override
  String get songActionRemoveDownload => 'Rimuovi dai Download';

  @override
  String get songActionDownloadChecking => 'Controllo in corso...';

  @override
  String get songActionDownloading => 'Download in corso...';

  @override
  String get songActionDownloaded => 'Scaricato!';

  @override
  String get songActionDownloadAlready => 'Già scaricato';

  @override
  String get songActionDownloadFailed => 'Download non riuscito';

  @override
  String get songActionDownload => 'Scarica';

  @override
  String get songActionDownloadingSnack => 'In download';

  @override
  String get songActionView => 'VISUALIZZA';

  @override
  String get spotifyImportTitle => 'Importa da Spotify';

  @override
  String get spotifyImportSubtitle => 'Scegli la dimensione della tua playlist';

  @override
  String get spotifyChoiceSmallTitle => '100 brani o meno';

  @override
  String get spotifyChoiceSmallDesc =>
      'Incolla l\'URL di una playlist pubblica di Spotify.';

  @override
  String get spotifyChoiceLargeTitle => 'Più di 100 brani';

  @override
  String get spotifyChoiceLargeDesc =>
      'Connetti la tua App per Sviluppatori Spotify per importare tracce illimitate.';

  @override
  String get cancelButton => 'Annulla';

  @override
  String get spotifyPlaylistsTitle => 'Le Tue Playlist Spotify';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'Errore: $error\nAssicurati che il tuo Client ID sia valido.';
  }

  @override
  String get spotifyPlaylistsEmpty =>
      'Nessuna playlist trovata nella tua libreria';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count brani';
  }

  @override
  String get spotifyPlaylistsImport => 'Importa';

  @override
  String get audioPlaybackFailed =>
      'Riproduzione fallita. Controlla la tua connessione internet.';

  @override
  String get audioControlPrevious => 'Precedente';

  @override
  String get audioControlPause => 'Pausa';

  @override
  String get audioControlPlay => 'Riproduci';

  @override
  String get audioControlNext => 'Successivo';

  @override
  String get audioControlUnlike => 'Non mi piace più';

  @override
  String get audioControlLike => 'Mi piace';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'Risposta grezza: $data\n\nFallback: $error';
  }

  @override
  String get apiErrorInvalidClient => 'Client o client secret non valido.';

  @override
  String get apiErrorBadRequest =>
      'Richiesta non valida. Controlla i tuoi inserimenti.';

  @override
  String get apiErrorUnauthorized =>
      'Non autorizzato. Effettua di nuovo l\'accesso.';

  @override
  String get apiErrorForbidden => 'Accesso negato. Non hai le autorizzazioni.';

  @override
  String get apiErrorNotFound => 'Risorsa non trovata.';

  @override
  String get apiErrorEmailInUse => 'Questo indirizzo email è già in uso.';

  @override
  String get apiErrorUserNotFound => 'Nessun account trovato con questa email.';

  @override
  String get apiErrorWrongPassword => 'Password errata.';

  @override
  String get apiErrorInvalidCredential =>
      'Accesso fallito. Controlla le tue credenziali.';

  @override
  String get apiErrorNetwork => 'Errore di rete. Controlla la tua connessione.';

  @override
  String get apiErrorSocketTimeout => 'Connessione scaduta. Riprova.';

  @override
  String get apiErrorTooManyRequests =>
      'Troppe richieste. Attendi un momento e riprova.';

  @override
  String get apiErrorServerError => 'Errore del server. Riprova più tardi.';

  @override
  String get apiErrorInvalidEmail => 'Inserisci un indirizzo email valido.';

  @override
  String get apiErrorWeakPassword =>
      'La password è troppo debole. Usa almeno 6 caratteri.';

  @override
  String get apiErrorTooManyAttempts =>
      'Troppi tentativi falliti. Riprova più tardi.';

  @override
  String get homeForgottenFavorites => 'Preferiti dimenticati';

  @override
  String get artistShowAll => 'Mostra tutto';

  @override
  String get homeTopTracks => 'Brani più ascoltati';
}
