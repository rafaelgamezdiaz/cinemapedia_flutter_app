class Video {
  final String id;
  final String? key; // La clave de YouTube
  final String name;
  final String site;
  final String type; // 'Trailer', 'Teaser', etc.
  final bool? official; // Si es oficial o no

  Video({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    this.official = false,
  });
}
