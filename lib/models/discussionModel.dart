import 'package:intl/intl.dart';

class Discussion {

  String title;
  String createdBy;
  String dp_img;
  String uid;
  DateTime discussionDate;
  DateTime discussionTime;
  String discussionBody;
  int noOfReplies;
  Replies replies;
  String imgRef;
  bool isMe;

  Discussion({
    this.title,
    this.createdBy,
    this.dp_img,
    this.discussionDate,
    this.discussionTime,
    this.discussionBody,
    this.noOfReplies,
    this.replies,
    this.imgRef,
    this.isMe,
    this.uid
  });

  Discussion.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    title = json['title'];
    createdBy = json['createdBy'];
    dp_img = json['dp_img'];
    discussionDate = DateFormat("MM/dd/yyyy").parse(json['discussionDate']);
    discussionTime = DateFormat("hh:mm").parse(json['discussionTime']);
    discussionBody = json['discussionBody'];
    noOfReplies = int.parse(json['noOfReplies']);
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
  String uid;
  String createdBy;
  String dp_img;
  String specialty;
  DateTime replyDate;
  DateTime replyTime;
  String replyBody;
  bool isMe;

  Replies({
        this.uid,
        this.createdBy,
        this.dp_img,
        this.specialty,
        this.replyDate,
        this.replyTime,
        this.replyBody,
      });

  Replies.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    createdBy = json['createdBy'];
    dp_img = json['dp_img'];
    specialty = json['specialty'];
    replyDate = DateFormat("MM/dd/yyyy").parse(json['replyDate']);
    replyTime = DateFormat("hh:mm").parse(json['replyTime']);
    replyBody = json['replyBody'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['createdBy'] = this.createdBy;
    data['dp_img'] = this.dp_img;
    data['specialty'] = this.specialty;
    data['replyDate'] = DateFormat("MM/dd/yyyy").format(this.replyDate);
    data['replyTime'] = DateFormat("hh:mm").format(this.replyTime);
    data['replyBody'] = this.replyBody;
    return data;
  }
}