import 'package:flutter/gestures.dart';
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

  double topBarOpacity = 0.0;

  @override
  void initState() {

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
                          Text( "Chan, Gian Lord",
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
                                Text('gian_lord_chan@dlsu.edu.ph',
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
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:<Widget>[
                          Expanded(
                            child: Text( "Personal Information",
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
                      height: 380,
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
                                          Text("Complete Name",
                                            style: TextStyle(
                                                fontSize:14,
                                                color:Color(0xFF363f93),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text("Gian Lord Chan",
                                            style: TextStyle(
                                                fontSize:16,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          // Text("Email address",
                                          //   style: TextStyle(
                                          //     fontSize:14,
                                          //     color:Color(0xFF363f93),
                                          //   ),
                                          // ),
                                          // SizedBox(height: 8),
                                          // Text("gian_lord_chan@dlsu.edu.ph",
                                          //   style: TextStyle(
                                          //       fontSize:16,
                                          //       fontWeight: FontWeight.bold
                                          //   ),
                                          // ),
                                          // SizedBox(height: 16),
                                          // Text("Contact Number",
                                          //   style: TextStyle(
                                          //     fontSize:14,
                                          //     color:Color(0xFF363f93),
                                          //   ),
                                          // ),
                                          // SizedBox(height: 8),
                                          // Text("09123456789",
                                          //   style: TextStyle(
                                          //       fontSize:16,
                                          //       fontWeight: FontWeight.bold
                                          //   ),
                                          // ),
                                          // SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Text("Birthday",
                                                style: TextStyle(
                                                  fontSize:14,
                                                  color:Color(0xFF363f93),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text("08/07/1999",
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
                                          Text("22 years old",
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
                                          Text("Male",
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
                                          Text("54.0 kg",
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
                                          Text("161.0 cm",
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
                            child: Text( "Health Information",
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
                                          // Text("Email address",
                                          //   style: TextStyle(
                                          //     fontSize:14,
                                          //     color:Color(0xFF363f93),
                                          //   ),
                                          // ),
                                          // SizedBox(height: 8),
                                          // Text("gian_lord_chan@dlsu.edu.ph",
                                          //   style: TextStyle(
                                          //       fontSize:16,
                                          //       fontWeight: FontWeight.bold
                                          //   ),
                                          // ),
                                          // SizedBox(height: 16),
                                          // Text("Contact Number",
                                          //   style: TextStyle(
                                          //     fontSize:14,
                                          //     color:Color(0xFF363f93),
                                          //   ),
                                          // ),
                                          // SizedBox(height: 8),
                                          // Text("09123456789",
                                          //   style: TextStyle(
                                          //       fontSize:16,
                                          //       fontWeight: FontWeight.bold
                                          //   ),
                                          // ),
                                          // SizedBox(height: 16),
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
}
