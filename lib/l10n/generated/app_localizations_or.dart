// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Oriya (`or`).
class AppLocalizationsOr extends AppLocalizations {
  AppLocalizationsOr([String locale = 'or']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'ବିଷୟରେ';

  @override
  String get artistPopular => 'ଲୋକପ୍ରିୟ';

  @override
  String get artistAlbums => 'ଆଲବମ୍';

  @override
  String get artistSinglesAndEPs => 'ସିଙ୍ଗଲ୍ସ ଏବଂ EP';

  @override
  String artistSubscribersCount(String count) {
    return '$count ସବସ୍କ୍ରାଇବର୍';
  }

  @override
  String get artistPlayAll => 'ସବୁ ଚଲାନ୍ତୁ';

  @override
  String get artistLoadError => 'କଳାକାର ଲୋଡ୍ କରିହେଲାନି';

  @override
  String get artistGoBack => 'ପଛକୁ ଯାଆନ୍ତୁ';

  @override
  String adminChatFailedToReply(String error) {
    return 'ଉତ୍ତର ଦେଇହେଲାନି: $error';
  }

  @override
  String get adminChatSupportChat => 'ସହାୟତା ଚାଟ୍';

  @override
  String adminChatError(String error) {
    return 'ତ୍ରୁଟି: $error';
  }

  @override
  String get adminChatNoHistory => 'କୌଣସି ପୂର୍ବ କଥୋପକଥନ ନାହିଁ।';

  @override
  String get adminChatSupportYou => 'ସହାୟତା (ଆପଣ)';

  @override
  String get adminChatTypeReply => 'ଆପଣଙ୍କର ଉତ୍ତର ଲେଖନ୍ତୁ...';

  @override
  String get broadcastSuccess => 'ଘୋଷଣା ସଫଳତାର ସହ ପ୍ରସାରିତ ହେଲା!';

  @override
  String broadcastFailed(String error) {
    return 'ପ୍ରସାରଣ କରିହେଲାନି: $error';
  }

  @override
  String get broadcastTitle => 'ଗ୍ଲୋବାଲ୍ ଘୋଷଣା';

  @override
  String get broadcastSubtitle => 'ସମସ୍ତ ୟୁଜର୍ସଙ୍କୁ ପଠାଗଲା';

  @override
  String get broadcastWarning => 'ଏଠାରେ ପଠାଯାଇଥିବା ବାର୍ତ୍ତା ସମସ୍ତେ ଦେଖିପାରିବେ।';

  @override
  String broadcastError(String error) {
    return 'ତ୍ରୁଟି: $error';
  }

  @override
  String get broadcastNoHistory => 'କୌଣସି ପୂର୍ବ ଘୋଷଣା ନାହିଁ।';

  @override
  String get broadcastTypeMessage => 'ଏକ ଗ୍ଲୋବାଲ୍ ଘୋଷଣା ଲେଖନ୍ତୁ...';

  @override
  String commFailedToSend(String error) {
    return 'ପଠାଇ ହେଲାନି: $error';
  }

  @override
  String get commAdminDashboard => 'ଆଡମିନ୍ ଡ୍ୟାସବୋର୍ଡ';

  @override
  String get commAdminSupport => 'ଆଡମିନ୍ ସହାୟତା';

  @override
  String get commAlwaysHere => 'ସାହାଯ୍ୟ କରିବାକୁ ସର୍ବଦା ପ୍ରସ୍ତୁତ';

  @override
  String get commWelcomeTitle => 'ନମସ୍କାର! 👋 ମୁଁ ଆଶୁତୋଷ ପାଠକ';

  @override
  String get commWelcomeSubtitle => 'Pulse ର ଡେଭେଲପର୍';

  @override
  String get commWelcomeBody1 =>
      'ମୁଁ ଆଶାକରେ ଆପଣ ବିନା ବିଜ୍ଞାପନ କିମ୍ବା ସବସ୍କ୍ରିପସନ୍ ବାଧାରେ ନିଜର ପ୍ରିୟ ସଙ୍ଗୀତ ଉପଭୋଗ କରୁଛନ୍ତି। ସଙ୍ଗୀତ କେବଳ ଧନୀମାନଙ୍କ ପାଇଁ ସୀମିତ ହେବା ଉଚିତ୍ ନୁହେଁ।\n\nସିଧାସଳଖ ଯୋଗାଯୋଗ କରିବା ପାଇଁ ଏହି ବିଭାଗଟି ଅଛି।\n\nଆପଣ ମତେ ଜଣାଇ ପାରିବେ:';

  @override
  String get commBullet1 => 'ଆପଣଙ୍କ ମତାମତ';

  @override
  String get commBullet2 => 'ତ୍ରୁଟି ରିପୋର୍ଟ';

  @override
  String get commBullet3 => 'ନୂଆ ଫିଚର୍ ପ୍ରସ୍ତାବ';

  @override
  String get commWelcomeBody2 =>
      'ମୁଁ ନିଜେ ପ୍ରତିଟି ମେସେଜ୍ ପଢ଼େ ଏବଂ ଆପଣଙ୍କ ପରାମର୍ଶ ସହ ଆପ୍‌କୁ ଉନ୍ନତ କରିବି।\n\nଆପଣଙ୍କ ପାଖରେ ଏମିତି କୌଣସି ଆପ୍‌ର ଚିନ୍ତାଧାରା ଅଛି କି ଯାହା ସବସ୍କ୍ରିପସନ୍‌ରେ ବନ୍ଧା ଅଛି? ମତେ ଜଣାନ୍ତୁ! ସମ୍ଭବ ହେଲେ ମୁଁ ତାହା ତିଆରି କରି ସମସ୍ତଙ୍କ ପାଇଁ ଦେବି।\n\nଏହି ଯାତ୍ରାରେ ସାମିଲ୍ ହୋଇଥିବାରୁ ଧନ୍ୟବାଦ। ❤️';

  @override
  String commError(String error) {
    return 'ତ୍ରୁଟି: $error';
  }

  @override
  String get commNoMessages => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ବାର୍ତ୍ତା ନାହିଁ';

  @override
  String get commNoMessagesDesc =>
      'ଆମର ସହାୟତା ଟିମ୍‌କୁ ମେସେଜ୍ କରନ୍ତୁ କିମ୍ବା ପରେ ପୁଣି ଦେଖନ୍ତୁ।';

  @override
  String get commMessageSupportHint => 'ସହାୟତା ଟିମ୍‌କୁ ଲେଖନ୍ତୁ...';

  @override
  String get commGlobalAnnouncements => 'ଗ୍ଲୋବାଲ୍ ଘୋଷଣା';

  @override
  String get commSendMessagesToAll => 'ସମସ୍ତ ୟୁଜର୍ସଙ୍କୁ ମେସେଜ୍ ପଠାନ୍ତୁ';

  @override
  String get homeGreetingMorning => 'ଶୁଭ ସକାଳ,';

  @override
  String get homeGreetingAfternoon => 'ଶୁଭ ଅପରାହ୍ନ,';

  @override
  String get homeGreetingEvening => 'ଶୁଭ ସନ୍ଧ୍ୟା,';

  @override
  String get homeMember => 'ସଦସ୍ୟ';

  @override
  String get homeRecentPlaylists => 'ସାମ୍ପ୍ରତିକ ପ୍ଲେଲିଷ୍ଟ';

  @override
  String get homeRecentlyPlayed => 'ସମ୍ପ୍ରତି ବଜାଯାଇଥିବା';

  @override
  String get homeSpeedDial => 'ସ୍ପିଡ୍ ଡାଏଲ୍';

  @override
  String get homeNoContent => 'କୌଣସି ବିଷୟବସ୍ତୁ ନାହିଁ';

  @override
  String get homeRefresh => 'ରିଫ୍ରେସ୍';

  @override
  String get homeLoadError => 'ମ୍ୟୁଜିକ୍ ଫିଡ୍ ଲୋଡ୍ କରିହେଲାନି।';

  @override
  String get homeRetry => 'ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ';

  @override
  String get importSuccess => 'ସଫଳତାର ସହ Spotify ସଂଯୁକ୍ତ ହେଲା!';

  @override
  String importFailed(String error) {
    return 'ସଂଯୁକ୍ତ କରିହେଲାନି: $error';
  }

  @override
  String get importTitle => 'Spotify ସଂଯୁକ୍ତ କରନ୍ତୁ';

  @override
  String get importSetupTitle => 'Spotify ସେଟଅପ୍';

  @override
  String get importSetupDesc =>
      'Spotify ସୀମାବଦ୍ଧତାକୁ ଏଡାଇ ଆପଣଙ୍କ ପ୍ଲେଲିଷ୍ଟଗୁଡ଼ିକୁ ଶୀଘ୍ର ଇମ୍ପୋର୍ଟ କରିବା ପାଇଁ ଆପଣଙ୍କ ନିଜ ଡେଭେଲପର୍ କି ବ୍ୟବହାର କରନ୍ତୁ। ଏହି ପଦକ୍ଷେପଗୁଡିକ ଅନୁସରଣ କରନ୍ତୁ:';

  @override
  String get importStep1 => 'Spotify Developer Dashboard ଖୋଲନ୍ତୁ।';

  @override
  String get importStep2 => 'ଲଗଇନ୍ କରନ୍ତୁ ଏବଂ \"Create app\" କ୍ଲିକ୍ କରନ୍ତୁ।';

  @override
  String get importStep3 => 'କୌଣସି ଆପ୍ ନାମ ଏବଂ ବିବରଣୀ ଦିଅନ୍ତୁ।';

  @override
  String get importStep4 =>
      '\"Redirect URIs\" ତଳେ ଏହି ନିର୍ଦ୍ଦିଷ୍ଟ URL ପେଷ୍ଟ କରନ୍ତୁ:';

  @override
  String get importRedirectCopied => 'ରିଡାଇରେକ୍ଟ URI କପି ହେଲା!';

  @override
  String get importStep5 =>
      'ଆପ୍ ସେଭ୍ କରନ୍ତୁ, ସେଟିଂସ୍‌ରୁ ଆପଣଙ୍କର \"Client ID\" କପି କରନ୍ତୁ ଏବଂ ତଳେ ପେଷ୍ଟ କରନ୍ତୁ।';

  @override
  String get importImportant =>
      'ଗୁରୁତ୍ୱପୂର୍ଣ୍ଣ: ଏହି ଡେଭେଲପର୍ ଆପ୍ ତିଆରି କରିବା ପାଇଁ ବ୍ୟବହୃତ Spotify ଆକାଉଣ୍ଟରେ ଆକ୍ଟିଭ୍ ପ୍ରିମିୟମ୍ ସବସ୍କ୍ରିପସନ୍ ଥିବା ଆବଶ୍ୟକ।';

  @override
  String get importClientIdHint =>
      'ଆପଣଙ୍କର Spotify Client ID ଏଠାରେ ପେଷ୍ଟ କରନ୍ତୁ...';

  @override
  String get importConnectButton => 'ସଂଯୁକ୍ତ କରନ୍ତୁ ଓ ଲାଇବ୍ରେରୀ ଲୋଡ୍ କରନ୍ତୁ';

  @override
  String get downloadingNoActive => 'କୌଣସି ଆକ୍ଟିଭ୍ ଡାଉନଲୋଡ୍ ନାହିଁ';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'ଡାଉନଲୋଡ୍';

  @override
  String downloadsStats(String count, String size) {
    return '$count ଗୀତ • $size';
  }

  @override
  String get downloadsNoOffline => 'କୌଣସି ଅଫଲାଇନ୍ ଗୀତ ନାହିଁ';

  @override
  String get downloadsNoOfflineDesc =>
      'ଆପଣ ଡାଉନଲୋଡ୍ କରିଥିବା ଗୀତଗୁଡ଼ିକ ଏଠାରେ ଦେଖାଯିବ';

  @override
  String get downloadsClearAllTitle => 'ସବୁ କ୍ଲିୟର୍ କରିବେ କି?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'ଏହା $count ଗୀତ ଡିଲିଟ୍ କରିବ ଏବଂ $size ଷ୍ଟୋରେଜ୍ ଖାଲି କରିବ।';
  }

