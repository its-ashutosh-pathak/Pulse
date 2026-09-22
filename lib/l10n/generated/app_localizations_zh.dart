// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => '关于';

  @override
  String get artistPopular => '热门';

  @override
  String get artistAlbums => '专辑';

  @override
  String get artistSinglesAndEPs => '单曲和 EP';

  @override
  String artistSubscribersCount(String count) {
    return '$count 位订阅者';
  }

  @override
  String get artistPlayAll => '播放全部';

  @override
  String get artistLoadError => '无法加载歌手';

  @override
  String get artistGoBack => '返回';

  @override
  String adminChatFailedToReply(String error) {
    return '回复失败: $error';
  }

  @override
  String get adminChatSupportChat => '技术支持';

  @override
  String adminChatError(String error) {
    return '错误: $error';
  }

  @override
  String get adminChatNoHistory => '没有消息记录。';

  @override
  String get adminChatSupportYou => '技术支持（您）';

  @override
  String get adminChatTypeReply => '输入回复...';

  @override
  String get broadcastSuccess => '公告发送成功！';

  @override
  String broadcastFailed(String error) {
    return '发送失败: $error';
  }

  @override
  String get broadcastTitle => '全局公告';

  @override
  String get broadcastSubtitle => '已发送给所有用户';

  @override
  String get broadcastWarning => '此消息所有人可见。';

  @override
  String broadcastError(String error) {
    return '错误: $error';
  }

  @override
  String get broadcastNoHistory => '暂无全局公告。';

  @override
  String get broadcastTypeMessage => '输入公告...';

  @override
  String commFailedToSend(String error) {
    return '发送失败: $error';
  }

  @override
  String get commAdminDashboard => '管理员面板';

  @override
  String get commAdminSupport => '支持';

  @override
  String get commAlwaysHere => '随时为您提供帮助';

  @override
  String get commWelcomeTitle => '你好！👋 我是 Ashutosh Pathak';

  @override
  String get commWelcomeSubtitle => 'Pulse 创作者';

  @override
  String get commWelcomeBody1 =>
      '希望您享受无广告的音乐体验。音乐应该是自由的。\n\n您可以在这里直接与我交流。\n\n随时发送：';

  @override
  String get commBullet1 => '您的反馈';

  @override
  String get commBullet2 => '错误报告';

  @override
  String get commBullet3 => '新功能建议';

  @override
  String get commWelcomeBody2 =>
      '我会亲自阅读每一条消息。\n\n如果有新应用的想法，请告诉我！如果可能，我会制作它。\n\n感谢您成为这里的一部分。❤️';

  @override
  String commError(String error) {
    return '错误: $error';
  }

  @override
  String get commNoMessages => '暂无消息';

  @override
  String get commNoMessagesDesc => '向支持团队发送消息或稍后查看。';

  @override
  String get commMessageSupportHint => '发送消息...';

  @override
  String get commGlobalAnnouncements => '全局公告';

  @override
  String get commSendMessagesToAll => '向所有人发送';

  @override
  String get homeGreetingMorning => '早上好，';

  @override
  String get homeGreetingAfternoon => '下午好，';

  @override
  String get homeGreetingEvening => '晚上好，';

  @override
  String get homeMember => '会员';

  @override
  String get homeRecentPlaylists => '最近的歌单';

  @override
  String get homeRecentlyPlayed => '最近播放';

  @override
  String get homeSpeedDial => '快速访问';

  @override
  String get homeNoContent => '没有内容';

  @override
  String get homeRefresh => '刷新';

  @override
  String get homeLoadError => '加载失败。';

  @override
  String get homeRetry => '重试';

  @override
  String get importSuccess => '成功连接 Spotify！';

  @override
  String importFailed(String error) {
    return '连接失败: $error';
  }

  @override
  String get importTitle => '连接 Spotify';

  @override
  String get importSetupTitle => 'Spotify 设置';

  @override
  String get importSetupDesc => '使用您的开发者密钥快速导入歌单：';

  @override
  String get importStep1 => '打开 Spotify Developer Dashboard。';

  @override
  String get importStep2 => '登录并点击 \'Create app\'。';

  @override
  String get importStep3 => '输入应用名称和描述。';

  @override
  String get importStep4 => '在 \'Redirect URIs\' 下，粘贴此链接：';

  @override
  String get importRedirectCopied => '重定向链接已复制！';

  @override
  String get importStep5 => '保存，复制 \'Client ID\' 并粘贴到下方。';

  @override
  String get importImportant => '重要提示：需要 Spotify Premium 订阅。';

  @override
  String get importClientIdHint => '在此粘贴 Spotify Client ID...';

  @override
  String get importConnectButton => '连接并加载音乐库';

  @override
  String get downloadingNoActive => '没有正在下载的歌曲';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => '下载内容';

  @override
  String downloadsStats(String count, String size) {
    return '$count 首歌曲 • $size';
  }

  @override
  String get downloadsNoOffline => '没有离线歌曲';

  @override
  String get downloadsNoOfflineDesc => '下载的歌曲将显示在这里';

  @override
  String get downloadsClearAllTitle => '全部清除？';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return '这将删除 $count 首歌曲并释放 $size 的空间。';
  }

  @override
  String get downloadsCancel => '取消';

  @override
  String get downloadsClearAll => '全部清除';

  @override
  String downloadsSongsCount(String count) {
    return '$count 首歌曲';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count 首歌';
  }

  @override
  String get downloadsCannotRenameMaster => '无法重命名主下载歌单。';

  @override
  String get downloadsRename => '重命名';

  @override
  String get downloadsEditSongs => '编辑歌曲';

  @override
  String get downloadsDelete => '删除';

  @override
  String get downloadsRenamePlaylistTitle => '重命名歌单';

  @override
  String get downloadsRenamePlaylistDesc => '输入歌单的新名称。';

  @override
  String get downloadsDeletePlaylistTitle => '删除歌单？';

  @override
  String get downloadsDeleteMasterDesc => '确定要删除吗？您将永久丢失所有下载的歌曲和歌单。';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return '确定要删除 \'$name\' 吗？此操作无法撤销。';
  }

  @override
  String get downloadsSave => '保存';

  @override
  String get downloadsNoSongs => '此歌单没有歌曲。';

  @override
  String get libraryTitle => '音乐库';

  @override
  String get libraryPauseAll => '全部暂停';

  @override
  String get libraryResumeAll => '全部恢复';

  @override
  String get libraryTabPlaylists => '歌单';

  @override
  String get libraryTabDownloads => '下载';

  @override
  String get libraryTabDownloading => '下载中';

  @override
  String libraryImportedTask(String name) {
    return '已导入 $name';
  }

  @override
  String get libraryImportWaiting => '等待中...';

  @override
  String get libraryImportFetching => '正在获取歌单...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '已处理 $processed/$total · 匹配 $matched';
  }

  @override
  String get libraryImportSaving => '正在保存...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '添加了 $matched 首歌 · 点击 × 关闭';
  }

  @override
  String get libraryImportDoneAll => '已添加全部歌曲 · 点击 × 关闭';

  @override
  String get libraryAddButton => '添加';

  @override
  String get librarySortRecent => '最近添加';

  @override
  String get librarySortAlpha => '按字母顺序';

  @override
  String get libraryEmptyTitle => '您的音乐库是空的。';

  @override
  String get libraryEmptyDesc => '点击“添加”开始您的音乐之旅。';

  @override
  String get libraryRenameLikedError => '无法重命名“我喜欢的音乐”。';

  @override
  String get libraryRename => '重命名';

  @override
  String get libraryEditSongs => '编辑歌曲';

  @override
  String get libraryDeleteLikedError => '无法删除“我喜欢的音乐”。';

  @override
  String get libraryDelete => '删除';

  @override
  String get libraryEditSongsTitle => '编辑歌曲';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count 首歌';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count 首歌曲';
  }

  @override
  String get libraryCancel => '取消';

  @override
  String get librarySave => '保存';

  @override
  String get libraryNoSongs => '此歌单没有歌曲。';

  @override
  String get libraryAddOptionsTitle => '添加到音乐库';

  @override
  String get libraryAddOptionsDesc => '选择如何扩充您的 Pulse 音乐库';

  @override
  String get libraryImportPulse => '从 Pulse 导入';

  @override
  String get libraryImportPulseDesc => '粘贴 Pulse 歌单链接';

  @override
  String get libraryImportYtm => '从 YT Music 导入';

  @override
  String get libraryImportYtmDesc => '粘贴公开链接';

  @override
  String get libraryImportSpotify => '从 Spotify 导入';

  @override
  String get libraryImportSpotifyDesc => '连接您的 Spotify';

  @override
  String get libraryClose => '关闭';

  @override
  String get libraryImportYtmFull => '从 YouTube Music 导入';

  @override
  String get libraryImportSpotifyFull => '从 Spotify 导入 (≤100首)';

  @override
  String get libraryImportYtmUrlDesc => '在此粘贴 YouTube Music 公开歌单或专辑链接';

  @override
  String get libraryImportSpotifyUrlDesc => '在此粘贴 Spotify 公开歌单链接';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => '无法导入 Pulse 歌单';

  @override
  String get importErrorPlaylist => '导入错误';

  @override
  String get importErrorHighlyPopulated => '歌单很大，可能需要一些时间。';

  @override
  String get libraryImportBtn => '导入';

  @override
  String get libraryCreateTitle => '新歌单';

  @override
  String get libraryCreateDesc => '给新歌单起个名字吧？';

  @override
  String get libraryCreateHint => '例：公路旅行';

  @override
  String get libraryCreateBtn => '创建';

  @override
  String get libraryRenameTitle => '重命名歌单';

  @override
  String get libraryRenameDesc => '输入新名称。';

  @override
  String get libraryRenameBtn => '重命名';

  @override
  String get libraryDeleteTitle => '删除歌单？';

  @override
  String libraryDeleteDesc(String name) {
    return '确定要删除 \'$name\' 吗？此操作无法撤销。';
  }

  @override
  String get libraryDeleteBtn => '删除';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => '最近';

  @override
  String librarySongsCount(String count) {
    return '$count 首歌曲';
  }

  @override
  String get libraryComingSoon => '敬请期待';

  @override
  String get loginErrName => '请输入您的名字';

  @override
  String get loginErrEmail => '请输入您的邮箱';

  @override
  String get loginErrPassword => '请输入您的密码';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => '感受每一次脉动！';

  @override
  String get loginMadeWithHeartBy => '用心制作 ❤️: ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => '您的名字';

  @override
  String get loginHintEmail => '邮箱地址';

  @override
  String get loginHintPassword => '密码';

  @override
  String get loginErrEmailReset => '请输入重置邮箱';

  @override
  String get loginResetSent => '已发送！请检查收件箱。';

  @override
  String get loginForgotPwd => '忘记密码？';

  @override
  String get loginBtnSignup => '创建账户';

  @override
  String get loginBtnSignin => '登录';

  @override
  String get loginToggleHaveAccount => '已经有 Pulse 账户了？ ';

  @override
  String get loginToggleNoAccount => '还没有 Pulse 账户？ ';

  @override
  String get loginToggleSignin => '登录';

  @override
  String get loginToggleSignup => '注册';

  @override
  String get offlineStillOffline => '仍处于离线状态。请检查网络连接。';

  @override
  String get offlineTitle => '您已离线';

  @override
  String get offlineSubtitle => '没有网络连接。\n请检查您的网络并重试。';

  @override
  String get offlineChecking => '正在检查...';

  @override
  String get offlineRetry => '重试';

  @override
  String get offlineGoToDownloads => '前往下载内容';

  @override
  String get playerMadeWithHeartBy => '用心制作 ❤️: ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => '滑动查看歌词';

  @override
  String get playerNoLyrics => '没有可用歌词';

  @override
  String get playerUpNext => '接下来播放';

  @override
  String get playerNoTracksInQueue => '队列中没有歌曲';

  @override
  String get playerNoMusicPlaying => '没有正在播放的音乐';

  @override
  String get playerPickAVibe => '从音乐库中挑选一首歌';

  @override
  String get playerGoHome => '回到首页';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => '均衡器';

  @override
  String get playerEqCustom => '自定义';

  @override
  String get playlistDownloads => '下载内容';

  @override
  String get playlistOffline => '离线歌单';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hours小时 $mins分钟';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$mins分钟';
  }

  @override
  String get playlistFindOnPage => '在页面中查找';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count 首歌曲 • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => '最近';

  @override
  String get playlistNoMatches => '没有找到匹配项。';

  @override
  String get playlistNoTracks => '此歌单没有歌曲。';

  @override
  String get playlistNoSongsYet => '目前还没有歌曲。';

  @override
  String get playlistSortRecentlyAdded => '最近添加';

  @override
  String get playlistSortAlphabetical => '按字母顺序';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '首歌曲',
      one: '首歌',
    );
    return '正在下载 $count $_temp0';
  }

  @override
  String get playlistView => '查看';

  @override
  String get playlistAllDownloaded => '已全部下载';

  @override
  String playlistShareText(String name, String url) {
    return '在 Pulse 上听听 \'$name\' 吧！\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => '从下载中移除';

  @override
  String get playlistRemoveFromPlaylist => '从歌单中移除';

  @override
  String get playlistLoadError => '加载失败。';

  @override
  String get playlistGoBack => '← 返回';

  @override
  String get profileNotLoggedIn => '未登录';

  @override
  String get profileSignIn => '登录';

  @override
  String get profileDefaultUser => 'Pulse 用户';

  @override
  String get profileEditProfile => '编辑';

  @override
  String get profileTimeframeDay => '天';

  @override
  String get profileTimeframeWeek => '周';

  @override
  String get profileTimeframeMonth => '月';

  @override
  String get profileTimeframeYear => '年';

  @override
  String get profileListeningTime => '收听时长';

  @override
  String get profileToday => '今天';

  @override
  String get profileThisWeek => '本周';

  @override
  String get profileThisMonth => '本月';

  @override
  String get profileThisYear => '今年';

  @override
  String get profileDailyAvg => '日均';

  @override
  String get profilePerDay => '/天';

  @override
  String get profileLifetimeListening => '累计收听';

  @override
  String get profileTotalTimeListened => 'Pulse 累计收听总时长';

  @override
  String get profileYourTopSongs => '最爱歌曲';

  @override
  String get profileListeningHistoryEmpty => '您的收听记录将显示在这里。';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '次播放',
      one: '次播放',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => '最爱歌手';

  @override
  String get profileTopArtistsEmpty => '您最爱的歌手将显示在这里。';

  @override
  String get profileArtistLabel => '歌手';

  @override
  String get profileSignOut => '退出登录';

  @override
  String profileVersion(String version) {
    return '版本 $version';
  }

  @override
  String get profileMadeWithHeartBy => '用心制作 ❤️: ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => '编辑资料';

  @override
  String get profileDisplayName => '显示名称';

  @override
  String get profileCancel => '取消';

  @override
  String get profileSave => '保存';

  @override
  String get profileChooseAvatar => '选择头像';

  @override
  String get searchMicPermissionRequired => '需要麦克风权限';

  @override
  String get searchUnknownSong => '未知歌曲';

  @override
  String get searchUnknownArtist => '未知歌手';

  @override
  String get searchNoSongDetected => '未检测到任何歌曲。';

  @override
  String searchError(String message) {
    return '错误: $message';
  }

  @override
  String get searchSpeechNotAvailable => '语音搜索不可用';

  @override
  String get searchHint => '歌曲、歌手、专辑...';

  @override
  String get searchRecentEmpty => '您的近期搜索将显示在这里';

  @override
  String get searchRecentSearches => '近期搜索';

  @override
  String get searchClearAll => '全部清除';

  @override
  String searchNoResultsFor(String query) {
    return '没有找到与 \'$query\' 相关的结果';
  }

  @override
  String get searchTryDifferentKeywords => '尝试使用不同的关键词';

  @override
  String get searchTopResult => '最佳结果';

  @override
  String get searchSongsLabel => '歌曲';

  @override
  String get searchArtistsLabel => '歌手';

  @override
  String get searchAlbumsLabel => '专辑';

  @override
  String get searchPlaylistsLabel => '歌单';

  @override
  String get searchArtistLabel => '歌手';

  @override
  String get searchListening => '正在聆听...';

  @override
  String get searchSpeakNow => '请说话';

  @override
  String get searchCancel => '取消';

  @override
  String get searchIdentifying => '正在识别...';

  @override
  String get searchListeningForSong => '正在收听歌曲...';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsStreamingQuality => '流媒体音质';

  @override
  String get settingsQualityAutomatic => '自动';

  @override
  String get settingsQualityLow => '低';

  @override
  String get settingsQualityNormal => '标准';

  @override
  String get settingsQualityHigh => '高';

  @override
  String get settingsDownloadQuality => '下载音质';

  @override
  String get settingsPlayback => '播放';

  @override
  String get settingsCrossfade => '淡入淡出';

  @override
  String get settingsCrossfadeDesc => '歌曲之间的平滑过渡';

  @override
  String get settingsDataUsage => '数据流量';

  @override
  String get settingsDataSaver => '省流模式';

  @override
  String get settingsDataSaverDesc => '在移动网络下以较低音质播放';

  @override
  String get settingsAppearance => '外观';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsCustomAccent => '强调色';

  @override
  String get settingsSaturation => '饱和度';

  @override
  String get settingsBrightness => '亮度';

  @override
  String get settingsResetDefault => '恢复默认';

  @override
  String get playlistSheetTitle => '添加到歌单';

  @override
  String get playlistSheetNewPlaylist => '新歌单';

  @override
  String get playlistSheetNoPlaylists => '没有歌单';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '首歌曲',
      one: '首歌',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => '歌单名称';

  @override
  String get playlistSheetCancel => '取消';

  @override
  String playlistSheetAddedTo(String name) {
    return '已添加到 $name';
  }

  @override
  String get playlistSheetCreateFailAuth => '创建失败: 认证错误';

  @override
  String playlistSheetCreateFail(String error) {
    return '创建失败: $error';
  }

  @override
  String get playlistSheetCreate => '创建';

  @override
  String get appUpdateAvailable => '有可用更新';

  @override
  String appUpdateDesc(String version) {
    return '版本 $version 现已发布！请更新以体验新功能。';
  }

  @override
  String get appUpdateDownload => '下载更新';

  @override
  String get navHome => '首页';

  @override
  String get navLibrary => '音乐库';

  @override
  String get navSearch => '搜索';

  @override
  String get navSettings => '设置';

  @override
  String get navProfile => '我的';

  @override
  String get artistSelect => '选择歌手';

  @override
  String get songActionQueue => '添加到队列';

  @override
  String get songActionPlaylist => '添加到歌单';

  @override
  String get songActionFinding => '正在查找...';

  @override
  String get songActionAlbum => '查看专辑';

  @override
  String get songActionArtist => '查看歌手';

  @override
  String get songActionRemovePlaylist => '从歌单中移除';

  @override
  String get songActionRemoveDownload => '从下载中移除';

  @override
  String get songActionDownloadChecking => '正在检查...';

  @override
  String get songActionDownloading => '正在下载...';

  @override
  String get songActionDownloaded => '已下载！';

  @override
  String get songActionDownloadAlready => '已下载';

  @override
  String get songActionDownloadFailed => '下载失败';

  @override
  String get songActionDownload => '下载';

  @override
  String get songActionDownloadingSnack => '正在下载';

  @override
  String get songActionView => '查看';

  @override
  String get spotifyImportTitle => '从 Spotify 导入';

  @override
  String get spotifyImportSubtitle => '选择歌单大小';

  @override
  String get spotifyChoiceSmallTitle => '100 首歌以内';

  @override
  String get spotifyChoiceSmallDesc => '粘贴公开的 Spotify 链接。';

  @override
  String get spotifyChoiceLargeTitle => '超过 100 首歌';

  @override
  String get spotifyChoiceLargeDesc => '连接您自己的 Spotify 开发者应用。';

  @override
  String get cancelButton => '取消';

  @override
  String get spotifyPlaylistsTitle => 'Spotify 歌单';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return '错误: $error\n请检查您的 Client ID。';
  }

  @override
  String get spotifyPlaylistsEmpty => '您的音乐库中没有歌单';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count 首歌';
  }

  @override
  String get spotifyPlaylistsImport => '导入';

  @override
  String get audioPlaybackFailed => '播放失败。';

  @override
  String get audioControlPrevious => '上一首';

  @override
  String get audioControlPause => '暂停';

  @override
  String get audioControlPlay => '播放';

  @override
  String get audioControlNext => '下一首';

  @override
  String get audioControlUnlike => '取消喜欢';

  @override
  String get audioControlLike => '喜欢';

  @override
  String spotifyRawResponseError(String data, String error) {
    return '原始响应: $data\n\n错误: $error';
  }

  @override
  String get apiErrorInvalidClient => '无效的 Client ID。';

  @override
  String get apiErrorBadRequest => '请求无效。请检查您的数据。';

  @override
  String get apiErrorUnauthorized => '未授权。请重新登录。';

  @override
  String get apiErrorForbidden => '被拒绝。您没有访问权限。';

  @override
  String get apiErrorNotFound => '找不到请求的资源。';

  @override
  String get apiErrorEmailInUse => '该邮箱已被使用。';

  @override
  String get apiErrorUserNotFound => '找不到使用此邮箱的账户。';

  @override
  String get apiErrorWrongPassword => '密码错误。';

  @override
  String get apiErrorInvalidCredential => '登录失败。请检查您的登录信息。';

  @override
  String get apiErrorNetwork => '网络错误。请检查您的网络连接。';

  @override
  String get apiErrorSocketTimeout => '连接超时。请稍后再试。';

  @override
  String get apiErrorTooManyRequests => '请求过多。请稍后再试。';

  @override
  String get apiErrorServerError => '服务器出错。请稍后再试。';

  @override
  String get apiErrorInvalidEmail => '请提供有效的邮箱地址。';

  @override
  String get apiErrorWeakPassword => '密码太简单。请至少使用 6 个字符。';

  @override
  String get apiErrorTooManyAttempts => '失败尝试过多。请稍后再试。';

  @override
  String get homeForgottenFavorites => '遗忘的最爱';

  @override
  String get artistShowAll => '查看全部';

  @override
  String get homeTopTracks => '热门曲目';
}
