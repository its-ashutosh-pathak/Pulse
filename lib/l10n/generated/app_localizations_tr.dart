// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'Hakkında';

  @override
  String get artistPopular => 'Popüler';

  @override
  String get artistAlbums => 'Albümler';

  @override
  String get artistSinglesAndEPs => 'Tekliler & EP\'ler';

  @override
  String artistSubscribersCount(String count) {
    return '$count abone';
  }

  @override
  String get artistPlayAll => 'Tümünü Çal';

  @override
  String get artistLoadError => 'Sanatçı yüklenemedi';

  @override
  String get artistGoBack => 'Geri Dön';

  @override
  String adminChatFailedToReply(String error) {
    return 'Yanıtlanamadı: $error';
  }

  @override
  String get adminChatSupportChat => 'Destek Sohbeti';

  @override
  String adminChatError(String error) {
    return 'Hata: $error';
  }

  @override
  String get adminChatNoHistory => 'Sohbet geçmişi yok.';

  @override
  String get adminChatSupportYou => 'Destek (Sen)';

  @override
  String get adminChatTypeReply => 'Yanıtınızı yazın...';

  @override
  String get broadcastSuccess => 'Duyuru başarıyla yayınlandı!';

  @override
  String broadcastFailed(String error) {
    return 'Yayınlanamadı: $error';
  }

  @override
  String get broadcastTitle => 'Genel Duyurular';

  @override
  String get broadcastSubtitle => 'Tüm kullanıcılara gönderildi';

  @override
  String get broadcastWarning =>
      'Buradan gönderilen mesajlar herkes tarafından görülecektir.';

  @override
  String broadcastError(String error) {
    return 'Hata: $error';
  }

  @override
  String get broadcastNoHistory => 'Önceki duyuru yok.';

  @override
  String get broadcastTypeMessage => 'Genel bir duyuru yazın...';

  @override
  String commFailedToSend(String error) {
    return 'Gönderilemedi: $error';
  }

  @override
  String get commAdminDashboard => 'Yönetici Paneli';

  @override
  String get commAdminSupport => 'Yönetici Desteği';

  @override
  String get commAlwaysHere => 'Her zaman yardıma hazır';

  @override
  String get commWelcomeTitle => 'Selam! 👋 Ben Ashutosh Pathak';

  @override
  String get commWelcomeSubtitle => 'Pulse Geliştiricisi';

  @override
  String get commWelcomeBody1 =>
      'Umarım rahatsız edici reklamlar veya abonelik engelleri olmadan en sevdiğin müziği dinlemekten keyif alıyorsundur. Sonuçta müzik, sırf birileri yeni bir yat alabilsin diye ödeme duvarının arkasında olmamalı.\n\nBu bölüm doğrudan iletişim kurabilmemiz için var.\n\nÇekinmeden şunları yapabilirsin:';

  @override
  String get commBullet1 => 'Geri bildirimini paylaş';

  @override
  String get commBullet2 => 'Hataları bildir';

  @override
  String get commBullet3 => 'Görmek istediğin yeni özellikleri öner';

  @override
  String get commWelcomeBody2 =>
      'Her mesajı şahsen okuyorum ve uygulamayı önerilerine göre geliştirmek için elimden geleni yapacağım.\n\nHenüz var olmayan veya pahalı aboneliklerin arkasına kilitlenmiş bir uygulama fikrin mi var? Bana ondan bahset! Mümkünse onu yapmaya ve herkesin kullanımına sunmaya çalışacağım.\n\nUygulamamı kullandığın ve bu yolculuğun bir parçası olduğun için teşekkürler. ❤️';

  @override
  String commError(String error) {
    return 'Hata: $error';
  }

  @override
  String get commNoMessages => 'Henüz mesaj yok';

  @override
  String get commNoMessagesDesc =>
      'Destek ekibimize bir mesaj gönderin veya daha sonra duyurular için tekrar kontrol edin.';

  @override
  String get commMessageSupportHint => 'Desteğe mesaj yaz...';

  @override
  String get commGlobalAnnouncements => 'Genel Duyurular';

  @override
  String get commSendMessagesToAll => 'Tüm kullanıcılara mesaj gönder';

  @override
  String get homeGreetingMorning => 'Günaydın,';

  @override
  String get homeGreetingAfternoon => 'İyi günler,';

  @override
  String get homeGreetingEvening => 'İyi akşamlar,';

  @override
  String get homeMember => 'Üye';

  @override
  String get homeRecentPlaylists => 'Son Çalma Listeleri';

  @override
  String get homeRecentlyPlayed => 'Son çalınanlar';

  @override
  String get homeSpeedDial => 'Hızlı Erişim';

  @override
  String get homeNoContent => 'İçerik bulunamadı';

  @override
  String get homeRefresh => 'Yenile';

  @override
  String get homeLoadError => 'Müzik akışı yüklenemedi.';

  @override
  String get homeRetry => 'Tekrar Dene';

  @override
  String get importSuccess => 'Spotify\'a Başarıyla Bağlanıldı!';

  @override
  String importFailed(String error) {
    return 'Bağlanılamadı: $error';
  }

  @override
  String get importTitle => 'Spotify\'ı Bağla';

  @override
  String get importSetupTitle => 'Spotify Entegrasyonunu Kur';

  @override
  String get importSetupDesc =>
      'Spotify\'ın katı oran sınırlarını aşmak ve tüm çalma listelerinizi anında içe aktarmak için kendi ücretsiz geliştirici anahtarınızı kullanmalısınız. Şu basit adımları izleyin:';

  @override
  String get importStep1 => 'Spotify Geliştirici Paneli\'ni açın.';

  @override
  String get importStep2 =>
      'Giriş yapın ve \"Create app\" seçeneğine tıklayın.';

  @override
  String get importStep3 => 'Herhangi bir Uygulama Adı ve Açıklaması girin.';

  @override
  String get importStep4 =>
      '\"Redirect URIs\" altında tam olarak şu URL\'yi yapıştırın:';

  @override
  String get importRedirectCopied => 'Yönlendirme URI Kopyalandı!';

  @override
  String get importStep5 =>
      'Uygulamayı kaydedin, ayarlardan \"Client ID\"nizi kopyalayın ve aşağıya yapıştırın.';

  @override
  String get importImportant =>
      'Önemli: Bu geliştirici uygulamasını oluşturmak için kullanılan Spotify hesabının aktif bir Premium aboneliği olmalıdır.';

  @override
  String get importClientIdHint =>
      'Spotify Client ID\'nizi buraya yapıştırın...';

  @override
  String get importConnectButton => 'Bağlan ve Kütüphaneyi Yükle';

  @override
  String get downloadingNoActive => 'Aktif indirme yok';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'İndirilenler';

  @override
  String downloadsStats(String count, String size) {
    return '$count şarkı • $size';
  }

  @override
  String get downloadsNoOffline => 'Henüz çevrimdışı şarkı yok';

  @override
  String get downloadsNoOfflineDesc => 'İndirdiğiniz şarkılar burada görünecek';

  @override
  String get downloadsClearAllTitle => 'Tüm İndirilenleri Temizle?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'Bu işlem $count şarkıyı silecek ve $size alan boşaltacak.';
  }

  @override
  String get downloadsCancel => 'İptal';

  @override
  String get downloadsClearAll => 'Tümünü Temizle';

  @override
  String downloadsSongsCount(String count) {
    return '$count şarkı';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count şarkı';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'Ana indirilenler çalma listesi yeniden adlandırılamaz.';

  @override
  String get downloadsRename => 'Yeniden Adlandır';

  @override
  String get downloadsEditSongs => 'Şarkıları Düzenle';

  @override
  String get downloadsDelete => 'Sil';

  @override
  String get downloadsRenamePlaylistTitle => 'Çalma Listesini Yeniden Adlandır';

  @override
  String get downloadsRenamePlaylistDesc =>
      'Çalma listeniz için yeni bir ad girin.';

  @override
  String get downloadsDeletePlaylistTitle => 'Çalma Listesi Silinsin mi?';

  @override
  String get downloadsDeleteMasterDesc =>
      'Bunu silmek istediğinizden emin misiniz? İndirilen tüm şarkıları ve çalma listelerini kalıcı olarak kaybedeceksiniz.';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return '\"$name\" silinsin mi? Bu çalma listesi kalıcı olarak kaybolacak.';
  }

  @override
  String get downloadsSave => 'Kaydet';

  @override
  String get downloadsNoSongs => 'Bu çalma listesinde şarkı yok.';

  @override
  String get libraryTitle => 'Kütüphane';

  @override
  String get libraryPauseAll => 'Tümünü Duraklat';

  @override
  String get libraryResumeAll => 'Tümünü Devam Ettir';

  @override
  String get libraryTabPlaylists => 'Çalma Listeleri';

  @override
  String get libraryTabDownloads => 'İndirilenler';

  @override
  String get libraryTabDownloading => 'İndiriliyor';

  @override
  String libraryImportedTask(String name) {
    return '$name içe aktarıldı';
  }

  @override
  String get libraryImportWaiting => 'Sırada bekliyor...';

  @override
  String get libraryImportFetching => 'Çalma listesi getiriliyor...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total işlendi · $matched eşleşti';
  }

  @override
  String get libraryImportSaving => 'Kütüphaneye kaydediliyor...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched şarkı eklendi · kapatmak için ×\'ya dokunun';
  }

  @override
  String get libraryImportDoneAll =>
      'Tüm şarkılar eklendi · kapatmak için ×\'ya dokunun';

  @override
  String get libraryAddButton => 'Ekle';

  @override
  String get librarySortRecent => 'Son Eklenenler';

  @override
  String get librarySortAlpha => 'Alfabetik';

  @override
  String get libraryEmptyTitle => 'Kütüphaneniz boş.';

  @override
  String get libraryEmptyDesc =>
      'İlk Pulse\'unuzu başlatmak için \"Ekle\"ye dokunun.';

  @override
  String get libraryRenameLikedError =>
      'Beğenilen Şarkılar listesi yeniden adlandırılamaz.';

  @override
  String get libraryRename => 'Yeniden Adlandır';

  @override
  String get libraryEditSongs => 'Şarkıları Düzenle';

  @override
  String get libraryDeleteLikedError => 'Beğenilen Şarkılar listesi silinemez.';

  @override
  String get libraryDelete => 'Sil';

  @override
  String get libraryEditSongsTitle => 'Şarkıları Düzenle';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count şarkı';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count şarkı';
  }

  @override
  String get libraryCancel => 'İptal';

  @override
  String get librarySave => 'Kaydet';

  @override
  String get libraryNoSongs => 'Bu çalma listesinde şarkı yok.';

  @override
  String get libraryAddOptionsTitle => 'Kütüphaneye Ekle';

  @override
  String get libraryAddOptionsDesc =>
      'Pulse\'unuzu nasıl genişletmek istediğinizi seçin';

  @override
  String get libraryImportPulse => 'Pulse\'dan İçe Aktar';

  @override
  String get libraryImportPulseDesc => 'Pulse çalma listesi URL\'si yapıştır';

  @override
  String get libraryImportYtm => 'YT Music\'ten İçe Aktar';

  @override
  String get libraryImportYtmDesc =>
      'HERKESE AÇIK bir çalma listesi URL\'si yapıştır';

  @override
  String get libraryImportSpotify => 'Spotify\'dan İçe Aktar';

  @override
  String get libraryImportSpotifyDesc => 'Spotify hesabınızı bağlayın';

  @override
  String get libraryClose => 'Kapat';

  @override
  String get libraryImportYtmFull => 'YouTube Music\'ten İçe Aktar';

  @override
  String get libraryImportSpotifyFull => 'Spotify\'dan İçe Aktar (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'Herkese açık bir YouTube Music çalma listesi veya albüm URL\'si yapıştırın';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'Herkese açık bir Spotify çalma listesi URL\'sini aşağıya yapıştırın';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Pulse çalma listesi içe aktarılamadı';

  @override
  String get importErrorPlaylist =>
      'Çalma listesi içe aktarılırken hata oluştu';

  @override
  String get importErrorHighlyPopulated =>
      'Çalma listesi çok kalabalık, getirilmesi biraz zaman alabilir.';

  @override
  String get libraryImportBtn => 'İçe Aktar';

  @override
  String get libraryCreateTitle => 'Yeni Çalma Listesi';

  @override
  String get libraryCreateDesc => 'Yeni çalma listemize ne ad verelim?';

  @override
  String get libraryCreateHint => 'örn. Gece Sürüşü';

  @override
  String get libraryCreateBtn => 'Oluştur';

  @override
  String get libraryRenameTitle => 'Çalma Listesini Yeniden Adlandır';

  @override
  String get libraryRenameDesc => 'Çalma listeniz için yeni bir ad girin.';

  @override
  String get libraryRenameBtn => 'Yeniden Adlandır';

  @override
  String get libraryDeleteTitle => 'Çalma Listesi Silinsin mi?';

  @override
  String libraryDeleteDesc(String name) {
    return '\"$name\" silinsin mi? Bu çalma listesi kalıcı olarak kaybolacak.';
  }

  @override
  String get libraryDeleteBtn => 'Sil';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'Son';

  @override
  String librarySongsCount(String count) {
    return '$count Şarkı';
  }

  @override
  String get libraryComingSoon => 'Yakında';

  @override
  String get loginErrName => 'Lütfen adınızı girin';

  @override
  String get loginErrEmail => 'Lütfen e-posta adresinizi girin';

  @override
  String get loginErrPassword => 'Lütfen şifrenizi girin';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'Her Ritmi Hisset!';

  @override
  String get loginMadeWithHeartBy => '❤️ ile tasarlayan: ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'Adınız';

  @override
  String get loginHintEmail => 'E-posta adresi';

  @override
  String get loginHintPassword => 'Şifre';

  @override
  String get loginErrEmailReset =>
      'Şifreyi sıfırlamak için lütfen e-postanızı girin';

  @override
  String get loginResetSent =>
      'Şifre sıfırlama e-postası gönderildi! Gelen kutunuzu kontrol edin.';

  @override
  String get loginForgotPwd => 'Şifremi Unuttum?';

  @override
  String get loginBtnSignup => 'Hesap Oluştur';

  @override
  String get loginBtnSignin => 'Giriş Yap';

  @override
  String get loginToggleHaveAccount => 'Zaten Pulse hesabın var mı? ';

  @override
  String get loginToggleNoAccount => 'Pulse hesabın yok mu? ';

  @override
  String get loginToggleSignin => 'Giriş Yap';

  @override
  String get loginToggleSignup => 'Kayıt Ol';

  @override
  String get offlineStillOffline =>
      'Hala çevrimdışı. Lütfen bağlantınızı kontrol edin.';

  @override
  String get offlineTitle => 'Çevrimdışısınız';

  @override
  String get offlineSubtitle =>
      'İnternet bağlantısı bulunamadı.\nAğınızı kontrol edip tekrar deneyin.';

  @override
  String get offlineChecking => 'Kontrol ediliyor...';

  @override
  String get offlineRetry => 'Tekrar Dene';

  @override
  String get offlineGoToDownloads => 'İndirilenlere Git';

  @override
  String get playerMadeWithHeartBy => '❤️ ile tasarlayan: ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'Şarkı sözleri için kaydır';

  @override
  String get playerNoLyrics => 'Şarkı sözü bulunamadı';

  @override
  String get playerUpNext => 'Sıradaki';

  @override
  String get playerNoTracksInQueue => 'Sırada parça yok';

  @override
  String get playerNoMusicPlaying => 'Çalan müzik yok';

  @override
  String get playerPickAVibe => 'Kütüphanenden veya ana sayfadan bir ritim seç';

  @override
  String get playerGoHome => 'Ana Sayfaya Git';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'Ekolayzır';

  @override
  String get playerEqCustom => 'Özel';

  @override
  String get playlistDownloads => 'İndirilenler';

  @override
  String get playlistOffline => 'Çevrimdışı Liste';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '${hours}s ${mins}dk';
  }

  @override
  String playlistDurationMins(String mins) {
    return '${mins}dk';
  }

  @override
  String get playlistFindOnPage => 'Bu sayfada bul';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count şarkı • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'Son';

  @override
  String get playlistNoMatches => 'Eşleşme bulunamadı.';

  @override
  String get playlistNoTracks => 'Bu çalma listesinde parça yok.';

  @override
  String get playlistNoSongsYet => 'Henüz şarkı yok.';

  @override
  String get playlistSortRecentlyAdded => 'Son Eklenenler';

  @override
  String get playlistSortAlphabetical => 'Alfabetik';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'şarkı',
      one: 'şarkı',
    );
    return '$count $_temp0 indiriliyor';
  }

  @override
  String get playlistView => 'GÖRÜNTÜLE';

  @override
  String get playlistAllDownloaded => 'Tüm şarkılar zaten indirildi';

  @override
  String playlistShareText(String name, String url) {
    return 'Pulse\'da \"$name\"e göz at!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'İndirilenlerden Kaldır';

  @override
  String get playlistRemoveFromPlaylist => 'Listeden Kaldır';

  @override
  String get playlistLoadError => 'Bu çalma listesi yüklenemedi.';

  @override
  String get playlistGoBack => '← Geri dön';

  @override
  String get profileNotLoggedIn => 'Giriş yapılmadı';

  @override
  String get profileSignIn => 'Giriş Yap';

  @override
  String get profileDefaultUser => 'Pulse Kullanıcısı';

  @override
  String get profileEditProfile => 'Profili Düzenle';

  @override
  String get profileTimeframeDay => 'Gün';

  @override
  String get profileTimeframeWeek => 'Hafta';

  @override
  String get profileTimeframeMonth => 'Ay';

  @override
  String get profileTimeframeYear => 'Yıl';

  @override
  String get profileListeningTime => 'DİNLEME SÜRESİ';

  @override
  String get profileToday => 'Bugün';

  @override
  String get profileThisWeek => 'Bu hafta';

  @override
  String get profileThisMonth => 'Bu ay';

  @override
  String get profileThisYear => 'Bu yıl';

  @override
  String get profileDailyAvg => 'GÜNLÜK ORT.';

  @override
  String get profilePerDay => 'Günlük';

  @override
  String get profileLifetimeListening => 'TOPLAM DİNLEME';

  @override
  String get profileTotalTimeListened => 'Pulse\'da müzik dinlenen toplam süre';

  @override
  String get profileYourTopSongs => 'En Çok Dinlediklerin';

  @override
  String get profileListeningHistoryEmpty =>
      'Dinleme geçmişi burada görünecek.';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'çalma',
      one: 'çalma',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => 'Favori Sanatçıların';

  @override
  String get profileTopArtistsEmpty => 'Favori sanatçıların burada görünecek.';

  @override
  String get profileArtistLabel => 'Sanatçı';

  @override
  String get profileSignOut => 'Çıkış Yap';

  @override
  String profileVersion(String version) {
    return 'Sürüm $version';
  }

  @override
  String get profileMadeWithHeartBy => '❤️ ile tasarlayan: ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'PROFİLİ DÜZENLE';

  @override
  String get profileDisplayName => 'GÖRÜNEN AD';

  @override
  String get profileCancel => 'İptal';

  @override
  String get profileSave => 'Kaydet';

  @override
  String get profileChooseAvatar => 'Avatar Seç';

  @override
  String get searchMicPermissionRequired =>
      'Bu özellik için mikrofon izni gerekiyor';

  @override
  String get searchUnknownSong => 'Bilinmeyen Şarkı';

  @override
  String get searchUnknownArtist => 'Bilinmeyen Sanatçı';

  @override
  String get searchNoSongDetected => 'Şarkı algılanmadı.';

  @override
  String searchError(String message) {
    return 'Hata: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'Ses tanıma kullanılamıyor';

  @override
  String get searchHint => 'Şarkılar, sanatçılar, albümler...';

  @override
  String get searchRecentEmpty => 'Son aramaların burada görünür';

  @override
  String get searchRecentSearches => 'Son Aramalar';

  @override
  String get searchClearAll => 'Tümünü temizle';

  @override
  String searchNoResultsFor(String query) {
    return '\"$query\" için sonuç yok';
  }

  @override
  String get searchTryDifferentKeywords => 'Farklı anahtar kelimeler deneyin';

  @override
  String get searchTopResult => 'En iyi sonuç';

  @override
  String get searchSongsLabel => 'Şarkılar';

  @override
  String get searchArtistsLabel => 'Sanatçılar';

  @override
  String get searchAlbumsLabel => 'Albümler';

  @override
  String get searchPlaylistsLabel => 'Listeler';

  @override
  String get searchArtistLabel => 'Sanatçı';

  @override
  String get searchListening => 'Dinleniyor...';

  @override
  String get searchSpeakNow => 'Aramak için şimdi konuşun';

  @override
  String get searchCancel => 'İptal';

  @override
  String get searchIdentifying => 'Tanımlanıyor...';

  @override
  String get searchListeningForSong => 'Şarkı dinleniyor...';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsStreamingQuality => 'Akış Kalitesi';

  @override
  String get settingsQualityAutomatic => 'Otomatik';

  @override
  String get settingsQualityLow => 'Düşük';

  @override
  String get settingsQualityNormal => 'Normal';

  @override
  String get settingsQualityHigh => 'Yüksek';

  @override
  String get settingsDownloadQuality => 'İndirme Kalitesi';

  @override
  String get settingsPlayback => 'Oynatma';

  @override
  String get settingsCrossfade => 'Geçiş';

  @override
  String get settingsCrossfadeDesc =>
      'Kusursuz geçişler için parçaları örtüştürün';

  @override
  String get settingsDataUsage => 'Veri Kullanımı';

  @override
  String get settingsDataSaver => 'Veri Tasarrufu';

  @override
  String get settingsDataSaverDesc =>
      'Hücresel veride daha düşük kalitede dinle';

  @override
  String get settingsAppearance => 'Görünüm';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsCustomAccent => 'Özel Vurgu Rengi';

  @override
  String get settingsSaturation => 'Doygunluk';

  @override
  String get settingsBrightness => 'Parlaklık';

  @override
  String get settingsResetDefault => 'Sıfırla';

  @override
  String get playlistSheetTitle => 'Çalma Listesine Ekle';

  @override
  String get playlistSheetNewPlaylist => 'Yeni Liste';

  @override
  String get playlistSheetNoPlaylists => 'Henüz liste yok';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'şarkı',
      one: 'şarkı',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => 'Liste Adı';

  @override
  String get playlistSheetCancel => 'İptal';

  @override
  String playlistSheetAddedTo(String name) {
    return '$name listesine eklendi';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'Liste oluşturulamadı: Kimlik doğrulama hatası';

  @override
  String playlistSheetCreateFail(String error) {
    return 'Liste oluşturulamadı: $error';
  }

  @override
  String get playlistSheetCreate => 'Oluştur';

  @override
  String get appUpdateAvailable => 'Güncelleme Var';

  @override
  String appUpdateDesc(String version) {
    return 'Sürüm $version çıktı! En son özellikleri almak için şimdi güncelleyin.';
  }

  @override
  String get appUpdateDownload => 'Güncellemeyi İndir';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navLibrary => 'Kütüphane';

  @override
  String get navSearch => 'Ara';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get navProfile => 'Profil';

  @override
  String get artistSelect => 'Sanatçı Seç';

  @override
  String get songActionQueue => 'Sıraya Ekle';

  @override
  String get songActionPlaylist => 'Listeye Ekle';

  @override
  String get songActionFinding => 'Bulunuyor...';

  @override
  String get songActionAlbum => 'Albüme Git';

  @override
  String get songActionArtist => 'Sanatçıya Git';

  @override
  String get songActionRemovePlaylist => 'Listeden Kaldır';

  @override
  String get songActionRemoveDownload => 'İndirilenlerden Kaldır';

  @override
  String get songActionDownloadChecking => 'Kontrol ediliyor...';

  @override
  String get songActionDownloading => 'İndiriliyor...';

  @override
  String get songActionDownloaded => 'İndirildi!';

  @override
  String get songActionDownloadAlready => 'Zaten indirildi';

  @override
  String get songActionDownloadFailed => 'İndirme başarısız';

  @override
  String get songActionDownload => 'İndir';

  @override
  String get songActionDownloadingSnack => 'İndiriliyor';

  @override
  String get songActionView => 'GÖRÜNTÜLE';

  @override
  String get spotifyImportTitle => 'Spotify\'dan İçe Aktar';

  @override
  String get spotifyImportSubtitle => 'Liste boyutunuzu seçin';

  @override
  String get spotifyChoiceSmallTitle => '100 veya daha az şarkı';

  @override
  String get spotifyChoiceSmallDesc =>
      'Herkese açık bir Spotify liste URL\'si yapıştırın.';

  @override
  String get spotifyChoiceLargeTitle => '100\'den fazla şarkı';

  @override
  String get spotifyChoiceLargeDesc =>
      'Sınırsız parça içe aktarmak için kendi Spotify Geliştirici Uygulamanızı bağlayın.';

  @override
  String get cancelButton => 'İptal';

  @override
  String get spotifyPlaylistsTitle => 'Spotify Listeleriniz';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'Hata: $error\nClient ID\'nizin geçerli olduğundan emin olun.';
  }

  @override
  String get spotifyPlaylistsEmpty => 'Kütüphanenizde çalma listesi bulunamadı';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count parça';
  }

  @override
  String get spotifyPlaylistsImport => 'İçe Aktar';

  @override
  String get audioPlaybackFailed =>
      'Oynatma başarısız. İnternet bağlantınızı kontrol edin.';

  @override
  String get audioControlPrevious => 'Önceki';

  @override
  String get audioControlPause => 'Duraklat';

  @override
  String get audioControlPlay => 'Çal';

  @override
  String get audioControlNext => 'Sonraki';

  @override
  String get audioControlUnlike => 'Beğenmekten Vazgeç';

  @override
  String get audioControlLike => 'Beğen';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'Ham yanıt: $data\n\nYedek: $error';
  }

  @override
  String get apiErrorInvalidClient => 'Geçersiz istemci veya gizli anahtar.';

  @override
  String get apiErrorBadRequest =>
      'Geçersiz İstek. Lütfen girdilerinizi kontrol edin.';

  @override
  String get apiErrorUnauthorized => 'Yetkisiz. Lütfen tekrar giriş yapın.';

  @override
  String get apiErrorForbidden => 'Yasak. Erişim izniniz yok.';

  @override
  String get apiErrorNotFound => 'Kaynak bulunamadı.';

  @override
  String get apiErrorEmailInUse => 'Bu e-posta adresi zaten kullanılıyor.';

  @override
  String get apiErrorUserNotFound => 'Bu e-postayla eşleşen hesap bulunamadı.';

  @override
  String get apiErrorWrongPassword => 'Yanlış şifre.';

  @override
  String get apiErrorInvalidCredential =>
      'Giriş başarısız. Lütfen bilgilerinizi kontrol edin.';

  @override
  String get apiErrorNetwork => 'Ağ hatası. Lütfen bağlantınızı kontrol edin.';

  @override
  String get apiErrorSocketTimeout =>
      'Bağlantı zaman aşımına uğradı. Lütfen tekrar deneyin.';

  @override
  String get apiErrorTooManyRequests =>
      'Çok fazla istek. Lütfen bir süre bekleyip tekrar deneyin.';

  @override
  String get apiErrorServerError =>
      'Sunucu hatası. Lütfen daha sonra tekrar deneyin.';

  @override
  String get apiErrorInvalidEmail => 'Lütfen geçerli bir e-posta adresi girin.';

  @override
  String get apiErrorWeakPassword =>
      'Şifre çok zayıf. En az 6 karakter kullanın.';

  @override
  String get apiErrorTooManyAttempts =>
      'Çok fazla başarısız deneme. Lütfen daha sonra tekrar deneyin.';

  @override
  String get homeForgottenFavorites => 'Unutulan Favoriler';

  @override
  String get artistShowAll => 'Tümünü göster';

  @override
  String get homeTopTracks => 'En çok dinlenenler';
}
