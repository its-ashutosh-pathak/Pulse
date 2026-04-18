import 'package:flutter/material.dart';

class ArtistScreen extends StatelessWidget {
  final String browseId;
  const ArtistScreen({super.key, required this.browseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Artist: $browseId', style: const TextStyle(fontSize: 24))),
    );
  }
}
