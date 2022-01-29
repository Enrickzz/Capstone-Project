import 'package:intl/intl.dart';
class Reviews{
  String added_by;
  String review;
  String user_name;
  String placeid;
  String place_name;
  String place_loc;
  int rating;
  bool recommend;
  DateTime reviewDate;
  DateTime reviewTime;
  String special;


  Reviews({this.placeid,this.place_name,this.place_loc, this.reviewDate, this.reviewTime, this.user_name, this.added_by, this.review, this.rating, this.recommend,this.special});

  Reviews.fromJson(Map<String, dynamic> json) {
    added_by = json['added_by'];
    user_name = json['user_name'];
    placeid = json['placeid'];
    review = json['review'];
    rating = json['rating'];
    recommend = json['recommend'];
    reviewDate = DateFormat("MM/dd/yyyy").parse(json['reviewDate']);
    reviewTime = DateFormat("hh:mm").parse(json['reviewTime']);
    if(json['special'] != null){
      special = json['special'];
    }else special ="";
    if(json['place_name'] != null){
      place_name = json['place_name'];
    }else place_name ="";
    if(json['place_loc'] != null){
      place_loc = json['place_loc'];
    }else place_loc ="";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['added_by'] = this.added_by;
    data['user_name'] = this.user_name;
    data['placeid'] = this.placeid;
    data['review'] = this.review;
    data['rating'] = this.rating;
    data['recommend'] = this.recommend;
    data['reviewDate'] = this.reviewDate;
    data['reviewTime'] = this.reviewTime;
    if (this.special != null) {
      data['special'] = this.special;
    }
    if (this.place_name != null) {
      data['place_name'] = this.place_name;
    }
    if (this.place_loc != null) {
      data['place_loc'] = this.place_loc;
    }
    return data;
  }
}