class GenreResponse {
  final List<GenreFormMovieDb> genres;

  GenreResponse({required this.genres});

  factory GenreResponse.fromJson(Map<String, dynamic> json) => GenreResponse(
    genres: List<GenreFormMovieDb>.from(
      json["genres"].map((x) => GenreFormMovieDb.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
  };
}

class GenreFormMovieDb {
  final int id;
  final String name;

  GenreFormMovieDb({required this.id, required this.name});

  factory GenreFormMovieDb.fromJson(Map<String, dynamic> json) =>
      GenreFormMovieDb(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
