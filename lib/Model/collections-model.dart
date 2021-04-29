class CollectionsModel {
  String collectionId;
  String collectionTitle;
  String collectionDescription;
  String photosCount;
  String totalResults;

  CollectionsModel({
    this.collectionId,
    this.collectionTitle,
    this.collectionDescription,
    this.photosCount,
    this.totalResults,
  });

  factory CollectionsModel.fromMap(Map<String, dynamic> jsonData) {
    return CollectionsModel(
      collectionId: jsonData["id"].toString(),
      collectionTitle: jsonData["title"].toString(),
      collectionDescription: jsonData["description"].toString(),
      photosCount: jsonData["photos_count"].toString(),
      totalResults: jsonData["total_results"].toString(),
    );
  }
}
