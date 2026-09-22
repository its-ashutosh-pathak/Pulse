// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'Об исполнителе';

  @override
  String get artistPopular => 'Популярное';

  @override
  String get artistAlbums => 'Альбомы';

  @override
  String get artistSinglesAndEPs => 'Синглы и EP';

  @override
  String artistSubscribersCount(String count) {
    return '$count подписчиков';
  }

  @override
  String get artistPlayAll => 'Играть всё';

  @override
  String get artistLoadError => 'Ошибка загрузки исполнителя';

  @override
  String get artistGoBack => 'Назад';

  @override
  String adminChatFailedToReply(String error) {
    return 'Ошибка ответа: $error';
  }

  @override
  String get adminChatSupportChat => 'Чат поддержки';

  @override
  String adminChatError(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get adminChatNoHistory => 'Нет истории сообщений.';

  @override
  String get adminChatSupportYou => 'Поддержка (Вы)';

  @override
  String get adminChatTypeReply => 'Введите ответ...';

  @override
  String get broadcastSuccess => 'Объявление успешно отправлено!';

  @override
  String broadcastFailed(String error) {
    return 'Ошибка отправки: $error';
  }

  @override
  String get broadcastTitle => 'Глобальное объявление';

  @override
  String get broadcastSubtitle => 'Отправлено всем пользователям';

  @override
  String get broadcastWarning => 'Это сообщение увидят все.';

  @override
  String broadcastError(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get broadcastNoHistory => 'Нет глобальных объявлений.';

  @override
  String get broadcastTypeMessage => 'Введите объявление...';

  @override
  String commFailedToSend(String error) {
    return 'Ошибка отправки: $error';
  }

  @override
  String get commAdminDashboard => 'Панель админа';

  @override
  String get commAdminSupport => 'Поддержка';

  @override
  String get commAlwaysHere => 'Всегда готовы помочь';

  @override
  String get commWelcomeTitle => 'Привет! 👋 Я Ashutosh Pathak';

  @override
  String get commWelcomeSubtitle => 'Создатель Pulse';

  @override
  String get commWelcomeBody1 =>
      'Надеюсь, вы наслаждаетесь музыкой без рекламы. Музыка должна быть доступна каждому.\n\nЭто пространство для прямого общения.\n\nВы можете присылать:';

  @override
  String get commBullet1 => 'Ваши отзывы';

  @override
  String get commBullet2 => 'Сообщения об ошибках';

  @override
  String get commBullet3 => 'Идеи новых функций';

  @override
  String get commWelcomeBody2 =>
      'Я читаю каждое сообщение.\n\nЕсть идеи для новых приложений? Дайте знать! По возможности я их создам.\n\nСпасибо, что вы с нами. ❤️';

  @override
  String commError(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get commNoMessages => 'Пока нет сообщений';

  @override
  String get commNoMessagesDesc => 'Напишите в поддержку или проверьте позже.';

  @override
  String get commMessageSupportHint => 'Напишите нам...';

  @override
  String get commGlobalAnnouncements => 'Объявления';

  @override
  String get commSendMessagesToAll => 'Отправить всем';

  @override
  String get homeGreetingMorning => 'Доброе утро,';

  @override
  String get homeGreetingAfternoon => 'Добрый день,';

  @override
  String get homeGreetingEvening => 'Добрый вечер,';

  @override
  String get homeMember => 'Пользователь';

  @override
  String get homeRecentPlaylists => 'Недавние плейлисты';

  @override
  String get homeRecentlyPlayed => 'Недавно прослушанные';

  @override
  String get homeSpeedDial => 'Быстрый набор';

  @override
  String get homeNoContent => 'Нет контента';

  @override
  String get homeRefresh => 'Обновить';

  @override
  String get homeLoadError => 'Ошибка загрузки ленты.';

  @override
  String get homeRetry => 'Повторить';

  @override
  String get importSuccess => 'Spotify успешно подключен!';

  @override
  String importFailed(String error) {
    return 'Ошибка подключения: $error';
  }

  @override
  String get importTitle => 'Подключить Spotify';

  @override
  String get importSetupTitle => 'Настройка Spotify';

  @override
  String get importSetupDesc =>
      'Используйте свой ключ разработчика для быстрого импорта плейлистов:';

  @override
  String get importStep1 => 'Откройте панель Spotify Developer.';

  @override
  String get importStep2 => 'Войдите и нажмите «Create app».';

  @override
  String get importStep3 => 'Укажите имя и описание.';

  @override
  String get importStep4 => 'В поле «Redirect URIs» вставьте эту ссылку:';

  @override
  String get importRedirectCopied => 'URI скопирован!';

  @override
  String get importStep5 =>
      'Сохраните, скопируйте «Client ID» и вставьте ниже.';

  @override
  String get importImportant =>
      'Важно: Требуется активная подписка Spotify Premium.';

  @override
  String get importClientIdHint => 'Вставьте Spotify Client ID...';

  @override
  String get importConnectButton => 'Подключить и загрузить библиотеку';

  @override
  String get downloadingNoActive => 'Нет активных загрузок';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'Загрузки';

  @override
  String downloadsStats(String count, String size) {
    return '$count треков • $size';
  }

  @override
  String get downloadsNoOffline => 'Нет треков офлайн';

  @override
  String get downloadsNoOfflineDesc => 'Скачанные треки появятся здесь';

  @override
  String get downloadsClearAllTitle => 'Удалить все?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'Будет удалено $count треков и освобождено $size места.';
  }

  @override
  String get downloadsCancel => 'Отмена';

  @override
  String get downloadsClearAll => 'Очистить';

  @override
  String downloadsSongsCount(String count) {
    return '$count треков';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count трек';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'Нельзя переименовать главный плейлист загрузок.';

  @override
  String get downloadsRename => 'Переименовать';

  @override
  String get downloadsEditSongs => 'Изменить треки';

  @override
  String get downloadsDelete => 'Удалить';

  @override
  String get downloadsRenamePlaylistTitle => 'Переименовать';

  @override
  String get downloadsRenamePlaylistDesc => 'Введите новое имя плейлиста.';

  @override
  String get downloadsDeletePlaylistTitle => 'Удалить плейлист?';

  @override
  String get downloadsDeleteMasterDesc =>
      'Уверены? Вы навсегда потеряете все скачанные треки.';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'Точно удалить «$name»? Плейлист будет утерян.';
  }

  @override
  String get downloadsSave => 'Сохранить';

  @override
  String get downloadsNoSongs => 'В этом плейлисте нет треков.';

  @override
  String get libraryTitle => 'Медиатека';

  @override
  String get libraryPauseAll => 'Пауза';

  @override
  String get libraryResumeAll => 'Продолжить';

  @override
  String get libraryTabPlaylists => 'Плейлисты';

  @override
  String get libraryTabDownloads => 'Загрузки';

  @override
  String get libraryTabDownloading => 'Загружается';

  @override
  String libraryImportedTask(String name) {
    return '$name импортировано';
  }

  @override
  String get libraryImportWaiting => 'В ожидании...';

  @override
  String get libraryImportFetching => 'Загрузка плейлиста...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return 'Обработано $processed/$total · $matched найдено';
  }

  @override
  String get libraryImportSaving => 'Сохранение...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched треков добавлено · нажмите ×';
  }

  @override
  String get libraryImportDoneAll => 'Все треки добавлены · нажмите ×';

  @override
  String get libraryAddButton => 'Добавить';

  @override
  String get librarySortRecent => 'Недавние';

  @override
  String get librarySortAlpha => 'По алфавиту';

  @override
  String get libraryEmptyTitle => 'Медиатека пуста.';

  @override
  String get libraryEmptyDesc =>
      'Нажмите «Добавить», чтобы начать работу с Pulse.';

  @override
  String get libraryRenameLikedError =>
      'Плейлист любимых треков нельзя переименовать.';

  @override
  String get libraryRename => 'Переименовать';

  @override
  String get libraryEditSongs => 'Изменить треки';

  @override
  String get libraryDeleteLikedError => 'Нельзя удалить любимые треки.';

  @override
  String get libraryDelete => 'Удалить';

  @override
  String get libraryEditSongsTitle => 'Изменить треки';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count трек';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count треков';
  }

  @override
  String get libraryCancel => 'Отмена';

  @override
  String get librarySave => 'Сохранить';

  @override
  String get libraryNoSongs => 'В этом плейлисте нет треков.';

  @override
  String get libraryAddOptionsTitle => 'Добавить в медиатеку';

  @override
  String get libraryAddOptionsDesc => 'Откуда загрузить музыку?';

  @override
  String get libraryImportPulse => 'Из Pulse';

  @override
  String get libraryImportPulseDesc => 'Вставьте URL плейлиста';

  @override
  String get libraryImportYtm => 'Из YT Music';

  @override
  String get libraryImportYtmDesc => 'Вставьте URL публичного плейлиста';

  @override
  String get libraryImportSpotify => 'Из Spotify';

  @override
  String get libraryImportSpotifyDesc => 'Подключите Spotify';

  @override
  String get libraryClose => 'Закрыть';

  @override
  String get libraryImportYtmFull => 'Импорт из YouTube Music';

  @override
  String get libraryImportSpotifyFull => 'Импорт из Spotify (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'Вставьте ссылку на публичный плейлист YouTube Music';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'Вставьте ссылку на публичный плейлист Spotify';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Ошибка импорта Pulse плейлиста';

  @override
  String get importErrorPlaylist => 'Ошибка импорта';

  @override
  String get importErrorHighlyPopulated =>
      'Плейлист слишком большой, это займёт время.';

  @override
  String get libraryImportBtn => 'Импорт';

  @override
  String get libraryCreateTitle => 'Новый плейлист';

  @override
  String get libraryCreateDesc => 'Как назовем плейлист?';

  @override
  String get libraryCreateHint => 'Например: Избранное';

  @override
  String get libraryCreateBtn => 'Создать';

  @override
  String get libraryRenameTitle => 'Переименовать';

  @override
  String get libraryRenameDesc => 'Введите новое имя.';

  @override
  String get libraryRenameBtn => 'Сохранить';

  @override
  String get libraryDeleteTitle => 'Удалить плейлист?';

  @override
  String libraryDeleteDesc(String name) {
    return 'Точно удалить «$name»? Это необратимо.';
  }

  @override
  String get libraryDeleteBtn => 'Удалить';

  @override
  String get librarySortLabelAlpha => 'А-Я';

  @override
  String get librarySortLabelRecent => 'Недавние';

  @override
  String librarySongsCount(String count) {
    return '$count треков';
  }

  @override
  String get libraryComingSoon => 'Скоро';

  @override
  String get loginErrName => 'Введите имя';

  @override
  String get loginErrEmail => 'Введите email';

  @override
  String get loginErrPassword => 'Введите пароль';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'Почувствуй каждый бит!';

  @override
  String get loginMadeWithHeartBy => 'Создано с ❤️: ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'Имя';

  @override
  String get loginHintEmail => 'Email адрес';

  @override
  String get loginHintPassword => 'Пароль';

  @override
  String get loginErrEmailReset => 'Введите email для сброса';

  @override
  String get loginResetSent => 'Письмо отправлено! Проверьте почту.';

  @override
  String get loginForgotPwd => 'Забыли пароль?';

  @override
  String get loginBtnSignup => 'Создать аккаунт';

  @override
  String get loginBtnSignin => 'Войти';

  @override
  String get loginToggleHaveAccount => 'Уже есть аккаунт? ';

  @override
  String get loginToggleNoAccount => 'Нет аккаунта? ';

  @override
  String get loginToggleSignin => 'Войти';

  @override
  String get loginToggleSignup => 'Регистрация';

  @override
  String get offlineStillOffline => 'Всё ещё офлайн. Проверьте соединение.';

  @override
  String get offlineTitle => 'Вы офлайн';

  @override
  String get offlineSubtitle =>
      'Нет подключения к интернету.\nПроверьте сеть и повторите попытку.';

  @override
  String get offlineChecking => 'Проверка...';

  @override
  String get offlineRetry => 'Повторить';

  @override
  String get offlineGoToDownloads => 'Перейти к загрузкам';

  @override
  String get playerMadeWithHeartBy => 'Создано с ❤️: ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'Свайп для текста песни';

  @override
  String get playerNoLyrics => 'Текст не найден';

  @override
  String get playerUpNext => 'Далее';

  @override
  String get playerNoTracksInQueue => 'Очередь пуста';

  @override
  String get playerNoMusicPlaying => 'Ничего не играет';

  @override
  String get playerPickAVibe => 'Выберите трек из медиатеки';

  @override
  String get playerGoHome => 'На главную';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'Эквалайзер';

  @override
  String get playerEqCustom => 'Вручную';

  @override
  String get playlistDownloads => 'Загрузки';

  @override
  String get playlistOffline => 'Офлайн-плейлист';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hoursч $minsм';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$minsм';
  }

  @override
  String get playlistFindOnPage => 'Найти на странице';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count треков • $duration';
  }

  @override
  String get playlistSortAlpha => 'А-Я';

  @override
  String get playlistSortRecent => 'Недавние';

  @override
  String get playlistNoMatches => 'Ничего не найдено.';

  @override
  String get playlistNoTracks => 'В плейлисте нет треков.';

  @override
  String get playlistNoSongsYet => 'Пока нет треков.';

  @override
  String get playlistSortRecentlyAdded => 'Недавние';

  @override
  String get playlistSortAlphabetical => 'По алфавиту';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'треков',
      one: 'трек',
    );
    return 'Загружается $count $_temp0';
  }

  @override
  String get playlistView => 'Смотреть';

  @override
  String get playlistAllDownloaded => 'Всё загружено';

  @override
  String playlistShareText(String name, String url) {
    return 'Слушайте «$name» в Pulse!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'Удалить из загрузок';

  @override
  String get playlistRemoveFromPlaylist => 'Удалить из плейлиста';

  @override
  String get playlistLoadError => 'Ошибка загрузки плейлиста.';

  @override
  String get playlistGoBack => '← Назад';

  @override
  String get profileNotLoggedIn => 'Не в сети';

  @override
  String get profileSignIn => 'Войти';

  @override
  String get profileDefaultUser => 'Пользователь Pulse';

  @override
  String get profileEditProfile => 'Редактировать';

  @override
  String get profileTimeframeDay => 'День';

  @override
  String get profileTimeframeWeek => 'Неделя';

  @override
  String get profileTimeframeMonth => 'Месяц';

  @override
  String get profileTimeframeYear => 'Год';

  @override
  String get profileListeningTime => 'Время';

  @override
  String get profileToday => 'Сегодня';

  @override
  String get profileThisWeek => 'За неделю';

  @override
  String get profileThisMonth => 'За месяц';

  @override
  String get profileThisYear => 'За год';

  @override
  String get profileDailyAvg => 'В среднем за день';

  @override
  String get profilePerDay => '/день';

  @override
  String get profileLifetimeListening => 'Всего';

  @override
  String get profileTotalTimeListened => 'Общее время в Pulse';

  @override
  String get profileYourTopSongs => 'Топ треков';

  @override
  String get profileListeningHistoryEmpty => 'Здесь будет история.';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'прослушиваний',
      one: 'прослушивание',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => 'Топ артистов';

  @override
  String get profileTopArtistsEmpty => 'Здесь будут любимые артисты.';

  @override
  String get profileArtistLabel => 'Артист';

  @override
  String get profileSignOut => 'Выйти';

  @override
  String profileVersion(String version) {
    return 'Версия $version';
  }

  @override
  String get profileMadeWithHeartBy => 'Создано с ❤️: ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'Профиль';

  @override
  String get profileDisplayName => 'Имя пользователя';

  @override
  String get profileCancel => 'Отмена';

  @override
  String get profileSave => 'Сохранить';

  @override
  String get profileChooseAvatar => 'Выбрать аватар';

  @override
  String get searchMicPermissionRequired => 'Нужен доступ к микрофону';

  @override
  String get searchUnknownSong => 'Неизвестный трек';

  @override
  String get searchUnknownArtist => 'Неизвестный артист';

  @override
  String get searchNoSongDetected => 'Песня не распознана.';

  @override
  String searchError(String message) {
    return 'Ошибка: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'Голосовой поиск недоступен';

  @override
  String get searchHint => 'Трек, артист, альбом...';

  @override
  String get searchRecentEmpty => 'Ваши запросы появятся здесь';

  @override
  String get searchRecentSearches => 'Недавние поиски';

  @override
  String get searchClearAll => 'Очистить всё';

  @override
  String searchNoResultsFor(String query) {
    return 'Нет результатов для «$query»';
  }

  @override
  String get searchTryDifferentKeywords => 'Попробуйте другие слова';

  @override
  String get searchTopResult => 'Лучший результат';

  @override
  String get searchSongsLabel => 'Треки';

  @override
  String get searchArtistsLabel => 'Артисты';

  @override
  String get searchAlbumsLabel => 'Альбомы';

  @override
  String get searchPlaylistsLabel => 'Плейлисты';

  @override
  String get searchArtistLabel => 'Артист';

  @override
  String get searchListening => 'Слушаю...';

  @override
  String get searchSpeakNow => 'Говорите';

  @override
  String get searchCancel => 'Отмена';

  @override
  String get searchIdentifying => 'Распознавание...';

  @override
  String get searchListeningForSong => 'Определение трека...';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsStreamingQuality => 'Качество аудио';

  @override
  String get settingsQualityAutomatic => 'Авто';

  @override
  String get settingsQualityLow => 'Низкое';

  @override
  String get settingsQualityNormal => 'Обычное';

  @override
  String get settingsQualityHigh => 'Высокое';

  @override
  String get settingsDownloadQuality => 'Качество загрузки';

  @override
  String get settingsPlayback => 'Воспроизведение';

  @override
  String get settingsCrossfade => 'Плавный переход';

  @override
  String get settingsCrossfadeDesc => 'Наложение треков для плавности';

  @override
  String get settingsDataUsage => 'Передача данных';

  @override
  String get settingsDataSaver => 'Экономия трафика';

  @override
  String get settingsDataSaverDesc => 'Низкое качество при мобильном интернете';

  @override
  String get settingsAppearance => 'Оформление';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsCustomAccent => 'Цвет акцента';

  @override
  String get settingsSaturation => 'Насыщенность';

  @override
  String get settingsBrightness => 'Яркость';

  @override
  String get settingsResetDefault => 'Сбросить по умолчанию';

  @override
  String get playlistSheetTitle => 'Добавить в плейлист';

  @override
  String get playlistSheetNewPlaylist => 'Новый плейлист';

  @override
  String get playlistSheetNoPlaylists => 'Нет плейлистов';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'треков',
      one: 'трек',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => 'Название плейлиста';

  @override
  String get playlistSheetCancel => 'Отмена';

  @override
  String playlistSheetAddedTo(String name) {
    return 'Добавлено в $name';
  }

  @override
  String get playlistSheetCreateFailAuth => 'Ошибка авторизации';

  @override
  String playlistSheetCreateFail(String error) {
    return 'Ошибка создания: $error';
  }

  @override
  String get playlistSheetCreate => 'Создать';

  @override
  String get appUpdateAvailable => 'Доступно обновление';

  @override
  String appUpdateDesc(String version) {
    return 'Версия $version уже здесь! Обновитесь для новых функций.';
  }

  @override
  String get appUpdateDownload => 'Скачать';

  @override
  String get navHome => 'Главная';

  @override
  String get navLibrary => 'Медиатека';

  @override
  String get navSearch => 'Поиск';

  @override
  String get navSettings => 'Настройки';

  @override
  String get navProfile => 'Профиль';

  @override
  String get artistSelect => 'Выберите артиста';

  @override
  String get songActionQueue => 'В очередь';

  @override
  String get songActionPlaylist => 'В плейлист';

  @override
  String get songActionFinding => 'Поиск...';

  @override
  String get songActionAlbum => 'Перейти к альбому';

  @override
  String get songActionArtist => 'К артисту';

  @override
  String get songActionRemovePlaylist => 'Удалить из плейлиста';

  @override
  String get songActionRemoveDownload => 'Удалить из загрузок';

  @override
  String get songActionDownloadChecking => 'Проверка...';

  @override
  String get songActionDownloading => 'Загружается...';

  @override
  String get songActionDownloaded => 'Скачано!';

  @override
  String get songActionDownloadAlready => 'Уже загружено';

  @override
  String get songActionDownloadFailed => 'Ошибка загрузки';

  @override
  String get songActionDownload => 'Скачать';

  @override
  String get songActionDownloadingSnack => 'Загрузка';

  @override
  String get songActionView => 'Смотреть';

  @override
  String get spotifyImportTitle => 'Импорт из Spotify';

  @override
  String get spotifyImportSubtitle => 'Выберите размер плейлиста';

  @override
  String get spotifyChoiceSmallTitle => '100 треков или меньше';

  @override
  String get spotifyChoiceSmallDesc => 'Вставьте публичный URL.';

  @override
  String get spotifyChoiceLargeTitle => 'Более 100 треков';

  @override
  String get spotifyChoiceLargeDesc =>
      'Подключите свой ключ Spotify Developer.';

  @override
  String get cancelButton => 'Отмена';

  @override
  String get spotifyPlaylistsTitle => 'Плейлисты Spotify';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'Ошибка: $error\nПроверьте ваш Client ID.';
  }

  @override
  String get spotifyPlaylistsEmpty => 'В медиатеке нет плейлистов';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count треков';
  }

  @override
  String get spotifyPlaylistsImport => 'Импорт';

  @override
  String get audioPlaybackFailed => 'Ошибка воспроизведения.';

  @override
  String get audioControlPrevious => 'Предыдущий';

  @override
  String get audioControlPause => 'Пауза';

  @override
  String get audioControlPlay => 'Играть';

  @override
  String get audioControlNext => 'Следующий';

  @override
  String get audioControlUnlike => 'Убрать лайк';

  @override
  String get audioControlLike => 'Лайк';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'Ответ: $data\n\nОшибка: $error';
  }

  @override
  String get apiErrorInvalidClient => 'Неверный Client ID.';

  @override
  String get apiErrorBadRequest => 'Неверный запрос.';

  @override
  String get apiErrorUnauthorized => 'Ошибка авторизации. Войдите снова.';

  @override
  String get apiErrorForbidden => 'Отказано в доступе.';

  @override
  String get apiErrorNotFound => 'Не найдено.';

  @override
  String get apiErrorEmailInUse => 'Этот email уже используется.';

  @override
  String get apiErrorUserNotFound => 'Аккаунт не найден.';

  @override
  String get apiErrorWrongPassword => 'Неверный пароль.';

  @override
  String get apiErrorInvalidCredential => 'Ошибка входа. Проверьте данные.';

  @override
  String get apiErrorNetwork => 'Ошибка сети.';

  @override
  String get apiErrorSocketTimeout => 'Время ожидания истекло.';

  @override
  String get apiErrorTooManyRequests => 'Слишком много запросов.';

  @override
  String get apiErrorServerError => 'Ошибка сервера.';

  @override
  String get apiErrorInvalidEmail => 'Введите верный email.';

  @override
  String get apiErrorWeakPassword => 'Слишком простой пароль.';

  @override
  String get apiErrorTooManyAttempts => 'Слишком много попыток входа.';

  @override
  String get homeForgottenFavorites => 'Забытые избранные';

  @override
  String get artistShowAll => 'Показать все';

  @override
  String get homeTopTracks => 'Популярные треки';
}
