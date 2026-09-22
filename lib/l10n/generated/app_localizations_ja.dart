// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => '概要';

  @override
  String get artistPopular => '人気の曲';

  @override
  String get artistAlbums => 'アルバム';

  @override
  String get artistSinglesAndEPs => 'シングルとEP';

  @override
  String artistSubscribersCount(String count) {
    return '登録者 $count 人';
  }

  @override
  String get artistPlayAll => 'すべて再生';

  @override
  String get artistLoadError => 'アーティストを読み込めませんでした';

  @override
  String get artistGoBack => '戻る';

  @override
  String adminChatFailedToReply(String error) {
    return '返信に失敗しました: $error';
  }

  @override
  String get adminChatSupportChat => 'サポートチャット';

  @override
  String adminChatError(String error) {
    return 'エラー: $error';
  }

  @override
  String get adminChatNoHistory => 'メッセージ履歴がありません。';

  @override
  String get adminChatSupportYou => 'サポート (あなた)';

  @override
  String get adminChatTypeReply => '返信を入力...';

  @override
  String get broadcastSuccess => 'お知らせを送信しました';

  @override
  String broadcastFailed(String error) {
    return '送信に失敗しました: $error';
  }

  @override
  String get broadcastTitle => '全体へのメッセージ';

  @override
  String get broadcastSubtitle => '全ユーザーへ送信';

  @override
  String get broadcastWarning => 'このメッセージは全員に表示されます。';

  @override
  String broadcastError(String error) {
    return 'エラー: $error';
  }

  @override
  String get broadcastNoHistory => 'お知らせはありません。';

  @override
  String get broadcastTypeMessage => 'メッセージを入力...';

  @override
  String commFailedToSend(String error) {
    return '送信に失敗しました: $error';
  }

  @override
  String get commAdminDashboard => '管理者ダッシュボード';

  @override
  String get commAdminSupport => 'サポート';

  @override
  String get commAlwaysHere => 'いつでもサポートします';

  @override
  String get commWelcomeTitle => 'こんにちは！👋 開発者の Ashutosh Pathak です';

  @override
  String get commWelcomeSubtitle => 'Pulse クリエイター';

  @override
  String get commWelcomeBody1 =>
      '広告なしの音楽体験を楽しんでいただければ幸いです。音楽は誰にでも開かれているべきです。\n\nここは私と直接やり取りできるスペースです。\n\nお気軽にどうぞ:';

  @override
  String get commBullet1 => 'フィードバック';

  @override
  String get commBullet2 => 'バグの報告';

  @override
  String get commBullet3 => '新機能の提案';

  @override
  String get commWelcomeBody2 =>
      'すべてのメッセージを読んでいます。\n\nもし新しいアプリのアイデアがあれば教えてください！可能なら作ってみます。\n\nPulseをご利用いただきありがとうございます。❤️';

  @override
  String commError(String error) {
    return 'エラー: $error';
  }

  @override
  String get commNoMessages => 'まだメッセージはありません';

  @override
  String get commNoMessagesDesc => 'サポートチームにメッセージを送ってみましょう。';

  @override
  String get commMessageSupportHint => 'メッセージを入力...';

  @override
  String get commGlobalAnnouncements => 'お知らせ';

  @override
  String get commSendMessagesToAll => '全員に送信';

  @override
  String get homeGreetingMorning => 'おはようございます';

  @override
  String get homeGreetingAfternoon => 'こんにちは';

  @override
  String get homeGreetingEvening => 'こんばんは';

  @override
  String get homeMember => 'メンバー';

  @override
  String get homeRecentPlaylists => '最近のプレイリスト';

  @override
  String get homeRecentlyPlayed => '最近再生した曲';

  @override
  String get homeSpeedDial => 'クイックアクセス';

  @override
  String get homeNoContent => 'コンテンツがありません';

  @override
  String get homeRefresh => '更新';

  @override
  String get homeLoadError => '読み込みに失敗しました。';

  @override
  String get homeRetry => '再試行';

  @override
  String get importSuccess => 'Spotifyに接続しました';

  @override
  String importFailed(String error) {
    return '接続に失敗しました: $error';
  }

  @override
  String get importTitle => 'Spotify 接続';

  @override
  String get importSetupTitle => 'Spotify の設定';

  @override
  String get importSetupDesc => 'ご自身の開発者キーを使用してプレイリストを高速インポートします:';

  @override
  String get importStep1 => 'Spotify Developer Dashboard を開きます。';

  @override
  String get importStep2 => 'ログインして「Create app」をクリックします。';

  @override
  String get importStep3 => 'アプリ名と説明を入力します。';

  @override
  String get importStep4 => '「Redirect URIs」に以下の URL を貼り付けます:';

  @override
  String get importRedirectCopied => 'URLをコピーしました！';

  @override
  String get importStep5 => '保存後、「Client ID」をコピーして以下に貼り付けます。';

  @override
  String get importImportant => '重要: 有効な Spotify Premium サブスクリプションが必要です。';

  @override
  String get importClientIdHint => 'Client ID を入力...';

  @override
  String get importConnectButton => '接続してライブラリを読み込む';

  @override
  String get downloadingNoActive => 'ダウンロード中の曲はありません';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'ダウンロード';

  @override
  String downloadsStats(String count, String size) {
    return '$count 曲 • $size';
  }

  @override
  String get downloadsNoOffline => 'オフラインの曲がありません';

  @override
  String get downloadsNoOfflineDesc => 'ダウンロードした曲がここに表示されます';

  @override
  String get downloadsClearAllTitle => 'すべてクリアしますか？';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return '$count 曲が削除され、$size のストレージが解放されます。';
  }

  @override
  String get downloadsCancel => 'キャンセル';

  @override
  String get downloadsClearAll => 'すべてクリア';

  @override
  String downloadsSongsCount(String count) {
    return '$count 曲';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count 曲';
  }

  @override
  String get downloadsCannotRenameMaster => 'メインのダウンロードプレイリストは名前を変更できません。';

  @override
  String get downloadsRename => '名前を変更';

  @override
  String get downloadsEditSongs => '曲を編集';

  @override
  String get downloadsDelete => '削除';

  @override
  String get downloadsRenamePlaylistTitle => '名前を変更';

  @override
  String get downloadsRenamePlaylistDesc => 'プレイリストの新しい名前を入力してください。';

  @override
  String get downloadsDeletePlaylistTitle => 'プレイリストを削除しますか？';

  @override
  String get downloadsDeleteMasterDesc =>
      '本当に削除しますか？ ダウンロードしたすべての曲とプレイリストが完全に失われます。';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return '本当に「$name」を削除しますか？ この操作は元に戻せません。';
  }

  @override
  String get downloadsSave => '保存';

  @override
  String get downloadsNoSongs => 'このプレイリストには曲がありません。';

  @override
  String get libraryTitle => 'ライブラリ';

  @override
  String get libraryPauseAll => 'すべて一時停止';

  @override
  String get libraryResumeAll => 'すべて再開';

  @override
  String get libraryTabPlaylists => 'プレイリスト';

  @override
  String get libraryTabDownloads => 'ダウンロード';

  @override
  String get libraryTabDownloading => 'ダウンロード中';

  @override
  String libraryImportedTask(String name) {
    return '$name をインポートしました';
  }

  @override
  String get libraryImportWaiting => '待機中...';

  @override
  String get libraryImportFetching => 'プレイリストを取得中...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total 件処理 · $matched 件一致';
  }

  @override
  String get libraryImportSaving => '保存中...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched 曲追加 · ×で閉じる';
  }

  @override
  String get libraryImportDoneAll => 'すべての曲を追加しました · ×で閉じる';

  @override
  String get libraryAddButton => '追加';

  @override
  String get librarySortRecent => '最近追加した順';

  @override
  String get librarySortAlpha => 'アルファベット順';

  @override
  String get libraryEmptyTitle => 'ライブラリは空です。';

  @override
  String get libraryEmptyDesc => '「追加」を押して始めましょう。';

  @override
  String get libraryRenameLikedError => '「お気に入りの曲」は名前を変更できません。';

  @override
  String get libraryRename => '名前を変更';

  @override
  String get libraryEditSongs => '曲を編集';

  @override
  String get libraryDeleteLikedError => '「お気に入りの曲」は削除できません。';

  @override
  String get libraryDelete => '削除';

  @override
  String get libraryEditSongsTitle => '曲を編集';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count 曲';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count 曲';
  }

  @override
  String get libraryCancel => 'キャンセル';

  @override
  String get librarySave => '保存';

  @override
  String get libraryNoSongs => 'このプレイリストには曲がありません。';

  @override
  String get libraryAddOptionsTitle => 'ライブラリに追加';

  @override
  String get libraryAddOptionsDesc => 'どこから追加しますか？';

  @override
  String get libraryImportPulse => 'Pulse から';

  @override
  String get libraryImportPulseDesc => 'Pulse の URL を貼り付け';

  @override
  String get libraryImportYtm => 'YT Music から';

  @override
  String get libraryImportYtmDesc => '公開 URL を貼り付け';

  @override
  String get libraryImportSpotify => 'Spotify から';

  @override
  String get libraryImportSpotifyDesc => 'Spotify を接続';

  @override
  String get libraryClose => '閉じる';

  @override
  String get libraryImportYtmFull => 'YouTube Music からインポート';

  @override
  String get libraryImportSpotifyFull => 'Spotify からインポート (100曲まで)';

  @override
  String get libraryImportYtmUrlDesc => 'YouTube Music の公開プレイリスト URL を貼り付けます';

  @override
  String get libraryImportSpotifyUrlDesc => 'Spotify の公開プレイリスト URL を貼り付けます';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Pulse プレイリストをインポートできませんでした';

  @override
  String get importErrorPlaylist => 'インポート エラー';

  @override
  String get importErrorHighlyPopulated => 'プレイリストが大きいため、時間がかかる場合があります。';

  @override
  String get libraryImportBtn => 'インポート';

  @override
  String get libraryCreateTitle => '新しいプレイリスト';

  @override
  String get libraryCreateDesc => 'プレイリスト名を入力してください';

  @override
  String get libraryCreateHint => '例: ドライブ用';

  @override
  String get libraryCreateBtn => '作成';

  @override
  String get libraryRenameTitle => '名前を変更';

  @override
  String get libraryRenameDesc => '新しい名前を入力してください。';

  @override
  String get libraryRenameBtn => '保存';

  @override
  String get libraryDeleteTitle => 'プレイリストを削除しますか？';

  @override
  String libraryDeleteDesc(String name) {
    return '本当に「$name」を削除しますか？ この操作は元に戻せません。';
  }

  @override
  String get libraryDeleteBtn => '削除';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => '最近';

  @override
  String librarySongsCount(String count) {
    return '$count 曲';
  }

  @override
  String get libraryComingSoon => '近日公開';

  @override
  String get loginErrName => '名前を入力してください';

  @override
  String get loginErrEmail => 'メールアドレスを入力してください';

  @override
  String get loginErrPassword => 'パスワードを入力してください';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => '音楽を体感しよう！';

  @override
  String get loginMadeWithHeartBy => '心を込めて作成しました: ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => '名前';

  @override
  String get loginHintEmail => 'メールアドレス';

  @override
  String get loginHintPassword => 'パスワード';

  @override
  String get loginErrEmailReset => 'リセット用のメールアドレスを入力してください';

  @override
  String get loginResetSent => '送信しました。受信トレイを確認してください。';

  @override
  String get loginForgotPwd => 'パスワードを忘れた場合';

  @override
  String get loginBtnSignup => 'アカウント作成';

  @override
  String get loginBtnSignin => 'ログイン';

  @override
  String get loginToggleHaveAccount => 'すでにアカウントをお持ちですか？ ';

  @override
  String get loginToggleNoAccount => 'アカウントをお持ちでないですか？ ';

  @override
  String get loginToggleSignin => 'ログイン';

  @override
  String get loginToggleSignup => '登録';

  @override
  String get offlineStillOffline => 'まだオフラインです。接続を確認してください。';

  @override
  String get offlineTitle => 'オフラインです';

  @override
  String get offlineSubtitle => 'インターネット接続がありません。\nネットワークを確認してもう一度お試しください。';

  @override
  String get offlineChecking => '確認中...';

  @override
  String get offlineRetry => '再試行';

  @override
  String get offlineGoToDownloads => 'ダウンロードへ移動';

  @override
  String get playerMadeWithHeartBy => '心を込めて作成しました: ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'スワイプして歌詞を表示';

  @override
  String get playerNoLyrics => '歌詞はありません';

  @override
  String get playerUpNext => '次へ';

  @override
  String get playerNoTracksInQueue => 'キューに曲がありません';

  @override
  String get playerNoMusicPlaying => '再生していません';

  @override
  String get playerPickAVibe => '曲を選んでください';

  @override
  String get playerGoHome => 'ホームへ';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'イコライザー';

  @override
  String get playerEqCustom => 'カスタム';

  @override
  String get playlistDownloads => 'ダウンロード';

  @override
  String get playlistOffline => 'オフライン';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hours時間 $mins分';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$mins分';
  }

  @override
  String get playlistFindOnPage => 'ページ内検索';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count 曲 • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => '最近';

  @override
  String get playlistNoMatches => '見つかりませんでした。';

  @override
  String get playlistNoTracks => 'このプレイリストには曲がありません。';

  @override
  String get playlistNoSongsYet => 'まだ曲がありません。';

  @override
  String get playlistSortRecentlyAdded => '最近追加した順';

  @override
  String get playlistSortAlphabetical => 'アルファベット順';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '曲',
      one: '曲',
    );
    return '$count $_temp0 をダウンロード中';
  }

  @override
  String get playlistView => '表示';

  @override
  String get playlistAllDownloaded => 'すべてダウンロード済み';

  @override
  String playlistShareText(String name, String url) {
    return 'Pulseで「$name」を聴いてみて！\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'ダウンロードから削除';

  @override
  String get playlistRemoveFromPlaylist => 'プレイリストから削除';

  @override
  String get playlistLoadError => '読み込めませんでした。';

  @override
  String get playlistGoBack => '← 戻る';

  @override
  String get profileNotLoggedIn => '未ログイン';

  @override
  String get profileSignIn => 'ログイン';

  @override
  String get profileDefaultUser => 'Pulse ユーザー';

  @override
  String get profileEditProfile => '編集';

  @override
  String get profileTimeframeDay => '日';

  @override
  String get profileTimeframeWeek => '週';

  @override
  String get profileTimeframeMonth => '月';

  @override
  String get profileTimeframeYear => '年';

  @override
  String get profileListeningTime => '再生時間';

  @override
  String get profileToday => '今日';

  @override
  String get profileThisWeek => '今週';

  @override
  String get profileThisMonth => '今月';

  @override
  String get profileThisYear => '今年';

  @override
  String get profileDailyAvg => '1日平均';

  @override
  String get profilePerDay => '/日';

  @override
  String get profileLifetimeListening => '合計';

  @override
  String get profileTotalTimeListened => 'Pulseでの総再生時間';

  @override
  String get profileYourTopSongs => 'トップソング';

  @override
  String get profileListeningHistoryEmpty => '履歴がここに表示されます。';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '回再生',
      one: '回再生',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => 'トップアーティスト';

  @override
  String get profileTopArtistsEmpty => 'お気に入りのアーティストがここに表示されます。';

  @override
  String get profileArtistLabel => 'アーティスト';

  @override
  String get profileSignOut => 'ログアウト';

  @override
  String profileVersion(String version) {
    return 'バージョン $version';
  }

  @override
  String get profileMadeWithHeartBy => '心を込めて作成しました: ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'プロフィール';

  @override
  String get profileDisplayName => '表示名';

  @override
  String get profileCancel => 'キャンセル';

  @override
  String get profileSave => '保存';

  @override
  String get profileChooseAvatar => 'アバターを選択';

  @override
  String get searchMicPermissionRequired => 'マイクの許可が必要です';

  @override
  String get searchUnknownSong => '不明な曲';

  @override
  String get searchUnknownArtist => '不明なアーティスト';

  @override
  String get searchNoSongDetected => '曲を認識できませんでした。';

  @override
  String searchError(String message) {
    return 'エラー: $message';
  }

  @override
  String get searchSpeechNotAvailable => '音声検索は利用できません';

  @override
  String get searchHint => '曲名、アーティスト、アルバム...';

  @override
  String get searchRecentEmpty => '検索履歴がここに表示されます';

  @override
  String get searchRecentSearches => '最近の検索';

  @override
  String get searchClearAll => 'すべてクリア';

  @override
  String searchNoResultsFor(String query) {
    return '「$query」の結果はありません';
  }

  @override
  String get searchTryDifferentKeywords => '別のキーワードをお試しください';

  @override
  String get searchTopResult => 'トップ結果';

  @override
  String get searchSongsLabel => '曲';

  @override
  String get searchArtistsLabel => 'アーティスト';

  @override
  String get searchAlbumsLabel => 'アルバム';

  @override
  String get searchPlaylistsLabel => 'プレイリスト';

  @override
  String get searchArtistLabel => 'アーティスト';

  @override
  String get searchListening => '聞いています...';

  @override
  String get searchSpeakNow => 'お話しください';

  @override
  String get searchCancel => 'キャンセル';

  @override
  String get searchIdentifying => '認識中...';

  @override
  String get searchListeningForSong => '曲を特定中...';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsStreamingQuality => 'ストリーミング品質';

  @override
  String get settingsQualityAutomatic => '自動';

  @override
  String get settingsQualityLow => '低';

  @override
  String get settingsQualityNormal => '標準';

  @override
  String get settingsQualityHigh => '高';

  @override
  String get settingsDownloadQuality => 'ダウンロード品質';

  @override
  String get settingsPlayback => '再生';

  @override
  String get settingsCrossfade => 'クロスフェード';

  @override
  String get settingsCrossfadeDesc => '曲間のスムーズな切り替え';

  @override
  String get settingsDataUsage => 'データ使用';

  @override
  String get settingsDataSaver => 'データセーバー';

  @override
  String get settingsDataSaverDesc => 'モバイル通信時に低音質で再生';

  @override
  String get settingsAppearance => '表示';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsCustomAccent => 'アクセントカラー';

  @override
  String get settingsSaturation => '彩度';

  @override
  String get settingsBrightness => '明るさ';

  @override
  String get settingsResetDefault => 'デフォルトに戻す';

  @override
  String get playlistSheetTitle => 'プレイリストに追加';

  @override
  String get playlistSheetNewPlaylist => '新しいプレイリスト';

  @override
  String get playlistSheetNoPlaylists => 'プレイリストがありません';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '曲',
      one: '曲',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => 'プレイリスト名';

  @override
  String get playlistSheetCancel => 'キャンセル';

  @override
  String playlistSheetAddedTo(String name) {
    return '$name に追加しました';
  }

  @override
  String get playlistSheetCreateFailAuth => 'エラー: 認証に失敗しました';

  @override
  String playlistSheetCreateFail(String error) {
    return 'エラー: $error';
  }

  @override
  String get playlistSheetCreate => '作成';

  @override
  String get appUpdateAvailable => 'アップデート可能';

  @override
  String appUpdateDesc(String version) {
    return 'バージョン $version が利用可能です！';
  }

  @override
  String get appUpdateDownload => 'ダウンロード';

  @override
  String get navHome => 'ホーム';

  @override
  String get navLibrary => 'ライブラリ';

  @override
  String get navSearch => '検索';

  @override
  String get navSettings => '設定';

  @override
  String get navProfile => 'プロフィール';

  @override
  String get artistSelect => 'アーティストを選択';

  @override
  String get songActionQueue => 'キューに追加';

  @override
  String get songActionPlaylist => 'プレイリストに追加';

  @override
  String get songActionFinding => '検索中...';

  @override
  String get songActionAlbum => 'アルバムへ移動';

  @override
  String get songActionArtist => 'アーティストへ移動';

  @override
  String get songActionRemovePlaylist => 'プレイリストから削除';

  @override
  String get songActionRemoveDownload => 'ダウンロードから削除';

  @override
  String get songActionDownloadChecking => '確認中...';

  @override
  String get songActionDownloading => 'ダウンロード中...';

  @override
  String get songActionDownloaded => '完了！';

  @override
  String get songActionDownloadAlready => 'ダウンロード済み';

  @override
  String get songActionDownloadFailed => '失敗しました';

  @override
  String get songActionDownload => 'ダウンロード';

  @override
  String get songActionDownloadingSnack => 'ダウンロード中';

  @override
  String get songActionView => '表示';

  @override
  String get spotifyImportTitle => 'Spotify からインポート';

  @override
  String get spotifyImportSubtitle => 'プレイリストのサイズを選択';

  @override
  String get spotifyChoiceSmallTitle => '100曲以下';

  @override
  String get spotifyChoiceSmallDesc => '公開 URL を貼り付けます。';

  @override
  String get spotifyChoiceLargeTitle => '100曲以上';

  @override
  String get spotifyChoiceLargeDesc => 'Spotify Developer キーを使用します。';

  @override
  String get cancelButton => 'キャンセル';

  @override
  String get spotifyPlaylistsTitle => 'Spotify プレイリスト';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'エラー: $error\nClient ID を確認してください。';
  }

  @override
  String get spotifyPlaylistsEmpty => 'プレイリストがありません';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count 曲';
  }

  @override
  String get spotifyPlaylistsImport => 'インポート';

  @override
  String get audioPlaybackFailed => '再生できませんでした。';

  @override
  String get audioControlPrevious => '前へ';

  @override
  String get audioControlPause => '一時停止';

  @override
  String get audioControlPlay => '再生';

  @override
  String get audioControlNext => '次へ';

  @override
  String get audioControlUnlike => 'いいねを取り消す';

  @override
  String get audioControlLike => 'いいね';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'レスポンス: $data\n\nエラー: $error';
  }

  @override
  String get apiErrorInvalidClient => 'Client ID が無効です。';

  @override
  String get apiErrorBadRequest => 'リクエストが無効です。';

  @override
  String get apiErrorUnauthorized => '認証されていません。再ログインしてください。';

  @override
  String get apiErrorForbidden => 'アクセスが拒否されました。';

  @override
  String get apiErrorNotFound => '見つかりません。';

  @override
  String get apiErrorEmailInUse => 'このメールはすでに使用されています。';

  @override
  String get apiErrorUserNotFound => 'アカウントが見つかりません。';

  @override
  String get apiErrorWrongPassword => 'パスワードが間違っています。';

  @override
  String get apiErrorInvalidCredential => 'ログイン情報が間違っています。';

  @override
  String get apiErrorNetwork => 'ネットワークエラーです。';

  @override
  String get apiErrorSocketTimeout => 'タイムアウトしました。';

  @override
  String get apiErrorTooManyRequests => 'リクエストが多すぎます。';

  @override
  String get apiErrorServerError => 'サーバーエラーです。';

  @override
  String get apiErrorInvalidEmail => '有効なメールアドレスを入力してください。';

  @override
  String get apiErrorWeakPassword => 'パスワードが弱すぎます。';

  @override
  String get apiErrorTooManyAttempts => 'ログイン試行回数が多すぎます。';

  @override
  String get homeForgottenFavorites => '忘れられたお気に入り';

  @override
  String get artistShowAll => 'すべて表示';

  @override
  String get homeTopTracks => 'トップトラック';
}
