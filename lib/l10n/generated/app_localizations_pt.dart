// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get artistAbout => 'Sobre';

  @override
  String get artistPopular => 'Populares';

  @override
  String get artistAlbums => 'Álbuns';

  @override
  String get artistSinglesAndEPs => 'Singles e EPs';

  @override
  String artistSubscribersCount(String count) {
    return '$count inscritos';
  }

  @override
  String get artistPlayAll => 'Tocar Tudo';

  @override
  String get artistLoadError => 'Não foi possível carregar o artista';

  @override
  String get artistGoBack => 'Voltar';

  @override
  String adminChatFailedToReply(String error) {
    return 'Falha ao responder: $error';
  }

  @override
  String get adminChatSupportChat => 'Chat de Suporte';

  @override
  String adminChatError(String error) {
    return 'Erro: $error';
  }

  @override
  String get adminChatNoHistory => 'Nenhum histórico de mensagens.';

  @override
  String get adminChatSupportYou => 'Suporte (Você)';

  @override
  String get adminChatTypeReply => 'Digite uma resposta...';

  @override
  String get broadcastSuccess => 'Aviso enviado com sucesso!';

  @override
  String broadcastFailed(String error) {
    return 'Falha ao enviar: $error';
  }

  @override
  String get broadcastTitle => 'Aviso Global';

  @override
  String get broadcastSubtitle => 'Enviado a todos os usuários';

  @override
  String get broadcastWarning => 'Esta mensagem será vista por todos.';

  @override
  String broadcastError(String error) {
    return 'Erro: $error';
  }

  @override
  String get broadcastNoHistory => 'Nenhum aviso global.';

  @override
  String get broadcastTypeMessage => 'Digite um aviso...';

  @override
  String commFailedToSend(String error) {
    return 'Falha ao enviar: $error';
  }

  @override
  String get commAdminDashboard => 'Painel de Administração';

  @override
  String get commAdminSupport => 'Suporte';

  @override
  String get commAlwaysHere => 'Sempre prontos para ajudar';

  @override
  String get commWelcomeTitle => 'Olá! 👋 Sou o Ashutosh Pathak';

  @override
  String get commWelcomeSubtitle => 'Criador do Pulse';

  @override
  String get commWelcomeBody1 =>
      'Espero que você esteja curtindo músicas sem anúncios. A música não deve ter barreiras.\n\nEste é o espaço para conversarmos diretamente.\n\nVocê pode enviar:';

  @override
  String get commBullet1 => 'Seu feedback';

  @override
  String get commBullet2 => 'Relatórios de bugs';

  @override
  String get commBullet3 => 'Sugestões de novos recursos';

  @override
  String get commWelcomeBody2 =>
      'Leio cada mensagem pessoalmente.\n\nTem ideias para um novo app? Me conte! Se possível, eu o criarei.\n\nObrigado por fazer parte disso. ❤️';

  @override
  String commError(String error) {
    return 'Erro: $error';
  }

  @override
  String get commNoMessages => 'Ainda não há mensagens';

  @override
  String get commNoMessagesDesc => 'Fale com o suporte ou verifique depois.';

  @override
  String get commMessageSupportHint => 'Envie uma mensagem...';

  @override
  String get commGlobalAnnouncements => 'Avisos Globais';

  @override
  String get commSendMessagesToAll => 'Enviar para todos';

  @override
  String get homeGreetingMorning => 'Bom dia,';

  @override
  String get homeGreetingAfternoon => 'Boa tarde,';

  @override
  String get homeGreetingEvening => 'Boa noite,';

  @override
  String get homeMember => 'Membro';

  @override
  String get homeRecentPlaylists => 'Playlists Recentes';

  @override
  String get homeRecentlyPlayed => 'Tocadas Recentemente';

  @override
  String get homeSpeedDial => 'Acesso Rápido';

  @override
  String get homeNoContent => 'Nenhum conteúdo';

  @override
  String get homeRefresh => 'Atualizar';

  @override
  String get homeLoadError => 'Falha ao carregar o feed.';

  @override
  String get homeRetry => 'Tentar Novamente';

  @override
  String get importSuccess => 'Spotify conectado com sucesso!';

  @override
  String importFailed(String error) {
    return 'Falha ao conectar: $error';
  }

  @override
  String get importTitle => 'Conectar Spotify';

  @override
  String get importSetupTitle => 'Configuração do Spotify';

  @override
  String get importSetupDesc =>
      'Use sua própria chave de desenvolvedor para importar suas playlists rapidamente:';

  @override
  String get importStep1 => 'Abra o Spotify Developer Dashboard.';

  @override
  String get importStep2 => 'Faça login e clique em \'Create app\'.';

  @override
  String get importStep3 => 'Dê um nome e descrição ao app.';

  @override
  String get importStep4 => 'Em \'Redirect URIs\', cole esta URL específica:';

  @override
  String get importRedirectCopied => 'URI de redirecionamento copiada!';

  @override
  String get importStep5 => 'Salve, copie o \'Client ID\' e cole abaixo.';

  @override
  String get importImportant =>
      'Importante: É necessária uma assinatura ativa do Spotify Premium.';

  @override
  String get importClientIdHint => 'Cole seu Spotify Client ID aqui...';

  @override
  String get importConnectButton => 'Conectar e Carregar Biblioteca';

  @override
  String get downloadingNoActive => 'Nenhum download ativo';

  @override
  String downloadingMb(String value) {
    return '$value MB';
  }

  @override
  String get downloadsPlaylistName => 'Downloads';

  @override
  String downloadsStats(String count, String size) {
    return '$count músicas • $size';
  }

  @override
  String get downloadsNoOffline => 'Nenhuma música offline';

  @override
  String get downloadsNoOfflineDesc => 'As músicas baixadas aparecerão aqui';

  @override
  String get downloadsClearAllTitle => 'Limpar Tudo?';

  @override
  String downloadsClearAllDesc(String count, String size) {
    return 'Isso excluirá $count músicas e liberará $size de armazenamento.';
  }

  @override
  String get downloadsCancel => 'Cancelar';

  @override
  String get downloadsClearAll => 'Limpar Tudo';

  @override
  String downloadsSongsCount(String count) {
    return '$count músicas';
  }

  @override
  String downloadsSongCountSingle(String count) {
    return '$count música';
  }

  @override
  String get downloadsCannotRenameMaster =>
      'A playlist principal de downloads não pode ser renomeada.';

  @override
  String get downloadsRename => 'Renomear';

  @override
  String get downloadsEditSongs => 'Editar Músicas';

  @override
  String get downloadsDelete => 'Excluir';

  @override
  String get downloadsRenamePlaylistTitle => 'Renomear Playlist';

  @override
  String get downloadsRenamePlaylistDesc =>
      'Digite um novo nome para a playlist.';

  @override
  String get downloadsDeletePlaylistTitle => 'Excluir Playlist?';

  @override
  String get downloadsDeleteMasterDesc =>
      'Tem certeza? Você perderá permanentemente todas as músicas e playlists baixadas.';

  @override
  String downloadsDeletePlaylistDesc(String name) {
    return 'Tem certeza que deseja excluir \'$name\'? A playlist será perdida para sempre.';
  }

  @override
  String get downloadsSave => 'Salvar';

  @override
  String get downloadsNoSongs => 'Esta playlist não tem músicas.';

  @override
  String get libraryTitle => 'Biblioteca';

  @override
  String get libraryPauseAll => 'Pausar Tudo';

  @override
  String get libraryResumeAll => 'Retomar Tudo';

  @override
  String get libraryTabPlaylists => 'Playlists';

  @override
  String get libraryTabDownloads => 'Downloads';

  @override
  String get libraryTabDownloading => 'Baixando';

  @override
  String libraryImportedTask(String name) {
    return '$name importado';
  }

  @override
  String get libraryImportWaiting => 'Aguardando...';

  @override
  String get libraryImportFetching => 'Buscando playlist...';

  @override
  String libraryImportProcessed(
    String processed,
    String total,
    String matched,
  ) {
    return '$processed/$total processadas · $matched correspondências';
  }

  @override
  String get libraryImportSaving => 'Salvando na biblioteca...';

  @override
  String libraryImportDoneSongs(String matched) {
    return '$matched músicas adicionadas · toque em ×';
  }

  @override
  String get libraryImportDoneAll =>
      'Todas as músicas adicionadas · toque em ×';

  @override
  String get libraryAddButton => 'Adicionar';

  @override
  String get librarySortRecent => 'Adicionadas Recentemente';

  @override
  String get librarySortAlpha => 'Ordem Alfabética';

  @override
  String get libraryEmptyTitle => 'Sua biblioteca está vazia.';

  @override
  String get libraryEmptyDesc =>
      'Toque em \'Adicionar\' para criar seu primeiro Pulse.';

  @override
  String get libraryRenameLikedError =>
      'A playlist de Músicas Curtidas não pode ser renomeada.';

  @override
  String get libraryRename => 'Renomear';

  @override
  String get libraryEditSongs => 'Editar Músicas';

  @override
  String get libraryDeleteLikedError =>
      'A playlist de Músicas Curtidas não pode ser excluída.';

  @override
  String get libraryDelete => 'Excluir';

  @override
  String get libraryEditSongsTitle => 'Editar Músicas';

  @override
  String libraryEditSongsCountSingle(String count) {
    return '$count música';
  }

  @override
  String libraryEditSongsCountPlural(String count) {
    return '$count músicas';
  }

  @override
  String get libraryCancel => 'Cancelar';

  @override
  String get librarySave => 'Salvar';

  @override
  String get libraryNoSongs => 'Esta playlist não tem músicas.';

  @override
  String get libraryAddOptionsTitle => 'Adicionar à Biblioteca';

  @override
  String get libraryAddOptionsDesc =>
      'Escolha como expandir sua biblioteca do Pulse';

  @override
  String get libraryImportPulse => 'Importar do Pulse';

  @override
  String get libraryImportPulseDesc => 'Cole a URL de uma playlist do Pulse';

  @override
  String get libraryImportYtm => 'Importar do YT Music';

  @override
  String get libraryImportYtmDesc => 'Cole a URL de uma playlist pública';

  @override
  String get libraryImportSpotify => 'Importar do Spotify';

  @override
  String get libraryImportSpotifyDesc => 'Conecte seu Spotify';

  @override
  String get libraryClose => 'Fechar';

  @override
  String get libraryImportYtmFull => 'Importar do YouTube Music';

  @override
  String get libraryImportSpotifyFull => 'Importar do Spotify (≤100)';

  @override
  String get libraryImportYtmUrlDesc =>
      'Cole a URL de uma playlist ou álbum público do YouTube Music';

  @override
  String get libraryImportSpotifyUrlDesc =>
      'Cole a URL de uma playlist pública do Spotify';

  @override
  String get libraryImportPulseHint => 'https://pulse.app/playlist/...';

  @override
  String get libraryImportYtmHint =>
      'https://music.youtube.com/playlist?list=...';

  @override
  String get libraryImportSpotifyHint =>
      'https://open.spotify.com/playlist/...';

  @override
  String get libraryImportFailed => 'Falha ao importar a playlist do Pulse';

  @override
  String get importErrorPlaylist => 'Erro ao Importar Playlist';

  @override
  String get importErrorHighlyPopulated =>
      'A playlist é grande e pode demorar um pouco.';

  @override
  String get libraryImportBtn => 'Importar';

  @override
  String get libraryCreateTitle => 'Nova Playlist';

  @override
  String get libraryCreateDesc => 'Qual será o nome da sua nova playlist?';

  @override
  String get libraryCreateHint => 'Ex: Viagem de Carro';

  @override
  String get libraryCreateBtn => 'Criar';

  @override
  String get libraryRenameTitle => 'Renomear Playlist';

  @override
  String get libraryRenameDesc => 'Digite um novo nome para a playlist.';

  @override
  String get libraryRenameBtn => 'Renomear';

  @override
  String get libraryDeleteTitle => 'Excluir Playlist?';

  @override
  String libraryDeleteDesc(String name) {
    return 'Tem certeza que deseja excluir \'$name\'? Isso será perdido para sempre.';
  }

  @override
  String get libraryDeleteBtn => 'Excluir';

  @override
  String get librarySortLabelAlpha => 'A-Z';

  @override
  String get librarySortLabelRecent => 'Recente';

  @override
  String librarySongsCount(String count) {
    return '$count músicas';
  }

  @override
  String get libraryComingSoon => 'Em breve';

  @override
  String get loginErrName => 'Por favor, digite seu nome';

  @override
  String get loginErrEmail => 'Por favor, insira seu e-mail';

  @override
  String get loginErrPassword => 'Por favor, insira sua senha';

  @override
  String get loginAppName => 'PULSE';

  @override
  String get loginSubtitle => 'Sinta cada batida!';

  @override
  String get loginMadeWithHeartBy => 'Criado com ❤️: ';

  @override
  String get loginAuthorName => 'Ashutosh Pathak';

  @override
  String get loginHintName => 'Seu Nome';

  @override
  String get loginHintEmail => 'Endereço de E-mail';

  @override
  String get loginHintPassword => 'Senha';

  @override
  String get loginErrEmailReset => 'Por favor, insira um e-mail para resetar';

  @override
  String get loginResetSent =>
      'E-mail de redefinição enviado! Verifique a caixa de entrada.';

  @override
  String get loginForgotPwd => 'Esqueceu a Senha?';

  @override
  String get loginBtnSignup => 'Criar Conta';

  @override
  String get loginBtnSignin => 'Entrar';

  @override
  String get loginToggleHaveAccount => 'Já tem uma conta no Pulse? ';

  @override
  String get loginToggleNoAccount => 'Não tem uma conta no Pulse? ';

  @override
  String get loginToggleSignin => 'Entrar';

  @override
  String get loginToggleSignup => 'Cadastrar-se';

  @override
  String get offlineStillOffline => 'Ainda offline. Verifique a conexão.';

  @override
  String get offlineTitle => 'Você está offline';

  @override
  String get offlineSubtitle =>
      'Sem conexão com a internet.\nVerifique sua rede e tente novamente.';

  @override
  String get offlineChecking => 'Verificando...';

  @override
  String get offlineRetry => 'Tentar Novamente';

  @override
  String get offlineGoToDownloads => 'Ir para Downloads';

  @override
  String get playerMadeWithHeartBy => 'Criado com ❤️: ';

  @override
  String get playerAuthorName => 'Ashutosh Pathak';

  @override
  String get playerSwipeForLyrics => 'Deslize para ver as letras';

  @override
  String get playerNoLyrics => 'Nenhuma letra disponível';

  @override
  String get playerUpNext => 'A Seguir';

  @override
  String get playerNoTracksInQueue => 'Nenhuma música na fila';

  @override
  String get playerNoMusicPlaying => 'Nenhuma música tocando';

  @override
  String get playerPickAVibe => 'Escolha uma música da biblioteca';

  @override
  String get playerGoHome => 'Ir para o Início';

  @override
  String get playerAppName => 'PULSE';

  @override
  String get playerEqualizer => 'Equalizador';

  @override
  String get playerEqCustom => 'Personalizado';

  @override
  String get playlistDownloads => 'Downloads';

  @override
  String get playlistOffline => 'Playlist Offline';

  @override
  String playlistDurationHours(String hours, String mins) {
    return '${hours}h ${mins}m';
  }

  @override
  String playlistDurationMins(String mins) {
    return '${mins}m';
  }

  @override
  String get playlistFindOnPage => 'Encontrar na página';

  @override
  String playlistSongsAndDuration(String count, String duration) {
    return '$count músicas • $duration';
  }

  @override
  String get playlistSortAlpha => 'A-Z';

  @override
  String get playlistSortRecent => 'Recente';

  @override
  String get playlistNoMatches => 'Nenhuma correspondência.';

  @override
  String get playlistNoTracks => 'Esta playlist não tem músicas.';

  @override
  String get playlistNoSongsYet => 'Ainda não há músicas.';

  @override
  String get playlistSortRecentlyAdded => 'Adicionadas Recentemente';

  @override
  String get playlistSortAlphabetical => 'Ordem Alfabética';

  @override
  String playlistDownloadingSongs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'músicas',
      one: 'música',
    );
    return 'Baixando $count $_temp0';
  }

  @override
  String get playlistView => 'Ver';

  @override
  String get playlistAllDownloaded => 'Tudo já baixado';

  @override
  String playlistShareText(String name, String url) {
    return 'Ouça \'$name\' no Pulse!\n$url';
  }

  @override
  String get playlistRemoveFromDownloads => 'Remover dos Downloads';

  @override
  String get playlistRemoveFromPlaylist => 'Remover da Playlist';

  @override
  String get playlistLoadError => 'Falha ao carregar playlist.';

  @override
  String get playlistGoBack => '← Voltar';

  @override
  String get profileNotLoggedIn => 'Não conectado';

  @override
  String get profileSignIn => 'Entrar';

  @override
  String get profileDefaultUser => 'Usuário Pulse';

  @override
  String get profileEditProfile => 'Editar Perfil';

  @override
  String get profileTimeframeDay => 'Dia';

  @override
  String get profileTimeframeWeek => 'Semana';

  @override
  String get profileTimeframeMonth => 'Mês';

  @override
  String get profileTimeframeYear => 'Ano';

  @override
  String get profileListeningTime => 'Tempo Ouvindo';

  @override
  String get profileToday => 'Hoje';

  @override
  String get profileThisWeek => 'Esta Semana';

  @override
  String get profileThisMonth => 'Este Mês';

  @override
  String get profileThisYear => 'Este Ano';

  @override
  String get profileDailyAvg => 'Média Diária';

  @override
  String get profilePerDay => '/dia';

  @override
  String get profileLifetimeListening => 'Tempo Total';

  @override
  String get profileTotalTimeListened => 'Tempo Total de Música no Pulse';

  @override
  String get profileYourTopSongs => 'Mais Ouvidas';

  @override
  String get profileListeningHistoryEmpty => 'Seu histórico aparecerá aqui.';

  @override
  String profilePlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'reproduções',
      one: 'reprodução',
    );
    return '$count $_temp0';
  }

  @override
  String get profileYourTopArtists => 'Artistas Favoritos';

  @override
  String get profileTopArtistsEmpty =>
      'Seus artistas favoritos aparecerão aqui.';

  @override
  String get profileArtistLabel => 'Artista';

  @override
  String get profileSignOut => 'Sair';

  @override
  String profileVersion(String version) {
    return 'Versão $version';
  }

  @override
  String get profileMadeWithHeartBy => 'Criado com ❤️: ';

  @override
  String get profileAuthorName => 'Ashutosh Pathak';

  @override
  String get profileEditProfileHeader => 'Editar Perfil';

  @override
  String get profileDisplayName => 'Nome de Exibição';

  @override
  String get profileCancel => 'Cancelar';

  @override
  String get profileSave => 'Salvar';

  @override
  String get profileChooseAvatar => 'Escolher Avatar';

  @override
  String get searchMicPermissionRequired =>
      'A permissão do microfone é necessária';

  @override
  String get searchUnknownSong => 'Música Desconhecida';

  @override
  String get searchUnknownArtist => 'Artista Desconhecido';

  @override
  String get searchNoSongDetected => 'Nenhuma música detectada.';

  @override
  String searchError(String message) {
    return 'Erro: $message';
  }

  @override
  String get searchSpeechNotAvailable => 'Pesquisa por voz não disponível';

  @override
  String get searchHint => 'Música, Artista, Álbum...';

  @override
  String get searchRecentEmpty => 'Suas pesquisas recentes aparecerão aqui';

  @override
  String get searchRecentSearches => 'Pesquisas Recentes';

  @override
  String get searchClearAll => 'Limpar Tudo';

  @override
  String searchNoResultsFor(String query) {
    return 'Nenhum resultado para \'$query\'';
  }

  @override
  String get searchTryDifferentKeywords => 'Tente palavras diferentes';

  @override
  String get searchTopResult => 'Melhor Resultado';

  @override
  String get searchSongsLabel => 'Músicas';

  @override
  String get searchArtistsLabel => 'Artistas';

  @override
  String get searchAlbumsLabel => 'Álbuns';

  @override
  String get searchPlaylistsLabel => 'Playlists';

  @override
  String get searchArtistLabel => 'Artista';

  @override
  String get searchListening => 'Ouvindo...';

  @override
  String get searchSpeakNow => 'Fale agora';

  @override
  String get searchCancel => 'Cancelar';

  @override
  String get searchIdentifying => 'Identificando...';

  @override
  String get searchListeningForSong => 'Ouvindo música...';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsStreamingQuality => 'Qualidade do Streaming';

  @override
  String get settingsQualityAutomatic => 'Automático';

  @override
  String get settingsQualityLow => 'Baixa';

  @override
  String get settingsQualityNormal => 'Normal';

  @override
  String get settingsQualityHigh => 'Alta';

  @override
  String get settingsDownloadQuality => 'Qualidade do Download';

  @override
  String get settingsPlayback => 'Reprodução';

  @override
  String get settingsCrossfade => 'Transição Gradual (Crossfade)';

  @override
  String get settingsCrossfadeDesc => 'Sobreponha as músicas';

  @override
  String get settingsDataUsage => 'Uso de Dados';

  @override
  String get settingsDataSaver => 'Economia de Dados';

  @override
  String get settingsDataSaverDesc =>
      'Streaming em baixa qualidade na rede móvel';

  @override
  String get settingsAppearance => 'Aparência';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsCustomAccent => 'Cor de Destaque';

  @override
  String get settingsSaturation => 'Saturação';

  @override
  String get settingsBrightness => 'Brilho';

  @override
  String get settingsResetDefault => 'Restaurar Padrões';

  @override
  String get playlistSheetTitle => 'Adicionar à Playlist';

  @override
  String get playlistSheetNewPlaylist => 'Nova Playlist';

  @override
  String get playlistSheetNoPlaylists => 'Nenhuma playlist';

  @override
  String playlistSheetSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'músicas',
      one: 'música',
    );
    return '$count $_temp0';
  }

  @override
  String get playlistSheetNameHint => 'Nome da Playlist';

  @override
  String get playlistSheetCancel => 'Cancelar';

  @override
  String playlistSheetAddedTo(String name) {
    return 'Adicionada a $name';
  }

  @override
  String get playlistSheetCreateFailAuth =>
      'Falha ao criar: Erro de autenticação';

  @override
  String playlistSheetCreateFail(String error) {
    return 'Falha ao criar: $error';
  }

  @override
  String get playlistSheetCreate => 'Criar';

  @override
  String get appUpdateAvailable => 'Atualização Disponível';

  @override
  String appUpdateDesc(String version) {
    return 'A versão $version chegou! Atualize para novos recursos.';
  }

  @override
  String get appUpdateDownload => 'Baixar Atualização';

  @override
  String get navHome => 'Início';

  @override
  String get navLibrary => 'Biblioteca';

  @override
  String get navSearch => 'Buscar';

  @override
  String get navSettings => 'Configurações';

  @override
  String get navProfile => 'Perfil';

  @override
  String get artistSelect => 'Selecione o Artista';

  @override
  String get songActionQueue => 'Adicionar à Fila';

  @override
  String get songActionPlaylist => 'Adicionar à Playlist';

  @override
  String get songActionFinding => 'Buscando...';

  @override
  String get songActionAlbum => 'Ir para o Álbum';

  @override
  String get songActionArtist => 'Ir para o Artista';

  @override
  String get songActionRemovePlaylist => 'Remover da Playlist';

  @override
  String get songActionRemoveDownload => 'Remover dos Downloads';

  @override
  String get songActionDownloadChecking => 'Verificando...';

  @override
  String get songActionDownloading => 'Baixando...';

  @override
  String get songActionDownloaded => 'Baixada!';

  @override
  String get songActionDownloadAlready => 'Já baixada';

  @override
  String get songActionDownloadFailed => 'Falha ao baixar';

  @override
  String get songActionDownload => 'Baixar';

  @override
  String get songActionDownloadingSnack => 'Baixando';

  @override
  String get songActionView => 'Ver';

  @override
  String get spotifyImportTitle => 'Importar do Spotify';

  @override
  String get spotifyImportSubtitle => 'Selecione o tamanho da playlist';

  @override
  String get spotifyChoiceSmallTitle => '100 músicas ou menos';

  @override
  String get spotifyChoiceSmallDesc => 'Cole uma URL de playlist pública.';

  @override
  String get spotifyChoiceLargeTitle => 'Mais de 100 músicas';

  @override
  String get spotifyChoiceLargeDesc =>
      'Conecte seu próprio Spotify Developer App.';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get spotifyPlaylistsTitle => 'Playlists do Spotify';

  @override
  String spotifyPlaylistsErrorMsg(String error) {
    return 'Erro: $error\nVerifique seu Client ID.';
  }

  @override
  String get spotifyPlaylistsEmpty => 'Nenhuma playlist em sua biblioteca';

  @override
  String spotifyPlaylistsTracks(String count) {
    return '$count faixas';
  }

  @override
  String get spotifyPlaylistsImport => 'Importar';

  @override
  String get audioPlaybackFailed => 'Falha na reprodução.';

  @override
  String get audioControlPrevious => 'Anterior';

  @override
  String get audioControlPause => 'Pausar';

  @override
  String get audioControlPlay => 'Tocar';

  @override
  String get audioControlNext => 'Próximo';

  @override
  String get audioControlUnlike => 'Descurtir';

  @override
  String get audioControlLike => 'Curtir';

  @override
  String spotifyRawResponseError(String data, String error) {
    return 'Resposta bruta: $data\n\nErro: $error';
  }

  @override
  String get apiErrorInvalidClient => 'Client ID inválido.';

  @override
  String get apiErrorBadRequest => 'Requisição ruim. Verifique seus dados.';

  @override
  String get apiErrorUnauthorized => 'Não autorizado. Faça login novamente.';

  @override
  String get apiErrorForbidden => 'Proibido. Você não tem acesso.';

  @override
  String get apiErrorNotFound => 'Recurso não encontrado.';

  @override
  String get apiErrorEmailInUse => 'Este endereço de e-mail já está em uso.';

  @override
  String get apiErrorUserNotFound => 'Nenhuma conta com este e-mail.';

  @override
  String get apiErrorWrongPassword => 'Senha incorreta.';

  @override
  String get apiErrorInvalidCredential =>
      'Falha no login. Verifique seus dados.';

  @override
  String get apiErrorNetwork => 'Erro de rede. Verifique sua conexão.';

  @override
  String get apiErrorSocketTimeout =>
      'O tempo da conexão esgotou. Tente novamente.';

  @override
  String get apiErrorTooManyRequests => 'Muitas requisições. Tente mais tarde.';

  @override
  String get apiErrorServerError => 'Erro no servidor. Tente mais tarde.';

  @override
  String get apiErrorInvalidEmail => 'Forneça um endereço de e-mail válido.';

  @override
  String get apiErrorWeakPassword =>
      'A senha é muito fraca. Use pelo menos 6 caracteres.';

  @override
  String get apiErrorTooManyAttempts =>
      'Muitas tentativas falhas. Tente mais tarde.';

  @override
  String get homeForgottenFavorites => 'Favoritos esquecidos';

  @override
  String get artistShowAll => 'Ver tudo';

  @override
  String get homeTopTracks => 'Músicas mais tocadas';
}
