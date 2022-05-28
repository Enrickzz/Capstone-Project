import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/discussion_board/reply_post.dart';
import 'package:my_app/models/discussionModel.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/support_system_journal/journal_reply.dart';
import 'package:my_app/ui_view/weight/BMI_chart.dart';
import 'package:my_app/ui_view/area_list_view.dart';
import 'package:my_app/ui_view/calorie_intake.dart';
import 'package:my_app/ui_view/diet_view.dart';
import 'package:my_app/ui_view/glucose_levels_chart.dart';
import 'package:my_app/ui_view/grid_images.dart';
import 'package:my_app/ui_view/heartrate.dart';
import 'package:my_app/ui_view/exercises/running_view.dart';
import 'package:my_app/ui_view/title_view.dart';
import 'package:my_app/ui_view/workout_view.dart';
import 'package:my_app/ui_view/blood_pressure/bp_chart.dart';
import 'package:my_app/models/nutritionixApi.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../../../fitness_app_theme.dart';

class specific_journal_doctor_view extends StatefulWidget {
  String userUID;
  int index;
  specific_journal_doctor_view({Key key, this.userUID, this.index}): super(key: key);
  @override
  _specific_postState createState() => _specific_postState();
}

final _formKey = GlobalKey<FormState>();

class _specific_postState extends State<specific_journal_doctor_view>
    with TickerProviderStateMixin {

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  List<Discussion> discussion_list = new List<Discussion>();
  List<Replies> reply_list = new List<Replies>();
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
    discussion_list.clear();
    reply_list.clear();
    getDiscussion();
    getReplies();
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        isLoading = false;
        print("setstate");
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
      child: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      ): new Scaffold(
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
                      ).then((value) {
                        if (value != null){
                          reply_list.add(value);
                          final FirebaseAuth auth = FirebaseAuth.instance;
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
        body: Scrollbar(
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
                        ),
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
                            // itemCount: reply_list.length,
                            itemCount: reply_list.length,
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
                                                                // "Dr. " + reply_list[index].createdBy,
                                                                reply_list[index].createdBy,
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
                                                            // reply_list[index].specialty,
                                                            reply_list[index].specialty,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 2.0),
                                                        Text(
                                                          // reply_list[index].replyDate + " " + reply_list[index].replyTime,
                                                          "${reply_list[index].replyDate.month.toString().padLeft(2, "0")}/${reply_list[index].replyDate.day.toString().padLeft(2, "0")}/${reply_list[index].replyDate.year}"
                                                              + " " +
                                                              "${reply_list[index].replyTime.hour.toString().padLeft(2, "0")}:${reply_list[index].replyTime.minute.toString().padLeft(2, "0")}",
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
                                            // reply_list[index].replyBody,
                                            reply_list[index].replyBody,
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

      title = discussion_list[index].title;
      doctor_name = discussion_list[index].createdBy;
      date = "${discussion_list[index].discussionDate.month.toString().padLeft(2,"0")}/${discussion_list[index].discussionDate.day.toString().padLeft(2,"0")}/${discussion_list[index].discussionDate.year}";
      time = "${discussion_list[index].discussionTime.hour.toString().padLeft(2,"0")}:${discussion_list[index].discussionTime.minute.toString().padLeft(2,"0")}";
      body = discussion_list[index].discussionBody;
      noOfReply = discussion_list[index].noOfReplies.toString();
      img = discussion_list[index].dp_img.toString();
    });
  }
  void getReplies() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    int index = widget.index;
    final readReplies = databaseReference.child('users/' + userUID + '/journal/'+ (index + 1).toString() +'/replies/');
    readReplies.once().then((DataSnapshot snapshot) async{
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        reply_list.add(Replies.fromJson(jsonString));
      });
    }).then((value) {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;
      final uid = user.uid;
      for(int i = 0; i < reply_list.length; i++){
        if(reply_list[i].uid == uid){
          reply_list[i].isMe = true;
        }
        else{
          reply_list[i].isMe = false;
        }
      }
    });
  }

  Future<void> _showMyDialogDelete() async {
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
                print('Deleted');
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
