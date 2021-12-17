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
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
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
                                  color:Color(0xFF363f93),
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
                                      color:Color(0xFF363f93),
                                  )
                                )
                              ]
                            )
                          )
                        ]
                    )
                  )
                ]
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:<Widget>[
                    Text( "Personal Information",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:Color(0xFF253840),
                        )
                    ),
                    Text( "Edit",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:Color(0xFF363f93),
                        )
                    ),
                  ]
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                  height: 230,
                  child: Stack(
                      children: [
                        Positioned(
                            child: Material(
                              child: Container(
                                  height: 180.0,
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
                            )),
                        Positioned(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Sinigang na Baboy",
                                        style: TextStyle(
                                            fontSize:18,
                                            color:Color(0xFF363f93),
                                            fontWeight: FontWeight.bold
                                        ),),
                                      Text("Lunch",
                                        style: TextStyle(
                                            fontSize:16,
                                            color:Colors.grey,
                                            fontWeight: FontWeight.bold
                                        ),),
                                      Text("420kcal",
                                        style: TextStyle(
                                          fontSize:16,
                                          color:Colors.grey,
                                        ),),
                                      Text("69g",
                                        style: TextStyle(
                                          fontSize:16,
                                          color:Colors.grey,
                                        ),),
                                      Text("Other info",
                                        style: TextStyle(
                                          fontSize:16,
                                          color:Colors.grey,
                                        ),),
                                    ]
                                ),
                              ),
                            ))
                      ]
                  )
              ),
            ]
          ),



          // child: Row(
          //   children: [
          //     Column(
          //       children: [
          //         Container(
          //           alignment: Alignment.topLeft,
          //           child: Container(
          //             padding: EdgeInsets.all(10),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(100),
          //               border: Border.all(width: 2, color: Colors.white),
          //               color: Colors.white,
          //               boxShadow: [
          //                 BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),),
          //               ],
          //             ),
          //             child: Icon(Icons.person_outlined, size: 50, color: Colors.blue,),
          //           ),
          //         ),
          //       ],
          //     ),
          //     SizedBox(width: 20.0),
          //     Container(
          //       alignment: Alignment.topLeft,
          //       child:  Text( "Chan, Gian Lord", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //   ],
          // ),
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
