// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'Tentang';

  @override
  String get artistPopular => 'Populer';

  @override
  String get artistAlbums => 'Album';

  @override
  String get artistSinglesAndEPs => 'Single & EP';

  @override
  String artistSubscribersCount(String count) {
    return '$count pelanggan';
  }

  @override
  String get artistPlayAll => 'Putar Semua';

  @override
  String get artistLoadError => 'Gagal memuat artis';

  @override
  String get artistGoBack => 'Kembali';

  @override
  String adminChatFailedToReply(String error) {
    return 'Gagal membalas: $error';
  }

  @override
  String get adminChatSupportChat => 'Obrolan Dukungan';

  @override
  String adminChatError(String error) {
    return 'Kesalahan: $error';
  }

  @override
  String get adminChatNoHistory => 'Tidak ada riwayat pesan.';

  @override
  String get adminChatSupportYou => 'Dukungan (Anda)';

  @override
  String get adminChatTypeReply => 'Ketik balasan...';

  @override
  String get broadcastSuccess => 'Pengumuman berhasil dikirim!';

  @override
  String broadcastFailed(String error) {
    return 'Gagal mengirim: $error';
  }

  @override
  String get broadcastTitle => 'Pengumuman Global';

  @override
  String get broadcastSubtitle => 'Dikirim ke semua pengguna';

  @override
  String get broadcastWarning => 'Pesan ini akan dilihat oleh semua orang.';

  @override
  String broadcastError(String error) {
    return 'Kesalahan: $error';
  }

  @override
  String get broadcastNoHistory => 'Tidak ada pengumuman global.';

  @override
  String get broadcastTypeMessage => 'Ketik pengumuman...';

  @override
  String commFailedToSend(String error) {
    return 'Gagal mengirim: $error';
  }

  @override
  String get commAdminDashboard => 'Dasbor Admin';

  @override
  String get commAdminSupport => 'Dukungan';

  @override
  String get commAlwaysHere => 'Selalu siap membantu';

  @override
  String get commWelcomeTitle => 'Halo! 👋 Saya Ashutosh Pathak';

  @override
  String get commWelcomeSubtitle => 'Pembuat Pulse';

  @override
  String get commWelcomeBody1 =>
      'Semoga Anda menikmati pengalaman musik tanpa iklan. Musik harus tanpa batas.\n\nIni adalah ruang Anda untuk berbicara langsung dengan saya.\n\nJangan ragu untuk mengirim:';

  @override
  String get commBullet1 => 'Umpan balik Anda';

  @override
  String get commBullet2 => 'Laporan bug';

  @override
  String get commBullet3 => 'Ide fitur baru';

  @override
  String get commWelcomeBody2 =>
      'Saya membaca setiap pesan secara pribadi.\n\nPunya ide untuk aplikasi baru? Beri tahu saya! Jika memungkinkan, saya akan membuatnya.\n\nTerima kasih telah menjadi bagian dari ini. ❤️';

  @override
  String commError(String error) {
    return 'Kesalahan: $error';
  }

  @override
  String get commNoMessages => 'Belum ada pesan';

  @override
  String get commNoMessagesDesc =>
      'Kirim pesan ke dukungan atau periksa lagi nanti.';

  @override
  String get commMessageSupportHint => 'Ketik pesan...';

  @override
  String get commGlobalAnnouncements => 'Pengumuman Global';

  @override
  String get commSendMessagesToAll => 'Kirim ke Semua';

  @override
  String get homeGreetingMorning => 'Selamat Pagi,';

  @override
  String get homeGreetingAfternoon => 'Selamat Siang,';

  @override
  String get homeGreetingEvening => 'Selamat Malam,';

  @override
  String get homeMember => 'Anggota';

  @override
  String get homeRecentPlaylists => 'Daftar Putar Terbaru';

  @override
  String get homeRecentlyPlayed => 'Baru Diputar';

  @override
  String get homeSpeedDial => 'Akses Cepat';

  @override
  String get homeNoContent => 'Tidak ada konten';

  @override
  String get homeRefresh => 'Segarkan';

  @override
  String get homeLoadError => 'Gagal memuat feed.';

  @override
  String get homeRetry => 'Coba Lagi';

  @override
  String get importSuccess => 'Berhasil terhubung ke Spotify!';

  @override
  String importFailed(String error) {
    return 'Gagal menghubungkan: $error';
  }

  @override
  String get importTitle => 'Hubungkan Spotify';

  @override
  String get importSetupTitle => 'Pengaturan Spotify';

  @override
  String get importSetupDesc =>
      'Gunakan kunci pengembang Anda sendiri untuk mengimpor daftar putar Anda dengan cepat:';

  @override
  String get importStep1 => 'Buka Spotify Developer Dashboard.';

  @override
  String get importStep2 => 'Masuk dan klik \'Create app\'.';

  @override
  String get importStep3 => 'Beri nama dan deskripsi aplikasi Anda.';

  @override
  String get importStep4 =>
      'Di bawah \'Redirect URIs\', rekatkan tautan tepat ini:';

  @override
  String get importRedirectCopied => 'Redirect URI disalin!';

  @override
  String get importStep5 =>
      'Simpan, salin \'Client ID\' dan rekatkan di bawah ini.';

  @override
  String get importImportant =>
      'Penting: Diperlukan langganan Spotify Premium yang aktif.';

  @override
  String get importClientIdHint => 'Rekatkan Spotify Client ID Anda di sini...';

  @override
  String get importConnectButton => 'Hubungkan & Muat Pustaka';

  @override
  String get downloadingNoActive => 'Tidak ada unduhan aktif';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'Unduhan';

  @override
  String downloadsStats(String count, String size) {
    return '$count lagu • $size';
  }

  @override
  String get downloadsNoOffline => 'Tidak ada lagu luring';

  @override
  String get downloadsNoOfflineDesc => 'Lagu unduhan Anda akan muncul di sini';

  @override
  String get downloadsClearAllTitle => 'Hapus Semua?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'Ini akan menghapus $count lagu dan membebaskan $size penyimpanan.';
  }

  @override
  String get downloadsCancel => 'Batal';

  @override
  String get downloadsClearAll => 'Hapus Semua';

  @override
  String downloadsSongsCount(String count) {
    return '$count lagu';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count lagu';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'Daftar putar unduhan utama tidak dapat diganti nama.';

  @override
  String get downloadsRename => 'Ganti Nama';

  @override
  String get downloadsEditSongs => 'Edit Lagu';

  @override
  String get downloadsDelete => 'Hapus';

  @override
  String get downloadsRenamePlaylistTitle => 'Ganti Nama Daftar Putar';

  @override
  String get downloadsRenamePlaylistDesc =>
      'Masukkan nama baru untuk daftar putar.';

  @override
  String get downloadsDeletePlaylistTitle => 'Hapus Daftar Putar?';

  @override
  String get downloadsDeleteMasterDesc =>
      'Apakah Anda yakin? Anda akan kehilangan semua lagu dan daftar putar yang diunduh secara permanen.';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'Apakah Anda yakin ingin menghapus \'$name\'? Ini akan hilang selamanya.';
  }

  @override
  String get downloadsSave => 'Simpan';

  @override
  String get downloadsNoSongs => 'Daftar putar ini tidak memiliki lagu.';

  @override
  String get libraryTitle => 'Koleksi';

  @override
  String get libraryPauseAll => 'Jeda Semua';

  @override
  String get libraryResumeAll => 'Lanjutkan Semua';

  @override
  String get libraryTabPlaylists => 'Daftar Putar';

  @override
  String get libraryTabDownloads => 'Unduhan';

  @override
  String get libraryTabDownloading => 'Mengunduh';

  @override
  String libraryImportedTask(String name) {
    return 'Mengimpor $name';
  }

  @override
  String get libraryImportWaiting => 'Menunggu...';

  @override
  String get libraryImportFetching => 'Mengambil daftar putar...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return 'Diproses $processed/$total · Cocok $matched';
  }

  @override
  String get libraryImportSaving => 'Menyimpan...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched lagu ditambahkan · ketuk × untuk tutup';
  }

  @override
  String get libraryImportDoneAll => 'Semua lagu ditambahkan · ketuk ×';

  @override
  String get libraryAddButton => 'Tambah';

  @override
  String get librarySortRecent => 'Baru Ditambahkan';

  @override
  String get librarySortAlpha => 'Abjad';

  @override
  String get libraryEmptyTitle => 'Koleksi Anda kosong.';

  @override
  String get libraryEmptyDesc => 'Ketuk \'Tambah\' untuk memulai.';

  @override
  String get libraryRenameLikedError =>
      'Daftar Lagu yang Disukai tidak dapat diganti namanya.';

  @override
  String get libraryRename => 'Ganti Nama';

  @override
  String get libraryEditSongs => 'Edit Lagu';

  @override
  String get libraryDeleteLikedError =>
      'Daftar Lagu yang Disukai tidak dapat dihapus.';

  @override
  String get libraryDelete => 'Hapus';

  @override
  String get libraryEditSongsTitle => 'Edit Lagu';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count lagu';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count lagu';
  }

  @override
  String get libraryCancel => 'Batal';

  @override
  String get librarySave => 'Simpan';

  @override
  String get libraryNoSongs => 'Daftar putar ini tidak memiliki lagu.';

  @override
  String get libraryAddOptionsTitle => 'Tambah ke Koleksi';

  @override
  String get libraryAddOptionsDesc =>
      'Pilih cara memperluas koleksi Pulse Anda';

  @override
  String get libraryImportPulse => 'Impor dari Pulse';

  @override
  String get libraryImportPulseDesc => 'Tempel URL daftar putar Pulse';

  @override
  String get libraryImportYtm => 'Impor dari YT Music';

  @override
  String get libraryImportYtmDesc => 'Tempel tautan publik';

  @override
  String get libraryImportSpotify => 'Impor dari Spotify';

  @override
  String get libraryImportSpotifyDesc => 'Hubungkan Spotify Anda';

  @override
  String get libraryClose => 'Tutup';

  @override
  String get libraryImportYtmFull => 'Impor dari YouTube Music';

  @override
  String get libraryImportSpotifyFull => 'Impor dari Spotify (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'Tempel tautan publik ke daftar putar atau album dari YouTube Music di sini';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'Tempel tautan publik ke daftar putar dari Spotify di sini';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Gagal mengimpor daftar putar Pulse';

  @override
  String get importErrorPlaylist => 'Kesalahan Impor';

  @override
  String get importErrorHighlyPopulated =>
      'Daftar putarnya besar, ini mungkin memakan waktu agak lama.';

  @override
  String get libraryImportBtn => 'Impor';

  @override
  String get libraryCreateTitle => 'Daftar Putar Baru';

  @override
  String get libraryCreateDesc => 'Apa nama daftar putar baru Anda?';

  @override
  String get libraryCreateHint => 'Misal: Perjalanan Jauh';

  @override
  String get libraryCreateBtn => 'Buat';

  @override
  String get libraryRenameTitle => 'Ganti Nama Daftar';

  @override
  String get libraryRenameDesc => 'Masukkan nama baru.';

  @override
  String get libraryRenameBtn => 'Ganti Nama';

  @override
  String get libraryDeleteTitle => 'Hapus Daftar?';

  @override
  String libraryDeleteDesc(String name) {
    return 'Apakah Anda yakin ingin menghapus \'$name\'? Ini akan hilang selamanya.';
  }

  @override
  String get libraryDeleteBtn => 'Hapus';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'Terbaru';

  @override
  String librarySongsCount(String count) {
    return '$count lagu';
  }

  @override
  String get libraryComingSoon => 'Segera Hadir';

  @override
  String get loginErrName => 'Silakan ketik nama Anda';

  @override
  String get loginErrEmail => 'Silakan masukkan email Anda';

  @override
  String get loginErrPassword => 'Silakan masukkan kata sandi Anda';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'Rasakan setiap ketukan!';

  @override
  String get loginMadeWithHeartBy => 'Dibuat dengan ❤️ oleh: ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'Nama Anda';

  @override
  String get loginHintEmail => 'Alamat Email';

  @override
  String get loginHintPassword => 'Kata Sandi';

  @override
  String get loginErrEmailReset => 'Silakan masukkan email untuk mereset';

  @override
  String get loginResetSent => 'Terkirim! Periksa kotak masuk Anda.';

  @override
  String get loginForgotPwd => 'Lupa Kata Sandi?';

  @override
  String get loginBtnSignup => 'Buat Akun';

  @override
  String get loginBtnSignin => 'Masuk';

  @override
  String get loginToggleHaveAccount => 'Sudah punya akun Pulse? ';

  @override
  String get loginToggleNoAccount => 'Belum punya akun Pulse? ';

  @override
  String get loginToggleSignin => 'Masuk';

  @override
  String get loginToggleSignup => 'Daftar';

  @override
  String get offlineStillOffline => 'Masih luring. Harap periksa koneksi Anda.';

  @override
  String get offlineTitle => 'Anda Sedang Luring';

  @override
  String get offlineSubtitle =>
      'Tidak ada koneksi internet.\nPeriksa jaringan Anda dan coba lagi.';

  @override
  String get offlineChecking => 'Memeriksa...';

  @override
  String get offlineRetry => 'Coba Lagi';

  @override
  String get offlineGoToDownloads => 'Buka Unduhan';

  @override
  String get playerMadeWithHeartBy => 'Dibuat dengan ❤️ oleh: ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'Usap untuk Lirik';

  @override
  String get playerNoLyrics => 'Lirik tidak tersedia';

  @override
  String get playerUpNext => 'Selanjutnya';

  @override
  String get playerNoTracksInQueue => 'Tidak ada lagu dalam antrean';

  @override
  String get playerNoMusicPlaying => 'Tidak ada musik yang diputar';

  @override
  String get playerPickAVibe => 'Pilih lagu dari koleksi';

  @override
  String get playerGoHome => 'Ke Beranda';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'Ekualiser';

  @override
  String get playerEqCustom => 'Kustom';

  @override
  String get playlistDownloads => 'Unduhan';

  @override
  String get playlistOffline => 'Daftar Luring';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '${hours}j ${mins}m';
  }

  @override
  String playlistDurationMins(String mins) {
    return '${mins}m';
  }

  @override
  String get playlistFindOnPage => 'Cari di halaman';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count lagu • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'Terbaru';

  @override
  String get playlistNoMatches => 'Tidak ada yang cocok.';

  @override
  String get playlistNoTracks => 'Daftar putar ini tidak memiliki lagu.';

  @override
  String get playlistNoSongsYet => 'Belum ada lagu.';

  @override
  String get playlistSortRecentlyAdded => 'Baru Ditambahkan';

  @override
  String get playlistSortAlphabetical => 'Abjad';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'lagu',
      one: 'lagu',
    );
    return 'Mengunduh $count $_temp0';
  }

  @override
  String get playlistView => 'Lihat';

  @override
  String get playlistAllDownloaded => 'Semua terunduh';

  @override
  String playlistShareText(String name, String url) {
    return 'Dengarkan \'$name\' di Pulse!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'Hapus dari Unduhan';

  @override
  String get playlistRemoveFromPlaylist => 'Hapus dari Daftar Putar';

  @override
  String get playlistLoadError => 'Gagal memuat.';

  @override
  String get playlistGoBack => '← Kembali';

  @override
  String get profileNotLoggedIn => 'Belum Masuk';

  @override
  String get profileSignIn => 'Masuk';

  @override
  String get profileDefaultUser => 'Pengguna Pulse';

  @override
  String get profileEditProfile => 'Edit Profil';

  @override
  String get profileTimeframeDay => 'Hari';

  @override
  String get profileTimeframeWeek => 'Minggu';

  @override
  String get profileTimeframeMonth => 'Bulan';

  @override
  String get profileTimeframeYear => 'Tahun';

  @override
  String get profileListeningTime => 'Waktu Mendengar';

  @override
  String get profileToday => 'Hari Ini';

  @override
  String get profileThisWeek => 'Minggu Ini';

  @override
  String get profileThisMonth => 'Bulan Ini';

  @override
  String get profileThisYear => 'Tahun Ini';

  @override
  String get profileDailyAvg => 'Rata-rata Harian';

  @override
  String get profilePerDay => '/hari';

  @override
  String get profileLifetimeListening => 'Sepanjang Waktu';

  @override
  String get profileTotalTimeListened => 'Total Waktu di Pulse';

  @override
  String get profileYourTopSongs => 'Lagu Teratas Anda';

  @override
  String get profileListeningHistoryEmpty =>
      'Riwayat pendengaran Anda akan muncul di sini.';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'putaran',
      one: 'putaran',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => 'Artis Teratas Anda';

  @override
  String get profileTopArtistsEmpty =>
      'Artis favorit Anda akan muncul di sini.';

  @override
  String get profileArtistLabel => 'Artis';

  @override
  String get profileSignOut => 'Keluar';

  @override
  String profileVersion(String version) {
    return 'Versi $version';
  }

  @override
  String get profileMadeWithHeartBy => 'Dibuat dengan ❤️ oleh: ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'Edit Profil';

  @override
  String get profileDisplayName => 'Nama Tampilan';

  @override
  String get profileCancel => 'Batal';

  @override
  String get profileSave => 'Simpan';

  @override
  String get profileChooseAvatar => 'Pilih Avatar';

  @override
  String get searchMicPermissionRequired => 'Izin mikrofon diperlukan';

  @override
  String get searchUnknownSong => 'Lagu Tidak Dikenal';

  @override
  String get searchUnknownArtist => 'Artis Tidak Dikenal';

  @override
  String get searchNoSongDetected => 'Tidak ada lagu yang terdeteksi.';

  @override
  String searchError(String message) {
    return 'Kesalahan: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'Pencarian suara tidak tersedia';

  @override
  String get searchHint => 'Lagu, Artis, Album...';

  @override
  String get searchRecentEmpty => 'Pencarian terbaru Anda akan muncul di sini';

  @override
  String get searchRecentSearches => 'Pencarian Terbaru';

  @override
  String get searchClearAll => 'Hapus Semua';

  @override
  String searchNoResultsFor(String query) {
    return 'Tidak ada hasil untuk \'$query\'';
  }

  @override
  String get searchTryDifferentKeywords => 'Coba kata kunci yang berbeda';

  @override
  String get searchTopResult => 'Hasil Teratas';

  @override
  String get searchSongsLabel => 'Lagu';

  @override
  String get searchArtistsLabel => 'Artis';

  @override
  String get searchAlbumsLabel => 'Album';

  @override
  String get searchPlaylistsLabel => 'Daftar Putar';

  @override
  String get searchArtistLabel => 'Artis';

  @override
  String get searchListening => 'Mendengarkan...';

  @override
  String get searchSpeakNow => 'Bicara sekarang';

  @override
  String get searchCancel => 'Batal';

  @override
  String get searchIdentifying => 'Mengidentifikasi...';

  @override
  String get searchListeningForSong => 'Mendengarkan lagu...';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsStreamingQuality => 'Kualitas Streaming';

  @override
  String get settingsQualityAutomatic => 'Otomatis';

  @override
  String get settingsQualityLow => 'Rendah';

  @override
  String get settingsQualityNormal => 'Normal';

  @override
  String get settingsQualityHigh => 'Tinggi';

  @override
  String get settingsDownloadQuality => 'Kualitas Unduhan';

  @override
  String get settingsPlayback => 'Pemutaran';

  @override
  String get settingsCrossfade => 'Transisi Lintas';

  @override
  String get settingsCrossfadeDesc => 'Menyambungkan lagu dengan mulus';

  @override
  String get settingsDataUsage => 'Penggunaan Data';

  @override
  String get settingsDataSaver => 'Penghemat Data';

  @override
  String get settingsDataSaverDesc => 'Streaming dengan kualitas lebih rendah';

  @override
  String get settingsAppearance => 'Tampilan';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsCustomAccent => 'Warna Aksen';

  @override
  String get settingsSaturation => 'Saturasi';

  @override
  String get settingsBrightness => 'Kecerahan';

  @override
  String get settingsResetDefault => 'Kembalikan ke Default';

  @override
  String get playlistSheetTitle => 'Tambah ke Daftar';

  @override
  String get playlistSheetNewPlaylist => 'Daftar Putar Baru';

  @override
  String get playlistSheetNoPlaylists => 'Tidak ada daftar';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'lagu',
      one: 'lagu',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => 'Nama Daftar Putar';

  @override
  String get playlistSheetCancel => 'Batal';

  @override
  String playlistSheetAddedTo(String name) {
    return 'Ditambahkan ke $name';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'Gagal membuat: Kesalahan autentikasi';

  @override
  String playlistSheetCreateFail(String error) {
    return 'Gagal membuat: $error';
  }

  @override
  String get playlistSheetCreate => 'Buat';

  @override
  String get appUpdateAvailable => 'Pembaruan Tersedia';

  @override
  String appUpdateDesc(String version) {
    return 'Versi $version sudah ada! Perbarui sekarang.';
  }

  @override
  String get appUpdateDownload => 'Unduh Pembaruan';

  @override
  String get navHome => 'Beranda';

  @override
  String get navLibrary => 'Koleksi';

  @override
  String get navSearch => 'Cari';

  @override
  String get navSettings => 'Pengaturan';

  @override
  String get navProfile => 'Profil';

  @override
  String get artistSelect => 'Pilih Artis';

  @override
  String get songActionQueue => 'Tambah ke Antrean';

  @override
  String get songActionPlaylist => 'Tambah ke Daftar Putar';

  @override
  String get songActionFinding => 'Mencari...';

  @override
  String get songActionAlbum => 'Pergi ke Album';

  @override
  String get songActionArtist => 'Pergi ke Artis';

  @override
  String get songActionRemovePlaylist => 'Hapus dari Daftar';

  @override
  String get songActionRemoveDownload => 'Hapus dari Unduhan';

  @override
  String get songActionDownloadChecking => 'Memeriksa...';

  @override
  String get songActionDownloading => 'Mengunduh...';

  @override
  String get songActionDownloaded => 'Terunduh!';

  @override
  String get songActionDownloadAlready => 'Sudah diunduh';

  @override
  String get songActionDownloadFailed => 'Gagal mengunduh';

  @override
  String get songActionDownload => 'Unduh';

  @override
  String get songActionDownloadingSnack => 'Mengunduh';

  @override
  String get songActionView => 'Lihat';

  @override
  String get spotifyImportTitle => 'Impor dari Spotify';

  @override
  String get spotifyImportSubtitle => 'Pilih ukuran daftar putar';

  @override
  String get spotifyChoiceSmallTitle => '100 lagu atau kurang';

  @override
  String get spotifyChoiceSmallDesc => 'Tempel tautan publik.';

  @override
  String get spotifyChoiceLargeTitle => 'Lebih dari 100 lagu';

  @override
  String get spotifyChoiceLargeDesc => 'Hubungkan Spotify Developer App Anda.';

  @override
  String get cancelButton => 'Batal';

  @override
  String get spotifyPlaylistsTitle => 'Daftar Putar Spotify';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'Kesalahan: $error\nPeriksa Client ID Anda.';
  }

  @override
  String get spotifyPlaylistsEmpty => 'Tidak ada daftar putar';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count lagu';
  }

  @override
  String get spotifyPlaylistsImport => 'Impor';

  @override
  String get audioPlaybackFailed => 'Gagal memutar.';

  @override
  String get audioControlPrevious => 'Sebelumnya';

  @override
  String get audioControlPause => 'Jeda';

  @override
  String get audioControlPlay => 'Putar';

  @override
  String get audioControlNext => 'Selanjutnya';

  @override
  String get audioControlUnlike => 'Batal Suka';

  @override
  String get audioControlLike => 'Suka';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'Respons mentah: $data\n\nKesalahan: $error';
  }

  @override
  String get apiErrorInvalidClient => 'Client ID tidak valid.';

  @override
  String get apiErrorBadRequest => 'Permintaan buruk. Periksa data Anda.';

  @override
  String get apiErrorUnauthorized => 'Tidak sah. Silakan masuk kembali.';

  @override
  String get apiErrorForbidden => 'Dilarang. Anda tidak memiliki akses.';

  @override
  String get apiErrorNotFound => 'Sumber daya tidak ditemukan.';

  @override
  String get apiErrorEmailInUse => 'Alamat email ini sudah digunakan.';

  @override
  String get apiErrorUserNotFound => 'Tidak ada akun dengan email ini.';

  @override
  String get apiErrorWrongPassword => 'Kata sandi salah.';

  @override
  String get apiErrorInvalidCredential =>
      'Gagal masuk. Periksa kredensial Anda.';

  @override
  String get apiErrorNetwork => 'Kesalahan jaringan. Periksa koneksi Anda.';

  @override
  String get apiErrorSocketTimeout => 'Waktu habis. Silakan coba lagi.';

  @override
  String get apiErrorTooManyRequests =>
      'Terlalu banyak permintaan. Coba lagi nanti.';

  @override
  String get apiErrorServerError => 'Kesalahan server. Coba lagi nanti.';

  @override
  String get apiErrorInvalidEmail => 'Berikan alamat email yang valid.';

  @override
  String get apiErrorWeakPassword =>
      'Kata sandi terlalu lemah. Gunakan minimal 6 karakter.';

  @override
  String get apiErrorTooManyAttempts =>
      'Terlalu banyak percobaan gagal. Coba lagi nanti.';

  @override
  String get homeForgottenFavorites => 'Favorit yang Terlupakan';

  @override
  String get artistShowAll => 'Tampilkan semua';

  @override
  String get homeTopTracks => 'Lagu terbaik';
}
