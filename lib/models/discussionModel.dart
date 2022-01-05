import 'package:intl/intl.dart';

class Discussion {

  String title;
  String createdBy;
  DateTime discussionDate;
  DateTime discussionTime;
  String discussionBody;
  int noOfReplies;
  Replies replies;
  String imgRef;

  Discussion({
    this.title,
    this.createdBy,
    this.discussionDate,
    this.discussionTime,
    this.discussionBody,
    this.noOfReplies,
    this.replies,
    this.imgRef
  });

  Discussion.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    createdBy = json['createdBy'];
    discussionDate = DateFormat("MM/dd/yyyy").parse(json['discussionDate']);
    discussionTime = DateFormat("hh:mm").parse(json['discussionTime']);
    discussionBody = json['discussionBody'];
    noOfReplies = json['noOfReplies'];
    imgRef = json['imgRef'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['createdBy'] = this.createdBy;
    data['discussionDate'] = this.discussionDate;
    data['discussionTime'] = this.discussionTime;
    data['discussionBody'] = this.discussionBody;
    data['noOfReplies'] = this.noOfReplies;
    data['imgRef'] = this.imgRef;
    return data;
  }

}

class Replies {
  String createdBy;
  String specialty;
  String replyDate;
  String replyTime;
  String replyBody;

  Replies({
        this.createdBy,
        this.specialty,
        this.replyDate,
        this.replyTime,
        this.replyBody,
      });

  Replies.fromJson(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    specialty = json['specialty'];
    replyDate = json['replyDate'];
    replyTime = json['replyTime'];
    replyBody = json['replyBody'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdBy'] = this.createdBy;
    data['specialty'] = this.specialty;
    data['replyDate'] = this.replyDate;
    data['replyTime'] = this.replyTime;
    data['replyBody'] = this.replyBody;
    return data;
  }
}