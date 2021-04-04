class PixaBayModel {
  int imgId;
  String thumb;
  String imgUrl;
  int views;
  int downloads;
  int likes;
  String creatorName;
  int creatorId;
  String creatorImageUrl;

  PixaBayModel({
    this.imgId,
    this.thumb,
    this.imgUrl,
    this.views,
    this.downloads,
    this.likes,
    this.creatorId,
    this.creatorImageUrl,
    this.creatorName,
  });

  factory PixaBayModel.fromMap(Map<String, dynamic> jsonData) {
    return PixaBayModel(
      imgId: jsonData['id'],
      thumb: jsonData['previewURL'],
      imgUrl: jsonData['largeImageURL'],
      views: jsonData['views'],
      downloads: jsonData['downloads'],
      likes: jsonData['likes'],
      creatorId: jsonData['user_id'],
      creatorImageUrl: jsonData['userImageURL'],
      creatorName: jsonData['user'],
    );
  }
}
