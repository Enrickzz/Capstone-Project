import 'package:intl/intl.dart';

class Reviews{
  String added_by;
  String review;
  String user_name;
  int rating;
  bool recommend;
  DateTime reviewDate;
  DateTime reviewTime;

  Reviews({this.added_by, this.review, this.rating, this.recommend});

  Reviews.fromJson(Map<String, dynamic> json) {
    added_by = json['added_by'];
    user_name = json['user_name'];
    review = json['review'];
    rating = json['rating'];
    recommend = json['recommend'];
    reviewDate = DateFormat("MM/dd/yyyy").parse(json['reviewDate']);
    reviewTime = DateFormat("hh:mm").parse(json['reviewTime']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['added_by'] = this.added_by;
    data['user_name'] = this.user_name;
    data['review'] = this.review;
    data['rating'] = this.rating;
    data['recommend'] = this.recommend;
    data['reviewDate'] = this.reviewDate;
    data['reviewTime'] = this.reviewTime;
    return data;
  }
}