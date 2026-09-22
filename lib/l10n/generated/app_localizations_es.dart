// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'Acerca de';

  @override
  String get artistPopular => 'Populares';

  @override
  String get artistAlbums => 'Álbumes';

  @override
  String get artistSinglesAndEPs => 'Sencillos y EPs';

  @override
  String artistSubscribersCount(String count) {
    return '$count suscriptores';
  }

  @override
  String get artistPlayAll => 'Reproducir todo';

  @override
  String get artistLoadError => 'No se pudo cargar el artista';

  @override
  String get artistGoBack => 'Atrás';

  @override
  String adminChatFailedToReply(String error) {
    return 'Error al responder: $error';
  }

  @override
  String get adminChatSupportChat => 'Chat de soporte';

  @override
  String adminChatError(String error) {
    return 'Error: $error';
  }

  @override
  String get adminChatNoHistory => 'No hay historial de mensajes.';

  @override
  String get adminChatSupportYou => 'Soporte (Tú)';

  @override
  String get adminChatTypeReply => 'Escribe una respuesta...';

  @override
  String get broadcastSuccess => '¡Anuncio enviado con éxito!';

  @override
  String broadcastFailed(String error) {
    return 'Error al enviar: $error';
  }

  @override
  String get broadcastTitle => 'Anuncio global';

  @override
  String get broadcastSubtitle => 'Enviado a todos los usuarios';

  @override
  String get broadcastWarning => 'Todos verán este mensaje.';

  @override
  String broadcastError(String error) {
    return 'Error: $error';
  }

  @override
  String get broadcastNoHistory => 'No hay anuncios globales.';

  @override
  String get broadcastTypeMessage => 'Escribe un anuncio...';

  @override
  String commFailedToSend(String error) {
    return 'Error al enviar: $error';
  }

  @override
  String get commAdminDashboard => 'Panel de administración';

  @override
  String get commAdminSupport => 'Soporte';

  @override
  String get commAlwaysHere => 'Siempre aquí para ayudar';

  @override
  String get commWelcomeTitle => '¡Hola! 👋 Soy Ashutosh Pathak';

  @override
  String get commWelcomeSubtitle => 'Creador de Pulse';

  @override
  String get commWelcomeBody1 =>
      'Espero que disfrutes de la música sin anuncios. La música debería ser libre.\n\nEste espacio es para que hables directamente conmigo.\n\nPuedes enviar:';

  @override
  String get commBullet1 => 'Tus comentarios';

  @override
  String get commBullet2 => 'Reportes de errores';

  @override
  String get commBullet3 => 'Sugerencias de funciones';

  @override
  String get commWelcomeBody2 =>
      'Leo cada mensaje personalmente.\n\n¿Tienes una idea para una nueva app? ¡Dime! Si es posible, la crearé.\n\nGracias por ser parte de esto. ❤️';

  @override
  String commError(String error) {
    return 'Error: $error';
  }

  @override
  String get commNoMessages => 'Aún no hay mensajes';

  @override
  String get commNoMessagesDesc =>
      'Envía un mensaje al soporte o revisa luego.';

  @override
  String get commMessageSupportHint => 'Escribe un mensaje...';

  @override
  String get commGlobalAnnouncements => 'Anuncios globales';

  @override
  String get commSendMessagesToAll => 'Enviar a todos';

  @override
  String get homeGreetingMorning => 'Buenos días,';

  @override
  String get homeGreetingAfternoon => 'Buenas tardes,';

  @override
  String get homeGreetingEvening => 'Buenas noches,';

  @override
  String get homeMember => 'Miembro';

  @override
  String get homeRecentPlaylists => 'Listas recientes';

  @override
  String get homeRecentlyPlayed => 'Escuchado recientemente';

  @override
  String get homeSpeedDial => 'Acceso rápido';

  @override
  String get homeNoContent => 'Sin contenido';

  @override
  String get homeRefresh => 'Actualizar';

  @override
  String get homeLoadError => 'No se pudo cargar el inicio.';

  @override
  String get homeRetry => 'Reintentar';

  @override
  String get importSuccess => '¡Conectado a Spotify con éxito!';

  @override
  String importFailed(String error) {
    return 'Error al conectar: $error';
  }

  @override
  String get importTitle => 'Conectar Spotify';

  @override
  String get importSetupTitle => 'Configuración de Spotify';

  @override
  String get importSetupDesc =>
      'Usa tu clave de desarrollador para importar listas rápidamente:';

  @override
  String get importStep1 => 'Abre el Spotify Developer Dashboard.';

  @override
  String get importStep2 => 'Inicia sesión y haz clic en \'Create app\'.';

  @override
  String get importStep3 => 'Dale un nombre y descripción a tu app.';

  @override
  String get importStep4 => 'En \'Redirect URIs\', pega este enlace exacto:';

  @override
  String get importRedirectCopied => '¡URI copiada!';

  @override
  String get importStep5 => 'Guarda, copia el \'Client ID\' y pégalo abajo.';

  @override
  String get importImportant =>
      'Importante: Se requiere una suscripción activa a Spotify Premium.';

  @override
  String get importClientIdHint => 'Pega tu Spotify Client ID aquí...';

  @override
  String get importConnectButton => 'Conectar y cargar biblioteca';

  @override
  String get downloadingNoActive => 'No hay descargas activas';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'Descargas';

  @override
  String downloadsStats(String count, String size) {
    return '$count canciones • $size';
  }

  @override
  String get downloadsNoOffline => 'No hay canciones offline';

  @override
  String get downloadsNoOfflineDesc =>
      'Tus canciones descargadas aparecerán aquí';

  @override
  String get downloadsClearAllTitle => '¿Borrar todo?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'Esto eliminará $count canciones y liberará $size de espacio.';
  }

  @override
  String get downloadsCancel => 'Cancelar';

  @override
  String get downloadsClearAll => 'Borrar todo';

  @override
  String downloadsSongsCount(String count) {
    return '$count canciones';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count canción';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'La lista de descargas principal no se puede renombrar.';

  @override
  String get downloadsRename => 'Renombrar';

  @override
  String get downloadsEditSongs => 'Editar canciones';

  @override
  String get downloadsDelete => 'Eliminar';

  @override
  String get downloadsRenamePlaylistTitle => 'Renombrar lista';

  @override
  String get downloadsRenamePlaylistDesc =>
      'Ingresa un nuevo nombre para la lista.';

  @override
  String get downloadsDeletePlaylistTitle => '¿Eliminar lista?';

  @override
  String get downloadsDeleteMasterDesc =>
      '¿Estás seguro? Perderás permanentemente todas las canciones y listas descargadas.';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return '¿Estás seguro de que deseas eliminar \'$name\'? Se perderá para siempre.';
  }

  @override
  String get downloadsSave => 'Guardar';

  @override
  String get downloadsNoSongs => 'Esta lista no tiene canciones.';

  @override
  String get libraryTitle => 'Biblioteca';

  @override
  String get libraryPauseAll => 'Pausar todo';

  @override
  String get libraryResumeAll => 'Reanudar todo';

  @override
  String get libraryTabPlaylists => 'Listas';

  @override
  String get libraryTabDownloads => 'Descargas';

  @override
  String get libraryTabDownloading => 'Descargando';

  @override
  String libraryImportedTask(String name) {
    return 'Importado $name';
  }

  @override
  String get libraryImportWaiting => 'Esperando...';

  @override
  String get libraryImportFetching => 'Obteniendo lista...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total procesadas · $matched coincidencias';
  }

  @override
  String get libraryImportSaving => 'Guardando...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched canciones añadidas · pulsa ×';
  }

  @override
  String get libraryImportDoneAll => 'Todas las canciones añadidas · pulsa ×';

  @override
  String get libraryAddButton => 'Agregar';

  @override
  String get librarySortRecent => 'Añadido recientemente';

  @override
  String get librarySortAlpha => 'Alfabético';

  @override
  String get libraryEmptyTitle => 'Tu biblioteca está vacía.';

  @override
  String get libraryEmptyDesc => 'Toca en \'Agregar\' para comenzar.';

  @override
  String get libraryRenameLikedError =>
      'La lista de Canciones Favoritas no se puede renombrar.';

  @override
  String get libraryRename => 'Renombrar';

  @override
  String get libraryEditSongs => 'Editar canciones';

  @override
  String get libraryDeleteLikedError =>
      'La lista de Canciones Favoritas no se puede eliminar.';

  @override
  String get libraryDelete => 'Eliminar';

  @override
  String get libraryEditSongsTitle => 'Editar canciones';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count canción';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count canciones';
  }

  @override
  String get libraryCancel => 'Cancelar';

  @override
  String get librarySave => 'Guardar';

  @override
  String get libraryNoSongs => 'Esta lista no tiene canciones.';

  @override
  String get libraryAddOptionsTitle => 'Añadir a la Biblioteca';

  @override
  String get libraryAddOptionsDesc =>
      'Elige cómo expandir tu biblioteca de Pulse';

  @override
  String get libraryImportPulse => 'Importar desde Pulse';

  @override
  String get libraryImportPulseDesc => 'Pega el enlace de una lista de Pulse';

  @override
  String get libraryImportYtm => 'Importar desde YT Music';

  @override
  String get libraryImportYtmDesc => 'Pega un enlace público';

  @override
  String get libraryImportSpotify => 'Importar desde Spotify';

  @override
  String get libraryImportSpotifyDesc => 'Conecta tu Spotify';

  @override
  String get libraryClose => 'Cerrar';

  @override
  String get libraryImportYtmFull => 'Importar desde YouTube Music';

  @override
  String get libraryImportSpotifyFull => 'Importar desde Spotify (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'Pega el enlace público de una lista o álbum de YouTube Music aquí';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'Pega el enlace público de una lista de Spotify aquí';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'No se pudo importar la lista de Pulse';

  @override
  String get importErrorPlaylist => 'Error de importación';

  @override
  String get importErrorHighlyPopulated =>
      'La lista es muy grande, esto podría tomar un tiempo.';

  @override
  String get libraryImportBtn => 'Importar';

  @override
  String get libraryCreateTitle => 'Nueva lista';

  @override
  String get libraryCreateDesc => '¿Cómo se llamará tu nueva lista?';

  @override
  String get libraryCreateHint => 'Ej: Viaje en auto';

  @override
  String get libraryCreateBtn => 'Crear';

  @override
  String get libraryRenameTitle => 'Renombrar lista';

  @override
  String get libraryRenameDesc => 'Ingresa un nuevo nombre.';

  @override
  String get libraryRenameBtn => 'Renombrar';

  @override
  String get libraryDeleteTitle => '¿Eliminar lista?';

  @override
  String libraryDeleteDesc(String name) {
    return '¿Estás seguro de que deseas eliminar \'$name\'? Se perderá para siempre.';
  }

  @override
  String get libraryDeleteBtn => 'Eliminar';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'Reciente';

  @override
  String librarySongsCount(String count) {
    return '$count canciones';
  }

  @override
  String get libraryComingSoon => 'Próximamente';

  @override
  String get loginErrName => 'Por favor, escribe tu nombre';

  @override
  String get loginErrEmail => 'Por favor, ingresa tu correo';

  @override
  String get loginErrPassword => 'Por favor, ingresa tu contraseña';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => '¡Siente cada latido!';

  @override
  String get loginMadeWithHeartBy => 'Creado con ❤️ por: ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'Tu nombre';

  @override
  String get loginHintEmail => 'Correo electrónico';

  @override
  String get loginHintPassword => 'Contraseña';

  @override
  String get loginErrEmailReset =>
      'Por favor, ingresa un correo para restablecer';

  @override
  String get loginResetSent => '¡Enviado! Revisa tu bandeja de entrada.';

  @override
  String get loginForgotPwd => '¿Olvidaste tu contraseña?';

  @override
  String get loginBtnSignup => 'Crear cuenta';

  @override
  String get loginBtnSignin => 'Iniciar sesión';

  @override
  String get loginToggleHaveAccount => '¿Ya tienes una cuenta de Pulse? ';

  @override
  String get loginToggleNoAccount => '¿No tienes una cuenta de Pulse? ';

  @override
  String get loginToggleSignin => 'Iniciar sesión';

  @override
  String get loginToggleSignup => 'Registrarse';

  @override
  String get offlineStillOffline => 'Aún sin conexión. Revisa tu red.';

  @override
  String get offlineTitle => 'Estás desconectado';

  @override
  String get offlineSubtitle =>
      'No hay conexión a internet.\nVerifica tu red y vuelve a intentarlo.';

  @override
  String get offlineChecking => 'Comprobando...';

  @override
  String get offlineRetry => 'Reintentar';

  @override
  String get offlineGoToDownloads => 'Ir a Descargas';

  @override
  String get playerMadeWithHeartBy => 'Creado con ❤️ por: ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'Desliza para ver la letra';

  @override
  String get playerNoLyrics => 'No hay letra disponible';

  @override
  String get playerUpNext => 'A continuación';

  @override
  String get playerNoTracksInQueue => 'No hay canciones en la cola';

  @override
  String get playerNoMusicPlaying => 'No hay música reproduciéndose';

  @override
  String get playerPickAVibe => 'Elige una canción de tu biblioteca';

  @override
  String get playerGoHome => 'Ir al inicio';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'Ecualizador';

  @override
  String get playerEqCustom => 'Personalizado';

  @override
  String get playlistDownloads => 'Descargas';

  @override
  String get playlistOffline => 'Lista Offline';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '${hours}h ${mins}m';
  }

  @override
  String playlistDurationMins(String mins) {
    return '${mins}m';
  }

  @override
  String get playlistFindOnPage => 'Buscar en la página';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count canciones • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'Reciente';

  @override
  String get playlistNoMatches => 'No hay coincidencias.';

  @override
  String get playlistNoTracks => 'Esta lista no tiene canciones.';

  @override
  String get playlistNoSongsYet => 'Aún no hay canciones.';

  @override
  String get playlistSortRecentlyAdded => 'Añadido recientemente';

  @override
  String get playlistSortAlphabetical => 'Alfabético';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'canciones',
      one: 'canción',
    );
    return 'Descargando $count $_temp0';
  }

  @override
  String get playlistView => 'Ver';

  @override
  String get playlistAllDownloaded => 'Todo descargado';

  @override
  String playlistShareText(String name, String url) {
    return '¡Escucha \'$name\' en Pulse!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'Quitar de descargas';

  @override
  String get playlistRemoveFromPlaylist => 'Quitar de la lista';

  @override
  String get playlistLoadError => 'No se pudo cargar la lista.';

  @override
  String get playlistGoBack => '← Volver';

  @override
  String get profileNotLoggedIn => 'No has iniciado sesión';

  @override
  String get profileSignIn => 'Iniciar sesión';

  @override
  String get profileDefaultUser => 'Usuario Pulse';

  @override
  String get profileEditProfile => 'Editar perfil';

  @override
  String get profileTimeframeDay => 'Día';

  @override
  String get profileTimeframeWeek => 'Semana';

  @override
  String get profileTimeframeMonth => 'Mes';

  @override
  String get profileTimeframeYear => 'Año';

  @override
  String get profileListeningTime => 'Tiempo de escucha';

  @override
  String get profileToday => 'Hoy';

  @override
  String get profileThisWeek => 'Esta semana';

  @override
  String get profileThisMonth => 'Este mes';

  @override
  String get profileThisYear => 'Este año';

  @override
  String get profileDailyAvg => 'Promedio diario';

  @override
  String get profilePerDay => '/día';

  @override
  String get profileLifetimeListening => 'Total de tiempo';

  @override
  String get profileTotalTimeListened => 'Tiempo total en Pulse';

  @override
  String get profileYourTopSongs => 'Canciones más escuchadas';

  @override
  String get profileListeningHistoryEmpty => 'Tu historial aparecerá aquí.';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'reproducciones',
      one: 'reproducción',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => 'Artistas más escuchados';

  @override
  String get profileTopArtistsEmpty =>
      'Tus artistas favoritos aparecerán aquí.';

  @override
  String get profileArtistLabel => 'Artista';

  @override
  String get profileSignOut => 'Cerrar sesión';

  @override
  String profileVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get profileMadeWithHeartBy => 'Creado con ❤️ por: ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'Editar perfil';

  @override
  String get profileDisplayName => 'Nombre de usuario';

  @override
  String get profileCancel => 'Cancelar';

  @override
  String get profileSave => 'Guardar';

  @override
  String get profileChooseAvatar => 'Elegir avatar';

  @override
  String get searchMicPermissionRequired =>
      'Se requiere permiso para el micrófono';

  @override
  String get searchUnknownSong => 'Canción desconocida';

  @override
  String get searchUnknownArtist => 'Artista desconocido';

  @override
  String get searchNoSongDetected => 'No se detectó ninguna canción.';

  @override
  String searchError(String message) {
    return 'Error: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'Búsqueda por voz no disponible';

  @override
  String get searchHint => 'Canción, artista, álbum...';

  @override
  String get searchRecentEmpty => 'Tus búsquedas recientes aparecerán aquí';

  @override
  String get searchRecentSearches => 'Búsquedas recientes';

  @override
  String get searchClearAll => 'Borrar todo';

  @override
  String searchNoResultsFor(String query) {
    return 'No hay resultados para \'$query\'';
  }

  @override
  String get searchTryDifferentKeywords => 'Prueba con palabras diferentes';

  @override
  String get searchTopResult => 'Mejor resultado';

  @override
  String get searchSongsLabel => 'Canciones';

  @override
  String get searchArtistsLabel => 'Artistas';

  @override
  String get searchAlbumsLabel => 'Álbumes';

  @override
  String get searchPlaylistsLabel => 'Listas';

  @override
  String get searchArtistLabel => 'Artista';

  @override
  String get searchListening => 'Escuchando...';

  @override
  String get searchSpeakNow => 'Habla ahora';

  @override
  String get searchCancel => 'Cancelar';

  @override
  String get searchIdentifying => 'Identificando...';

  @override
  String get searchListeningForSong => 'Escuchando música...';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get settingsStreamingQuality => 'Calidad de transmisión';

  @override
  String get settingsQualityAutomatic => 'Automática';

  @override
  String get settingsQualityLow => 'Baja';

  @override
  String get settingsQualityNormal => 'Normal';

  @override
  String get settingsQualityHigh => 'Alta';

  @override
  String get settingsDownloadQuality => 'Calidad de descarga';

  @override
  String get settingsPlayback => 'Reproducción';

  @override
  String get settingsCrossfade => 'Transición suave (Crossfade)';

  @override
  String get settingsCrossfadeDesc => 'Mezclar canciones suavemente';

  @override
  String get settingsDataUsage => 'Uso de datos';

  @override
  String get settingsDataSaver => 'Ahorro de datos';

  @override
  String get settingsDataSaverDesc =>
      'Transmisión en baja calidad con datos móviles';

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsCustomAccent => 'Color de énfasis';

  @override
  String get settingsSaturation => 'Saturación';

  @override
  String get settingsBrightness => 'Brillo';

  @override
  String get settingsResetDefault => 'Restaurar predeterminados';

  @override
  String get playlistSheetTitle => 'Añadir a lista';

  @override
  String get playlistSheetNewPlaylist => 'Nueva lista';

  @override
  String get playlistSheetNoPlaylists => 'Sin listas';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'canciones',
      one: 'canción',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => 'Nombre de la lista';

  @override
  String get playlistSheetCancel => 'Cancelar';

  @override
  String playlistSheetAddedTo(String name) {
    return 'Añadida a $name';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'Error al crear: Autenticación fallida';

  @override
  String playlistSheetCreateFail(String error) {
    return 'Error al crear: $error';
  }

  @override
  String get playlistSheetCreate => 'Crear';

  @override
  String get appUpdateAvailable => 'Actualización disponible';

  @override
  String appUpdateDesc(String version) {
    return '¡La versión $version ya está aquí! Actualiza para disfrutar de nuevas funciones.';
  }

  @override
  String get appUpdateDownload => 'Descargar actualización';

  @override
  String get navHome => 'Inicio';

  @override
  String get navLibrary => 'Biblioteca';

  @override
  String get navSearch => 'Buscar';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get navProfile => 'Perfil';

  @override
  String get artistSelect => 'Selecciona el artista';

  @override
  String get songActionQueue => 'Añadir a la cola';

  @override
  String get songActionPlaylist => 'Añadir a la lista';

  @override
  String get songActionFinding => 'Buscando...';

  @override
  String get songActionAlbum => 'Ir al álbum';

  @override
  String get songActionArtist => 'Ir al artista';

  @override
  String get songActionRemovePlaylist => 'Quitar de la lista';

  @override
  String get songActionRemoveDownload => 'Quitar de descargas';

  @override
  String get songActionDownloadChecking => 'Comprobando...';

  @override
  String get songActionDownloading => 'Descargando...';

  @override
  String get songActionDownloaded => '¡Descargada!';

  @override
  String get songActionDownloadAlready => 'Ya descargada';

  @override
  String get songActionDownloadFailed => 'Error al descargar';

  @override
  String get songActionDownload => 'Descargar';

  @override
  String get songActionDownloadingSnack => 'Descargando';

  @override
  String get songActionView => 'Ver';

  @override
  String get spotifyImportTitle => 'Importar desde Spotify';

  @override
  String get spotifyImportSubtitle => 'Selecciona el tamaño de la lista';

  @override
  String get spotifyChoiceSmallTitle => '100 canciones o menos';

  @override
  String get spotifyChoiceSmallDesc => 'Pega un enlace público de Spotify.';

  @override
  String get spotifyChoiceLargeTitle => 'Más de 100 canciones';

  @override
  String get spotifyChoiceLargeDesc =>
      'Conecta tu propia app de Spotify Developer.';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get spotifyPlaylistsTitle => 'Listas de Spotify';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'Error: $error\nComprueba tu Client ID.';
  }

  @override
  String get spotifyPlaylistsEmpty => 'No hay listas en tu biblioteca';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count canciones';
  }

  @override
  String get spotifyPlaylistsImport => 'Importar';

  @override
  String get audioPlaybackFailed => 'Error al reproducir.';

  @override
  String get audioControlPrevious => 'Anterior';

  @override
  String get audioControlPause => 'Pausar';

  @override
  String get audioControlPlay => 'Reproducir';

  @override
  String get audioControlNext => 'Siguiente';

  @override
  String get audioControlUnlike => 'Ya no me gusta';

  @override
  String get audioControlLike => 'Me gusta';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'Respuesta en bruto: $data\n\nError: $error';
  }

  @override
  String get apiErrorInvalidClient => 'Client ID inválido.';

  @override
  String get apiErrorBadRequest => 'Petición incorrecta. Revisa tus datos.';

  @override
  String get apiErrorUnauthorized => 'No autorizado. Inicia sesión de nuevo.';

  @override
  String get apiErrorForbidden => 'Prohibido. No tienes acceso a este recurso.';

  @override
  String get apiErrorNotFound => 'El recurso solicitado no fue encontrado.';

  @override
  String get apiErrorEmailInUse => 'Este correo electrónico ya está en uso.';

  @override
  String get apiErrorUserNotFound => 'No hay ninguna cuenta con este correo.';

  @override
  String get apiErrorWrongPassword => 'Contraseña incorrecta.';

  @override
  String get apiErrorInvalidCredential =>
      'Error de inicio de sesión. Revisa tus datos.';

  @override
  String get apiErrorNetwork =>
      'Error de red. Comprueba tu conexión a internet.';

  @override
  String get apiErrorSocketTimeout =>
      'Se agotó el tiempo de conexión. Inténtalo de nuevo.';

  @override
  String get apiErrorTooManyRequests =>
      'Demasiadas peticiones. Inténtalo más tarde.';

  @override
  String get apiErrorServerError =>
      'Ocurrió un error en el servidor. Inténtalo más tarde.';

  @override
  String get apiErrorInvalidEmail =>
      'Proporciona un correo electrónico válido.';

  @override
  String get apiErrorWeakPassword =>
      'La contraseña es muy débil. Usa al menos 6 caracteres.';

  @override
  String get apiErrorTooManyAttempts =>
      'Demasiados intentos fallidos. Inténtalo más tarde.';

  @override
  String get homeForgottenFavorites => 'Favoritos olvidados';

  @override
  String get artistShowAll => 'Ver todo';

  @override
  String get homeTopTracks => 'Canciones principales';
}
