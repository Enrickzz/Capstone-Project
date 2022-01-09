import 'package:my_app/discussion_board/create_post.dart';
import 'package:my_app/reviews/recreational/add_recreational_reviews.dart';
import 'package:my_app/reviews/recreational/info_recreational.dart';
import 'package:my_app/reviews/restaurant/info_restaurant.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/discussion_board/specific_post.dart';
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
import 'package:my_app/models/nutritionixApi.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../../../fitness_app_theme.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class recreational_reviews extends StatefulWidget {
  @override
  _RecreationalState createState() => _RecreationalState();
}

final _formKey = GlobalKey<FormState>();
List<Common> result = [];
List<double> calories = [];
class _RecreationalState extends State<recreational_reviews>
    with TickerProviderStateMixin {

  String search="";
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();

  final AuthService _auth = AuthService();

  final double minScale = 1;
  final double maxScale = 1.5;
  double _ratingValue;

  // bool isRecommendedTrue = false;
  // bool isRecommendedFalse = true;
  bool isRecommended = true;

  double topBarOpacity = 0.0;
  @override
  void initState() {
    super.initState();
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
          title: const Text('Recreational Place Reviews', style: TextStyle(
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
                          child: add_recreational_review(),
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
                              child: Text( "Reviews",
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
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 14),
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(context: context,
                                    isScrollControlled: true,
                                    builder: (context) => SingleChildScrollView(child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                      // child: add_medication(thislist: medtemp),
                                      child: info_recreational(),
                                    ),
                                    ),
                                  ).then((value) =>
                                      Future.delayed(const Duration(milliseconds: 1500), (){
                                        setState((){
                                        });
                                      }));
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
                                                  // CircleAvatar(
                                                  //   backgroundImage: AssetImage('assets/images/heart_icon.png'),
                                                  //   radius: 22,
                                                  // ),
                                                  if (isRecommended) ...[
                                                    Icon(
                                                      Icons.thumb_up_alt_sharp,
                                                    ),
                                                  ] else ...[
                                                    Icon(
                                                      Icons.thumb_down_alt_sharp,
                                                    ),
                                                  ],

                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        // Container(
                                                        //   width: MediaQuery.of(context).size.width * 0.65,
                                                        //   child: Text(
                                                        //     "Painful Heart. What to do?",
                                                        //     style: TextStyle(
                                                        //       fontSize: 16,
                                                        //       fontWeight: FontWeight.bold,
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                        RatingBar(
                                                          initialRating: 3,
                                                          direction: Axis.horizontal,
                                                          allowHalfRating: true,
                                                          itemCount: 5,
                                                          ignoreGestures: true,
                                                          itemSize: 15.0,
                                                          onRatingUpdate: (rating) {
                                                            print(rating);
                                                          },
                                                          ratingWidget: RatingWidget(
                                                              full: Icon(Icons.star, color: Colors.orange),
                                                              half: Icon(
                                                                Icons.star_half,
                                                                color: Colors.orange,
                                                              ),
                                                              empty: Icon(
                                                                Icons.star_outline,
                                                                color: Colors.orange,
                                                              )),
                                                        ),
                                                        SizedBox(height: 2.0),
                                                        Row(
                                                          children: <Widget>[
                                                            Text(
                                                              "Louis Borja",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.bold
                                                              ),
                                                            ),

                                                            SizedBox(width: 10),
                                                            Text(
                                                              "12/29/2021 11:09",
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

                                          child: Center(
                                            child: Text(
                                              "Lorem ipsum bla bla bla bla tite masakit aray ko!!!! 121321 asd asd asd asd asd asddddddddddddd   sd asd asda d asd a das da ad asd asd asd asd asd asd asd as das dasd asd a dasd asd  asd asdasdad asd",
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        // InteractiveViewer(
                                        //   clipBehavior: Clip.none,
                                        //   minScale: minScale,
                                        //   maxScale: maxScale,
                                        //   child: AspectRatio(
                                        //     aspectRatio: 1,
                                        //     child: ClipRRect(
                                        //       borderRadius: BorderRadius.circular(20),
                                        //       child: Image.asset('assets/images/body.PNG'
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),

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

}
