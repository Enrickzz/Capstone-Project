import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/ui_view/BMI_chart.dart';
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
import 'package:flutter/material.dart';

import '../fitness_app_theme.dart';

class index3 extends StatefulWidget {
  const index3({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _index3State createState() => _index3State();
}

class _index3State extends State<index3>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  double topBarOpacity = 0.0;
  Users profile = new Users();
  Additional_Info info = new Additional_Info();
  String DisplayName = " ";
  String email = " ";
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateTime birthdate;
  final test = DateTime(1999, 5, 18); // for test
  int age = 0;
  String gender = "";
  double weight = 0;
  double height = 0;

  @override
  void initState() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
    final userRef = databaseReference.child('users/' + uid +'/personal_info/');
    final infoRef = databaseReference.child('users/' + uid +'/vitals/additional_info/');
    String tempFName = "";
    String tempLName = "";
    String tempEmail = "";
    String tempPassword = "";
    String tempBMI = "";
    String tempBirthDay = "";
    String tempGender = "";
    String tempHeight = "";
    String tempWeight = "";
    userRef.once().then((DataSnapshot datasnapshot) {
      String temp1 = datasnapshot.value.toString();
      print(temp1);
      List<String> temp = temp1.split(',');

      for(var i = 0; i < temp.length; i++){
        String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
        List<String> splitFull = full.split(" ");
        switch(i){
          case 0: {
            print("i = " + i.toString() + splitFull.last);
            tempEmail = splitFull.last;
          }
          break;
          case 1: {
            print("i = " + i.toString() + splitFull.last);
            tempFName = splitFull.last;
          }
          break;
          case 2: {
            print("i = " + i.toString() + splitFull.last);

          }
          break;
          case 3: {
            print("i = " + i.toString() + splitFull.last);
            tempLName = splitFull.last;
          }
          break;
          case 4: {
            print("i = " + i.toString() + splitFull.last);
            tempPassword = splitFull.last;
            profile = new Users(uid: uid, firstname: tempFName,lastname: tempLName,email: tempEmail,password: tempPassword);
            print("email " + profile.email);
          }
          break;
        }
      }
    });
    infoRef.once().then((DataSnapshot datasnapshot) {
      String temp2 = datasnapshot.value.toString();
      print(temp2);
      List<String> templist = temp2.split(',');

      for(var i = 0; i < templist.length; i++){
        String full = templist[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
        List<String> splitFull = full.split(" ");
        switch(i){
          case 0: {
            print("i = " + i.toString() + splitFull.last);
            tempBMI = splitFull.last;
          }
          break;
          case 1: {
            print("i = " + i.toString() + splitFull.last);
            tempBirthDay = splitFull.last;
          }
          break;
          case 2: {
            print("i = " + i.toString() + splitFull.last);
            tempGender = splitFull.last;
          }
          break;
          case 3: {
            print("i = " + i.toString() + splitFull.last);
            tempHeight = splitFull.last;
          }
          break;
          case 4: {
            print("i = " + i.toString() + splitFull.last);
            tempWeight = splitFull.last;
            info = new Additional_Info(bmi: double.parse(tempBMI), birthday: format.parse(tempBirthDay), gender: tempGender, height: double.parse(tempHeight), weight: double.parse(tempWeight));
          }
          break;
        }
      }
    });
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        DisplayName = profile.firstname + " " + profile.lastname;
        email = profile.email;
        print("display name " + DisplayName);
        print("setstate");
      });
    });


    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();

  }

  void addAllListData() {
    const int count = 5;

    listViews.add(
      GridImages(
        titleTxt: 'Your program',
        subTxt: 'Details',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

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

    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;


    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: const Text('Profile', style: TextStyle(
              color: Colors.black
          )),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: [
            Container(
              margin: EdgeInsets.only( top: 16, right: 16,),
              child: Stack(
                children: <Widget>[
                  Icon(Icons.notifications, ),
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration( color: Colors.red, borderRadius: BorderRadius.circular(6),),
                      constraints: BoxConstraints( minWidth: 12, minHeight: 12, ),
                      child: Text( '5', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center,),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 28, 24, 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(width: 2, color: Colors.white),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),),
                        ],
                      ),
                      child: Icon(Icons.person_outlined, size: 50, color: Colors.blue,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(DisplayName,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  // color:Color(0xFF363f93),
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(email,
                                  style: TextStyle(
                                      fontSize: 14,
                                      // color:Color(0xFF363f93),
                                  )
                                )
                              ]
                            )
                          ),
                        ],
                    )
                  )
                ]
              ),
              SizedBox(height: 30),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: Row(
                        children:<Widget>[
                          Expanded(
                            child: Text("Personal Information",
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
                              child: Row(
                                children: <Widget>[
                                  Text("Edit",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color:Color(0xFF2633C5),
                                      )
                                  ),
                                ],
                              )
                          )
                      ]
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                      height: 380,
                      child: Stack(
                          children: [
                            Positioned(
                                child: Material(
                                  child: Center(
                                    child: Container(
                                        width: 340,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20.0),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                blurRadius: 20.0)],
                                        )
                                    ),
                                  ),
                                )),
                            Positioned(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Complete Name",
                                            style: TextStyle(
                                                fontSize:14,
                                                color:Color(0xFF363f93),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(DisplayName,
                                            style: TextStyle(
                                                fontSize:16,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text("Birthday",
                                            style: TextStyle(
                                              fontSize:14,
                                              color:Color(0xFF363f93),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(info.birthday.month.toString() + "/" + info.birthday.day.toString() + "/" + info.birthday.year.toString(),
                                            style: TextStyle(
                                                fontSize:16,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text("Age",
                                            style: TextStyle(
                                              fontSize:14,
                                              color:Color(0xFF363f93),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(getAge(info.birthday) + " years old",
                                            style: TextStyle(
                                                fontSize:16,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text("Gender",
                                            style: TextStyle(
                                              fontSize:14,
                                              color:Color(0xFF363f93),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(info.gender,
                                            style: TextStyle(
                                                fontSize:16,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text("Weight",
                                            style: TextStyle(
                                              fontSize:14,
                                              color:Color(0xFF363f93),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(info.weight.toString() + " kg",
                                            style: TextStyle(
                                                fontSize:16,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text("Height",
                                            style: TextStyle(
                                              fontSize:14,
                                              color:Color(0xFF363f93),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(info.height.toString() + " cm",
                                            style: TextStyle(
                                                fontSize:16,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ]
                                    ),
                                  ),
                                ))
                          ]
                      )
                  ),
                ],
              ),  // Personal Information
              SizedBox(height: 30),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:<Widget>[
                          Expanded(
                            child: Text( "Medical History",
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
                                  Text( "Edit",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color:Color(0xFF2633C5),
                                      )
                                  ),
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
                  SizedBox(height: 10.0),
                  Container(
                      height: 200,
                      // height: 500, if may contact number and email
                      // margin: EdgeInsets.only(bottom: 50),
                      child: Stack(
                          children: [
                            Positioned(
                                child: Material(
                                  child: Center(
                                    child: Container(
                                        width: 340,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20.0),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                blurRadius: 20.0)],
                                        )
                                    ),
                                  ),
                                )),
                            Positioned(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Disease",
                                            style: TextStyle(
                                              fontSize:14,
                                              color:Color(0xFF363f93),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text("Rheumatic Heart Disease",
                                            style: TextStyle(
                                                fontSize:16,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Text("Comorbidities",
                                                style: TextStyle(
                                                  fontSize:14,
                                                  color:Color(0xFF363f93),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text("Diabetes",
                                            style: TextStyle(
                                                fontSize:16,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text("Family History",
                                            style: TextStyle(
                                              fontSize:14,
                                              color:Color(0xFF363f93),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text("No",
                                            style: TextStyle(
                                                fontSize:16,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ]
                                    ),
                                  ),
                                ))
                          ]
                      )
                  ),
                ],
              ),  // Health Information
              SizedBox(height: 30),
              Container(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("Personal Information"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap:(){

                        },
                      ),
                      _buildDivider(),
                      ListTile(
                        title: Text("Medical History"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap:(){

                        },
                      ),
                      _buildDivider(),
                      ListTile(
                        title: Text("Manage Support System"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap:(){

                        },
                      ),
                      _buildDivider(),
                      ListTile(
                        title: Text("Manage Healthcare Team"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap:(){

                        },
                      ),
                    ],
                  ),
                ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 20.0)],
                  )
              ),
              SizedBox(height: 30),
              Container(
                child: ElevatedButton(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text('Sign Out', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  onPressed: () async{

                  },
                ),
              ),

            ]
          ),


        ),

      )
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }



  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FitnessAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FitnessAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),

                ),
              ),
            );
          },
        )
      ],
    );
  }
  String formatDate (String date) {
    return format.parse(date).toString();
  }
  String getAge (DateTime birthday) {
    DateTime today = new DateTime.now();
    String days1 = "";
    String month1 = "";
    String year1 = "";
    int d = int.parse(DateFormat("dd").format(birthday));
    int m = int.parse(DateFormat("MM").format(birthday));
    int y = int.parse(DateFormat("yyyy").format(birthday));
    int d1 = int.parse(DateFormat("dd").format(DateTime.now()));
    int m1 = int.parse(DateFormat("MM").format(DateTime.now()));
    int y1 = int.parse(DateFormat("yyyy").format(DateTime.now()));
    int age = 0;
    age = y1 - y;
    print(age);

    // dec < jan
    if(m1 < m){
      print("month --");
      age--;
    }
    else if (m1 == m){
      if(d1 < d){
        print("day --");
        age--;
      }
    }
    return age.toString();
  }


}
