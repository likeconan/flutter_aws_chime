class VideoTileModel {
  final int tileId;
  int videoStreamContentWidth;
  int videoStreamContentHeight;
  bool isLocalTile;
  bool isContentShare;

  VideoTileModel(
    this.tileId,
    this.videoStreamContentWidth,
    this.videoStreamContentHeight,
    this.isLocalTile,
    this.isContentShare,
  );

  factory VideoTileModel.fromJson(json) {
    return VideoTileModel(
        json["tileId"],
        json["videoStreamContentWidth"],
        json["videoStreamContentHeight"],
        json["isLocalTile"],
        json["isContent"]);
  }
}
