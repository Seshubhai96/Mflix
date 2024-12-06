class Moviemodel {
  int? id;
  String? title;
  String? posterURL;
  String? imdbId;

  Moviemodel({this.id, this.title, this.posterURL, this.imdbId});

  Moviemodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    posterURL = json['posterURL'];
    imdbId = json['imdbId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['posterURL'] = posterURL;
    data['imdbId'] = imdbId;
    return data;
  }
}