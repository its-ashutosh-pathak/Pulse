// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'Giới thiệu';

  @override
  String get artistPopular => 'Phổ biến';

  @override
  String get artistAlbums => 'Album';

  @override
  String get artistSinglesAndEPs => 'Đĩa đơn & EP';

  @override
  String artistSubscribersCount(String count) {
    return '$count người đăng ký';
  }

  @override
  String get artistPlayAll => 'Phát tất cả';

  @override
  String get artistLoadError => 'Không thể tải nghệ sĩ';

  @override
  String get artistGoBack => 'Quay lại';

  @override
  String adminChatFailedToReply(String error) {
    return 'Không thể trả lời: $error';
  }

  @override
  String get adminChatSupportChat => 'Trò chuyện Hỗ trợ';

  @override
  String adminChatError(String error) {
    return 'Lỗi: $error';
  }

  @override
  String get adminChatNoHistory => 'Không có lịch sử trò chuyện.';

  @override
  String get adminChatSupportYou => 'Hỗ trợ (Bạn)';

  @override
  String get adminChatTypeReply => 'Nhập câu trả lời của bạn...';

  @override
  String get broadcastSuccess => 'Thông báo đã được phát thành công!';

  @override
  String broadcastFailed(String error) {
    return 'Không thể phát: $error';
  }

  @override
  String get broadcastTitle => 'Thông báo Chung';

  @override
  String get broadcastSubtitle => 'Gửi cho tất cả người dùng';

  @override
  String get broadcastWarning =>
      'Tin nhắn gửi ở đây sẽ hiển thị với mọi người.';

  @override
  String broadcastError(String error) {
    return 'Lỗi: $error';
  }

  @override
  String get broadcastNoHistory => 'Không có thông báo nào trước đó.';

  @override
  String get broadcastTypeMessage => 'Nhập thông báo chung...';

  @override
  String commFailedToSend(String error) {
    return 'Không thể gửi: $error';
  }

  @override
  String get commAdminDashboard => 'Bảng điều khiển Quản trị';

  @override
  String get commAdminSupport => 'Hỗ trợ Quản trị';

  @override
  String get commAlwaysHere => 'Luôn sẵn sàng giúp đỡ';

  @override
  String get commWelcomeTitle => 'Chào bạn! 👋 Tôi là Ashutosh Pathak';

  @override
  String get commWelcomeSubtitle => 'Nhà phát triển của Pulse';

  @override
  String get commWelcomeBody1 =>
      'Hy vọng bạn đang tận hưởng việc nghe những bản nhạc yêu thích mà không bị quảng cáo phiền nhiễu hay rào cản đăng ký. Dù sao thì âm nhạc cũng không nên bị chặn lại sau một bức tường phí chỉ vì ai đó trong phòng họp cần thêm một chiếc du thuyền.\n\nPhần này ở đây để chúng ta có thể kết nối trực tiếp.\n\nHãy thoải mái:';

  @override
  String get commBullet1 => 'Chia sẻ phản hồi của bạn';

  @override
  String get commBullet2 => 'Báo cáo lỗi';

  @override
  String get commBullet3 => 'Đề xuất các tính năng mới mà bạn muốn thấy';

  @override
  String get commWelcomeBody2 =>
      'Tôi đích thân đọc mọi tin nhắn và sẽ cố gắng hết sức để cải thiện ứng dụng dựa trên các đề xuất của bạn.\n\nCó ý tưởng về một ứng dụng chưa tồn tại hoặc một ứng dụng bị khóa đằng sau các gói đăng ký đắt tiền? Hãy cho tôi biết! Nếu có thể, tôi sẽ cố gắng xây dựng nó và cung cấp miễn phí cho mọi người.\n\nCảm ơn bạn đã sử dụng ứng dụng của tôi và đồng hành cùng tôi trên hành trình này. ❤️';

  @override
  String commError(String error) {
    return 'Lỗi: $error';
  }

  @override
  String get commNoMessages => 'Chưa có tin nhắn nào';

  @override
  String get commNoMessagesDesc =>
      'Gửi tin nhắn cho nhóm hỗ trợ của chúng tôi hoặc kiểm tra lại sau để xem các thông báo.';

  @override
  String get commMessageSupportHint => 'Nhắn tin cho bộ phận hỗ trợ...';

  @override
  String get commGlobalAnnouncements => 'Thông báo Chung';

  @override
  String get commSendMessagesToAll => 'Gửi tin nhắn cho tất cả người dùng';

  @override
  String get homeGreetingMorning => 'Chào buổi sáng,';

  @override
  String get homeGreetingAfternoon => 'Chào buổi chiều,';

  @override
  String get homeGreetingEvening => 'Chào buổi tối,';

  @override
  String get homeMember => 'Thành viên';

  @override
  String get homeRecentPlaylists => 'Danh sách phát gần đây';

  @override
  String get homeRecentlyPlayed => 'Đã phát gần đây';

  @override
  String get homeSpeedDial => 'Truy cập nhanh';

  @override
  String get homeNoContent => 'Không có nội dung nào';

  @override
  String get homeRefresh => 'Làm mới';

  @override
  String get homeLoadError => 'Không thể tải luồng nhạc.';

  @override
  String get homeRetry => 'Thử lại';

  @override
  String get importSuccess => 'Đã kết nối thành công với Spotify!';

  @override
  String importFailed(String error) {
    return 'Không thể kết nối: $error';
  }

  @override
  String get importTitle => 'Kết nối Spotify';

  @override
  String get importSetupTitle => 'Thiết lập Tích hợp Spotify';

  @override
  String get importSetupDesc =>
      'Để vượt qua các giới hạn tỷ lệ nghiêm ngặt của Spotify và nhập tất cả danh sách phát của bạn ngay lập tức, bạn phải sử dụng khóa nhà phát triển miễn phí của riêng mình. Làm theo các bước đơn giản sau:';

  @override
  String get importStep1 =>
      'Mở Bảng điều khiển dành cho nhà phát triển của Spotify.';

  @override
  String get importStep2 => 'Đăng nhập và nhấp vào \"Create app\".';

  @override
  String get importStep3 => 'Điền vào Tên và Mô tả ứng dụng bất kỳ.';

  @override
  String get importStep4 => 'Trong \"Redirect URIs\", dán chính xác URL sau:';

  @override
  String get importRedirectCopied => 'Đã sao chép URI chuyển hướng!';

  @override
  String get importStep5 =>
      'Lưu ứng dụng, sao chép \"Client ID\" của bạn từ cài đặt và dán nó vào bên dưới.';

  @override
  String get importImportant =>
      'Quan trọng: Tài khoản Spotify được sử dụng để tạo ứng dụng dành cho nhà phát triển này phải có đăng ký Premium đang hoạt động.';

  @override
  String get importClientIdHint => 'Dán Client ID Spotify của bạn vào đây...';

  @override
  String get importConnectButton => 'Kết nối & Tải Thư viện';

  @override
  String get downloadingNoActive => 'Không có bản tải xuống nào';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'Tải xuống';

  @override
  String downloadsStats(String count, String size) {
    return '$count bài hát • $size';
  }

  @override
  String get downloadsNoOffline => 'Chưa có bài hát ngoại tuyến nào';

  @override
  String get downloadsNoOfflineDesc =>
      'Các bài hát bạn tải xuống sẽ xuất hiện ở đây';

  @override
  String get downloadsClearAllTitle => 'Xóa tất cả các bản tải xuống?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'Thao tác này sẽ xóa $count bài hát và giải phóng $size bộ nhớ.';
  }

  @override
  String get downloadsCancel => 'Hủy';

  @override
  String get downloadsClearAll => 'Xóa tất cả';

  @override
  String downloadsSongsCount(String count) {
    return '$count bài hát';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count bài hát';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'Không thể đổi tên danh sách phát tải xuống chính.';

  @override
  String get downloadsRename => 'Đổi tên';

  @override
  String get downloadsEditSongs => 'Chỉnh sửa bài hát';

  @override
  String get downloadsDelete => 'Xóa';

  @override
  String get downloadsRenamePlaylistTitle => 'Đổi tên danh sách phát';

  @override
  String get downloadsRenamePlaylistDesc =>
      'Nhập tên mới cho danh sách phát của bạn.';

  @override
  String get downloadsDeletePlaylistTitle => 'Xóa danh sách phát?';

  @override
  String get downloadsDeleteMasterDesc =>
      'Bạn có chắc chắn muốn xóa không? Bạn sẽ mất vĩnh viễn tất cả các bài hát và danh sách phát đã tải xuống.';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'Bạn có chắc chắn muốn xóa \"$name\"? Danh sách phát này sẽ bị mất vĩnh viễn.';
  }

  @override
  String get downloadsSave => 'Lưu';

  @override
  String get downloadsNoSongs =>
      'Không có bài hát nào trong danh sách phát này.';

  @override
  String get libraryTitle => 'Thư viện';

  @override
  String get libraryPauseAll => 'Tạm dừng tất cả';

  @override
  String get libraryResumeAll => 'Tiếp tục tất cả';

  @override
  String get libraryTabPlaylists => 'Danh sách phát';

  @override
  String get libraryTabDownloads => 'Tải xuống';

  @override
  String get libraryTabDownloading => 'Đang tải xuống';

  @override
  String libraryImportedTask(String name) {
    return 'Đã nhập $name';
  }

  @override
  String get libraryImportWaiting => 'Đang chờ trong hàng đợi...';

  @override
  String get libraryImportFetching => 'Đang lấy danh sách phát...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return 'Đã xử lý $processed/$total · $matched trùng khớp';
  }

  @override
  String get libraryImportSaving => 'Đang lưu vào thư viện...';

  @override
  String libraryImportDoneSongs(String matched) {
    return 'Đã thêm $matched bài hát · chạm vào × để đóng';
  }

  @override
  String get libraryImportDoneAll =>
      'Đã thêm tất cả bài hát · chạm vào × để đóng';

  @override
  String get libraryAddButton => 'Thêm';

  @override
  String get librarySortRecent => 'Đã thêm gần đây';

  @override
  String get librarySortAlpha => 'Theo bảng chữ cái';

  @override
  String get libraryEmptyTitle => 'Thư viện của bạn đang trống.';

  @override
  String get libraryEmptyDesc =>
      'Nhấn \"Thêm\" để bắt đầu Pulse đầu tiên của bạn.';

  @override
  String get libraryRenameLikedError =>
      'Không thể đổi tên danh sách Bài hát yêu thích.';

  @override
  String get libraryRename => 'Đổi tên';

  @override
  String get libraryEditSongs => 'Chỉnh sửa bài hát';

  @override
  String get libraryDeleteLikedError =>
      'Không thể xóa danh sách Bài hát yêu thích.';

  @override
  String get libraryDelete => 'Xóa';

  @override
  String get libraryEditSongsTitle => 'Chỉnh sửa bài hát';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count bài hát';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count bài hát';
  }

  @override
  String get libraryCancel => 'Hủy';

  @override
  String get librarySave => 'Lưu';

  @override
  String get libraryNoSongs => 'Không có bài hát nào trong danh sách phát này.';

  @override
  String get libraryAddOptionsTitle => 'Thêm vào Thư viện';

  @override
  String get libraryAddOptionsDesc =>
      'Chọn cách bạn muốn mở rộng Pulse của mình';

  @override
  String get libraryImportPulse => 'Nhập từ Pulse';

  @override
  String get libraryImportPulseDesc => 'Dán URL danh sách phát Pulse';

  @override
  String get libraryImportYtm => 'Nhập từ YT Music';

  @override
  String get libraryImportYtmDesc => 'Dán URL danh sách phát CÔNG KHAI';

  @override
  String get libraryImportSpotify => 'Nhập từ Spotify';

  @override
  String get libraryImportSpotifyDesc => 'Kết nối Spotify của bạn';

  @override
  String get libraryClose => 'Đóng';

  @override
  String get libraryImportYtmFull => 'Nhập từ YouTube Music';

  @override
  String get libraryImportSpotifyFull => 'Nhập từ Spotify (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'Dán URL album hoặc danh sách phát YouTube Music công khai';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'Dán URL danh sách phát Spotify công khai vào bên dưới';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Không thể nhập danh sách phát Pulse';

  @override
  String get importErrorPlaylist => 'Lỗi khi nhập danh sách phát';

  @override
  String get importErrorHighlyPopulated =>
      'Danh sách phát có quá nhiều bài, có thể mất một lúc để tải.';

  @override
  String get libraryImportBtn => 'Nhập';

  @override
  String get libraryCreateTitle => 'Danh sách phát mới';

  @override
  String get libraryCreateDesc =>
      'Chúng ta nên gọi danh sách phát mới của bạn là gì?';

  @override
  String get libraryCreateHint => 'vd: Chuyến đi Đêm';

  @override
  String get libraryCreateBtn => 'Tạo';

  @override
  String get libraryRenameTitle => 'Đổi tên danh sách phát';

  @override
  String get libraryRenameDesc => 'Nhập tên mới cho danh sách phát của bạn.';

  @override
  String get libraryRenameBtn => 'Đổi tên';

  @override
  String get libraryDeleteTitle => 'Xóa danh sách phát?';

  @override
  String libraryDeleteDesc(String name) {
    return 'Bạn có chắc chắn muốn xóa \"$name\"? Danh sách phát này sẽ bị mất vĩnh viễn.';
  }

  @override
  String get libraryDeleteBtn => 'Xóa';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'Gần đây';

  @override
  String librarySongsCount(String count) {
    return '$count Bài hát';
  }

  @override
  String get libraryComingSoon => 'Sắp ra mắt';

  @override
  String get loginErrName => 'Vui lòng nhập tên của bạn';

  @override
  String get loginErrEmail => 'Vui lòng nhập địa chỉ email của bạn';

  @override
  String get loginErrPassword => 'Vui lòng nhập mật khẩu của bạn';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'Cảm nhận từng nhịp điệu!';

  @override
  String get loginMadeWithHeartBy => 'Được tạo với ❤️ bởi ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'Tên của bạn';

  @override
  String get loginHintEmail => 'Địa chỉ email';

  @override
  String get loginHintPassword => 'Mật khẩu';

  @override
  String get loginErrEmailReset =>
      'Vui lòng nhập email của bạn để đặt lại mật khẩu';

  @override
  String get loginResetSent =>
      'Email đặt lại mật khẩu đã được gửi! Kiểm tra hộp thư đến của bạn.';

  @override
  String get loginForgotPwd => 'Quên mật khẩu?';

  @override
  String get loginBtnSignup => 'Tạo tài khoản';

  @override
  String get loginBtnSignin => 'Đăng nhập';

  @override
  String get loginToggleHaveAccount => 'Đã có tài khoản Pulse? ';

  @override
  String get loginToggleNoAccount => 'Chưa có tài khoản Pulse? ';

  @override
  String get loginToggleSignin => 'Đăng nhập';

  @override
  String get loginToggleSignup => 'Đăng ký';

  @override
  String get offlineStillOffline =>
      'Vẫn ngoại tuyến. Vui lòng kiểm tra kết nối của bạn.';

  @override
  String get offlineTitle => 'Bạn đang ngoại tuyến';

  @override
  String get offlineSubtitle =>
      'Không tìm thấy kết nối internet.\nKiểm tra mạng của bạn và thử lại.';

  @override
  String get offlineChecking => 'Đang kiểm tra...';

  @override
  String get offlineRetry => 'Thử lại';

  @override
  String get offlineGoToDownloads => 'Đi tới Tải xuống';

  @override
  String get playerMadeWithHeartBy => 'Được tạo với ❤️ bởi ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'Vuốt để xem lời bài hát';

  @override
  String get playerNoLyrics => 'Không có lời bài hát';

  @override
  String get playerUpNext => 'Tiếp theo';

  @override
  String get playerNoTracksInQueue => 'Không có bài hát nào trong hàng đợi';

  @override
  String get playerNoMusicPlaying => 'Không có nhạc nào đang phát';

  @override
  String get playerPickAVibe =>
      'Chọn một giai điệu từ thư viện hoặc trang chủ của bạn';

  @override
  String get playerGoHome => 'Về trang chủ';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'Bộ chỉnh âm';

  @override
  String get playerEqCustom => 'Tùy chỉnh';

  @override
  String get playlistDownloads => 'Tải xuống';

  @override
  String get playlistOffline => 'Danh sách phát Ngoại tuyến';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '${hours}g ${mins}p';
  }

  @override
  String playlistDurationMins(String mins) {
    return '${mins}p';
  }

  @override
  String get playlistFindOnPage => 'Tìm trên trang này';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count bài hát • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'Gần đây';

  @override
  String get playlistNoMatches => 'Không tìm thấy kết quả phù hợp.';

  @override
  String get playlistNoTracks =>
      'Không có bài hát nào trong danh sách phát này.';

  @override
  String get playlistNoSongsYet => 'Chưa có bài hát nào.';

  @override
  String get playlistSortRecentlyAdded => 'Đã thêm gần đây';

  @override
  String get playlistSortAlphabetical => 'Theo bảng chữ cái';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bài hát',
      one: 'bài hát',
    );
    return 'Đang tải xuống $count $_temp0';
  }

  @override
  String get playlistView => 'XEM';

  @override
  String get playlistAllDownloaded => 'Tất cả các bài hát đã được tải xuống';

  @override
  String playlistShareText(String name, String url) {
    return 'Hãy xem \"$name\" trên Pulse!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'Xóa khỏi Tải xuống';

  @override
  String get playlistRemoveFromPlaylist => 'Xóa khỏi Danh sách phát';

  @override
  String get playlistLoadError => 'Không thể tải danh sách phát này.';

  @override
  String get playlistGoBack => '← Quay lại';

  @override
  String get profileNotLoggedIn => 'Chưa đăng nhập';

  @override
  String get profileSignIn => 'Đăng nhập';

  @override
  String get profileDefaultUser => 'Người dùng Pulse';

  @override
  String get profileEditProfile => 'Sửa Hồ sơ';

  @override
  String get profileTimeframeDay => 'Ngày';

  @override
  String get profileTimeframeWeek => 'Tuần';

  @override
  String get profileTimeframeMonth => 'Tháng';

  @override
  String get profileTimeframeYear => 'Năm';

  @override
  String get profileListeningTime => 'THỜI GIAN NGHE';

  @override
  String get profileToday => 'Hôm nay';

  @override
  String get profileThisWeek => 'Tuần này';

  @override
  String get profileThisMonth => 'Tháng này';

  @override
  String get profileThisYear => 'Năm nay';

  @override
  String get profileDailyAvg => 'TB MỖI NGÀY';

  @override
  String get profilePerDay => 'Mỗi ngày';

  @override
  String get profileLifetimeListening => 'TỔNG THỜI GIAN NGHE';

  @override
  String get profileTotalTimeListened => 'Tổng thời gian nghe nhạc trên Pulse';

  @override
  String get profileYourTopSongs => 'Bài hát Hàng đầu của bạn';

  @override
  String get profileListeningHistoryEmpty => 'Lịch sử nghe sẽ xuất hiện ở đây.';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'lượt nghe',
      one: 'lượt nghe',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => 'Nghệ sĩ Hàng đầu của bạn';

  @override
  String get profileTopArtistsEmpty =>
      'Các nghệ sĩ yêu thích của bạn sẽ xuất hiện ở đây.';

  @override
  String get profileArtistLabel => 'Nghệ sĩ';

  @override
  String get profileSignOut => 'Đăng xuất';

  @override
  String profileVersion(String version) {
    return 'Phiên bản $version';
  }

  @override
  String get profileMadeWithHeartBy => 'Được tạo với ❤️ bởi ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'CHỈNH SỬA HỒ SƠ';

  @override
  String get profileDisplayName => 'TÊN HIỂN THỊ';

  @override
  String get profileCancel => 'Hủy';

  @override
  String get profileSave => 'Lưu';

  @override
  String get profileChooseAvatar => 'Chọn Ảnh đại diện';

  @override
  String get searchMicPermissionRequired =>
      'Cần quyền truy cập micrô cho tính năng này';

  @override
  String get searchUnknownSong => 'Bài hát không xác định';

  @override
  String get searchUnknownArtist => 'Nghệ sĩ không xác định';

  @override
  String get searchNoSongDetected => 'Không phát hiện thấy bài hát nào.';

  @override
  String searchError(String message) {
    return 'Lỗi: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'Nhận dạng giọng nói không khả dụng';

  @override
  String get searchHint => 'Bài hát, nghệ sĩ, album...';

  @override
  String get searchRecentEmpty =>
      'Các tìm kiếm gần đây của bạn xuất hiện ở đây';

  @override
  String get searchRecentSearches => 'Tìm kiếm Gần đây';

  @override
  String get searchClearAll => 'Xóa tất cả';

  @override
  String searchNoResultsFor(String query) {
    return 'Không có kết quả nào cho \"$query\"';
  }

  @override
  String get searchTryDifferentKeywords => 'Hãy thử các từ khóa khác';

  @override
  String get searchTopResult => 'Kết quả hàng đầu';

  @override
  String get searchSongsLabel => 'Bài hát';

  @override
  String get searchArtistsLabel => 'Nghệ sĩ';

  @override
  String get searchAlbumsLabel => 'Album';

  @override
  String get searchPlaylistsLabel => 'Danh sách phát';

  @override
  String get searchArtistLabel => 'Nghệ sĩ';

  @override
  String get searchListening => 'Đang nghe...';

  @override
  String get searchSpeakNow => 'Nói ngay bây giờ để tìm kiếm';

  @override
  String get searchCancel => 'Hủy';

  @override
  String get searchIdentifying => 'Đang nhận dạng...';

  @override
  String get searchListeningForSong => 'Đang nghe một bài hát...';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsStreamingQuality => 'Chất lượng Phát trực tuyến';

  @override
  String get settingsQualityAutomatic => 'Tự động';

  @override
  String get settingsQualityLow => 'Thấp';

  @override
  String get settingsQualityNormal => 'Bình thường';

  @override
  String get settingsQualityHigh => 'Cao';

  @override
  String get settingsDownloadQuality => 'Chất lượng Tải xuống';

  @override
  String get settingsPlayback => 'Phát lại';

  @override
  String get settingsCrossfade => 'Chuyển bài mượt mà';

  @override
  String get settingsCrossfadeDesc =>
      'Làm mờ dần các bài hát để chuyển tiếp không bị ngắt quãng';

  @override
  String get settingsDataUsage => 'Sử dụng Dữ liệu';

  @override
  String get settingsDataSaver => 'Tiết kiệm Dữ liệu';

  @override
  String get settingsDataSaverDesc =>
      'Phát trực tuyến ở chất lượng thấp hơn trên mạng di động';

  @override
  String get settingsAppearance => 'Giao diện';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get settingsCustomAccent => 'Màu Nổi bật Tùy chỉnh';

  @override
  String get settingsSaturation => 'Độ bão hòa';

  @override
  String get settingsBrightness => 'Độ sáng';

  @override
  String get settingsResetDefault => 'Đặt lại Mặc định';

  @override
  String get playlistSheetTitle => 'Thêm vào Danh sách phát';

  @override
  String get playlistSheetNewPlaylist => 'Danh sách phát mới';

  @override
  String get playlistSheetNoPlaylists => 'Chưa có danh sách phát nào';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bài hát',
      one: 'bài hát',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => 'Tên Danh sách phát';

  @override
  String get playlistSheetCancel => 'Hủy';

  @override
  String playlistSheetAddedTo(String name) {
    return 'Đã thêm vào $name';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'Không thể tạo danh sách phát: Lỗi xác thực';

  @override
  String playlistSheetCreateFail(String error) {
    return 'Không thể tạo danh sách phát: $error';
  }

  @override
  String get playlistSheetCreate => 'Tạo';

  @override
  String get appUpdateAvailable => 'Có bản cập nhật';

  @override
  String appUpdateDesc(String version) {
    return 'Phiên bản $version đã ra mắt! Cập nhật ngay để nhận các tính năng mới nhất.';
  }

  @override
  String get appUpdateDownload => 'Tải xuống Bản cập nhật';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navLibrary => 'Thư viện';

  @override
  String get navSearch => 'Tìm kiếm';

  @override
  String get navSettings => 'Cài đặt';

  @override
  String get navProfile => 'Hồ sơ';

  @override
  String get artistSelect => 'Chọn Nghệ sĩ';

  @override
  String get songActionQueue => 'Thêm vào Hàng đợi';

  @override
  String get songActionPlaylist => 'Thêm vào Danh sách phát';

  @override
  String get songActionFinding => 'Đang tìm...';

  @override
  String get songActionAlbum => 'Đến Album';

  @override
  String get songActionArtist => 'Đến Nghệ sĩ';

  @override
  String get songActionRemovePlaylist => 'Xóa khỏi Danh sách phát';

  @override
  String get songActionRemoveDownload => 'Xóa khỏi Tải xuống';

  @override
  String get songActionDownloadChecking => 'Đang kiểm tra...';

  @override
  String get songActionDownloading => 'Đang tải xuống...';

  @override
  String get songActionDownloaded => 'Đã tải xuống!';

  @override
  String get songActionDownloadAlready => 'Đã tải xuống rồi';

  @override
  String get songActionDownloadFailed => 'Tải xuống không thành công';

  @override
  String get songActionDownload => 'Tải xuống';

  @override
  String get songActionDownloadingSnack => 'Đang tải xuống';

  @override
  String get songActionView => 'XEM';

  @override
  String get spotifyImportTitle => 'Nhập từ Spotify';

  @override
  String get spotifyImportSubtitle => 'Chọn kích thước danh sách phát của bạn';

  @override
  String get spotifyChoiceSmallTitle => '100 bài hát trở xuống';

  @override
  String get spotifyChoiceSmallDesc =>
      'Dán URL danh sách phát Spotify công khai.';

  @override
  String get spotifyChoiceLargeTitle => 'Hơn 100 bài hát';

  @override
  String get spotifyChoiceLargeDesc =>
      'Kết nối Ứng dụng Nhà phát triển Spotify của riêng bạn để nhập các bản nhạc không giới hạn.';

  @override
  String get cancelButton => 'Hủy';

  @override
  String get spotifyPlaylistsTitle => 'Danh sách phát Spotify của bạn';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'Lỗi: $error\nĐảm bảo Client ID của bạn hợp lệ.';
  }

  @override
  String get spotifyPlaylistsEmpty =>
      'Không tìm thấy danh sách phát nào trong thư viện của bạn';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count bài hát';
  }

  @override
  String get spotifyPlaylistsImport => 'Nhập';

  @override
  String get audioPlaybackFailed =>
      'Phát lại không thành công. Kiểm tra kết nối internet của bạn.';

  @override
  String get audioControlPrevious => 'Trước';

  @override
  String get audioControlPause => 'Tạm dừng';

  @override
  String get audioControlPlay => 'Phát';

  @override
  String get audioControlNext => 'Tiếp';

  @override
  String get audioControlUnlike => 'Bỏ thích';

  @override
  String get audioControlLike => 'Thích';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'Phản hồi thô: $data\n\nDự phòng: $error';
  }

  @override
  String get apiErrorInvalidClient => 'Client hoặc client secret không hợp lệ.';

  @override
  String get apiErrorBadRequest =>
      'Yêu cầu không hợp lệ. Vui lòng kiểm tra thông tin của bạn.';

  @override
  String get apiErrorUnauthorized => 'Không được phép. Vui lòng đăng nhập lại.';

  @override
  String get apiErrorForbidden => 'Bị cấm. Bạn không có quyền truy cập.';

  @override
  String get apiErrorNotFound => 'Không tìm thấy tài nguyên.';

  @override
  String get apiErrorEmailInUse => 'Địa chỉ email này đã được sử dụng.';

  @override
  String get apiErrorUserNotFound =>
      'Không tìm thấy tài khoản nào với email này.';

  @override
  String get apiErrorWrongPassword => 'Mật khẩu không chính xác.';

  @override
  String get apiErrorInvalidCredential =>
      'Đăng nhập không thành công. Vui lòng kiểm tra thông tin đăng nhập của bạn.';

  @override
  String get apiErrorNetwork => 'Lỗi mạng. Vui lòng kiểm tra kết nối của bạn.';

  @override
  String get apiErrorSocketTimeout =>
      'Kết nối đã hết thời gian chờ. Vui lòng thử lại.';

  @override
  String get apiErrorTooManyRequests =>
      'Quá nhiều yêu cầu. Vui lòng đợi một lát và thử lại.';

  @override
  String get apiErrorServerError => 'Lỗi máy chủ. Vui lòng thử lại sau.';

  @override
  String get apiErrorInvalidEmail => 'Vui lòng nhập một địa chỉ email hợp lệ.';

  @override
  String get apiErrorWeakPassword =>
      'Mật khẩu quá yếu. Sử dụng ít nhất 6 ký tự.';

  @override
  String get apiErrorTooManyAttempts =>
      'Quá nhiều nỗ lực thất bại. Vui lòng thử lại sau.';

  @override
  String get homeForgottenFavorites => 'Yêu thích bị lãng quên';

  @override
  String get artistShowAll => 'Xem tất cả';

  @override
  String get homeTopTracks => 'Bài hát hàng đầu';
}
