import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/videos_response.dart';

class VideoMapper {
  static Video videoMovieDbToEntity(VideoFromMovieDB videoDb) {
    return Video(
      id: videoDb.id,
      key: videoDb.key,
      name: videoDb.name,
      site: videoDb.site,
      type: videoDb.type,
      official: videoDb.official,
    );
  }
}
