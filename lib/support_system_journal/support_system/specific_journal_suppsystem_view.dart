import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/models/discussionModel.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/support_system_journal/journal_reply.dart';


import 'package:flutter/material.dart';

import '../../../fitness_app_theme.dart';

class specific_post_suppsystem_view extends StatefulWidget {
  String userUID;
  int index;
  specific_post_suppsystem_view({Key key, this.userUID, this.index}): super(key: key);
  @override
  _specific_postState createState() => _specific_postState();
}

final _formKey = GlobalKey<FormState>();

class _specific_postState extends State<specific_post_suppsystem_view>
    with TickerProviderStateMixin {

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Discussion> discussion_list = new List<Discussion>();
  List<Replies> reply_list = new List<Replies>();
  Discussion compare = new Discussion();
  String title = "";
  String date = "";
  String time = "";
  String doctor_name = "";
  String body = "";
  String noOfReply = "";
  String img = "";
  bool prescribedDoctor = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    discussion_list.clear();
    reply_list.clear();
    getDiscussion();
    getReplies();
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        for(int i = 0; i < reply_list.length; i++){
          if(reply_list[i].uid == uid){
            reply_list[i].isMe = true;
          }
          else{
            reply_list[i].isMe = false;
          }
        }
        isLoading = false;

      });
    });
  }


  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(milliseconds: 5000), () {
    //   setState(() {
    //     print("FULL SET STATE");
    //   });
    // });
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: const Text('View Journal Entry', style: TextStyle(
              color: Colors.black
          )),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: [
            // GestureDetector(
            //   onTap: () {
            //     _showMyDialogDelete();
            //   },
            //   child: Icon(
            //     Icons.delete,
            //   ),
            // ),
            SizedBox(width: 10),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(context: context,
                        isScrollControlled: true,
                        builder: (context) => SingleChildScrollView(child: Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          // child: add_medication(thislist: medtemp),
                          child: reply_journal(userUID: widget.userUID, index: widget.index),
                        ),
                        ),
                      ).then((value){
                        if (value != null){
                          reply_list.add(value);
                          final User user = auth.currentUser;
                          final uid = user.uid;
                          if(reply_list.last.uid == uid){
                            reply_list.last.isMe = true;
                          }else reply_list.last.isMe= false;
                          setState(() {

                          });
                        }
                      });
                    },
                    child: Icon(
                      Icons.reply,
                    )
                )
            ),
          ],
        ),
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        ): new Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(24, 28, 24, 0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [BoxShadow(
                          color: Colors.black26.withOpacity(0.2),
                          offset: Offset(0.0,6.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.10
                      )]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 60,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  ClipOval(
                                      child: checkimage(img)
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            doctor_name,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 2.0),
                                        Text(
                                           date + " " + time ,
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          body,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),showimg(discussion_list[widget.index].imgRef),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24.0, top: 20.0, bottom: 10.0),
                  child: Text(
                    // "Replies (" + noOfReply + ")",
                    "Replies ("+ noOfReply +")",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                      children: <Widget>[
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: reply_list.length,
                            // itemCount: 1,
                            // discussion_list[widget.index].noOfReplies,
                            itemBuilder: (context, index) {
                              return Container(
                                  margin: EdgeInsets.fromLTRB(24, 0, 24, 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [BoxShadow(
                                        color: Colors.black26.withOpacity(0.2),
                                        offset: Offset(0.0,6.0),
                                        blurRadius: 10.0,
                                        spreadRadius: 0.10
                                    )],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 60,
                                          color: Colors.white,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  ClipOval(
                                                      child: checkimage(reply_list[index].dp_img)
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                reply_list[index].createdBy,
                                                                // "Ryan Borja",
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 2.0),
                                                        Container(
                                                          child: Text(
                                                            checkSpec(reply_list[index].specialty),
                                                            // "Support System",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 2.0),
                                                        Text(
                                                          "${reply_list[index].replyDate.month.toString().padLeft(2, "0")}/${reply_list[index].replyDate.day.toString().padLeft(2, "0")}/${reply_list[index].replyDate.year}"
                                                              + " " +
                                                              "${reply_list[index].replyTime.hour.toString().padLeft(2, "0")}:${reply_list[index].replyTime.minute.toString().padLeft(2, "0")}",
                                                          // "01/11/2022 6:09",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Visibility(
                                                    visible: reply_list[index].isMe,
                                                    child: InkWell(
                                                      onTap: () {
                                                        _showMyDialogDelete(index);
                                                      },
                                                      child: Icon(
                                                        Icons.delete,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(),
                                                  Container()
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                                          child: Text(
                                            reply_list[index].replyBody,
                                            // "GG talaga lods sad",
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              );
                            }
                        ),
                      ]
                  ),
                )
              ],
            ),
          ),
        ),


      ),

    );
  }

  String checkSpec(String spec){
    if (spec == null)
    return "";
    else return spec;
  }
  void getDiscussion() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    int index = widget.index;
    final readdiscussion = databaseReference.child('users/' + userUID + '/journal/');
    readdiscussion.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        discussion_list.add(Discussion.fromJson(jsonString));
      });
      discussion_list.sort((a, b){ //sorting in ascending order
        List<String> dateA = a.discussionDate.toString().split(" ");
        List<String> timeA = a.discussionTime.toString().split(" ");
        String dateAfi = dateA[0] + " " + timeA[1];
        List<String> dateB = b.discussionDate.toString().split(" ");
        List<String> timeB = b.discussionTime.toString().split(" ");
        String dateBfi = dateB[0] + " " + timeB[1];
        print( dateAfi + "\n" + dateBfi);
        return DateTime.parse(dateBfi).compareTo(DateTime.parse(dateAfi));
      });

      title = discussion_list[index].title;
      doctor_name = discussion_list[index].createdBy;
      date = "${discussion_list[index].discussionDate.month.toString().padLeft(2,"0")}/${discussion_list[index].discussionDate.day.toString().padLeft(2,"0")}/${discussion_list[index].discussionDate.year}";
      time = "${discussion_list[index].discussionTime.hour.toString().padLeft(2,"0")}:${discussion_list[index].discussionTime.minute.toString().padLeft(2,"0")}";
      body = discussion_list[index].discussionBody;
      noOfReply = discussion_list[index].noOfReplies.toString();
      img = discussion_list[index].dp_img.toString();
      compare = new Discussion(title: title, createdBy: doctor_name, discussionDate: discussion_list[index].discussionDate, discussionTime: discussion_list[index].discussionTime
        ,discussionBody: body, noOfReplies: discussion_list[index].noOfReplies, imgRef: img );

    });
  }
  void getReplies() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    // double index = (widget.index + 1) / (widget.index + 1).floor(); int a = discussion_list.indexOf(compare);
    final readReplies = databaseReference.child('users/' + userUID + '/journal/'+ (widget.index).toString() +'/replies/');
    readReplies.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        reply_list.add(Replies.fromJson(jsonString));
      });
    });
  }

  Future<void> _showMyDialogDelete(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text('Are you sure you want to delete these record/s?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                String userUID = widget.userUID;
                int initialLength = reply_list.length;
                String discussionIndex = (widget.index + 1).toString();
                reply_list.removeAt(index);
                /// delete fields
                for(int i = 1; i <= initialLength; i++){
                  final bpRef = databaseReference.child('users/' + userUID + '/journal/' + discussionIndex + '/replies/' + i.toString());
                  bpRef.remove();
                }
                /// write fields
                for(int i = 0; i < reply_list.length; i++){
                  final bpRef = databaseReference.child('users/' + userUID + '/journal/' + discussionIndex + '/replies/' + (i+1).toString());
                  bpRef.set({
                    "createdBy": reply_list[i].createdBy.toString(),
                    "replyBody": reply_list[i].createdBy.toString(),
                    "replyDate": "${reply_list[i].replyDate.month.toString().padLeft(2,"0")}/${reply_list[i].replyDate.day.toString().padLeft(2,"0")}/${reply_list[i].replyDate.year}",
                    "replyTime": "${reply_list[i].replyTime.hour.toString().padLeft(2,"0")}:${reply_list[i].replyTime.minute.toString().padLeft(2,"0")}",
                    "specialty": reply_list[i].specialty.toString(),
                    "uid": reply_list[i].uid.toString(),
                  });
                }
                final discussionRef = databaseReference.child('users/' + userUID + '/journal/' + discussionIndex);
                discussionRef.update({"noOfReplies": (discussion_list[widget.index].noOfReplies-1).toString()});
                Navigator.of(context).pop();

              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Widget showimg(String imgref) {
    if(imgref == "null" || imgref == null || imgref == ""){
      return SizedBox(height: 10.0);
    }else{
      return Visibility(
        visible: true,
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          minScale: 1,
          maxScale: 1.5,
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(imgref, loadingBuilder: (context, child, loadingProgress) =>
              (loadingProgress == null) ? child : CircularProgressIndicator()),
            ),
          ),
        ),
      );
    }
  }
  Widget checkimage(String img) {
    if(img == null || img == "assets/images/blank_person.png" || img == "null"){
      return Image.asset("assets/images/blank_person.png", width: 50, height: 50,fit: BoxFit.cover);
    }else{
      return Image.network(img,
          width: 50,
          height: 50,
          fit: BoxFit.cover);
    }
  }
}
