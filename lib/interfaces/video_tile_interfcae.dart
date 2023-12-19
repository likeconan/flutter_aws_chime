import '../models/video_tile.model.dart';

class VideoTileInterface {
  void videoTileDidAdd(String attendeeId, VideoTileModel videoTile) {
    // Gets called when a video tile is added
  }

  void videoTileDidRemove(String attendeeId, VideoTileModel videoTile) {
    // Gets called when a video tile is removed
  }
}
