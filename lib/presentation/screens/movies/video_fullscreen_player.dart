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
  bool _isPlaying = true;
  double _sliderValue = 0.0;
  bool _showControls = true;
  bool _hasExited = false; // Bandera para evitar múltiples salidas

  @override
  void initState() {
    super.initState();

    // Ocultar la barra de estado y forzar orientación horizontal
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    ); // Oculta barra de estado y navegación
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: true,
        enableCaption: false,
        hideControls: true,
      ),
    )..addListener(() {
      if (!mounted) return;

      if (_controller.value.isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      }

      final duration = _controller.metadata.duration;
      final position = _controller.value.position;
      if (duration > Duration.zero) {
        setState(() {
          _sliderValue = position.inSeconds / duration.inSeconds;
        });

        // Detectar si el video está cerca del final (500ms de margen)
        if (!_hasExited &&
            position.inMilliseconds >= duration.inMilliseconds - 500) {
          _hasExited = true; // Evitar que se llame múltiples veces
          _exitFullscreen();
        }
      }
    });

    _controller.seekTo(widget.startAt);
  }

  @override
  void dispose() {
    _controller.dispose();

    // Restaurar la barra de estado y la orientación vertical
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    ); // Restaura barra de estado y navegación
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  void _exitFullscreen() {
    _controller.pause();
    Navigator.pop(context);
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _rewind() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    _controller.seekTo(
      newPosition < Duration.zero ? Duration.zero : newPosition,
    );
  }

  void _fastForward() {
    final currentPosition = _controller.value.position;
    final duration = _controller.metadata.duration;
    final newPosition = currentPosition + const Duration(seconds: 10);
    if (duration > Duration.zero && newPosition < duration) {
      _controller.seekTo(newPosition);
    }
  }

  void _onSliderChanged(double value) {
    final duration = _controller.metadata.duration;
    if (duration > Duration.zero) {
      final newPosition = Duration(
        seconds: (value * duration.inSeconds).toInt(),
      );
      _controller.seekTo(newPosition);
      setState(() {
        _sliderValue = value;
      });
    }
  }

  void _toggleControlsVisibility() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        onTap: _toggleControlsVisibility,
        child: Stack(
          alignment: Alignment.center,
          children: [
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
            if (_showControls)
              Positioned(
                bottom: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.replay_10,
                            color: Colors.white,
                            size: 30,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            padding: const EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _rewind,
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 30,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            padding: const EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _togglePlayPause,
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: const Icon(
                            Icons.forward_10,
                            color: Colors.white,
                            size: 30,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            padding: const EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _fastForward,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: Slider(
                        value: _sliderValue.clamp(0.0, 1.0),
                        min: 0.0,
                        max: 1.0,
                        activeColor: Colors.redAccent,
                        inactiveColor: Colors.grey,
                        onChanged: _onSliderChanged,
                      ),
                    ),
                  ],
                ),
              ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: const Icon(
                  Icons.fullscreen_exit,
                  color: Colors.white,
                  size: 30,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black,
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
      ),
    );
  }
}
