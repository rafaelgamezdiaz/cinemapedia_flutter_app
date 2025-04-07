import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoFullscreenPlayerScreen extends StatefulWidget {
  static const String name = 'video-fullscreen-player';

  final String youtubeId;
  final Duration startAt;

  const VideoFullscreenPlayerScreen({
    super.key,
    required this.youtubeId,
    this.startAt = Duration.zero,
  });

  @override
  State<VideoFullscreenPlayerScreen> createState() =>
      _VideoFullscreenPlayerScreenState();
}

class _VideoFullscreenPlayerScreenState
    extends State<VideoFullscreenPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Forzar orientación horizontal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        startAt: widget.startAt.inSeconds,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: true,
        enableCaption: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    // Restaurar orientación al salir
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _exitFullscreen() {
    _controller.pause(); // Pausar el video antes de salir
    Navigator.pop(context); // Volver a la vista anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Reproductor de YouTube
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.redAccent,
            progressColors: const ProgressBarColors(
              playedColor: Colors.red,
              handleColor: Colors.redAccent,
            ),
            onReady: () {
              print('Fullscreen Player Ready: ${widget.youtubeId}');
            },
          ),
          // Botón de salir de pantalla completa
          Positioned(
            top: 20, // Ajusta según necesites
            right: 20,
            child: IconButton(
              icon: const Icon(
                Icons.fullscreen_exit,
                color: Colors.white,
                size: 30,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.6),
                padding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _exitFullscreen,
            ),
          ),
        ],
      ),
    );
  }
}
