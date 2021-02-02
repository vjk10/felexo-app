class WallpaperModel {
  String photographer;
  String photographerUrl;
  int photographerId;
  int photoID;
  String avgColor;
  SourceModel src;

  WallpaperModel(
      {this.src,
      this.photoID,
      this.photographerUrl,
      this.photographerId,
      this.photographer,
      this.avgColor});

  factory WallpaperModel.fromMap(Map<String, dynamic> jsonData) {
    return WallpaperModel(
        src: SourceModel.fromMap(jsonData["src"]),
        photographerUrl: jsonData["photographer_url"],
        photographer: jsonData["photographer"],
        photographerId: jsonData["photographer_id"],
        photoID: jsonData["id"],
        avgColor: jsonData["avg_color"]);
  }
}

class SourceModel {
  String original;
  String small;
  String portrait;

  SourceModel({this.original, this.portrait, this.small});

  factory SourceModel.fromMap(Map<String, dynamic> jsonData) {
    return SourceModel(
        original: jsonData["original"],
        portrait: jsonData["portrait"],
        small: jsonData["small"]);
  }
}
