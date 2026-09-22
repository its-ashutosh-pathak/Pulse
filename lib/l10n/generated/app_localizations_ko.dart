// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => '정보';

  @override
  String get artistPopular => '인기 곡';

  @override
  String get artistAlbums => '앨범';

  @override
  String get artistSinglesAndEPs => '싱글 및 EP';

  @override
  String artistSubscribersCount(String count) {
    return '구독자 $count명';
  }

  @override
  String get artistPlayAll => '모두 재생';

  @override
  String get artistLoadError => '아티스트를 불러올 수 없습니다';

  @override
  String get artistGoBack => '뒤로 가기';

  @override
  String adminChatFailedToReply(String error) {
    return '답장 실패: $error';
  }

  @override
  String get adminChatSupportChat => '지원 채팅';

  @override
  String adminChatError(String error) {
    return '오류: $error';
  }

  @override
  String get adminChatNoHistory => '메시지 기록이 없습니다.';

  @override
  String get adminChatSupportYou => '지원 (나)';

  @override
  String get adminChatTypeReply => '답장 입력...';

  @override
  String get broadcastSuccess => '공지가 성공적으로 전송되었습니다!';

  @override
  String broadcastFailed(String error) {
    return '전송 실패: $error';
  }

  @override
  String get broadcastTitle => '전체 공지';

  @override
  String get broadcastSubtitle => '모든 사용자에게 전송됨';

  @override
  String get broadcastWarning => '이 메시지는 모든 사람에게 표시됩니다.';

  @override
  String broadcastError(String error) {
    return '오류: $error';
  }

  @override
  String get broadcastNoHistory => '전체 공지가 없습니다.';

  @override
  String get broadcastTypeMessage => '메시지를 입력하세요...';

  @override
  String commFailedToSend(String error) {
    return '전송 실패: $error';
  }

  @override
  String get commAdminDashboard => '관리자 대시보드';

  @override
  String get commAdminSupport => '지원';

  @override
  String get commAlwaysHere => '언제든 도와드리겠습니다';

  @override
  String get commWelcomeTitle => '안녕하세요! 👋 개발자 Ashutosh Pathak입니다';

  @override
  String get commWelcomeSubtitle => 'Pulse 크리에이터';

  @override
  String get commWelcomeBody1 =>
      '광고 없는 음악 감상을 즐기고 계시길 바랍니다. 음악은 누구에게나 열려 있어야 합니다.\n\n이곳은 저와 직접 소통할 수 있는 공간입니다.\n\n언제든지 보내주세요:';

  @override
  String get commBullet1 => '피드백';

  @override
  String get commBullet2 => '버그 신고';

  @override
  String get commBullet3 => '새로운 기능 제안';

  @override
  String get commWelcomeBody2 =>
      '보내주신 메시지는 모두 직접 읽어봅니다.\n\n새로운 앱 아이디어가 있다면 알려주세요! 가능하면 만들어 보겠습니다.\n\nPulse를 이용해 주셔서 감사합니다. ❤️';

  @override
  String commError(String error) {
    return '오류: $error';
  }

  @override
  String get commNoMessages => '아직 메시지가 없습니다';

  @override
  String get commNoMessagesDesc => '지원팀에 메시지를 보내보세요.';

  @override
  String get commMessageSupportHint => '메시지 입력...';

  @override
  String get commGlobalAnnouncements => '전체 공지';

  @override
  String get commSendMessagesToAll => '모두에게 전송';

  @override
  String get homeGreetingMorning => '좋은 아침입니다,';

  @override
  String get homeGreetingAfternoon => '안녕하세요,';

  @override
  String get homeGreetingEvening => '좋은 저녁입니다,';

  @override
  String get homeMember => '회원';

  @override
  String get homeRecentPlaylists => '최근 플레이리스트';

  @override
  String get homeRecentlyPlayed => '최근 재생한 곡';

  @override
  String get homeSpeedDial => '빠른 실행';

  @override
  String get homeNoContent => '콘텐츠가 없습니다';

  @override
  String get homeRefresh => '새로고침';

  @override
  String get homeLoadError => '피드를 불러오지 못했습니다.';

  @override
  String get homeRetry => '다시 시도';

  @override
  String get importSuccess => 'Spotify에 연결되었습니다!';

  @override
  String importFailed(String error) {
    return '연결 실패: $error';
  }

  @override
  String get importTitle => 'Spotify 연결';

  @override
  String get importSetupTitle => 'Spotify 설정';

  @override
  String get importSetupDesc => '개발자 키를 사용하여 플레이리스트를 빠르게 가져옵니다:';

  @override
  String get importStep1 => 'Spotify Developer Dashboard를 엽니다.';

  @override
  String get importStep2 => '로그인 후 \'Create app\'을 클릭합니다.';

  @override
  String get importStep3 => '앱 이름과 설명을 입력합니다.';

  @override
  String get importStep4 => '\'Redirect URIs\'에 다음 URL을 붙여넣습니다:';

  @override
  String get importRedirectCopied => 'URL이 복사되었습니다!';

  @override
  String get importStep5 => '저장 후 \'Client ID\'를 복사하여 아래에 붙여넣습니다.';

  @override
  String get importImportant => '중요: 활성화된 Spotify Premium 구독이 필요합니다.';

  @override
  String get importClientIdHint => 'Client ID 입력...';

  @override
  String get importConnectButton => '연결 및 라이브러리 불러오기';

  @override
  String get downloadingNoActive => '다운로드 중인 곡이 없습니다';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => '다운로드';

  @override
  String downloadsStats(String count, String size) {
    return '$count곡 • $size';
  }

  @override
  String get downloadsNoOffline => '오프라인 곡이 없습니다';

  @override
  String get downloadsNoOfflineDesc => '다운로드한 곡이 여기에 표시됩니다';

  @override
  String get downloadsClearAllTitle => '모두 지우시겠습니까?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return '$count곡이 삭제되고 $size의 저장 공간이 확보됩니다.';
  }

  @override
  String get downloadsCancel => '취소';

  @override
  String get downloadsClearAll => '모두 지우기';

  @override
  String downloadsSongsCount(String count) {
    return '$count곡';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count곡';
  }

  @override
  String get downloadsCannotRenameMaster => '기본 다운로드 플레이리스트는 이름을 변경할 수 없습니다.';

  @override
  String get downloadsRename => '이름 변경';

  @override
  String get downloadsEditSongs => '곡 편집';

  @override
  String get downloadsDelete => '삭제';

  @override
  String get downloadsRenamePlaylistTitle => '이름 변경';

  @override
  String get downloadsRenamePlaylistDesc => '플레이리스트의 새 이름을 입력하세요.';

  @override
  String get downloadsDeletePlaylistTitle => '플레이리스트 삭제?';

  @override
  String get downloadsDeleteMasterDesc =>
      '정말 삭제하시겠습니까? 다운로드한 모든 곡과 플레이리스트가 영구적으로 손실됩니다.';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return '정말 \'$name\'을(를) 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';
  }

  @override
  String get downloadsSave => '저장';

  @override
  String get downloadsNoSongs => '이 플레이리스트에는 곡이 없습니다.';

  @override
  String get libraryTitle => '라이브러리';

  @override
  String get libraryPauseAll => '모두 일시 정지';

  @override
  String get libraryResumeAll => '모두 다시 시작';

  @override
  String get libraryTabPlaylists => '플레이리스트';

  @override
  String get libraryTabDownloads => '다운로드';

  @override
  String get libraryTabDownloading => '다운로드 중';

  @override
  String libraryImportedTask(String name) {
    return '$name 가져옴';
  }

  @override
  String get libraryImportWaiting => '대기 중...';

  @override
  String get libraryImportFetching => '플레이리스트 가져오는 중...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total 처리됨 · $matched 일치';
  }

  @override
  String get libraryImportSaving => '저장 중...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched곡 추가됨 · ×를 눌러 닫기';
  }

  @override
  String get libraryImportDoneAll => '모든 곡이 추가됨 · ×를 눌러 닫기';

  @override
  String get libraryAddButton => '추가';

  @override
  String get librarySortRecent => '최근 추가순';

  @override
  String get librarySortAlpha => '알파벳순';

  @override
  String get libraryEmptyTitle => '라이브러리가 비어 있습니다.';

  @override
  String get libraryEmptyDesc => '\'추가\'를 눌러 시작하세요.';

  @override
  String get libraryRenameLikedError => '\'좋아요 표시한 곡\'은 이름을 변경할 수 없습니다.';

  @override
  String get libraryRename => '이름 변경';

  @override
  String get libraryEditSongs => '곡 편집';

  @override
  String get libraryDeleteLikedError => '\'좋아요 표시한 곡\'은 삭제할 수 없습니다.';

  @override
  String get libraryDelete => '삭제';

  @override
  String get libraryEditSongsTitle => '곡 편집';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count곡';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count곡';
  }

  @override
  String get libraryCancel => '취소';

  @override
  String get librarySave => '저장';

  @override
  String get libraryNoSongs => '이 플레이리스트에는 곡이 없습니다.';

  @override
  String get libraryAddOptionsTitle => '라이브러리에 추가';

  @override
  String get libraryAddOptionsDesc => '어디에서 가져올까요?';

  @override
  String get libraryImportPulse => 'Pulse에서';

  @override
  String get libraryImportPulseDesc => 'Pulse URL 붙여넣기';

  @override
  String get libraryImportYtm => 'YT Music에서';

  @override
  String get libraryImportYtmDesc => '공개 URL 붙여넣기';

  @override
  String get libraryImportSpotify => 'Spotify에서';

  @override
  String get libraryImportSpotifyDesc => 'Spotify 연결';

  @override
  String get libraryClose => '닫기';

  @override
  String get libraryImportYtmFull => 'YouTube Music에서 가져오기';

  @override
  String get libraryImportSpotifyFull => 'Spotify에서 가져오기 (최대 100곡)';

  @override
  String get libraryImportYtmUrlDesc => 'YouTube Music의 공개 플레이리스트 URL을 붙여넣으세요';

  @override
  String get libraryImportSpotifyUrlDesc => 'Spotify의 공개 플레이리스트 URL을 붙여넣으세요';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Pulse 플레이리스트를 가져오지 못했습니다';

  @override
  String get importErrorPlaylist => '가져오기 오류';

  @override
  String get importErrorHighlyPopulated => '플레이리스트가 커서 시간이 걸릴 수 있습니다.';

  @override
  String get libraryImportBtn => '가져오기';

  @override
  String get libraryCreateTitle => '새 플레이리스트';

  @override
  String get libraryCreateDesc => '플레이리스트 이름을 입력하세요';

  @override
  String get libraryCreateHint => '예: 드라이브 음악';

  @override
  String get libraryCreateBtn => '만들기';

  @override
  String get libraryRenameTitle => '이름 변경';

  @override
  String get libraryRenameDesc => '새로운 이름을 입력하세요.';

  @override
  String get libraryRenameBtn => '저장';

  @override
  String get libraryDeleteTitle => '플레이리스트 삭제?';

  @override
  String libraryDeleteDesc(String name) {
    return '정말 \'$name\'을(를) 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';
  }

  @override
  String get libraryDeleteBtn => '삭제';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => '최근';

  @override
  String librarySongsCount(String count) {
    return '$count곡';
  }

  @override
  String get libraryComingSoon => '출시 예정';

  @override
  String get loginErrName => '이름을 입력하세요';

  @override
  String get loginErrEmail => '이메일을 입력하세요';

  @override
  String get loginErrPassword => '비밀번호를 입력하세요';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => '음악을 느껴보세요!';

  @override
  String get loginMadeWithHeartBy => '정성을 담아 제작함: ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => '이름';

  @override
  String get loginHintEmail => '이메일 주소';

  @override
  String get loginHintPassword => '비밀번호';

  @override
  String get loginErrEmailReset => '재설정할 이메일을 입력하세요';

  @override
  String get loginResetSent => '전송 완료! 받은 편지함을 확인하세요.';

  @override
  String get loginForgotPwd => '비밀번호를 잊으셨나요?';

  @override
  String get loginBtnSignup => '계정 만들기';

  @override
  String get loginBtnSignin => '로그인';

  @override
  String get loginToggleHaveAccount => '이미 계정이 있으신가요? ';

  @override
  String get loginToggleNoAccount => '계정이 없으신가요? ';

  @override
  String get loginToggleSignin => '로그인';

  @override
  String get loginToggleSignup => '가입하기';

  @override
  String get offlineStillOffline => '여전히 오프라인 상태입니다. 연결을 확인하세요.';

  @override
  String get offlineTitle => '오프라인 상태입니다';

  @override
  String get offlineSubtitle => '인터넷 연결이 없습니다.\n네트워크를 확인하고 다시 시도하세요.';

  @override
  String get offlineChecking => '확인 중...';

  @override
  String get offlineRetry => '다시 시도';

  @override
  String get offlineGoToDownloads => '다운로드로 이동';

  @override
  String get playerMadeWithHeartBy => '정성을 담아 제작함: ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => '스와이프하여 가사 보기';

  @override
  String get playerNoLyrics => '가사가 없습니다';

  @override
  String get playerUpNext => '다음 곡';

  @override
  String get playerNoTracksInQueue => '대기열에 곡이 없습니다';

  @override
  String get playerNoMusicPlaying => '재생 중인 곡이 없습니다';

  @override
  String get playerPickAVibe => '곡을 선택하세요';

  @override
  String get playerGoHome => '홈으로 가기';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => '이퀄라이저';

  @override
  String get playerEqCustom => '사용자 지정';

  @override
  String get playlistDownloads => '다운로드';

  @override
  String get playlistOffline => '오프라인';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hours시간 $mins분';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$mins분';
  }

  @override
  String get playlistFindOnPage => '페이지에서 찾기';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count곡 • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => '최근';

  @override
  String get playlistNoMatches => '결과가 없습니다.';

  @override
  String get playlistNoTracks => '이 플레이리스트에는 곡이 없습니다.';

  @override
  String get playlistNoSongsYet => '아직 곡이 없습니다.';

  @override
  String get playlistSortRecentlyAdded => '최근 추가순';

  @override
  String get playlistSortAlphabetical => '알파벳순';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '곡',
      one: '곡',
    );
    return '$count $_temp0 다운로드 중';
  }

  @override
  String get playlistView => '보기';

  @override
  String get playlistAllDownloaded => '모두 다운로드됨';

  @override
  String playlistShareText(String name, String url) {
    return 'Pulse에서 \'$name\'을(를) 들어보세요!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => '다운로드에서 삭제';

  @override
  String get playlistRemoveFromPlaylist => '플레이리스트에서 삭제';

  @override
  String get playlistLoadError => '불러오지 못했습니다.';

  @override
  String get playlistGoBack => '← 뒤로 가기';

  @override
  String get profileNotLoggedIn => '로그인되지 않음';

  @override
  String get profileSignIn => '로그인';

  @override
  String get profileDefaultUser => 'Pulse 사용자';

  @override
  String get profileEditProfile => '프로필 편집';

  @override
  String get profileTimeframeDay => '일';

  @override
  String get profileTimeframeWeek => '주';

  @override
  String get profileTimeframeMonth => '월';

  @override
  String get profileTimeframeYear => '년';

  @override
  String get profileListeningTime => '재생 시간';

  @override
  String get profileToday => '오늘';

  @override
  String get profileThisWeek => '이번 주';

  @override
  String get profileThisMonth => '이번 달';

  @override
  String get profileThisYear => '올해';

  @override
  String get profileDailyAvg => '일일 평균';

  @override
  String get profilePerDay => '/일';

  @override
  String get profileLifetimeListening => '전체';

  @override
  String get profileTotalTimeListened => 'Pulse 총 청취 시간';

  @override
  String get profileYourTopSongs => '인기 곡';

  @override
  String get profileListeningHistoryEmpty => '여기에 기록이 표시됩니다.';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '회 재생',
      one: '회 재생',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => '인기 아티스트';

  @override
  String get profileTopArtistsEmpty => '즐겨찾는 아티스트가 여기에 표시됩니다.';

  @override
  String get profileArtistLabel => '아티스트';

  @override
  String get profileSignOut => '로그아웃';

  @override
  String profileVersion(String version) {
    return '버전 $version';
  }

  @override
  String get profileMadeWithHeartBy => '정성을 담아 제작함: ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => '프로필 편집';

  @override
  String get profileDisplayName => '표시 이름';

  @override
  String get profileCancel => '취소';

  @override
  String get profileSave => '저장';

  @override
  String get profileChooseAvatar => '아바타 선택';

  @override
  String get searchMicPermissionRequired => '마이크 권한이 필요합니다';

  @override
  String get searchUnknownSong => '알 수 없는 곡';

  @override
  String get searchUnknownArtist => '알 수 없는 아티스트';

  @override
  String get searchNoSongDetected => '곡을 인식할 수 없습니다.';

  @override
  String searchError(String message) {
    return '오류: $message';
  }

  @override
  String get searchSpeechNotAvailable => '음성 검색을 사용할 수 없습니다';

  @override
  String get searchHint => '곡, 아티스트, 앨범...';

  @override
  String get searchRecentEmpty => '검색 기록이 여기에 표시됩니다';

  @override
  String get searchRecentSearches => '최근 검색';

  @override
  String get searchClearAll => '모두 지우기';

  @override
  String searchNoResultsFor(String query) {
    return '\'$query\'에 대한 결과가 없습니다';
  }

  @override
  String get searchTryDifferentKeywords => '다른 검색어를 시도해 보세요';

  @override
  String get searchTopResult => '최고 결과';

  @override
  String get searchSongsLabel => '곡';

  @override
  String get searchArtistsLabel => '아티스트';

  @override
  String get searchAlbumsLabel => '앨범';

  @override
  String get searchPlaylistsLabel => '플레이리스트';

  @override
  String get searchArtistLabel => '아티스트';

  @override
  String get searchListening => '듣고 있습니다...';

  @override
  String get searchSpeakNow => '말씀해 주세요';

  @override
  String get searchCancel => '취소';

  @override
  String get searchIdentifying => '인식 중...';

  @override
  String get searchListeningForSong => '곡을 찾는 중...';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsStreamingQuality => '스트리밍 품질';

  @override
  String get settingsQualityAutomatic => '자동';

  @override
  String get settingsQualityLow => '낮음';

  @override
  String get settingsQualityNormal => '보통';

  @override
  String get settingsQualityHigh => '높음';

  @override
  String get settingsDownloadQuality => '다운로드 품질';

  @override
  String get settingsPlayback => '재생';

  @override
  String get settingsCrossfade => '크로스페이드';

  @override
  String get settingsCrossfadeDesc => '곡 사이를 부드럽게 전환합니다';

  @override
  String get settingsDataUsage => '데이터 사용량';

  @override
  String get settingsDataSaver => '데이터 절약';

  @override
  String get settingsDataSaverDesc => '모바일 네트워크에서 낮은 품질로 재생';

  @override
  String get settingsAppearance => '화면 설정';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsCustomAccent => '강조 색상';

  @override
  String get settingsSaturation => '채도';

  @override
  String get settingsBrightness => '밝기';

  @override
  String get settingsResetDefault => '기본값으로 초기화';

  @override
  String get playlistSheetTitle => '플레이리스트에 추가';

  @override
  String get playlistSheetNewPlaylist => '새 플레이리스트';

  @override
  String get playlistSheetNoPlaylists => '플레이리스트가 없습니다';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '곡',
      one: '곡',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => '플레이리스트 이름';

  @override
  String get playlistSheetCancel => '취소';

  @override
  String playlistSheetAddedTo(String name) {
    return '$name에 추가됨';
  }

  @override
  String get playlistSheetCreateFailAuth => '오류: 인증 실패';

  @override
  String playlistSheetCreateFail(String error) {
    return '오류: $error';
  }

  @override
  String get playlistSheetCreate => '만들기';

  @override
  String get appUpdateAvailable => '업데이트 가능';

  @override
  String appUpdateDesc(String version) {
    return '버전 $version이 출시되었습니다!';
  }

  @override
  String get appUpdateDownload => '다운로드';

  @override
  String get navHome => '홈';

  @override
  String get navLibrary => '라이브러리';

  @override
  String get navSearch => '검색';

  @override
  String get navSettings => '설정';

  @override
  String get navProfile => '프로필';

  @override
  String get artistSelect => '아티스트 선택';

  @override
  String get songActionQueue => '대기열에 추가';

  @override
  String get songActionPlaylist => '플레이리스트에 추가';

  @override
  String get songActionFinding => '검색 중...';

  @override
  String get songActionAlbum => '앨범으로 이동';

  @override
  String get songActionArtist => '아티스트로 이동';

  @override
  String get songActionRemovePlaylist => '플레이리스트에서 삭제';

  @override
  String get songActionRemoveDownload => '다운로드에서 삭제';

  @override
  String get songActionDownloadChecking => '확인 중...';

  @override
  String get songActionDownloading => '다운로드 중...';

  @override
  String get songActionDownloaded => '완료!';

  @override
  String get songActionDownloadAlready => '이미 다운로드됨';

  @override
  String get songActionDownloadFailed => '다운로드 실패';

  @override
  String get songActionDownload => '다운로드';

  @override
  String get songActionDownloadingSnack => '다운로드 중';

  @override
  String get songActionView => '보기';

  @override
  String get spotifyImportTitle => 'Spotify에서 가져오기';

  @override
  String get spotifyImportSubtitle => '플레이리스트 크기 선택';

  @override
  String get spotifyChoiceSmallTitle => '100곡 이하';

  @override
  String get spotifyChoiceSmallDesc => '공개 URL을 붙여넣으세요.';

  @override
  String get spotifyChoiceLargeTitle => '100곡 이상';

  @override
  String get spotifyChoiceLargeDesc => 'Spotify Developer 키를 연결합니다.';

  @override
  String get cancelButton => '취소';

  @override
  String get spotifyPlaylistsTitle => 'Spotify 플레이리스트';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return '오류: $error\nClient ID를 확인하세요.';
  }

  @override
  String get spotifyPlaylistsEmpty => '플레이리스트가 없습니다';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count곡';
  }

  @override
  String get spotifyPlaylistsImport => '가져오기';

  @override
  String get audioPlaybackFailed => '재생할 수 없습니다.';

  @override
  String get audioControlPrevious => '이전';

  @override
  String get audioControlPause => '일시 정지';

  @override
  String get audioControlPlay => '재생';

  @override
  String get audioControlNext => '다음';

  @override
  String get audioControlUnlike => '좋아요 취소';

  @override
  String get audioControlLike => '좋아요';

  @override
  String spotifyRawResponseError(String data, String error) {
    return '응답: $data\n\n오류: $error';
  }

  @override
  String get apiErrorInvalidClient => 'Client ID가 잘못되었습니다.';

  @override
  String get apiErrorBadRequest => '잘못된 요청입니다.';

  @override
  String get apiErrorUnauthorized => '권한이 없습니다. 다시 로그인하세요.';

  @override
  String get apiErrorForbidden => '접근이 거부되었습니다.';

  @override
  String get apiErrorNotFound => '찾을 수 없습니다.';

  @override
  String get apiErrorEmailInUse => '이미 사용 중인 이메일입니다.';

  @override
  String get apiErrorUserNotFound => '계정을 찾을 수 없습니다.';

  @override
  String get apiErrorWrongPassword => '비밀번호가 잘못되었습니다.';

  @override
  String get apiErrorInvalidCredential => '로그인 정보가 올바르지 않습니다.';

  @override
  String get apiErrorNetwork => '네트워크 오류입니다.';

  @override
  String get apiErrorSocketTimeout => '시간 초과되었습니다.';

  @override
  String get apiErrorTooManyRequests => '요청이 너무 많습니다.';

  @override
  String get apiErrorServerError => '서버 오류입니다.';

  @override
  String get apiErrorInvalidEmail => '올바른 이메일 주소를 입력하세요.';

  @override
  String get apiErrorWeakPassword => '비밀번호가 너무 약합니다.';

  @override
  String get apiErrorTooManyAttempts => '로그인 시도가 너무 많습니다.';

  @override
  String get homeForgottenFavorites => '잊혀진 즐겨찾기';

  @override
  String get artistShowAll => '모두 보기';

  @override
  String get homeTopTracks => '인기 트랙';
}
