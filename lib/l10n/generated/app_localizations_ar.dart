// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'حول';

  @override
  String get artistPopular => 'رائجة';

  @override
  String get artistAlbums => 'ألبومات';

  @override
  String get artistSinglesAndEPs => 'أغاني منفردة و EPs';

  @override
  String artistSubscribersCount(String count) {
    return '$count مشترك';
  }

  @override
  String get artistPlayAll => 'تشغيل الكل';

  @override
  String get artistLoadError => 'تعذر تحميل الفنان';

  @override
  String get artistGoBack => 'العودة';

  @override
  String adminChatFailedToReply(String error) {
    return 'فشل الرد: $error';
  }

  @override
  String get adminChatSupportChat => 'دردشة الدعم';

  @override
  String adminChatError(String error) {
    return 'خطأ: $error';
  }

  @override
  String get adminChatNoHistory => 'لا يوجد سجل رسائل.';

  @override
  String get adminChatSupportYou => 'الدعم (أنت)';

  @override
  String get adminChatTypeReply => 'اكتب رداً...';

  @override
  String get broadcastSuccess => 'تم إرسال الإعلان بنجاح!';

  @override
  String broadcastFailed(String error) {
    return 'فشل الإرسال: $error';
  }

  @override
  String get broadcastTitle => 'إعلان عام';

  @override
  String get broadcastSubtitle => 'مرسل لجميع المستخدمين';

  @override
  String get broadcastWarning => 'سيشاهد الجميع هذه الرسالة.';

  @override
  String broadcastError(String error) {
    return 'خطأ: $error';
  }

  @override
  String get broadcastNoHistory => 'لا توجد إعلانات عامة.';

  @override
  String get broadcastTypeMessage => 'اكتب رسالة الإعلان...';

  @override
  String commFailedToSend(String error) {
    return 'فشل الإرسال: $error';
  }

  @override
  String get commAdminDashboard => 'لوحة الإدارة';

  @override
  String get commAdminSupport => 'الدعم';

  @override
  String get commAlwaysHere => 'دائماً هنا للمساعدة';

  @override
  String get commWelcomeTitle => 'مرحباً! 👋 أنا Ashutosh Pathak';

  @override
  String get commWelcomeSubtitle => 'مطور Pulse';

  @override
  String get commWelcomeBody1 =>
      'أتمنى أن تستمتع بتجربة موسيقية خالية من الإعلانات. يجب أن تكون الموسيقى متاحة للجميع.\n\nهذه المساحة مخصصة للتواصل معي مباشرة.\n\nلا تتردد في مشاركة:';

  @override
  String get commBullet1 => 'ملاحظاتك';

  @override
  String get commBullet2 => 'الإبلاغ عن أخطاء';

  @override
  String get commBullet3 => 'اقتراح ميزات جديدة';

  @override
  String get commWelcomeBody2 =>
      'أقرأ كل رسالة شخصياً.\n\nهل لديك أفكار لتطبيق جديد؟ أخبرني! وسأحاول برمجته إن أمكن.\n\nشكراً لكونك جزءاً من هذا التطبيق. ❤️';

  @override
  String commError(String error) {
    return 'خطأ: $error';
  }

  @override
  String get commNoMessages => 'لا توجد رسائل بعد';

  @override
  String get commNoMessagesDesc => 'أرسل رسالة للدعم أو تحقق لاحقاً.';

  @override
  String get commMessageSupportHint => 'اكتب رسالة...';

  @override
  String get commGlobalAnnouncements => 'إعلانات عامة';

  @override
  String get commSendMessagesToAll => 'إرسال للجميع';

  @override
  String get homeGreetingMorning => 'صباح الخير،';

  @override
  String get homeGreetingAfternoon => 'طاب مساؤك،';

  @override
  String get homeGreetingEvening => 'مساء الخير،';

  @override
  String get homeMember => 'عضو';

  @override
  String get homeRecentPlaylists => 'قوائم التشغيل الأخيرة';

  @override
  String get homeRecentlyPlayed => 'تم تشغيلها مؤخراً';

  @override
  String get homeSpeedDial => 'الوصول السريع';

  @override
  String get homeNoContent => 'لا يوجد محتوى';

  @override
  String get homeRefresh => 'تحديث';

  @override
  String get homeLoadError => 'فشل في تحميل الخلاصة.';

  @override
  String get homeRetry => 'إعادة المحاولة';

  @override
  String get importSuccess => 'تم الاتصال بحساب Spotify بنجاح!';

  @override
  String importFailed(String error) {
    return 'فشل الاتصال: $error';
  }

  @override
  String get importTitle => 'الاتصال بحساب Spotify';

  @override
  String get importSetupTitle => 'إعداد Spotify';

  @override
  String get importSetupDesc =>
      'استخدم مفتاح المطور الخاص بك لاستيراد قوائم التشغيل بسرعة:';

  @override
  String get importStep1 => 'افتح لوحة تحكم مطوري Spotify.';

  @override
  String get importStep2 => 'قم بتسجيل الدخول وانقر على \'Create app\'.';

  @override
  String get importStep3 => 'أدخل اسماً ووصفاً للتطبيق.';

  @override
  String get importStep4 => 'ضمن \'Redirect URIs\'، انسخ هذا الرابط المحدد:';

  @override
  String get importRedirectCopied => 'تم نسخ رابط إعادة التوجيه!';

  @override
  String get importStep5 => 'احفظ التغييرات، وانسخ \'Client ID\' والصقه أدناه.';

  @override
  String get importImportant => 'هام: يتطلب اشتراك Spotify Premium فعال.';

  @override
  String get importClientIdHint => 'الصق Spotify Client ID هنا...';

  @override
  String get importConnectButton => 'اتصال وتحميل المكتبة';

  @override
  String get downloadingNoActive => 'لا يوجد تحميلات نشطة';

  @override
  String downloadingMb(String value) {
    return '$value ميغابايت';
  }

  @override
  String get downloadsPlaylistName => 'التنزيلات';

  @override
  String downloadsStats(String count, String size) {
    return '$count أغنية • $size';
  }

  @override
  String get downloadsNoOffline => 'لا توجد أغاني محفوظة';

  @override
  String get downloadsNoOfflineDesc => 'ستظهر الأغاني المحملة هنا';

  @override
  String get downloadsClearAllTitle => 'مسح الكل؟';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'سيؤدي هذا إلى حذف $count أغنية وتحرير $size من مساحة التخزين.';
  }

  @override
  String get downloadsCancel => 'إلغاء';

  @override
  String get downloadsClearAll => 'مسح الكل';

  @override
  String downloadsSongsCount(String count) {
    return '$count أغنية';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count أغنية';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'لا يمكن إعادة تسمية قائمة التنزيلات الرئيسية.';

  @override
  String get downloadsRename => 'إعادة تسمية';

  @override
  String get downloadsEditSongs => 'تعديل الأغاني';

  @override
  String get downloadsDelete => 'حذف';

  @override
  String get downloadsRenamePlaylistTitle => 'إعادة تسمية القائمة';

  @override
  String get downloadsRenamePlaylistDesc => 'أدخل اسماً جديداً للقائمة.';

  @override
  String get downloadsDeletePlaylistTitle => 'حذف القائمة؟';

  @override
  String get downloadsDeleteMasterDesc =>
      'هل أنت متأكد؟ ستفقد كافة الأغاني والقوائم المحملة نهائياً.';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'هل أنت متأكد من حذف \'$name\'؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get downloadsSave => 'حفظ';

  @override
  String get downloadsNoSongs => 'هذه القائمة لا تحتوي على أغاني.';

  @override
  String get libraryTitle => 'المكتبة';

  @override
  String get libraryPauseAll => 'إيقاف الكل';

  @override
  String get libraryResumeAll => 'استئناف الكل';

  @override
  String get libraryTabPlaylists => 'قوائم التشغيل';

  @override
  String get libraryTabDownloads => 'التنزيلات';

  @override
  String get libraryTabDownloading => 'جاري التحميل';

  @override
  String libraryImportedTask(String name) {
    return 'تم استيراد $name';
  }

  @override
  String get libraryImportWaiting => 'في الانتظار...';

  @override
  String get libraryImportFetching => 'جاري جلب القائمة...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return 'تمت معالجة $processed/$total · $matched متطابقة';
  }

  @override
  String get libraryImportSaving => 'يتم الحفظ في المكتبة...';

  @override
  String libraryImportDoneSongs(String matched) {
    return 'أضيفت $matched أغنية · انقر × للإغلاق';
  }

  @override
  String get libraryImportDoneAll => 'أضيفت كل الأغاني · انقر × للإغلاق';

  @override
  String get libraryAddButton => 'إضافة';

  @override
  String get librarySortRecent => 'أضيفت مؤخراً';

  @override
  String get librarySortAlpha => 'أبجدياً';

  @override
  String get libraryEmptyTitle => 'مكتبتك فارغة.';

  @override
  String get libraryEmptyDesc => 'انقر على \'إضافة\' لإنشاء نبضك الأول.';

  @override
  String get libraryRenameLikedError => 'لا يمكن إعادة تسمية الأغاني المفضلة.';

  @override
  String get libraryRename => 'إعادة التسمية';

  @override
  String get libraryEditSongs => 'تعديل الأغاني';

  @override
  String get libraryDeleteLikedError => 'لا يمكن حذف الأغاني المفضلة.';

  @override
  String get libraryDelete => 'حذف';

  @override
  String get libraryEditSongsTitle => 'تعديل الأغاني';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count أغنية';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count أغنية';
  }

  @override
  String get libraryCancel => 'إلغاء';

  @override
  String get librarySave => 'حفظ';

  @override
  String get libraryNoSongs => 'هذه القائمة لا تحتوي على أغاني.';

  @override
  String get libraryAddOptionsTitle => 'أضف إلى المكتبة';

  @override
  String get libraryAddOptionsDesc =>
      'اختر كيف تريد توسيع مكتبة Pulse الخاصة بك';

  @override
  String get libraryImportPulse => 'استيراد من Pulse';

  @override
  String get libraryImportPulseDesc => 'الصق رابط قائمة تشغيل Pulse';

  @override
  String get libraryImportYtm => 'استيراد من YT Music';

  @override
  String get libraryImportYtmDesc => 'الصق رابطاً عاماً';

  @override
  String get libraryImportSpotify => 'استيراد من Spotify';

  @override
  String get libraryImportSpotifyDesc => 'قم بربط حساب Spotify الخاص بك';

  @override
  String get libraryClose => 'إغلاق';

  @override
  String get libraryImportYtmFull => 'استيراد من YouTube Music';

  @override
  String get libraryImportSpotifyFull => 'استيراد من Spotify (≤100 أغنية)';

  @override
  String get libraryImportYtmUrlDesc =>
      'الصق الرابط العام لقائمة التشغيل أو الألبوم من YouTube Music هنا';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'الصق الرابط العام لقائمة التشغيل من Spotify هنا';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'فشل في استيراد قائمة تشغيل Pulse';

  @override
  String get importErrorPlaylist => 'خطأ في استيراد القائمة';

  @override
  String get importErrorHighlyPopulated =>
      'القائمة كبيرة الحجم وقد تستغرق بعض الوقت.';

  @override
  String get libraryImportBtn => 'استيراد';

  @override
  String get libraryCreateTitle => 'قائمة جديدة';

  @override
  String get libraryCreateDesc => 'ماذا سيكون اسم قائمتك الجديدة؟';

  @override
  String get libraryCreateHint => 'مثال: موسيقى الطريق';

  @override
  String get libraryCreateBtn => 'إنشاء';

  @override
  String get libraryRenameTitle => 'إعادة التسمية';

  @override
  String get libraryRenameDesc => 'أدخل اسماً جديداً للقائمة.';

  @override
  String get libraryRenameBtn => 'إعادة التسمية';

  @override
  String get libraryDeleteTitle => 'حذف القائمة؟';

  @override
  String libraryDeleteDesc(String name) {
    return 'هل أنت متأكد من حذف \'$name\'؟ هذا الإجراء نهائي.';
  }

  @override
  String get libraryDeleteBtn => 'حذف';

  @override
  String get librarySortLabelAlpha => 'أ-ي';

  @override
  String get librarySortLabelRecent => 'الأخيرة';

  @override
  String librarySongsCount(String count) {
    return '$count أغنية';
  }

  @override
  String get libraryComingSoon => 'قريباً';

  @override
  String get loginErrName => 'يرجى كتابة اسمك';

  @override
  String get loginErrEmail => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get loginErrPassword => 'يرجى إدخال كلمة المرور';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'اشعر بكل نبضة!';

  @override
  String get loginMadeWithHeartBy => 'صُنع بـ ❤️ بواسطة: ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'اسمك';

  @override
  String get loginHintEmail => 'عنوان البريد الإلكتروني';

  @override
  String get loginHintPassword => 'كلمة المرور';

  @override
  String get loginErrEmailReset => 'يرجى إدخال بريد للاستعادة';

  @override
  String get loginResetSent => 'تم الإرسال! تفقد صندوق الوارد.';

  @override
  String get loginForgotPwd => 'نسيت كلمة المرور؟';

  @override
  String get loginBtnSignup => 'إنشاء حساب';

  @override
  String get loginBtnSignin => 'تسجيل الدخول';

  @override
  String get loginToggleHaveAccount => 'هل لديك حساب؟ ';

  @override
  String get loginToggleNoAccount => 'ليس لديك حساب؟ ';

  @override
  String get loginToggleSignin => 'تسجيل الدخول';

  @override
  String get loginToggleSignup => 'إنشاء حساب';

  @override
  String get offlineStillOffline => 'لا تزال غير متصل. يرجى التحقق من الشبكة.';

  @override
  String get offlineTitle => 'أنت غير متصل';

  @override
  String get offlineSubtitle =>
      'لا يوجد اتصال بالإنترنت.\nتأكد من الشبكة وحاول مرة أخرى.';

  @override
  String get offlineChecking => 'يتم التحقق...';

  @override
  String get offlineRetry => 'إعادة المحاولة';

  @override
  String get offlineGoToDownloads => 'اذهب للتنزيلات';

  @override
  String get playerMadeWithHeartBy => 'صُنع بـ ❤️ بواسطة: ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'اسحب للكلمات';

  @override
  String get playerNoLyrics => 'لا توجد كلمات متاحة';

  @override
  String get playerUpNext => 'التالي';

  @override
  String get playerNoTracksInQueue => 'لا توجد مسارات في قائمة الانتظار';

  @override
  String get playerNoMusicPlaying => 'لا توجد موسيقى قيد التشغيل';

  @override
  String get playerPickAVibe => 'اختر أغنية من المكتبة';

  @override
  String get playerGoHome => 'اذهب للرئيسية';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'المُعادل (Equalizer)';

  @override
  String get playerEqCustom => 'مخصص';

  @override
  String get playlistDownloads => 'التنزيلات';

  @override
  String get playlistOffline => 'قائمة المحفوظات';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hoursس $minsد';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$minsد';
  }

  @override
  String get playlistFindOnPage => 'بحث في الصفحة';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count أغنية • $duration';
  }

  @override
  String get playlistSortAlpha => 'أ-ي';

  @override
  String get playlistSortRecent => 'الأخيرة';

  @override
  String get playlistNoMatches => 'لا توجد نتائج مطابقة.';

  @override
  String get playlistNoTracks => 'لا توجد مسارات هنا.';

  @override
  String get playlistNoSongsYet => 'لا توجد أغاني بعد.';

  @override
  String get playlistSortRecentlyAdded => 'أضيفت مؤخراً';

  @override
  String get playlistSortAlphabetical => 'أبجدياً';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أغنية',
      one: 'أغنية',
    );
    return 'جاري تنزيل $count $_temp0';
  }

  @override
  String get playlistView => 'عرض';

  @override
  String get playlistAllDownloaded => 'تم التنزيل بالكامل';

  @override
  String playlistShareText(String name, String url) {
    return 'استمع لـ \'$name\' على Pulse!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'إزالة من التنزيلات';

  @override
  String get playlistRemoveFromPlaylist => 'إزالة من القائمة';

  @override
  String get playlistLoadError => 'تعذر التحميل.';

  @override
  String get playlistGoBack => '← رجوع';

  @override
  String get profileNotLoggedIn => 'لم تقم بتسجيل الدخول';

  @override
  String get profileSignIn => 'تسجيل الدخول';

  @override
  String get profileDefaultUser => 'مستخدم Pulse';

  @override
  String get profileEditProfile => 'تعديل الملف';

  @override
  String get profileTimeframeDay => 'يوم';

  @override
  String get profileTimeframeWeek => 'أسبوع';

  @override
  String get profileTimeframeMonth => 'شهر';

  @override
  String get profileTimeframeYear => 'سنة';

  @override
  String get profileListeningTime => 'وقت الاستماع';

  @override
  String get profileToday => 'اليوم';

  @override
  String get profileThisWeek => 'هذا الأسبوع';

  @override
  String get profileThisMonth => 'هذا الشهر';

  @override
  String get profileThisYear => 'هذا العام';

  @override
  String get profileDailyAvg => 'المتوسط اليومي';

  @override
  String get profilePerDay => '/يوم';

  @override
  String get profileLifetimeListening => 'الإجمالي';

  @override
  String get profileTotalTimeListened => 'إجمالي الاستماع على Pulse';

  @override
  String get profileYourTopSongs => 'أكثر الأغاني استماعاً';

  @override
  String get profileListeningHistoryEmpty => 'سيظهر سجل استماعك هنا.';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تشغيل',
      one: 'تشغيل',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => 'أكثر الفنانين استماعاً';

  @override
  String get profileTopArtistsEmpty => 'سيظهر فنانوك المفضلون هنا.';

  @override
  String get profileArtistLabel => 'فنان';

  @override
  String get profileSignOut => 'تسجيل الخروج';

  @override
  String profileVersion(String version) {
    return 'الإصدار $version';
  }

  @override
  String get profileMadeWithHeartBy => 'صُنع بـ ❤️ بواسطة: ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'تعديل الملف الشخصي';

  @override
  String get profileDisplayName => 'الاسم الظاهر';

  @override
  String get profileCancel => 'إلغاء';

  @override
  String get profileSave => 'حفظ';

  @override
  String get profileChooseAvatar => 'اختر صورة';

  @override
  String get searchMicPermissionRequired => 'إذن الميكروفون مطلوب';

  @override
  String get searchUnknownSong => 'أغنية غير معروفة';

  @override
  String get searchUnknownArtist => 'فنان غير معروف';

  @override
  String get searchNoSongDetected => 'لم يتم التعرف على أي أغنية.';

  @override
  String searchError(String message) {
    return 'خطأ: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'البحث الصوتي غير متاح';

  @override
  String get searchHint => 'أغنية، فنان، ألبوم...';

  @override
  String get searchRecentEmpty => 'ستظهر عمليات البحث الأخيرة هنا';

  @override
  String get searchRecentSearches => 'عمليات البحث الأخيرة';

  @override
  String get searchClearAll => 'مسح الكل';

  @override
  String searchNoResultsFor(String query) {
    return 'لا توجد نتائج لـ \'$query\'';
  }

  @override
  String get searchTryDifferentKeywords => 'حاول استخدام كلمات مفتاحية مختلفة';

  @override
  String get searchTopResult => 'أفضل نتيجة';

  @override
  String get searchSongsLabel => 'الأغاني';

  @override
  String get searchArtistsLabel => 'الفنانون';

  @override
  String get searchAlbumsLabel => 'الألبومات';

  @override
  String get searchPlaylistsLabel => 'قوائم التشغيل';

  @override
  String get searchArtistLabel => 'فنان';

  @override
  String get searchListening => 'يستمع...';

  @override
  String get searchSpeakNow => 'تحدث الآن';

  @override
  String get searchCancel => 'إلغاء';

  @override
  String get searchIdentifying => 'يتم التعرف...';

  @override
  String get searchListeningForSong => 'نستمع للأغنية...';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsStreamingQuality => 'جودة البث';

  @override
  String get settingsQualityAutomatic => 'تلقائي';

  @override
  String get settingsQualityLow => 'منخفضة';

  @override
  String get settingsQualityNormal => 'عادية';

  @override
  String get settingsQualityHigh => 'عالية';

  @override
  String get settingsDownloadQuality => 'جودة التنزيل';

  @override
  String get settingsPlayback => 'التشغيل';

  @override
  String get settingsCrossfade => 'التلاشي المتقاطع';

  @override
  String get settingsCrossfadeDesc => 'مزج الأغاني ببعضها';

  @override
  String get settingsDataUsage => 'استخدام البيانات';

  @override
  String get settingsDataSaver => 'موفر البيانات';

  @override
  String get settingsDataSaverDesc => 'بث بجودة منخفضة على الشبكات الخلوية';

  @override
  String get settingsAppearance => 'المظهر';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsCustomAccent => 'لون مميز';

  @override
  String get settingsSaturation => 'التشبع';

  @override
  String get settingsBrightness => 'السطوع';

  @override
  String get settingsResetDefault => 'استعادة الافتراضي';

  @override
  String get playlistSheetTitle => 'إضافة إلى القائمة';

  @override
  String get playlistSheetNewPlaylist => 'قائمة جديدة';

  @override
  String get playlistSheetNoPlaylists => 'لا توجد قوائم';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أغنية',
      one: 'أغنية',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => 'اسم القائمة';

  @override
  String get playlistSheetCancel => 'إلغاء';

  @override
  String playlistSheetAddedTo(String name) {
    return 'أضيفت إلى $name';
  }

  @override
  String get playlistSheetCreateFailAuth => 'فشل الإنشاء: خطأ في المصادقة';

  @override
  String playlistSheetCreateFail(String error) {
    return 'فشل الإنشاء: $error';
  }

  @override
  String get playlistSheetCreate => 'إنشاء';

  @override
  String get appUpdateAvailable => 'تحديث متوفر';

  @override
  String appUpdateDesc(String version) {
    return 'الإصدار $version متوفر الآن! قم بالتحديث.';
  }

  @override
  String get appUpdateDownload => 'تنزيل التحديث';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navLibrary => 'المكتبة';

  @override
  String get navSearch => 'بحث';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get navProfile => 'الملف';

  @override
  String get artistSelect => 'اختر الفنان';

  @override
  String get songActionQueue => 'أضف لقائمة الانتظار';

  @override
  String get songActionPlaylist => 'أضف لقائمة تشغيل';

  @override
  String get songActionFinding => 'جاري البحث...';

  @override
  String get songActionAlbum => 'الذهاب للألبوم';

  @override
  String get songActionArtist => 'الذهاب للفنان';

  @override
  String get songActionRemovePlaylist => 'إزالة من القائمة';

  @override
  String get songActionRemoveDownload => 'إزالة من التنزيلات';

  @override
  String get songActionDownloadChecking => 'جاري التحقق...';

  @override
  String get songActionDownloading => 'جاري التنزيل...';

  @override
  String get songActionDownloaded => 'تم التنزيل!';

  @override
  String get songActionDownloadAlready => 'تم تنزيلها مسبقاً';

  @override
  String get songActionDownloadFailed => 'فشل التنزيل';

  @override
  String get songActionDownload => 'تنزيل';

  @override
  String get songActionDownloadingSnack => 'جاري التنزيل';

  @override
  String get songActionView => 'عرض';

  @override
  String get spotifyImportTitle => 'استيراد من Spotify';

  @override
  String get spotifyImportSubtitle => 'اختر حجم القائمة';

  @override
  String get spotifyChoiceSmallTitle => '100 أغنية أو أقل';

  @override
  String get spotifyChoiceSmallDesc => 'الصق الرابط العام لقائمة التشغيل.';

  @override
  String get spotifyChoiceLargeTitle => 'أكثر من 100 أغنية';

  @override
  String get spotifyChoiceLargeDesc => 'اربط حساب مطور Spotify الخاص بك.';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get spotifyPlaylistsTitle => 'قوائم Spotify';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'خطأ: $error\nتحقق من Client ID.';
  }

  @override
  String get spotifyPlaylistsEmpty => 'لا توجد قوائم في مكتبتك';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count مسار';
  }

  @override
  String get spotifyPlaylistsImport => 'استيراد';

  @override
  String get audioPlaybackFailed => 'فشل التشغيل.';

  @override
  String get audioControlPrevious => 'السابق';

  @override
  String get audioControlPause => 'إيقاف مؤقت';

  @override
  String get audioControlPlay => 'تشغيل';

  @override
  String get audioControlNext => 'التالي';

  @override
  String get audioControlUnlike => 'إلغاء الإعجاب';

  @override
  String get audioControlLike => 'إعجاب';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'استجابة خام: $data\n\nخطأ: $error';
  }

  @override
  String get apiErrorInvalidClient => 'معرف العميل (Client ID) غير صالح.';

  @override
  String get apiErrorBadRequest => 'طلب سيء. يرجى التحقق من بياناتك.';

  @override
  String get apiErrorUnauthorized => 'غير مصرح لك. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get apiErrorForbidden => 'ممنوع. لا تملك صلاحية الوصول.';

  @override
  String get apiErrorNotFound => 'المورد المطلوب غير موجود.';

  @override
  String get apiErrorEmailInUse => 'البريد الإلكتروني هذا مستخدم مسبقاً.';

  @override
  String get apiErrorUserNotFound => 'لا يوجد حساب بهذا البريد الإلكتروني.';

  @override
  String get apiErrorWrongPassword => 'كلمة المرور غير صحيحة.';

  @override
  String get apiErrorInvalidCredential =>
      'فشل تسجيل الدخول. يرجى التحقق من بياناتك.';

  @override
  String get apiErrorNetwork =>
      'خطأ في الشبكة. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get apiErrorSocketTimeout =>
      'انتهت مهلة الاتصال. يرجى المحاولة لاحقاً.';

  @override
  String get apiErrorTooManyRequests =>
      'طلبات كثيرة جداً. يرجى المحاولة لاحقاً.';

  @override
  String get apiErrorServerError => 'حدث خطأ في الخادم. يرجى المحاولة لاحقاً.';

  @override
  String get apiErrorInvalidEmail => 'يرجى تقديم عنوان بريد إلكتروني صالح.';

  @override
  String get apiErrorWeakPassword =>
      'كلمة المرور ضعيفة جداً. استخدم 6 أحرف على الأقل.';

  @override
  String get apiErrorTooManyAttempts =>
      'محاولات فشل كثيرة. يرجى المحاولة لاحقاً.';

  @override
  String get homeForgottenFavorites => 'المفضلة المنسية';

  @override
  String get artistShowAll => 'عرض الكل';

  @override
  String get homeTopTracks => 'أفضل المقاطع';
}
