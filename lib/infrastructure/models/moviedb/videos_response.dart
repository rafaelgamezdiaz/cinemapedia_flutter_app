class VideosResponse {
  final int id;
  final List<VideoFromMovieDB> results;

  VideosResponse({required this.id, required this.results});

  factory VideosResponse.fromJson(Map<String, dynamic> json) => VideosResponse(
    id: json["id"],
    results: List<VideoFromMovieDB>.from(
      json["results"].map((x) => VideoFromMovieDB.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class VideoFromMovieDB {
  final String iso6391;
  final String iso31661;
  final String name;
  final String? key;
  final String site;
  final int size;
  final String type;
  final bool official;
  final DateTime publishedAt;
  final String id;

  VideoFromMovieDB({
    required this.iso6391,
    required this.iso31661,
    required this.name,
    required this.key,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.publishedAt,
    required this.id,
  });

  factory VideoFromMovieDB.fromJson(Map<String, dynamic> json) =>
      VideoFromMovieDB(
        iso6391: json["iso_639_1"] ?? '',
        iso31661: json["iso_3166_1"] ?? '',
        name: json["name"],
        key: json["key"] ?? '',
        site: json["site"] ?? '',
        size: json["size"] ?? 0,
        type: json["type"] ?? '',
        official: json["official"] ?? false,
        publishedAt:
            json["published_at"]
                ? DateTime.parse(json["published_at"])
                : DateTime.now(),
        id: json["id"] ?? '',
      );

  Map<String, dynamic> toJson() => {
    "iso_639_1": iso6391,
    "iso_3166_1": iso31661,
    "name": name,
    "key": key,
    "site": site,
    "size": size,
    "type": type,
    "official": official,
    "published_at": publishedAt.toIso8601String(),
    "id": id,
  };
}
