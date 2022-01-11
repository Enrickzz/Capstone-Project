class Reviews{
  String added_by;
  String review;
  String user_name;
  int rating;
  bool recommend;

  Reviews({this.added_by, this.review, this.rating, this.recommend});

  Reviews.fromJson(Map<String, dynamic> json) {
    added_by = json['added_by'];
    user_name = json['user_name'];
    review = json['review'];
    rating = json['rating'];
    recommend = json['recommend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['added_by'] = this.added_by;
    data['user_name'] = this.user_name;
    data['review'] = this.review;
    data['rating'] = this.rating;
    data['recommend'] = this.recommend;
    return data;
  }
}