import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:my_app/discussion_board/create_post.dart';
import 'package:my_app/models/discussionModel.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/discussion_board/specific_post.dart';
import 'package:my_app/ui_view/weight/BMI_chart.dart';
import 'package:my_app/ui_view/area_list_view.dart';
import 'package:my_app/ui_view/calorie_intake.dart';
import 'package:my_app/ui_view/diet_view.dart';
import 'package:my_app/ui_view/glucose_levels_chart.dart';
import 'package:my_app/ui_view/grid_images.dart';
import 'package:my_app/ui_view/heartrate.dart';
import 'package:my_app/ui_view/running_view.dart';
import 'package:my_app/ui_view/title_view.dart';
import 'package:my_app/ui_view/workout_view.dart';
import 'package:my_app/ui_view/bp_chart.dart';
import 'package:my_app/models/nutritionixApi.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../../fitness_app_theme.dart';

class discussion extends StatefulWidget {
  String userUID;
  discussion({Key key, this.userUID}): super(key: key);
  @override
  _discussionState createState() => _discussionState();
}

final _formKey = GlobalKey<FormState>();
List<Common> result = [];
List<double> calories = [];
class _discussionState extends State<discussion> with TickerProviderStateMixin {

  String search="";
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  Users doctor = new Users();
  int count = 1;
  DateTime now =  DateTime.now();
  String title = '';
  String description = '';
  List<Discussion> discussion_list = new List<Discussion>();
  bool prescribedDoctor = false;


  double topBarOpacity = 0.0;
  @override
  void initState() {
    super.initState();
    discussion_list.clear();
    getDiscussion();
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
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
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: const Text('Discussion', style: TextStyle(
              color: Colors.black
          )),
          centerTitle: true,
          backgroundColor: Colors.white,

          actions: [
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
                          child: create_post(userUID: widget.userUID),
                        ),
                        ),
                      ).then((value) =>
                          Future.delayed(const Duration(milliseconds: 1500), (){
                            setState((){
                            });
                          }));
                    },
                    child: Icon(
                      Icons.add,
                    )
                )
            ),
          ],
        ),
        body:  Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 28, 24, 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:<Widget>[
                            Expanded(
                              child: Text( "Posts",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:Color(0xFF4A6572),
                                  )
                              ),
                            ),
                            InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                onTap: () {},
                                // child: Padding(
                                // padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: <Widget>[
                                    // Text( "Edit",
                                    //     style: TextStyle(
                                    //       fontSize: 16,
                                    //       fontWeight: FontWeight.normal,
                                    //       color:Color(0xFF2633C5),
                                    //     )
                                    // ),
                                    // SizedBox(
                                    //   height: 38,
                                    //   width: 26,
                                    //   // child: Icon(
                                    //   //   Icons.arrow_forward,
                                    //   //   color: FitnessAppTheme.darkText,
                                    //   //   size: 18,
                                    //   // ),
                                    // ),
                                  ],
                                )
                              // )
                            )
                          ]
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: discussion_list.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 14),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => specific_post(userUID: widget.userUID, index: index)
                                    )
                                );
                              },
                              child: Container(
                                height: 180,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [BoxShadow(
                                        color: Colors.black26.withOpacity(0.05),
                                        offset: Offset(0.0,6.0),
                                        blurRadius: 10.0,
                                        spreadRadius: 0.10
                                    )]
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        height: 70,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                CircleAvatar(
                                                  backgroundImage: AssetImage('assets/images/heart_icon.png'),
                                                  radius: 22,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Container(
                                                        width: MediaQuery.of(context).size.width * 0.65,
                                                        child: Text(
                                                          discussion_list[index].title,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 2.0),
                                                      Row(
                                                        children: <Widget>[
                                                          Text(
                                                            'Dr. ' + discussion_list[index].createdBy,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                            ),
                                                          ),

                                                          SizedBox(width: 15),
                                                          Text(
                                                            "${discussion_list[index].discussionDate.month.toString().padLeft(2,"0")}/${discussion_list[index].discussionDate.day.toString().padLeft(2,"0")}/${discussion_list[index].discussionDate.year} " +
                                                                "${discussion_list[index].discussionTime.hour.toString().padLeft(2,"0")}:${discussion_list[index].discussionTime.minute.toString().padLeft(2,"0")}",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 300,

                                        child: Text(
                                          discussion_list[index].discussionBody,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.reply,
                                                size: 14,
                                              ),
                                              SizedBox(width: 4.0),
                                              Text(
                                                discussion_list[index].noOfReplies.toString() + " replies",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _showMyDialogDelete();

                                            },
                                            child: Icon(
                                              Icons.delete,
                                              size: 18,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),

    );
  }
  void getDiscussion() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    final readdiscussion = databaseReference.child('users/' + userUID + '/discussion/');
    readdiscussion.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        discussion_list.add(Discussion.fromJson(jsonString));
      });
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
}
