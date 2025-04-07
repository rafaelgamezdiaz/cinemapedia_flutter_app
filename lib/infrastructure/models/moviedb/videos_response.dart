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

  factory VideoFromMovieDB.fromJson(Map<String, dynamic> json) {
    // --- Inicio: Parseo seguro del campo 'official' ---
    final dynamic officialValue =
        json['official']; // Obtener el valor como dynamic
    bool parsedOfficial = false; // Valor por defecto si no se puede parsear

    if (officialValue is bool) {
      // Si ya es un booleano, usarlo directamente
      parsedOfficial = officialValue;
    } else if (officialValue is String) {
      // Si es un String, intentar convertirlo
      parsedOfficial = officialValue.toLowerCase() == 'true';
    }

    // --- Inicio: Parseo seguro de 'publishedAt' ---
    DateTime parsedPublishedAt;
    final publishedAtString =
        json['published_at']; // Obtener el valor String (o null)

    if (publishedAtString != null &&
        publishedAtString is String &&
        publishedAtString.isNotEmpty) {
      // Intentar parsear solo si es un String no nulo y no vacío
      parsedPublishedAt =
          DateTime.tryParse(publishedAtString) ??
          DateTime.now(); // Usa tryParse y valor por defecto si falla
    } else {
      // Si es nulo, no es String o está vacío, usa la fecha actual
      parsedPublishedAt = DateTime.now();
    }

    return VideoFromMovieDB(
      iso6391: json["iso_639_1"] ?? '',
      iso31661: json["iso_3166_1"] ?? '',
      name: json["name"],
      key: json["key"] ?? '',
      site: json["site"] ?? '',
      size: json["size"] ?? 0,
      type: json["type"] ?? '',
      official: parsedOfficial,
      publishedAt: parsedPublishedAt,
      id: json["id"] ?? '',
    );
  }

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