  @override
  String get downloadsCancel => 'ବାତିଲ୍';

  @override
  String get downloadsClearAll => 'ସବୁ କ୍ଲିୟର୍';

  @override
  String downloadsSongsCount(String count) {
    return '$count ଗୀତ';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count ଗୀତ';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'ମେନ୍ ଡାଉନଲୋଡ୍ ପ୍ଲେଲିଷ୍ଟର ନାମ ବଦଳାଯାଇପାରିବ ନାହିଁ।';

  @override
  String get downloadsRename => 'ନାମ ପରିବର୍ତ୍ତନ';

  @override
  String get downloadsEditSongs => 'ଗୀତ ଏଡିଟ୍ କରନ୍ତୁ';

  @override
  String get downloadsDelete => 'ଡିଲିଟ୍ କରନ୍ତୁ';

  @override
  String get downloadsRenamePlaylistTitle => 'ପ୍ଲେଲିଷ୍ଟର ନାମ ପରିବର୍ତ୍ତନ';

  @override
  String get downloadsRenamePlaylistDesc => 'ପ୍ଲେଲିଷ୍ଟ ପାଇଁ ନୂଆ ନାମ ଲେଖନ୍ତୁ।';

  @override
  String get downloadsDeletePlaylistTitle => 'ପ୍ଲେଲିଷ୍ଟ ଡିଲିଟ୍ କରିବେ କି?';

  @override
  String get downloadsDeleteMasterDesc =>
      'ଆପଣ ନିଶ୍ଚିତ କି? ଆପଣ ସମସ୍ତ ଡାଉନଲୋଡ୍ ହୋଇଥିବା ଗୀତ ଏବଂ ପ୍ଲେଲିଷ୍ଟ ସବୁଦିନ ପାଇଁ ହରାଇବେ।';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'ଆପଣ ନିଶ୍ଚିତ କି ଆପଣ \"$name\" ଡିଲିଟ୍ କରିବାକୁ ଚାହୁଁଛନ୍ତି? ଏହି ପ୍ଲେଲିଷ୍ଟଟି ସବୁଦିନ ପାଇଁ ହଜିଯିବ।';
  }

