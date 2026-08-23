import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DesktopRightPane {
  shell,
  player,
  communication,
  broadcastChat,
  adminChat,
}

final desktopRightPaneProvider = StateProvider<DesktopRightPane>((ref) => DesktopRightPane.player);

// State providers for admin chat arguments on desktop
final desktopChatUserIdProvider = StateProvider<String>((ref) => '');
final desktopChatUserNameProvider = StateProvider<String>((ref) => '');
final desktopChatUserEmailProvider = StateProvider<String>((ref) => '');
final desktopChatUserPhotoProvider = StateProvider<String>((ref) => '');

// Controls the active tab in the left pane library (Playlists=0, Downloads=1, Downloading=2)
final desktopLibraryTabProvider = StateProvider<int>((ref) => 0);