import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/presentation/screens/movies/video_fullscreen_player.dart';
import 'package:cinemapedia/providers/videos/videos_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:go_router/go_router.dart';

class MovieVideos extends ConsumerStatefulWidget {
  final int movieId;

  const MovieVideos({super.key, required this.movieId});

  @override
  MovieVideosState createState() => MovieVideosState();
}

class MovieVideosState extends ConsumerState<MovieVideos> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final moviesFromVideo = ref.watch(
      videosProvider(widget.movieId.toString()),
    );

    return moviesFromVideo.when(
      data: (videos) => _VideosList(videos: videos),
      error:
          (_, __) => const Center(
            child: Text('No se pudo cargar películas similares'),
          ),
      loading:
          () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _VideosList extends StatelessWidget {
  final List<Video> videos;

  const _VideosList({required this.videos});

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: const Text(
            'Trailers',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        ...videos.map(
          (video) =>
              _YouTubeVideoPlayer(youtubeId: video.key!, name: video.name),
        ),
      ],
    );
  }
}

class _YouTubeVideoPlayer extends StatefulWidget {
  final String youtubeId;
  final String name;

  const _YouTubeVideoPlayer({required this.youtubeId, required this.name});

  @override
  State<_YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<_YouTubeVideoPlayer> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false, // Permitir buscar en la miniatura
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
        hideControls: false, // Mostrar controles
        controlsVisibleAtStart: true, // Que se vean al inicio
      ),
    )..addListener(() {
      if (!mounted) return;
      if (_controller.value.isReady && !_isPlayerReady) {
        setState(() {
          _isPlayerReady =
              true; // Actualiza el estado cuando el reproductor esté listo
        });
      }
      if (_controller.value.hasError) {
        print('Inline Player Error: ${_controller.value.errorCode}');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Solo disponer el controlador
    super.dispose();
  }

  void _navigateToFullscreen() {
    _controller.pause();

    // Opcional: pequeña vibración al tocar
    HapticFeedback.lightImpact();

    // 2. Obtener la posición actual del 'value' del controller
    final currentPosition = _controller.value.position;

    // Navegar usando Navigator en lugar de GoRouter para pasar argumentos más fácilmente
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => VideoFullscreenPlayerScreen(
              youtubeId: widget.youtubeId,
              startAt: currentPosition, // Pasamos la posición actual
            ),
      ),
    ).then((_) {
      if (mounted) {
        _controller.play(); // Reanuda al volver
      }
    });

    // print('Navigating to fullscreen at position: $currentPosition');

    // // 3. Navegar a la nueva pantalla
    // if (!mounted) return;

    // context
    //     .push('/fullscreen-player/${widget.youtubeId}', extra: currentPosition)
    //     .then((_) {
    //       print('Returned from fullscreen via GoRouter pop');
    //     });
  }

  @override
  Widget build(BuildContext context) {
    // Usamos Stack para superponer nuestro botón de fullscreen
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Stack(
            alignment:
                Alignment.bottomRight, // Alinea el botón abajo a la derecha
            children: [
              // El reproductor con aspect ratio
              AspectRatio(
                aspectRatio: 16 / 9,
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.redAccent,
                  progressColors: const ProgressBarColors(
                    playedColor: Colors.red,
                    handleColor: Colors.redAccent,
                  ),
                  // Escucha eventos de fullscreen del propio player (opcional, pero útil para debug)
                  onReady: () {
                    print('Inline Player Ready: ${widget.youtubeId}');
                  },
                  // controlsTimeOut: const Duration(seconds: 3),
                ),
              ),
              // --- NUESTRO BOTÓN DE FULLSCREEN PERSONALIZADO ---
              //  if (_controller.value.isReady)
              Positioned(
                right: 10,
                bottom: 10,
                child: IconButton(
                  icon: const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                    size: 30,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54, // Un poco más opaco
                    padding: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      // Bordes redondeados
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _isPlayerReady ? _navigateToFullscreen : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
