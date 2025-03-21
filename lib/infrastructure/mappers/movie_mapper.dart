import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {
  static Movie movieDbToEntity(MovieFromMovieDb movieDb) {
    return Movie(
      adult: movieDb.adult,
      backdropPath:
          movieDb.backdropPath != ''
              ? 'https://image.tmdb.org/t/p/w500${movieDb.backdropPath}'
              : 'https://demofree.sirv.com/nope-not-here.jpg',
      genreIds: movieDb.genreIds.map((e) => e.toString()).toList(),
      id: movieDb.id,
      originalLanguage: movieDb.originalLanguage,
      originalTitle: movieDb.originalTitle,
      overview: movieDb.overview,
      popularity: movieDb.popularity,
      posterPath:
          movieDb.posterPath != ''
              ? 'https://image.tmdb.org/t/p/w500${movieDb.posterPath}'
              : 'no-poster',
      releaseDate: movieDb.releaseDate,
      title: movieDb.title,
      video: movieDb.video,
      voteAverage: movieDb.voteAverage,
      voteCount: movieDb.voteCount,
    );
  }
}
