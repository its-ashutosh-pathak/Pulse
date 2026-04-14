import 'package:flutter/material.dart';

class PlaylistScreen extends StatelessWidget {
  final String playlistId;
  const PlaylistScreen({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Playlist: $playlistId', style: const TextStyle(fontSize: 24))),
    );
  }
}
