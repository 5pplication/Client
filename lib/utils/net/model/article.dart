class Article {
  String? atclNo;
  String? body;
  String? date;
  String? email;
  String? images;
  String? latitude;
  int? likecnt;
  String? longitude;
  bool? share;
  String? tag;
  String? title;

  Article(
      {this.atclNo,
      this.body,
      this.date,
      this.email,
      this.images,
      this.latitude,
      this.likecnt,
      this.longitude,
      this.share,
      this.tag,
      this.title});

  Article.fromJson(Map<String, dynamic> json) {
    atclNo = json['atclNo'];
    body = json['body'];
    date = json['date'];
    email = json['email'];
    images = json['images'];
    latitude = json['latitude'];
    likecnt = json['likecnt'];
    longitude = json['longitude'];
    share = json['share'];
    tag = json['tag'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['atclNo'] = atclNo;
    data['body'] = body;
    data['date'] = date;
    data['email'] = email;
    data['images'] = images;
    data['latitude'] = latitude;
    data['likecnt'] = likecnt;
    data['longitude'] = longitude;
    data['share'] = share;
    data['tag'] = tag;
    data['title'] = title;
    return data;
  }
}
