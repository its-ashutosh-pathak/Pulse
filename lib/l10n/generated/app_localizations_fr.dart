// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'À propos';

  @override
  String get artistPopular => 'Populaire';

  @override
  String get artistAlbums => 'Albums';

  @override
  String get artistSinglesAndEPs => 'Singles & EPs';

  @override
  String artistSubscribersCount(String count) {
    return '$count abonnés';
  }

  @override
  String get artistPlayAll => 'Tout Lire';

  @override
  String get artistLoadError => 'Impossible de charger l\'artiste';

  @override
  String get artistGoBack => 'Retour';

  @override
  String adminChatFailedToReply(String error) {
    return 'Échec de la réponse : $error';
  }

  @override
  String get adminChatSupportChat => 'Tchat d\'assistance';

  @override
  String adminChatError(String error) {
    return 'Erreur : $error';
  }

  @override
  String get adminChatNoHistory => 'Aucun historique des conversations.';

  @override
  String get adminChatSupportYou => 'Assistance (pour vous)';

  @override
  String get adminChatTypeReply => 'Écrivez votre réponse...';

  @override
  String get broadcastSuccess => 'L\'annonce a été diffusée avec succès !';

  @override
  String broadcastFailed(String error) {
    return 'Échec de la diffusion : $error';
  }

  @override
  String get broadcastTitle => 'Annonces principales';

  @override
  String get broadcastSubtitle => 'Envoyé à tous les utilisateurs';

  @override
  String get broadcastWarning =>
      'Les messages envoyés ici seront visibles par tout le monde.';

  @override
  String broadcastError(String error) {
    return 'Erreur : $error';
  }

  @override
  String get broadcastNoHistory => 'Aucune annonce préalable.';

  @override
  String get broadcastTypeMessage => 'Saisissez une diffusion globale...';

  @override
  String commFailedToSend(String error) {
    return 'Échec de l\'envoi : $error';
  }

  @override
  String get commAdminDashboard => 'Tableau de bord de l\'administrateur';

  @override
  String get commAdminSupport => 'Assistance administrative';

  @override
  String get commAlwaysHere => 'Toujours là pour vous aider';

  @override
  String get commWelcomeTitle => 'Salut ! 👋 Je m\'appelle Ashutosh Pathak';

  @override
  String get commWelcomeSubtitle => 'Développeur de Pulse';

  @override
  String get commWelcomeBody1 =>
      'J\'espère que vous appréciez d\'écouter votre musique préférée sans publicités agaçantes ni obstacles liés à un abonnement. Après tout, la musique ne devrait pas être soumise à un accès payant simplement parce qu\'un dirigeant avait besoin d\'un yacht de plus.\n\nCette rubrique a pour but de nous permettre d\'échanger directement.\n\nN\'hésitez pas à :';

  @override
  String get commBullet1 => 'Donner votre avis';

  @override
  String get commBullet2 => 'Signaler un bug';

  @override
  String get commBullet3 =>
      'Proposez de nouvelles fonctionnalités que vous aimeriez voir apparaître';

  @override
  String get commWelcomeBody2 =>
      'Je lis personnellement chaque message et je ferai de mon mieux pour améliorer l\'application en tenant compte de vos suggestions.\n\nVous avez une idée d\'application qui n\'existe pas encore, ou qui est réservée aux abonnés payants ? Parlez-en ! Si c\'est possible, j\'essaierai de la développer et de la rendre accessible à tous.\n\nMerci d\'utiliser mon application et de m\'accompagner dans cette aventure. ❤️';

  @override
  String commError(String error) {
    return 'Erreur : $error';
  }

  @override
  String get commNoMessages => 'Aucun message pour l\'instant';

  @override
  String get commNoMessagesDesc =>
      'Envoyez un message à notre équipe d\'assistance ou revenez plus tard pour prendre connaissance des annonces.';

  @override
  String get commMessageSupportHint => 'Saisissez votre message...';

  @override
  String get commGlobalAnnouncements => 'Annonces principales';

  @override
  String get commSendMessagesToAll =>
      'Envoyer des messages à tous les utilisateurs';

  @override
  String get homeGreetingMorning => 'Bonjour,';

  @override
  String get homeGreetingAfternoon => 'Bonjour,';

  @override
  String get homeGreetingEvening => 'Bonsoir,';

  @override
  String get homeMember => 'Membre';

  @override
  String get homeRecentPlaylists => 'Playlists Récentes';

  @override
  String get homeRecentlyPlayed => 'Écoutés Récemment';

  @override
  String get homeSpeedDial => 'Sélection Rapide';

  @override
  String get homeNoContent => 'Aucun contenu disponible';

  @override
  String get homeRefresh => 'Actualiser';

  @override
  String get homeLoadError => 'Impossible de charger le flux musical.';

  @override
  String get homeRetry => 'Réessayer';

  @override
  String get importSuccess => 'Connexion à Spotify réussie !';

  @override
  String importFailed(String error) {
    return 'Échec de la connexion : $error';
  }

  @override
  String get importTitle => 'Se connecter à Spotify';

  @override
  String get importSetupTitle => 'Configurer l\'intégration à Spotify';

  @override
  String get importSetupDesc =>
      'Pour contourner les limites de fréquence strictes de Spotify et importer instantanément toutes vos playlists, vous devez utiliser votre propre clé de développeur gratuite. Suivez ces étapes simples :';

  @override
  String get importStep1 =>
      'Ouvrez le tableau de bord des développeurs Spotify.';

  @override
  String get importStep2 =>
      'Connectez-vous, puis cliquez sur « Créer une application ».';

  @override
  String get importStep3 =>
      'Saisissez le nom et la description de l\'application de votre choix.';

  @override
  String get importStep4 =>
      'Sous « URI de redirection », collez l’URL exacte suivante :';

  @override
  String get importRedirectCopied => 'L\'URI de redirection a été copiée !';

  @override
  String get importStep5 =>
      'Enregistrez l\'application, copiez votre « ID client » dans les paramètres, puis collez-le ci-dessous.';

  @override
  String get importImportant =>
      'Important : le compte Spotify utilisé pour créer cette application développeur doit disposer d\'un abonnement Premium actif.';

  @override
  String get importClientIdHint =>
      'Collez ici votre identifiant client Spotify...';

  @override
  String get importConnectButton => 'Se connecter et charger la bibliothèque';

  @override
  String get downloadingNoActive => 'Aucun téléchargement en cours';

  @override
  String downloadingMb(String value) {
    return '$value Mo';
  }

  @override
  String get downloadsPlaylistName => 'Téléchargements';

  @override
  String downloadsStats(String count, String size) {
    return '$count titres • $size';
  }

  @override
  String get downloadsNoOffline => 'Aucun titre hors ligne pour le moment';

  @override
  String get downloadsNoOfflineDesc =>
      'Les titres que vous téléchargez s\'afficheront ici';

  @override
  String get downloadsClearAllTitle => 'Effacer tous les téléchargements ?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'Cela supprimera $count titres et libérera $size d\'espace de stockage.';
  }

  @override
  String get downloadsCancel => 'Annuler';

  @override
  String get downloadsClearAll => 'Tout effacer';

  @override
  String downloadsSongsCount(String count) {
    return '$count titres';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count titre';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'Impossible de renommer la playlist principale « Téléchargements ».';

  @override
  String get downloadsRename => 'Renommer';

  @override
  String get downloadsEditSongs => 'Modifier les titres';

  @override
  String get downloadsDelete => 'Supprimer';

  @override
  String get downloadsRenamePlaylistTitle => 'Renommer la playlist';

  @override
  String get downloadsRenamePlaylistDesc =>
      'Saisissez un nouveau nom pour votre playlist.';

  @override
  String get downloadsDeletePlaylistTitle => 'Supprimer la playlist ?';

  @override
  String get downloadsDeleteMasterDesc =>
      'Êtes-vous sûr de vouloir supprimer cela ? Vous perdrez définitivement tous les titres et playlists téléchargés.';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'Êtes-vous sûr de vouloir supprimer « $name » ? Cette playlist sera définitivement perdue.';
  }

  @override
  String get downloadsSave => 'Enregistrer';

  @override
  String get downloadsNoSongs => 'Cette playlist ne contient aucun titre.';

  @override
  String get libraryTitle => 'Bibliothèque';

  @override
  String get libraryPauseAll => 'Tout mettre en pause';

  @override
  String get libraryResumeAll => 'Tout reprendre';

  @override
  String get libraryTabPlaylists => 'Playlists';

  @override
  String get libraryTabDownloads => 'Téléchargements';

  @override
  String get libraryTabDownloading => 'Téléchargement';

  @override
  String libraryImportedTask(String name) {
    return '$name importé';
  }

  @override
  String get libraryImportWaiting => 'En attente dans la file d\'attente...';

  @override
  String get libraryImportFetching => 'Chargement de la playlist...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total traitées · $matched correspondant';
  }

  @override
  String get libraryImportSaving => 'Enregistrement dans la bibliothèque...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched titres ajoutés · appuyez sur × pour ignorer';
  }

  @override
  String get libraryImportDoneAll =>
      'Tous les titres ajoutés · appuyez sur × pour fermer';

  @override
  String get libraryAddButton => 'Ajouter';

  @override
  String get librarySortRecent => 'Ajoutés récemment';

  @override
  String get librarySortAlpha => 'Par ordre alphabétique';

  @override
  String get libraryEmptyTitle => 'Votre bibliothèque est vide.';

  @override
  String get libraryEmptyDesc =>
      'Appuyez sur « Ajouter » pour créer votre premier Pulse.';

  @override
  String get libraryRenameLikedError =>
      'Impossible de renommer la playlist « Titres Favoris ».';

  @override
  String get libraryRename => 'Renommer';

  @override
  String get libraryEditSongs => 'Modifier les titres';

  @override
  String get libraryDeleteLikedError =>
      'Impossible de supprimer la playlist « Titres Favoris ».';

  @override
  String get libraryDelete => 'Supprimer';

  @override
  String get libraryEditSongsTitle => 'Modifier les titres';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count titre';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count titres';
  }

  @override
  String get libraryCancel => 'Annuler';

  @override
  String get librarySave => 'Enregistrer';

  @override
  String get libraryNoSongs => 'Aucun titre dans cette playlist.';

  @override
  String get libraryAddOptionsTitle => 'Ajouter à la bibliothèque';

  @override
  String get libraryAddOptionsDesc =>
      'Choisissez comment vous souhaitez développer votre Pulse';

  @override
  String get libraryImportPulse => 'Importer depuis Pulse';

  @override
  String get libraryImportPulseDesc => 'Coller l\'URL d\'une playlist Pulse';

  @override
  String get libraryImportYtm => 'Importer depuis YouTube Music';

  @override
  String get libraryImportYtmDesc => 'Collez l\'URL d\'une playlist publique';

  @override
  String get libraryImportSpotify => 'Importer depuis Spotify';

  @override
  String get libraryImportSpotifyDesc => 'Connectez votre compte Spotify';

  @override
  String get libraryClose => 'Fermer';

  @override
  String get libraryImportYtmFull => 'Importer depuis YouTube Music';

  @override
  String get libraryImportSpotifyFull => 'Importer depuis Spotify (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'Collez l\'URL d\'une playlist ou d\'un album YouTube Music publique';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'Collez ci-dessous l\'URL d\'une playlist Spotify publique';

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
      'Échec de l\'importation de la playlist Pulse';

  @override
  String get importErrorPlaylist =>
      'Erreur lors de l\'importation de la playlist';

  @override
  String get importErrorHighlyPopulated =>
      'La playlist contient beaucoup d\'éléments ; son chargement peut prendre un certain temps.';

  @override
  String get libraryImportBtn => 'Importer';

  @override
  String get libraryCreateTitle => 'Nouvelle playlist';

  @override
  String get libraryCreateDesc =>
      'Comment devrions-nous appeler votre nouvelle playlist ?';

  @override
  String get libraryCreateHint => 'par exemple : « Midnight Rides »';

  @override
  String get libraryCreateBtn => 'Créer';

  @override
  String get libraryRenameTitle => 'Renommer une playlist';

  @override
  String get libraryRenameDesc =>
      'Saisissez un nouveau nom pour votre playlist.';

  @override
  String get libraryRenameBtn => 'Renommer';

  @override
  String get libraryDeleteTitle => 'Supprimer la playlist ?';

  @override
  String libraryDeleteDesc(String name) {
    return 'Êtes-vous sûr de vouloir supprimer « $name » ? Cette playlist sera définitivement perdue.';
  }

  @override
  String get libraryDeleteBtn => 'Supprimer';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'Récents';

  @override
  String librarySongsCount(String count) {
    return '$count titres';
  }

  @override
  String get libraryComingSoon => 'À venir';

  @override
  String get loginErrName => 'Veuillez saisir votre nom';

  @override
  String get loginErrEmail => 'Veuillez saisir votre adresse e-mail';

  @override
  String get loginErrPassword => 'Veuillez saisir votre mot de passe';

  @override
  String get loginAppName => 'Pulse';

  @override
  String get loginSubtitle => 'Ressentez chaque battement !';

  @override
  String get loginMadeWithHeartBy => 'Réalisé avec ❤️ par ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'Votre nom';

  @override
  String get loginHintEmail => 'Adresse e-mail';

  @override
  String get loginHintPassword => 'Mot de passe';

  @override
  String get loginErrEmailReset =>
      'Veuillez saisir votre adresse e-mail pour réinitialiser votre mot de passe';

  @override
  String get loginResetSent =>
      'Un e-mail de réinitialisation du mot de passe vous a été envoyé ! Vérifiez votre boîte de réception.';

  @override
  String get loginForgotPwd => 'Mot de passe oublié ?';

  @override
  String get loginBtnSignup => 'Créer un compte';

  @override
  String get loginBtnSignin => 'Se connecter';

  @override
  String get loginToggleHaveAccount => 'Vous avez déjà un compte Pulse ? ';

  @override
  String get loginToggleNoAccount =>
      'Vous n\'avez pas encore de compte Pulse ? ';

  @override
  String get loginToggleSignin => 'Se connecter';

  @override
  String get loginToggleSignup => 'S\'inscrire';

  @override
  String get offlineStillOffline =>
      'Toujours hors ligne. Veuillez vérifier votre connexion.';

  @override
  String get offlineTitle => 'Vous n\'êtes pas connecté(e)';

  @override
  String get offlineSubtitle =>
      'Aucune connexion Internet détectée.\nVérifiez votre réseau et réessayez.';

  @override
  String get offlineChecking => 'Vérification en cours...';

  @override
  String get offlineRetry => 'Réessayer';

  @override
  String get offlineGoToDownloads => 'Accéder aux téléchargements';

  @override
  String get playerMadeWithHeartBy => 'Réalisé avec ❤️ par ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'Faites glisser pour voir les paroles';

  @override
  String get playerNoLyrics => 'Paroles indisponibles';

  @override
  String get playerUpNext => 'À suivre';

  @override
  String get playerNoTracksInQueue => 'Aucun titre dans la file d\'attente';

  @override
  String get playerNoMusicPlaying => 'Aucune musique n\'est diffusée';

  @override
  String get playerPickAVibe =>
      'Choisissez une ambiance dans votre bibliothèque ou chez vous';

  @override
  String get playerGoHome => 'Aller à l\'accueil';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'Égaliseur';

  @override
  String get playerEqCustom => 'Personnalisé';

  @override
  String get playlistDownloads => 'Téléchargements';

  @override
  String get playlistOffline => 'Playlist hors ligne';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '${hours}h ${mins}min';
  }

  @override
  String playlistDurationMins(String mins) {
    return '${mins}min';
  }

  @override
  String get playlistFindOnPage => 'À découvrir sur cette page';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count titres • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'Récentes';

  @override
  String get playlistNoMatches => 'Aucun résultat trouvé.';

  @override
  String get playlistNoTracks => 'Aucun titre dans cette playlist.';

  @override
  String get playlistNoSongsYet => 'Pas encore de titres.';

  @override
  String get playlistSortRecentlyAdded => 'Ajoutés récemment';

  @override
  String get playlistSortAlphabetical => 'Par ordre alphabétique';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'titres',
      one: 'titre',
    );
    return 'Téléchargement $count $_temp0';
  }

  @override
  String get playlistView => 'APERÇU';

  @override
  String get playlistAllDownloaded => 'Tous les titres sont déjà téléchargés';

  @override
  String playlistShareText(String name, String url) {
    return 'Découvrez « $name » sur Pulse !\n$url';
  }

  @override
  String get playlistRemoveFromDownloads =>
      'Supprimer du dossier « Téléchargements »';

  @override
  String get playlistRemoveFromPlaylist => 'Supprimer de la playlist';

  @override
  String get playlistLoadError => 'Impossible de charger cette playlist.';

  @override
  String get playlistGoBack => '← Retour';

  @override
  String get profileNotLoggedIn => 'Non connecté';

  @override
  String get profileSignIn => 'Se connecter';

  @override
  String get profileDefaultUser => 'Utilisateur Pulse';

  @override
  String get profileEditProfile => 'Modifier le profil';

  @override
  String get profileTimeframeDay => 'Jour';

  @override
  String get profileTimeframeWeek => 'Semaine';

  @override
  String get profileTimeframeMonth => 'Mois';

  @override
  String get profileTimeframeYear => 'Année';

  @override
  String get profileListeningTime => 'DURÉE D\'ÉCOUTE';

  @override
  String get profileToday => 'Aujourd\'hui';

  @override
  String get profileThisWeek => 'Cette semaine';

  @override
  String get profileThisMonth => 'Ce mois-ci';

  @override
  String get profileThisYear => 'Cette année';

  @override
  String get profileDailyAvg => 'MOYENNE QUOTIDIENNE';

  @override
  String get profilePerDay => 'Par jour';

  @override
  String get profileLifetimeListening => 'ÉCOUTE À VIE';

  @override
  String get profileTotalTimeListened =>
      'Durée totale d\'écoute de musique sur Pulse';

  @override
  String get profileYourTopSongs => 'Vos titres préférés';

  @override
  String get profileListeningHistoryEmpty =>
      'L\'historique d\'écoute s\'affichera ici.';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'écoutes',
      one: 'écoute',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => 'Vos artistes préférés';

  @override
  String get profileTopArtistsEmpty =>
      'Vos artistes préférés apparaîtront ici.';

  @override
  String get profileArtistLabel => 'Artiste';

  @override
  String get profileSignOut => 'Se déconnecter';

  @override
  String profileVersion(String version) {
    return 'Version $version';
  }

  @override
  String get profileMadeWithHeartBy => 'Réalisé avec ❤️ par ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'MODIFIER LE PROFIL';

  @override
  String get profileDisplayName => 'NOM D\'AFFICHAGE';

  @override
  String get profileCancel => 'Annuler';

  @override
  String get profileSave => 'Enregistrer';

  @override
  String get profileChooseAvatar => 'Choisissez un avatar';

  @override
  String get searchMicPermissionRequired =>
      'Cette fonctionnalité nécessite l\'autorisation d\'accès au microphone';

  @override
  String get searchUnknownSong => 'Titre inconnu';

  @override
  String get searchUnknownArtist => 'Artiste inconnu';

  @override
  String get searchNoSongDetected => 'Aucun titre détecté.';

  @override
  String searchError(String message) {
    return 'Erreur : $message';
  }

  @override
  String get searchSpeechNotAvailable => 'Reconnaissance vocale non disponible';

  @override
  String get searchHint => 'Titres, artistes, albums, playlists…';

  @override
  String get searchRecentEmpty => 'Vos recherches récentes s\'affichent ici';

  @override
  String get searchRecentSearches => 'Recherches récentes';

  @override
  String get searchClearAll => 'Tout effacer';

  @override
  String searchNoResultsFor(String query) {
    return 'Aucun résultat pour « $query »';
  }

  @override
  String get searchTryDifferentKeywords => 'Essayez différents mots-clés';

  @override
  String get searchTopResult => 'Meilleur résultat';

  @override
  String get searchSongsLabel => 'Titres';

  @override
  String get searchArtistsLabel => 'Artistes';

  @override
  String get searchAlbumsLabel => 'Albums';

  @override
  String get searchPlaylistsLabel => 'Playlists';

  @override
  String get searchArtistLabel => 'Artiste';

  @override
  String get searchListening => 'Écoute...';

  @override
  String get searchSpeakNow => 'Parlez maintenant pour lancer la recherche';

  @override
  String get searchCancel => 'Annuler';

  @override
  String get searchIdentifying => 'Identification en cours...';

  @override
  String get searchListeningForSong => 'À l\'écoute d\'un titre...';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsStreamingQuality => 'Qualité de streaming';

  @override
  String get settingsQualityAutomatic => 'Automatique';

  @override
  String get settingsQualityLow => 'Faible';

  @override
  String get settingsQualityNormal => 'Normale';

  @override
  String get settingsQualityHigh => 'Élevée';

  @override
  String get settingsDownloadQuality => 'Qualité du téléchargement';

  @override
  String get settingsPlayback => 'Lecture';

  @override
  String get settingsCrossfade => 'Fondu enchaîné';

  @override
  String get settingsCrossfadeDesc =>
      'Faire se chevaucher les titres pour obtenir des transitions sans interruption';

  @override
  String get settingsDataUsage => 'Utilisation des données';

  @override
  String get settingsDataSaver => 'Économiseur de données';

  @override
  String get settingsDataSaverDesc =>
      'Diffuser en qualité inférieure via le réseau mobile';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsCustomAccent => 'Couleur';

  @override
  String get settingsSaturation => 'Saturation';

  @override
  String get settingsBrightness => 'Luminosité';

  @override
  String get settingsResetDefault => 'Réinitialiser par défaut';

  @override
  String get playlistSheetTitle => 'Ajouter à la playlist';

  @override
  String get playlistSheetNewPlaylist => 'Nouvelle playlist';

  @override
  String get playlistSheetNoPlaylists => 'Aucune playlist pour le moment';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'titres',
      one: 'titre',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => 'Nom de la playlist';

  @override
  String get playlistSheetCancel => 'Annuler';

  @override
  String playlistSheetAddedTo(String name) {
    return 'Ajouté à $name';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'Échec de la création de la playlist : erreur d\'authentification';

  @override
  String playlistSheetCreateFail(String error) {
    return 'Échec de la création de la playlist : $error';
  }

  @override
  String get playlistSheetCreate => 'Créer';

  @override
  String get appUpdateAvailable => 'Mise à jour disponible';

  @override
  String appUpdateDesc(String version) {
    return 'La version $version est disponible ! Mettez-la à jour dès maintenant pour bénéficier des dernières fonctionnalités.';
  }

  @override
  String get appUpdateDownload => 'Télécharger la mise à jour';

  @override
  String get navHome => 'Accueil';

  @override
  String get navLibrary => 'Bibliothèque';

  @override
  String get navSearch => 'Rechercher';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get navProfile => 'Profil';

  @override
  String get artistSelect => 'Sélectionner un artiste';

  @override
  String get songActionQueue => 'Ajouter à la file d\'attente';

  @override
  String get songActionPlaylist => 'Ajouter à la playlist';

  @override
  String get songActionFinding => 'Recherche...';

  @override
  String get songActionAlbum => 'Voir l\'album';

  @override
  String get songActionArtist => 'Voir l\'artiste';

  @override
  String get songActionRemovePlaylist => 'Supprimer de la playlist';

  @override
  String get songActionRemoveDownload => 'Supprimer des téléchargements';

  @override
  String get songActionDownloadChecking => 'Vérification en cours...';

  @override
  String get songActionDownloading => 'Téléchargement en cours...';

  @override
  String get songActionDownloaded => 'Téléchargé !';

  @override
  String get songActionDownloadAlready => 'Déjà téléchargé';

  @override
  String get songActionDownloadFailed => 'Échec du téléchargement';

  @override
  String get songActionDownload => 'Télécharger';

  @override
  String get songActionDownloadingSnack => 'Téléchargement';

  @override
  String get songActionView => 'APERÇU';

  @override
  String get spotifyImportTitle => 'Importer depuis Spotify';

  @override
  String get spotifyImportSubtitle => 'Choisissez la taille de votre playlist';

  @override
  String get spotifyChoiceSmallTitle => '100 titres ou moins';

  @override
  String get spotifyChoiceSmallDesc =>
      'Collez l\'URL d\'une playlist Spotify publique.';

  @override
  String get spotifyChoiceLargeTitle => 'Plus de 100 titres';

  @override
  String get spotifyChoiceLargeDesc =>
      'Connectez votre propre application Spotify Developer pour importer un nombre illimité de titres.';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get spotifyPlaylistsTitle => 'Vos playlists Spotify';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'Erreur : $error\nVérifiez que votre identifiant client est valide.';
  }

  @override
  String get spotifyPlaylistsEmpty =>
      'Aucune playlist n\'a été trouvée dans votre bibliothèque';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count titres';
  }

  @override
  String get spotifyPlaylistsImport => 'Importer';

  @override
  String get audioPlaybackFailed =>
      'La lecture a échoué. Vérifiez votre connexion Internet.';

  @override
  String get audioControlPrevious => 'Précédent';

  @override
  String get audioControlPause => 'Pause';

  @override
  String get audioControlPlay => 'Lecture';

  @override
  String get audioControlNext => 'Suivant';

  @override
  String get audioControlUnlike => 'Je n\'aime pas';

  @override
  String get audioControlLike => 'J\'aime';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'Réponse brute : $data\n\nSolution de secours : $error';
  }

  @override
  String get apiErrorInvalidClient => 'Client ou secret client invalide.';

  @override
  String get apiErrorBadRequest =>
      'Erreur de requête. Veuillez vérifier les données saisies.';

  @override
  String get apiErrorUnauthorized =>
      'Accès non autorisé. Veuillez vous reconnecter.';

  @override
  String get apiErrorForbidden => 'Interdit. Vous n\'y avez pas accès.';

  @override
  String get apiErrorNotFound => 'Ressource introuvable.';

  @override
  String get apiErrorEmailInUse => 'Cette adresse e-mail est déjà utilisée.';

  @override
  String get apiErrorUserNotFound =>
      'Aucun compte n\'a été trouvé pour cette adresse e-mail.';

  @override
  String get apiErrorWrongPassword => 'Mot de passe incorrect.';

  @override
  String get apiErrorInvalidCredential =>
      'Échec de la connexion. Veuillez vérifier vos identifiants.';

  @override
  String get apiErrorNetwork =>
      'Erreur réseau. Veuillez vérifier votre connexion.';

  @override
  String get apiErrorSocketTimeout =>
      'Délai de connexion dépassé. Veuillez réessayer.';

  @override
  String get apiErrorTooManyRequests =>
      'Trop de requêtes. Veuillez patienter un instant et réessayer.';

  @override
  String get apiErrorServerError =>
      'Erreur serveur. Veuillez réessayer plus tard.';

  @override
  String get apiErrorInvalidEmail =>
      'Veuillez saisir une adresse e-mail valide.';

  @override
  String get apiErrorWeakPassword =>
      'Votre mot de passe est trop faible. Veuillez utiliser au moins 6 caractères.';

  @override
  String get apiErrorTooManyAttempts =>
      'Trop de tentatives infructueuses. Veuillez réessayer plus tard.';

  @override
  String get homeForgottenFavorites => 'Favoris oubliés';

  @override
  String get artistShowAll => 'Tout afficher';

  @override
  String get homeTopTracks => 'Titres populaires';
}
