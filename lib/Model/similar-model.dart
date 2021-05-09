class SimilarSearchTerms {
  String searchTerm1;
  String searchTerm2;
  String searchTerm3;
  String searchTerm4;
  SimilarSearchTerms(
      {this.searchTerm1, this.searchTerm2, this.searchTerm3, this.searchTerm4});

  factory SimilarSearchTerms.fromMap(Map<String, dynamic> jsonData) {
    return SimilarSearchTerms(
        searchTerm1: jsonData[0].toString(),
        searchTerm2: jsonData[1].toString(),
        searchTerm3: jsonData[2].toString(),
        searchTerm4: jsonData[3].toString());
  }
}
