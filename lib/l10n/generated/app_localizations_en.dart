// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'About';

  @override
  String get artistPopular => 'Popular';

  @override
  String get artistAlbums => 'Albums';

  @override
  String get artistSinglesAndEPs => 'Singles & EPs';

  @override
  String artistSubscribersCount(String count) {
    return '$count subscribers';
  }

  @override
  String get artistPlayAll => 'Play All';

  @override
  String get artistLoadError => 'Couldn\'t load artist';

  @override
  String get artistGoBack => 'Go Back';

  @override
  String adminChatFailedToReply(String error) {
    return 'Failed to reply: $error';
  }

  @override
  String get adminChatSupportChat => 'Support Chat';

  @override
  String adminChatError(String error) {
    return 'Error: $error';
  }

  @override
  String get adminChatNoHistory => 'No conversation history.';

  @override
  String get adminChatSupportYou => 'Support (You)';

  @override
  String get adminChatTypeReply => 'Type your reply...';

  @override
  String get broadcastSuccess => 'Announcement broadcasted successfully!';

  @override
  String broadcastFailed(String error) {
    return 'Failed to broadcast: $error';
  }

  @override
  String get broadcastTitle => 'Global Announcements';

  @override
  String get broadcastSubtitle => 'Sent to all users';

  @override
  String get broadcastWarning =>
      'Messages sent here will be visible to everyone.';

  @override
  String broadcastError(String error) {
    return 'Error: $error';
  }

  @override
  String get broadcastNoHistory => 'No previous announcements.';

  @override
  String get broadcastTypeMessage => 'Type a global broadcast...';

  @override
  String commFailedToSend(String error) {
    return 'Failed to send: $error';
  }

  @override
  String get commAdminDashboard => 'Admin Dashboard';

  @override
  String get commAdminSupport => 'Admin Support';

  @override
  String get commAlwaysHere => 'Always here to help';

  @override
  String get commWelcomeTitle => 'Hey! 👋 I\'m Ashutosh Pathak';

  @override
  String get commWelcomeSubtitle => 'Developer of Pulse';

  @override
  String get commWelcomeBody1 =>
      'I hope you\'re enjoying listening to your favorite music without annoying ads or subscription barriers. After all, music shouldn\'t come with a paywall just because someone in a boardroom needed another yacht.\n\nThis section is here so we can connect directly.\n\nFeel free to:';

  @override
  String get commBullet1 => 'Share your feedback';

  @override
  String get commBullet2 => 'Report bugs';

  @override
  String get commBullet3 => 'Suggest new features you\'d like to see';

  @override
  String get commWelcomeBody2 =>
      'I personally read every message and will do my best to improve the app based on your suggestions.\n\nGot an idea for an app that doesn\'t exist yet, or one that\'s locked behind expensive subscriptions? Tell me about it! If it\'s possible, I\'ll try to build it and make it available for everyone.\n\nThanks for using my app and for being part of this journey. ❤️';

  @override
  String commError(String error) {
    return 'Error: $error';
  }

  @override
  String get commNoMessages => 'No messages yet';

  @override
  String get commNoMessagesDesc =>
      'Send a message to our support team or check back later for announcements.';

  @override
  String get commMessageSupportHint => 'Message support...';

  @override
  String get commGlobalAnnouncements => 'Global Announcements';

  @override
  String get commSendMessagesToAll => 'Send messages to all users';

  @override
  String get homeGreetingMorning => 'Good morning,';

  @override
  String get homeGreetingAfternoon => 'Good afternoon,';

  @override
  String get homeGreetingEvening => 'Good evening,';

  @override
  String get homeMember => 'Member';

  @override
  String get homeRecentPlaylists => 'Recent Playlists';

  @override
  String get homeRecentlyPlayed => 'Recently played';

  @override
  String get homeSpeedDial => 'Speed dial';

  @override
  String get homeNoContent => 'No content available';

  @override
  String get homeRefresh => 'Refresh';

  @override
  String get homeLoadError => 'Couldn\'t load music feed.';

  @override
  String get homeRetry => 'Retry';

  @override
  String get importSuccess => 'Successfully Connected to Spotify!';

  @override
  String importFailed(String error) {
    return 'Failed to connect: $error';
  }

  @override
  String get importTitle => 'Connect Spotify';

  @override
  String get importSetupTitle => 'Setup Spotify Integration';

  @override
  String get importSetupDesc =>
      'To bypass Spotify\'s strict rate limits and import all your playlists instantly, you must use your own free developer key. Follow these simple steps:';

  @override
  String get importStep1 => 'Open the Spotify Developer Dashboard.';

  @override
  String get importStep2 => 'Log in and click \"Create app\".';

  @override
  String get importStep3 => 'Fill in any App Name and Description.';

  @override
  String get importStep4 =>
      'Under \"Redirect URIs\", paste the following exact URL:';

  @override
  String get importRedirectCopied => 'Redirect URI Copied!';

  @override
  String get importStep5 =>
      'Save the app, copy your \"Client ID\" from settings, and paste it below.';

  @override
  String get importImportant =>
      'Important: The Spotify account used to create this developer app must have an active Premium subscription.';

  @override
  String get importClientIdHint => 'Paste your Spotify Client ID here...';

  @override
  String get importConnectButton => 'Connect & Load Library';

  @override
  String get downloadingNoActive => 'No active downloads';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'Downloads';

  @override
  String downloadsStats(String count, String size) {
    return '$count songs • $size';
  }

  @override
  String get downloadsNoOffline => 'No offline songs yet';

  @override
  String get downloadsNoOfflineDesc => 'Songs you download will appear here';

  @override
  String get downloadsClearAllTitle => 'Clear All Downloads?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'This will remove $count songs and free up $size of storage.';
  }

  @override
  String get downloadsCancel => 'Cancel';

  @override
  String get downloadsClearAll => 'Clear All';

  @override
  String downloadsSongsCount(String count) {
    return '$count songs';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count song';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'Cannot rename the master downloads playlist.';

  @override
  String get downloadsRename => 'Rename';

  @override
  String get downloadsEditSongs => 'Edit Songs';

  @override
  String get downloadsDelete => 'Delete';

  @override
  String get downloadsRenamePlaylistTitle => 'Rename Playlist';

  @override
  String get downloadsRenamePlaylistDesc =>
      'Enter a new name for your playlist.';

  @override
  String get downloadsDeletePlaylistTitle => 'Delete Playlist?';

  @override
  String get downloadsDeleteMasterDesc =>
      'Are you sure you want to delete this? You will lose all downloaded songs and playlists forever.';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'Are you sure you want to delete \"$name\"? This playlist will be lost forever.';
  }

  @override
  String get downloadsSave => 'Save';

  @override
  String get downloadsNoSongs => 'No songs in this playlist.';

  @override
  String get libraryTitle => 'Library';

  @override
  String get libraryPauseAll => 'Pause all';

  @override
  String get libraryResumeAll => 'Resume all';

  @override
  String get libraryTabPlaylists => 'Playlists';

  @override
  String get libraryTabDownloads => 'Downloads';

  @override
  String get libraryTabDownloading => 'Downloading';

  @override
  String libraryImportedTask(String name) {
    return 'Imported $name';
  }

  @override
  String get libraryImportWaiting => 'Waiting in queue...';

  @override
  String get libraryImportFetching => 'Fetching playlist...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total processed · $matched matched';
  }

  @override
  String get libraryImportSaving => 'Saving to library...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched songs added · tap × to dismiss';
  }

  @override
  String get libraryImportDoneAll => 'All songs added · tap × to dismiss';

  @override
  String get libraryAddButton => 'Add';

  @override
  String get librarySortRecent => 'Recently Added';

  @override
  String get librarySortAlpha => 'Alphabetical';

  @override
  String get libraryEmptyTitle => 'Your library is empty.';

  @override
  String get libraryEmptyDesc => 'Tap \"Add\" to start your first Pulse.';

  @override
  String get libraryRenameLikedError =>
      'Cannot rename the Liked Songs playlist.';

  @override
  String get libraryRename => 'Rename';

  @override
  String get libraryEditSongs => 'Edit Songs';

  @override
  String get libraryDeleteLikedError =>
      'Cannot delete the Liked Songs playlist.';

  @override
  String get libraryDelete => 'Delete';

  @override
  String get libraryEditSongsTitle => 'Edit Songs';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count song';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count songs';
  }

  @override
  String get libraryCancel => 'Cancel';

  @override
  String get librarySave => 'Save';

  @override
  String get libraryNoSongs => 'No songs in this playlist.';

  @override
  String get libraryAddOptionsTitle => 'Add to Library';

  @override
  String get libraryAddOptionsDesc =>
      'Choose how you want to expand your Pulse';

  @override
  String get libraryImportPulse => 'Import from Pulse';

  @override
  String get libraryImportPulseDesc => 'Paste a Pulse playlist URL';

  @override
  String get libraryImportYtm => 'Import from YT Music';

  @override
  String get libraryImportYtmDesc => 'Paste a PUBLIC playlist URL';

  @override
  String get libraryImportSpotify => 'Import from Spotify';

  @override
  String get libraryImportSpotifyDesc => 'Connect your Spotify';

  @override
  String get libraryClose => 'Close';

  @override
  String get libraryImportYtmFull => 'Import from YouTube Music';

  @override
  String get libraryImportSpotifyFull => 'Import from Spotify (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'Paste a PUBLIC YouTube Music playlist or album URL';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'Paste a public Spotify playlist URL below';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Failed to import Pulse playlist';

  @override
  String get importErrorPlaylist => 'Error importing playlist';

  @override
  String get importErrorHighlyPopulated =>
      'Playlist is highly populated, it might take a while to fetch.';

  @override
  String get libraryImportBtn => 'Import';

  @override
  String get libraryCreateTitle => 'New Playlist';

  @override
  String get libraryCreateDesc => 'What should we call your new playlist?';

  @override
  String get libraryCreateHint => 'e.g. Midnight Rides';

  @override
  String get libraryCreateBtn => 'Create';

  @override
  String get libraryRenameTitle => 'Rename Playlist';

  @override
  String get libraryRenameDesc => 'Enter a new name for your playlist.';

  @override
  String get libraryRenameBtn => 'Rename';

  @override
  String get libraryDeleteTitle => 'Delete Playlist?';

  @override
  String libraryDeleteDesc(String name) {
    return 'Are you sure you want to delete \"$name\"? This playlist will be lost forever.';
  }

  @override
  String get libraryDeleteBtn => 'Delete';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'Recent';

  @override
  String librarySongsCount(String count) {
    return '$count Songs';
  }

  @override
  String get libraryComingSoon => 'Coming Soon';

  @override
  String get loginErrName => 'Please enter your name';

  @override
  String get loginErrEmail => 'Please enter your email address';

  @override
  String get loginErrPassword => 'Please enter your password';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'Feel Every Beat!';

  @override
  String get loginMadeWithHeartBy => 'Made with ❤️ by ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'Your name';

  @override
  String get loginHintEmail => 'Email address';

  @override
  String get loginHintPassword => 'Password';

  @override
  String get loginErrEmailReset => 'Please enter your email to reset password';

  @override
  String get loginResetSent => 'Password reset email sent! Check your inbox.';

  @override
  String get loginForgotPwd => 'Forgot Password?';

  @override
  String get loginBtnSignup => 'Create Account';

  @override
  String get loginBtnSignin => 'Sign In';

  @override
  String get loginToggleHaveAccount => 'Already have an Pulse account? ';

  @override
  String get loginToggleNoAccount => 'Don\'t have an Pulse account? ';

  @override
  String get loginToggleSignin => 'Sign In';

  @override
  String get loginToggleSignup => 'Sign Up';

  @override
  String get offlineStillOffline =>
      'Still offline. Please check your connection.';

  @override
  String get offlineTitle => 'You\'re Offline';

  @override
  String get offlineSubtitle =>
      'No internet connection found.\nCheck your network and try again.';

  @override
  String get offlineChecking => 'Checking...';

  @override
  String get offlineRetry => 'Retry';

  @override
  String get offlineGoToDownloads => 'Go to Downloads';

  @override
  String get playerMadeWithHeartBy => 'Made with ❤️ by ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'Swipe for lyrics';

  @override
  String get playerNoLyrics => 'No lyrics available';

  @override
  String get playerUpNext => 'Up Next';

  @override
  String get playerNoTracksInQueue => 'No tracks in queue';

  @override
  String get playerNoMusicPlaying => 'No music playing';

  @override
  String get playerPickAVibe => 'Pick a vibe from your library or home';

  @override
  String get playerGoHome => 'Go Home';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'Equalizer';

  @override
  String get playerEqCustom => 'Custom';

  @override
  String get playlistDownloads => 'Downloads';

  @override
  String get playlistOffline => 'Offline Playlist';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '${hours}h ${mins}min';
  }

  @override
  String playlistDurationMins(String mins) {
    return '${mins}min';
  }

  @override
  String get playlistFindOnPage => 'Find on this page';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count songs • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'Recent';

  @override
  String get playlistNoMatches => 'No matches found.';

  @override
  String get playlistNoTracks => 'No tracks in this playlist.';

  @override
  String get playlistNoSongsYet => 'No songs yet.';

  @override
  String get playlistSortRecentlyAdded => 'Recently Added';

  @override
  String get playlistSortAlphabetical => 'Alphabetical';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'songs',
      one: 'song',
    );
    return 'Downloading $count $_temp0';
  }

  @override
  String get playlistView => 'VIEW';

  @override
  String get playlistAllDownloaded => 'All songs are already downloaded';

  @override
  String playlistShareText(String name, String url) {
    return 'Check out \"$name\" on Pulse!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'Remove from Downloads';

  @override
  String get playlistRemoveFromPlaylist => 'Remove from Playlist';

  @override
  String get playlistLoadError => 'Couldn\'t load this playlist.';

  @override
  String get playlistGoBack => '← Go back';

  @override
  String get profileNotLoggedIn => 'Not logged in';

  @override
  String get profileSignIn => 'Sign In';

  @override
  String get profileDefaultUser => 'Pulse User';

  @override
  String get profileEditProfile => 'Edit Profile';

  @override
  String get profileTimeframeDay => 'Day';

  @override
  String get profileTimeframeWeek => 'Week';

  @override
  String get profileTimeframeMonth => 'Month';

  @override
  String get profileTimeframeYear => 'Year';

  @override
  String get profileListeningTime => 'LISTENING TIME';

  @override
  String get profileToday => 'Today';

  @override
  String get profileThisWeek => 'This week';

  @override
  String get profileThisMonth => 'This month';

  @override
  String get profileThisYear => 'This year';

  @override
  String get profileDailyAvg => 'DAILY AVG';

  @override
  String get profilePerDay => 'Per day';

  @override
  String get profileLifetimeListening => 'LIFETIME LISTENING';

  @override
  String get profileTotalTimeListened =>
      'Total time listened to music on Pulse';

  @override
  String get profileYourTopSongs => 'Your Top Songs';

  @override
  String get profileListeningHistoryEmpty =>
      'Listening history will appear here.';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'plays',
      one: 'play',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => 'Your Top Artists';

  @override
  String get profileTopArtistsEmpty =>
      'Your favorite artists will appear here.';

  @override
  String get profileArtistLabel => 'Artist';

  @override
  String get profileSignOut => 'Sign Out';

  @override
  String profileVersion(String version) {
    return 'Version $version';
  }

  @override
  String get profileMadeWithHeartBy => 'Made with ❤️ by ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'EDIT PROFILE';

  @override
  String get profileDisplayName => 'DISPLAY NAME';

  @override
  String get profileCancel => 'Cancel';

  @override
  String get profileSave => 'Save';

  @override
  String get profileChooseAvatar => 'Choose Avatar';

  @override
  String get searchMicPermissionRequired =>
      'Microphone permission required for this feature';

  @override
  String get searchUnknownSong => 'Unknown Song';

  @override
  String get searchUnknownArtist => 'Unknown Artist';

  @override
  String get searchNoSongDetected => 'No song detected.';

  @override
  String searchError(String message) {
    return 'Error: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'Speech recognition not available';

  @override
  String get searchHint => 'Songs, artists, albums, playlists…';

  @override
  String get searchRecentEmpty => 'Your recent searches appear here';

  @override
  String get searchRecentSearches => 'Recent Searches';

  @override
  String get searchClearAll => 'Clear all';

  @override
  String searchNoResultsFor(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get searchTryDifferentKeywords => 'Try different keywords';

  @override
  String get searchTopResult => 'Top result';

  @override
  String get searchSongsLabel => 'Songs';

  @override
  String get searchArtistsLabel => 'Artists';

  @override
  String get searchAlbumsLabel => 'Albums';

  @override
  String get searchPlaylistsLabel => 'Playlists';

  @override
  String get searchArtistLabel => 'Artist';

  @override
  String get searchListening => 'Listening...';

  @override
  String get searchSpeakNow => 'Speak now to search';

  @override
  String get searchCancel => 'Cancel';

  @override
  String get searchIdentifying => 'Identifying...';

  @override
  String get searchListeningForSong => 'Listening for a song...';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsStreamingQuality => 'Streaming Quality';

  @override
  String get settingsQualityAutomatic => 'Automatic';

  @override
  String get settingsQualityLow => 'Low';

  @override
  String get settingsQualityNormal => 'Normal';

  @override
  String get settingsQualityHigh => 'High';

  @override
  String get settingsDownloadQuality => 'Download Quality';

  @override
  String get settingsPlayback => 'Playback';

  @override
  String get settingsCrossfade => 'Crossfade';

  @override
  String get settingsCrossfadeDesc => 'Overlap tracks for gapless transitions';

  @override
  String get settingsDataUsage => 'Data Usage';

  @override
  String get settingsDataSaver => 'Data Saver';

  @override
  String get settingsDataSaverDesc => 'Stream at lower quality over cellular';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsCustomAccent => 'Custom Accent';

  @override
  String get settingsSaturation => 'Saturation';

  @override
  String get settingsBrightness => 'Brightness';

  @override
  String get settingsResetDefault => 'Reset Default';

  @override
  String get playlistSheetTitle => 'Add to Playlist';

  @override
  String get playlistSheetNewPlaylist => 'New Playlist';

  @override
  String get playlistSheetNoPlaylists => 'No playlists yet';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'songs',
      one: 'song',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => 'Playlist Name';

  @override
  String get playlistSheetCancel => 'Cancel';

  @override
  String playlistSheetAddedTo(String name) {
    return 'Added to $name';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'Failed to create playlist: Authentication error';

  @override
  String playlistSheetCreateFail(String error) {
    return 'Failed to create playlist: $error';
  }

  @override
  String get playlistSheetCreate => 'Create';

  @override
  String get appUpdateAvailable => 'Update Available';

  @override
  String appUpdateDesc(String version) {
    return 'Version $version is here! Update now to get the latest features.';
  }

  @override
  String get appUpdateDownload => 'Download Update';

  @override
  String get navHome => 'Home';

  @override
  String get navLibrary => 'Library';

  @override
  String get navSearch => 'Search';

  @override
  String get navSettings => 'Settings';

  @override
  String get navProfile => 'Profile';

  @override
  String get artistSelect => 'Select Artist';

  @override
  String get songActionQueue => 'Add to Queue';

  @override
  String get songActionPlaylist => 'Add to Playlist';

  @override
  String get songActionFinding => 'Finding...';

  @override
  String get songActionAlbum => 'Go to Album';

  @override
  String get songActionArtist => 'Go to Artist';

  @override
  String get songActionRemovePlaylist => 'Remove from Playlist';

  @override
  String get songActionRemoveDownload => 'Remove from Downloads';

  @override
  String get songActionDownloadChecking => 'Checking...';

  @override
  String get songActionDownloading => 'Downloading...';

  @override
  String get songActionDownloaded => 'Downloaded!';

  @override
  String get songActionDownloadAlready => 'Already downloaded';

  @override
  String get songActionDownloadFailed => 'Download failed';

  @override
  String get songActionDownload => 'Download';

  @override
  String get songActionDownloadingSnack => 'Downloading';

  @override
  String get songActionView => 'VIEW';

  @override
  String get spotifyImportTitle => 'Import from Spotify';

  @override
  String get spotifyImportSubtitle => 'Choose your playlist size';

  @override
  String get spotifyChoiceSmallTitle => '100 songs or fewer';

  @override
  String get spotifyChoiceSmallDesc => 'Paste a public Spotify playlist URL.';

  @override
  String get spotifyChoiceLargeTitle => 'More than 100 songs';

  @override
  String get spotifyChoiceLargeDesc =>
      'Connect your own Spotify Developer App to import unlimited tracks.';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get spotifyPlaylistsTitle => 'Your Spotify Playlists';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'Error: $error\nMake sure your Client ID is valid.';
  }

  @override
  String get spotifyPlaylistsEmpty => 'No playlists found in your library';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count tracks';
  }

  @override
  String get spotifyPlaylistsImport => 'Import';

  @override
  String get audioPlaybackFailed =>
      'Playback failed. Check your internet connection.';

  @override
  String get audioControlPrevious => 'Previous';

  @override
  String get audioControlPause => 'Pause';

  @override
  String get audioControlPlay => 'Play';

  @override
  String get audioControlNext => 'Next';

  @override
  String get audioControlUnlike => 'Unlike';

  @override
  String get audioControlLike => 'Like';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'Raw response: $data\n\nFallback: $error';
  }

  @override
  String get apiErrorInvalidClient => 'Invalid client or client secret.';

  @override
  String get apiErrorBadRequest => 'Bad Request. Please check your inputs.';

  @override
  String get apiErrorUnauthorized => 'Unauthorized. Please log in again.';

  @override
  String get apiErrorForbidden => 'Forbidden. You do not have access.';

  @override
  String get apiErrorNotFound => 'Resource not found.';

  @override
  String get apiErrorEmailInUse => 'This email address is already in use.';

  @override
  String get apiErrorUserNotFound => 'No account found with this email.';

  @override
  String get apiErrorWrongPassword => 'Incorrect password.';

  @override
  String get apiErrorInvalidCredential =>
      'Login failed. Please check your credentials.';

  @override
  String get apiErrorNetwork => 'Network error. Please check your connection.';

  @override
  String get apiErrorSocketTimeout => 'Connection timed out. Please try again.';

  @override
  String get apiErrorTooManyRequests =>
      'Too many requests. Please wait a moment and try again.';

  @override
  String get apiErrorServerError => 'Server error. Please try again later.';

  @override
  String get apiErrorInvalidEmail => 'Please enter a valid email address.';

  @override
  String get apiErrorWeakPassword =>
      'Password is too weak. Use at least 6 characters.';

  @override
  String get apiErrorTooManyAttempts =>
      'Too many failed attempts. Please try again later.';

  @override
  String get homeForgottenFavorites => 'Forgotten Favourites';

  @override
  String get artistShowAll => 'Show all';

  @override
  String get homeTopTracks => 'Top tracks';
}