  @override
  String get downloadsSave => 'ସେଭ୍ କରନ୍ତୁ';

  @override
  String get downloadsNoSongs => 'ଏହି ପ୍ଲେଲିଷ୍ଟରେ କୌଣସି ଗୀତ ନାହିଁ।';

  @override
  String get libraryTitle => 'ଲାଇବ୍ରେରୀ';

  @override
  String get libraryPauseAll => 'ସବୁ ପଜ୍ କରନ୍ତୁ';

  @override
  String get libraryResumeAll => 'ସବୁ ପୁନରାରମ୍ଭ';

  @override
  String get libraryTabPlaylists => 'ପ୍ଲେଲିଷ୍ଟ';

  @override
  String get libraryTabDownloads => 'ଡାଉନଲୋଡ୍';

  @override
  String get libraryTabDownloading => 'ଡାଉନଲୋଡିଂ';

  @override
  String libraryImportedTask(String name) {
    return '$name ଇମ୍ପୋର୍ଟ ହୋଇଛି';
  }

  @override
  String get libraryImportWaiting => 'ଅପେକ୍ଷା କରୁଛି...';

  @override
  String get libraryImportFetching => 'ପ୍ଲେଲିଷ୍ଟ ଆଣୁଛି...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total ପ୍ରକ୍ରିୟାକରଣ ହୋଇଛି · $matched ମିଳିଲା';
  }

  @override
  String get libraryImportSaving => 'ଲାଇବ୍ରେରୀରେ ସେଭ୍ କରୁଛି...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched ଗୀତ ଯୋଗ କରାଗଲା · ବନ୍ଦ କରିବାକୁ × ଦବାନ୍ତୁ';
  }

  @override
  String get libraryImportDoneAll =>
      'ସମସ୍ତ ଗୀତ ଯୋଗ କରାଗଲା · ବନ୍ଦ କରିବାକୁ × ଦବାନ୍ତୁ';

  @override
  String get libraryAddButton => 'ଯୋଗ କରନ୍ତୁ';

  @override
  String get librarySortRecent => 'ସମ୍ପ୍ରତି ଯୋଗ';

  @override
  String get librarySortAlpha => 'ବର୍ଣ୍ଣମାଳା ଅନୁଯାୟୀ';

  @override
  String get libraryEmptyTitle => 'ଆପଣଙ୍କର ଲାଇବ୍ରେରୀ ଖାଲି ଅଛି।';

  @override
  String get libraryEmptyDesc =>
      'ଆପଣଙ୍କର ପ୍ରଥମ Pulse ଆରମ୍ଭ କରିବାକୁ \"ଯୋଗ କରନ୍ତୁ\" ଦବାନ୍ତୁ।';

  @override
  String get libraryRenameLikedError =>
      'Liked Songs ପ୍ଲେଲିଷ୍ଟର ନାମ ବଦଳାଯାଇପାରିବ ନାହିଁ।';

  @override
  String get libraryRename => 'ନାମ ପରିବର୍ତ୍ତନ';

  @override
  String get libraryEditSongs => 'ଗୀତ ଏଡିଟ୍ କରନ୍ତୁ';

  @override
  String get libraryDeleteLikedError =>
      'Liked Songs ପ୍ଲେଲିଷ୍ଟ ଡିଲିଟ୍ କରାଯାଇପାରିବ ନାହିଁ।';

  @override
  String get libraryDelete => 'ଡିଲିଟ୍ କରନ୍ତୁ';

  @override
  String get libraryEditSongsTitle => 'ଗୀତ ଏଡିଟ୍ କରନ୍ତୁ';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count ଗୀତ';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count ଗୀତ';
  }

  @override
  String get libraryCancel => 'ବାତିଲ୍';

  @override
  String get librarySave => 'ସେଭ୍ କରନ୍ତୁ';

  @override
  String get libraryNoSongs => 'ଏହି ପ୍ଲେଲିଷ୍ଟରେ କୌଣସି ଗୀତ ନାହିଁ।';

  @override
  String get libraryAddOptionsTitle => 'ଲାଇବ୍ରେରୀରେ ଯୋଗ କରନ୍ତୁ';

  @override
  String get libraryAddOptionsDesc =>
      'ଆପଣଙ୍କର Pulse ଲାଇବ୍ରେରୀ କିପରି ବଢାଇବେ ବାଛନ୍ତୁ';

  @override
  String get libraryImportPulse => 'Pulse ରୁ ଇମ୍ପୋର୍ଟ କରନ୍ତୁ';

  @override
  String get libraryImportPulseDesc => 'ଏକ Pulse ପ୍ଲେଲିଷ୍ଟ URL ପେଷ୍ଟ କରନ୍ତୁ';

  @override
  String get libraryImportYtm => 'YT Music ରୁ ଇମ୍ପୋର୍ଟ';

  @override
  String get libraryImportYtmDesc => 'ଏକ ପବ୍ଲିକ୍ ପ୍ଲେଲିଷ୍ଟ URL ପେଷ୍ଟ କରନ୍ତୁ';

  @override
  String get libraryImportSpotify => 'Spotify ରୁ ଇମ୍ପୋର୍ଟ';

  @override
  String get libraryImportSpotifyDesc => 'ଆପଣଙ୍କର Spotify ସଂଯୁକ୍ତ କରନ୍ତୁ';

  @override
  String get libraryClose => 'ବନ୍ଦ କରନ୍ତୁ';

  @override
  String get libraryImportYtmFull => 'YouTube Music ରୁ ଇମ୍ପୋର୍ଟ';

  @override
  String get libraryImportSpotifyFull => 'Spotify ରୁ ଇମ୍ପୋର୍ଟ (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'ଏକ ପବ୍ଲିକ୍ YouTube Music ପ୍ଲେଲିଷ୍ଟ କିମ୍ବା ଆଲବମ୍ URL ପେଷ୍ଟ କରନ୍ତୁ';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'ଏକ ପବ୍ଲିକ୍ Spotify ପ୍ଲେଲିଷ୍ଟ URL ତଳେ ପେଷ୍ଟ କରନ୍ତୁ';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Pulse ପ୍ଲେଲିଷ୍ଟ ଇମ୍ପୋର୍ଟ କରିହେଲାନି';

  @override
  String get importErrorPlaylist => 'ପ୍ଲେଲିଷ୍ଟ ଇମ୍ପୋର୍ଟ କରିବାରେ ତ୍ରୁଟି';

  @override
  String get importErrorHighlyPopulated =>
      'ପ୍ଲେଲିଷ୍ଟ ଅନେକ ବଡ଼, ଆଣିବାକୁ ସମୟ ଲାଗିପାରେ।';

  @override
  String get libraryImportBtn => 'ଇମ୍ପୋର୍ଟ';

  @override
  String get libraryCreateTitle => 'ନୂଆ ପ୍ଲେଲିଷ୍ଟ';

  @override
  String get libraryCreateDesc => 'ଆମେ ଆପଣଙ୍କର ନୂଆ ପ୍ଲେଲିଷ୍ଟର ନାମ କ\'ଣ ଦେବା?';

  @override
  String get libraryCreateHint => 'ଉଦାହରଣ. Midnight Rides';

  @override
  String get libraryCreateBtn => 'ତିଆରି କରନ୍ତୁ';

  @override
  String get libraryRenameTitle => 'ପ୍ଲେଲିଷ୍ଟର ନାମ ପରିବର୍ତ୍ତନ';

  @override
  String get libraryRenameDesc => 'ପ୍ଲେଲିଷ୍ଟ ପାଇଁ ନୂଆ ନାମ ଲେଖନ୍ତୁ।';

  @override
  String get libraryRenameBtn => 'ନାମ ପରିବର୍ତ୍ତନ';

  @override
  String get libraryDeleteTitle => 'ପ୍ଲେଲିଷ୍ଟ ଡିଲିଟ୍ କରିବେ କି?';

  @override
  String libraryDeleteDesc(String name) {
    return 'ଆପଣ ନିଶ୍ଚିତ କି ଆପଣ \"$name\" ଡିଲିଟ୍ କରିବାକୁ ଚାହୁଁଛନ୍ତି? ଏହି ପ୍ଲେଲିଷ୍ଟଟି ସବୁଦିନ ପାଇଁ ହଜିଯିବ।';
  }

  @override
  String get libraryDeleteBtn => 'ଡିଲିଟ୍';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'ସମ୍ପ୍ରତି';

  @override
  String librarySongsCount(String count) {
    return '$count ଗୀତ';
  }

  @override
  String get libraryComingSoon => 'ଖୁବ୍ ଶୀଘ୍ର ଆସୁଛି';

  @override
  String get loginErrName => 'ଦୟାକରି ଆପଣଙ୍କ ନାମ ଦିଅନ୍ତୁ';

  @override
  String get loginErrEmail => 'ଦୟାକରି ଆପଣଙ୍କ ଇମେଲ ଦିଅନ୍ତୁ';

  @override
  String get loginErrPassword => 'ଦୟାକରି ଆପଣଙ୍କ ପାସୱାର୍ଡ ଦିଅନ୍ତୁ';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'ପ୍ରତ୍ୟେକ ବିଟ୍ ଅନୁଭବ କରନ୍ତୁ!';

  @override
  String get loginMadeWithHeartBy => 'ସ୍ନେହର ସହ ପ୍ରସ୍ତୁତ କଲେ: ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'ଆପଣଙ୍କ ନାମ';

  @override
  String get loginHintEmail => 'ଇମେଲ୍ ଠିକଣା';

  @override
  String get loginHintPassword => 'ପାସୱାର୍ଡ';

  @override
  String get loginErrEmailReset => 'ପାସୱାର୍ଡ ରିସେଟ୍ କରିବାକୁ ଇମେଲ୍ ଦିଅନ୍ତୁ';

  @override
  String get loginResetSent => 'ରିସେଟ୍ ଇମେଲ୍ ପଠାଗଲା! ଇନବକ୍ସ ଚେକ୍ କରନ୍ତୁ।';

  @override
  String get loginForgotPwd => 'ପାସୱାର୍ଡ ଭୁଲିଗଲେ କି?';

  @override
  String get loginBtnSignup => 'ଆକାଉଣ୍ଟ ତିଆରି କରନ୍ତୁ';

  @override
  String get loginBtnSignin => 'ସାଇନ୍ ଇନ୍';

  @override
  String get loginToggleHaveAccount => 'ପୂର୍ବରୁ Pulse ଆକାଉଣ୍ଟ ଅଛି କି? ';

  @override
  String get loginToggleNoAccount => 'Pulse ଆକାଉଣ୍ଟ ନାହିଁ? ';

  @override
  String get loginToggleSignin => 'ସାଇନ୍ ଇନ୍';

  @override
  String get loginToggleSignup => 'ସାଇନ୍ ଅପ୍';

  @override
  String get offlineStillOffline => 'ଏବେ ବି ଅଫଲାଇନ୍। ନେଟୱର୍କ ଚେକ୍ କରନ୍ତୁ।';

  @override
  String get offlineTitle => 'ଆପଣ ଅଫଲାଇନ୍ ଅଛନ୍ତି';

  @override
  String get offlineSubtitle =>
      'କୌଣସି ଇଣ୍ଟରନେଟ୍ ନେଟୱର୍କ ନାହିଁ।\nନେଟୱର୍କ ଚେକ୍ କରନ୍ତୁ ଏବଂ ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get offlineChecking => 'ଚେକ୍ କରୁଛି...';

  @override
  String get offlineRetry => 'ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ';

  @override
  String get offlineGoToDownloads => 'ଡାଉନଲୋଡ୍‌କୁ ଯାଆନ୍ତୁ';

  @override
  String get playerMadeWithHeartBy => 'ସ୍ନେହର ସହ ପ୍ରସ୍ତୁତ କଲେ: ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'ଲିରିକ୍ସ ପାଇଁ ସ୍ୱାଇପ୍ କରନ୍ତୁ';

  @override
  String get playerNoLyrics => 'କୌଣସି ଲିରିକ୍ସ ନାହିଁ';

  @override
  String get playerUpNext => 'ପରବର୍ତ୍ତୀ';

  @override
  String get playerNoTracksInQueue => 'ଧାଡ଼ିରେ କୌଣସି ଗୀତ ନାହିଁ';

  @override
  String get playerNoMusicPlaying => 'କୌଣସି ସଙ୍ଗୀତ ବାଜୁନାହିଁ';

  @override
  String get playerPickAVibe => 'ଆପଣଙ୍କର ଲାଇବ୍ରେରୀ ବା ହୋମ୍‌ରୁ ଏକ ଗୀତ ବାଛନ୍ତୁ';

  @override
  String get playerGoHome => 'ହୋମ୍‌କୁ ଯାଆନ୍ତୁ';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'ଇକ୍ୱାଲାଇଜର୍';

  @override
  String get playerEqCustom => 'କଷ୍ଟମ୍';

  @override
  String get playlistDownloads => 'ଡାଉନଲୋଡ୍';

  @override
  String get playlistOffline => 'ଅଫଲାଇନ୍ ପ୍ଲେଲିଷ୍ଟ';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '$hoursଘ $minsମି';
  }

  @override
  String playlistDurationMins(String mins) {
    return '$minsମି';
  }

  @override
  String get playlistFindOnPage => 'ଏହି ପୃଷ୍ଠାରେ ଖୋଜନ୍ତୁ';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count ଗୀତ • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'ସମ୍ପ୍ରତି';

  @override
  String get playlistNoMatches => 'କିଛି ମିଳିଲା ନାହିଁ।';

  @override
  String get playlistNoTracks => 'ଏହି ପ୍ଲେଲିଷ୍ଟରେ କୌଣସି ଗୀତ ନାହିଁ।';

  @override
  String get playlistNoSongsYet => 'ଏପର୍ଯ୍ୟନ୍ତ କୌଣସି ଗୀତ ନାହିଁ।';

  @override
  String get playlistSortRecentlyAdded => 'ସମ୍ପ୍ରତି ଯୋଗ';

  @override
  String get playlistSortAlphabetical => 'ବର୍ଣ୍ଣମାଳା ଅନୁଯାୟୀ';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ଗୀତ',
      one: 'ଗୀତ',
    );
    return '$count $_temp0 ଡାଉନଲୋଡ୍ ହେଉଛି';
  }

  @override
  String get playlistView => 'ଦେଖନ୍ତୁ';

  @override
  String get playlistAllDownloaded => 'ସମସ୍ତ ଗୀତ ପୂର୍ବରୁ ଡାଉନଲୋଡ୍ ହୋଇଛି';

  @override
  String playlistShareText(String name, String url) {
    return 'Pulse ରେ \"$name\" ଶୁଣନ୍ତୁ!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'ଡାଉନଲୋଡ୍‌ରୁ ହଟାନ୍ତୁ';

  @override
  String get playlistRemoveFromPlaylist => 'ପ୍ଲେଲିଷ୍ଟରୁ ହଟାନ୍ତୁ';

  @override
  String get playlistLoadError => 'ଏହି ପ୍ଲେଲିଷ୍ଟ ଲୋଡ୍ କରିହେଲାନି।';

  @override
  String get playlistGoBack => '← ପଛକୁ ଯାଆନ୍ତୁ';

  @override
  String get profileNotLoggedIn => 'ଲଗଇନ୍ ହୋଇନାହିଁ';

  @override
  String get profileSignIn => 'ସାଇନ୍ ଇନ୍';

  @override
  String get profileDefaultUser => 'Pulse ୟୁଜର୍';

  @override
  String get profileEditProfile => 'ପ୍ରୋଫାଇଲ୍ ଏଡିଟ୍';

  @override
  String get profileTimeframeDay => 'ଦିନ';

  @override
  String get profileTimeframeWeek => 'ସପ୍ତାହ';

  @override
  String get profileTimeframeMonth => 'ମାସ';

  @override
  String get profileTimeframeYear => 'ବର୍ଷ';

  @override
  String get profileListeningTime => 'ଶୁଣିବା ସମୟ';

  @override
  String get profileToday => 'ଆଜି';

  @override
  String get profileThisWeek => 'ଏହି ସପ୍ତାହ';

  @override
  String get profileThisMonth => 'ଏହି ମାସ';

  @override
  String get profileThisYear => 'ଏହି ବର୍ଷ';

  @override
  String get profileDailyAvg => 'ଦୈନିକ ହାରାହାରି';

  @override
  String get profilePerDay => 'ପ୍ରତିଦିନ';

  @override
  String get profileLifetimeListening => 'ମୋଟ ଶୁଣିବା ସମୟ';

  @override
  String get profileTotalTimeListened => 'Pulse ରେ ସଙ୍ଗୀତ ଶୁଣିବାର ମୋଟ ସମୟ';

  @override
  String get profileYourTopSongs => 'ଆପଣଙ୍କର ପ୍ରିୟ ଗୀତ';

  @override
  String get profileListeningHistoryEmpty =>
      'ଆପଣଙ୍କର ଶୁଣିବା ଇତିହାସ ଏଠାରେ ଦେଖାଯିବ।';

  @override
  String profilePlays(int count) {
    return '$count ଥର ବାଜିଛି';
  }

  @override
  String get profileYourTopArtists => 'ଆପଣଙ୍କର ପ୍ରିୟ କଳାକାର';

  @override
  String get profileTopArtistsEmpty => 'ଆପଣଙ୍କର ପ୍ରିୟ କଳାକାର ଏଠାରେ ଦେଖାଯିବ।';

  @override
  String get profileArtistLabel => 'କଳାକାର';

  @override
  String get profileSignOut => 'ସାଇନ୍ ଆଉଟ୍';

  @override
  String profileVersion(String version) {
    return 'ଭର୍ସନ $version';
  }

  @override
  String get profileMadeWithHeartBy => 'ସ୍ନେହର ସହ ପ୍ରସ୍ତୁତ କଲେ: ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'ପ୍ରୋଫାଇଲ୍ ଏଡିଟ୍';

  @override
  String get profileDisplayName => 'ପ୍ରଦର୍ଶନ ନାମ';

  @override
  String get profileCancel => 'ବାତିଲ୍';

  @override
  String get profileSave => 'ସେଭ୍ କରନ୍ତୁ';

  @override
  String get profileChooseAvatar => 'ଆଭାତାର ବାଛନ୍ତୁ';

  @override
  String get searchMicPermissionRequired =>
      'ଏହି ଫିଚର୍ ପାଇଁ ମାଇକ୍ରୋଫୋନ୍ ଅନୁମତି ଆବଶ୍ୟକ';

  @override
  String get searchUnknownSong => 'ଅଜ୍ଞାତ ଗୀତ';

  @override
  String get searchUnknownArtist => 'ଅଜ୍ଞାତ କଳାକାର';

  @override
  String get searchNoSongDetected => 'କୌଣସି ଗୀତ ମିଳିଲାନି।';

  @override
  String searchError(String message) {
    return 'ତ୍ରୁଟି: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'ଭଏସ୍ ସର୍ଚ୍ଚ ଉପଲବ୍ଧ ନାହିଁ';

  @override
  String get searchHint => 'ଗୀତ, କଳାକାର, ଆଲବମ୍...';

  @override
  String get searchRecentEmpty => 'ଆପଣଙ୍କର ସାମ୍ପ୍ରତିକ ସର୍ଚ୍ଚ ଏଠାରେ ଦେଖାଯିବ';

  @override
  String get searchRecentSearches => 'ସାମ୍ପ୍ରତିକ ସର୍ଚ୍ଚ';

  @override
  String get searchClearAll => 'ସବୁ କ୍ଲିୟର୍';

  @override
  String searchNoResultsFor(String query) {
    return '\"$query\" ପାଇଁ କୌଣସି ଫଳାଫଳ ନାହିଁ';
  }

  @override
  String get searchTryDifferentKeywords => 'ଅଲଗା ଶବ୍ଦ ସହ ଚେଷ୍ଟା କରନ୍ତୁ';

  @override
  String get searchTopResult => 'ଟପ୍ ରେଜଲ୍ଟ';

  @override
  String get searchSongsLabel => 'ଗୀତ';

  @override
  String get searchArtistsLabel => 'କଳାକାର';

  @override
  String get searchAlbumsLabel => 'ଆଲବମ୍';

  @override
  String get searchPlaylistsLabel => 'ପ୍ଲେଲିଷ୍ଟ';

  @override
  String get searchArtistLabel => 'କଳାକାର';

  @override
  String get searchListening => 'ଶୁଣୁଛି...';

  @override
  String get searchSpeakNow => 'ସର୍ଚ୍ଚ କରିବାକୁ ବର୍ତ୍ତମାନ କୁହନ୍ତୁ';

  @override
  String get searchCancel => 'ବାତିଲ୍';

  @override
  String get searchIdentifying => 'ଚିହ୍ନଟ କରୁଛି...';

  @override
  String get searchListeningForSong => 'ଗୀତ ପାଇଁ ଶୁଣୁଛି...';

  @override
  String get settingsTitle => 'ସେଟିଂସ୍';

  @override
  String get settingsStreamingQuality => 'ଷ୍ଟ୍ରିମିଂ କ୍ୱାଲିଟି';

  @override
  String get settingsQualityAutomatic => 'ସ୍ୱତଃ';

  @override
  String get settingsQualityLow => 'ନିମ୍ନ';

  @override
  String get settingsQualityNormal => 'ସାଧାରଣ';

  @override
  String get settingsQualityHigh => 'ଉଚ୍ଚ';

  @override
  String get settingsDownloadQuality => 'ଡାଉନଲୋଡ୍ କ୍ୱାଲିଟି';

  @override
  String get settingsPlayback => 'ପ୍ଲେବ୍ୟାକ୍';

  @override
  String get settingsCrossfade => 'କ୍ରସ୍‌ଫେଡ୍';

  @override
  String get settingsCrossfadeDesc =>
      'ସ୍ମୁଥ୍ ଟ୍ରାଞ୍ଜିସନ୍ ପାଇଁ ଗୀତଗୁଡ଼ିକୁ ଓଭରଲ୍ୟାପ୍ କରନ୍ତୁ';

  @override
  String get settingsDataUsage => 'ଡାଟା ବ୍ୟବହାର';

  @override
  String get settingsDataSaver => 'ଡାଟା ସେଭର୍';

  @override
  String get settingsDataSaverDesc =>
      'ମୋବାଇଲ୍ ଡାଟାରେ ନିମ୍ନ କ୍ୱାଲିଟିରେ ଷ୍ଟ୍ରିମ୍ କରନ୍ତୁ';

  @override
  String get settingsAppearance => 'ଆପିୟରାନ୍ସ';

  @override
  String get settingsLanguage => 'ଭାଷା';

  @override
  String get settingsCustomAccent => 'କଷ୍ଟମ୍ ଆକ୍ସେଣ୍ଟ';

  @override
  String get settingsSaturation => 'ସ୍ୟାଚୁରେସନ୍';

  @override
  String get settingsBrightness => 'ବ୍ରାଇଟନେସ୍';

  @override
  String get settingsResetDefault => 'ଡିଫଲ୍ଟକୁ ରିସେଟ୍ କରନ୍ତୁ';

  @override
  String get playlistSheetTitle => 'ପ୍ଲେଲିଷ୍ଟରେ ଯୋଗ କରନ୍ତୁ';

  @override
  String get playlistSheetNewPlaylist => 'ନୂଆ ପ୍ଲେଲିଷ୍ଟ';

  @override
  String get playlistSheetNoPlaylists => 'କୌଣସି ପ୍ଲେଲିଷ୍ଟ ନାହିଁ';

  @override
  String playlistSheetSongsCount(int count) {
    return '$count ଗୀତ';
  }

  @override
  String get playlistSheetNameHint => 'ପ୍ଲେଲିଷ୍ଟ ନାମ';

  @override
  String get playlistSheetCancel => 'ବାତିଲ୍';

  @override
  String playlistSheetAddedTo(String name) {
    return '$name ରେ ଯୋଗ କରାଗଲା';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'ତିଆରି କରିହେଲାନି: ଅଥେଣ୍ଟିକେସନ୍ ତ୍ରୁଟି';

  @override
  String playlistSheetCreateFail(String error) {
    return 'ତିଆରି କରିହେଲାନି: $error';
  }

  @override
  String get playlistSheetCreate => 'ତିଆରି କରନ୍ତୁ';

  @override
  String get appUpdateAvailable => 'ଆପ୍‌ଡେଟ୍ ଉପଲବ୍ଧ';

  @override
  String appUpdateDesc(String version) {
    return 'ଭର୍ସନ $version ଆସିଛି! ନୂଆ ଫିଚର୍ସ ପାଇଁ ଅପଡେଟ୍ କରନ୍ତୁ।';
  }

  @override
  String get appUpdateDownload => 'ଅପଡେଟ୍ ଡାଉନଲୋଡ୍ କରନ୍ତୁ';

  @override
  String get navHome => 'ହୋମ୍';

  @override
  String get navLibrary => 'ଲାଇବ୍ରେରୀ';

  @override
  String get navSearch => 'ସର୍ଚ୍ଚ';

  @override
  String get navSettings => 'ସେଟିଂସ୍';

  @override
  String get navProfile => 'ପ୍ରୋଫାଇଲ୍';

  @override
  String get artistSelect => 'କଳାକାର ବାଛନ୍ତୁ';

  @override
  String get songActionQueue => 'ଧାଡ଼ିରେ ଯୋଗ କରନ୍ତୁ';

  @override
  String get songActionPlaylist => 'ପ୍ଲେଲିଷ୍ଟରେ ଯୋଗ କରନ୍ତୁ';

  @override
  String get songActionFinding => 'ଖୋଜୁଛି...';

  @override
  String get songActionAlbum => 'ଆଲବମ୍‌କୁ ଯାଆନ୍ତୁ';

  @override
  String get songActionArtist => 'କଳାକାରଙ୍କ ପାଖକୁ ଯାଆନ୍ତୁ';

  @override
  String get songActionRemovePlaylist => 'ପ୍ଲେଲିଷ୍ଟରୁ ହଟାନ୍ତୁ';

  @override
  String get songActionRemoveDownload => 'ଡାଉନଲୋଡ୍‌ରୁ ହଟାନ୍ତୁ';

  @override
  String get songActionDownloadChecking => 'ଚେକ୍ କରୁଛି...';

  @override
  String get songActionDownloading => 'ଡାଉନଲୋଡ୍ ହେଉଛି...';

  @override
  String get songActionDownloaded => 'ଡାଉନଲୋଡ୍ ହେଲା!';

  @override
  String get songActionDownloadAlready => 'ପୂର୍ବରୁ ଡାଉନଲୋଡ୍ ହୋଇଛି';

  @override
  String get songActionDownloadFailed => 'ଡାଉନଲୋଡ୍ ବିଫଳ ହେଲା';

  @override
  String get songActionDownload => 'ଡାଉନଲୋଡ୍';

  @override
  String get songActionDownloadingSnack => 'ଡାଉନଲୋଡ୍ ହେଉଛି';

  @override
  String get songActionView => 'ଦେଖନ୍ତୁ';

  @override
  String get spotifyImportTitle => 'Spotify ରୁ ଇମ୍ପୋର୍ଟ କରନ୍ତୁ';

  @override
  String get spotifyImportSubtitle => 'ପ୍ଲେଲିଷ୍ଟ ସାଇଜ୍ ବାଛନ୍ତୁ';

  @override
  String get spotifyChoiceSmallTitle => '୧୦୦ ବା ତହିଁରୁ କମ୍ ଗୀତ';

  @override
  String get spotifyChoiceSmallDesc =>
      'ଏକ ପବ୍ଲିକ୍ Spotify ପ୍ଲେଲିଷ୍ଟ URL ପେଷ୍ଟ କରନ୍ତୁ।';

  @override
  String get spotifyChoiceLargeTitle => '୧୦୦ ରୁ ଅଧିକ ଗୀତ';

  @override
  String get spotifyChoiceLargeDesc =>
      'ଅସୀମିତ ଟ୍ରାକ୍ ଇମ୍ପୋର୍ଟ କରିବାକୁ ଆପଣଙ୍କ ନିଜର Spotify Developer App ଯୋଡ଼ନ୍ତୁ।';

  @override
  String get cancelButton => 'ବାତିଲ୍';

  @override
  String get spotifyPlaylistsTitle => 'ଆପଣଙ୍କର Spotify ପ୍ଲେଲିଷ୍ଟ';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'ତ୍ରୁଟି: $error\nଆପଣଙ୍କର Client ID ଠିକ୍ ଅଛି କି ନାହିଁ ଚେକ୍ କରନ୍ତୁ।';
  }

  @override
  String get spotifyPlaylistsEmpty =>
      'ଆପଣଙ୍କର ଲାଇବ୍ରେରୀରେ କୌଣସି ପ୍ଲେଲିଷ୍ଟ ନାହିଁ';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count ଟ୍ରାକ୍';
  }

  @override
  String get spotifyPlaylistsImport => 'ଇମ୍ପୋର୍ଟ';

  @override
  String get audioPlaybackFailed =>
      'ପ୍ଲେବ୍ୟାକ୍ ବିଫଳ ହେଲା। ଇଣ୍ଟରନେଟ୍ ନେଟୱର୍କ ଚେକ୍ କରନ୍ତୁ।';

  @override
  String get audioControlPrevious => 'ପୂର୍ବବର୍ତ୍ତୀ';

  @override
  String get audioControlPause => 'ପଜ୍';

  @override
  String get audioControlPlay => 'ପ୍ଲେ';

  @override
  String get audioControlNext => 'ପରବର୍ତ୍ତୀ';

  @override
  String get audioControlUnlike => 'ଅନଲାଇକ୍';

  @override
  String get audioControlLike => 'ଲାଇକ୍';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'ମୂଳ ରେସପନ୍ସ: $data\n\nଫଲବ୍ୟାକ୍: $error';
  }

  @override
  String get apiErrorInvalidClient =>
      'ଭୁଲ୍ କ୍ଲାଏଣ୍ଟ୍ କିମ୍ବା କ୍ଲାଏଣ୍ଟ୍ ସିକ୍ରେଟ୍।';

  @override
  String get apiErrorBadRequest => 'ଭୁଲ୍ ରିକ୍ୱେଷ୍ଟ। ଦୟାକରି ଚେକ୍ କରନ୍ତୁ।';

  @override
  String get apiErrorUnauthorized => 'ଅନଧିକୃତ। ଦୟାକରି ପୁଣି ଲଗଇନ୍ କରନ୍ତୁ।';

  @override
  String get apiErrorForbidden => 'ନିଷିଦ୍ଧ। ଆପଣଙ୍କର ଆକ୍ସେସ୍ ନାହିଁ।';

  @override
  String get apiErrorNotFound => 'ସମ୍ପଦ ମିଳିଲାନି।';

  @override
  String get apiErrorEmailInUse => 'ଏହି ଇମେଲ୍ ପୂର୍ବରୁ ବ୍ୟବହୃତ ହୋଇଛି।';

  @override
  String get apiErrorUserNotFound => 'ଏହି ଇମେଲ୍ ସହ କୌଣସି ଆକାଉଣ୍ଟ୍ ନାହିଁ।';

  @override
  String get apiErrorWrongPassword => 'ଭୁଲ୍ ପାସୱାର୍ଡ।';

  @override
  String get apiErrorInvalidCredential =>
      'ଲଗଇନ୍ ବିଫଳ ହେଲା। ଆପଣଙ୍କର ତଥ்ய ଚେକ୍ କରନ୍ତୁ।';

  @override
  String get apiErrorNetwork => 'ନେଟୱର୍କ ତ୍ରୁଟି। ଆପଣଙ୍କର ସଂଯୋଗ ଚେକ୍ କରନ୍ତୁ।';

  @override
  String get apiErrorSocketTimeout => 'କନେକସନ୍ ଟାଇମ୍ ଆଉଟ୍। ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get apiErrorTooManyRequests =>
      'ଅନେକ ରିକ୍ୱେଷ୍ଟ। କିଛି ସମୟ ପରେ ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get apiErrorServerError =>
      'ସର୍ଭର୍ ତ୍ରୁଟି। କିଛି ସମୟ ପରେ ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get apiErrorInvalidEmail => 'ଦୟାକରି ସଠିକ୍ ଇମେଲ୍ ଦିଅନ୍ତୁ।';

  @override
  String get apiErrorWeakPassword =>
      'ପାସୱାର୍ଡ ଅତ୍ୟନ୍ତ ଦୁର୍ବଳ। ଅତିକମରେ ୬ଟି ଅକ୍ଷର ବ୍ୟବହାର କରନ୍ତୁ।';

  @override
  String get apiErrorTooManyAttempts =>
      'ଅନେକ ଥର ଭୁଲ୍ ଚେଷ୍ଟା କରାଯାଇଛି। ପରେ ପୁଣି ଚେଷ୍ଟା କରନ୍ତୁ।';

  @override
  String get homeForgottenFavorites => 'ଭୁଲି ଯାଇଥିବା ପ୍ରିୟ ଗୀତ';

  @override
  String get artistShowAll => 'ସବୁ ଦେଖନ୍ତୁ';

  @override
  String get homeTopTracks => 'ଶୀର୍ଷ ଟ୍ରାକ';
}
