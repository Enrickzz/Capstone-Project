import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/discussion_board/create_post.dart';
import 'package:my_app/models/GooglePlaces.dart';
import 'package:my_app/models/Reviews.dart';
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
import 'add_restaurant_review.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class restaurant_reviews extends StatefulWidget {
  final Results thisPlace;
  restaurant_reviews({Key key,this.thisPlace});
  @override
  _discussionState createState() => _discussionState();
}

final _formKey = GlobalKey<FormState>();
List<Common> result = [];
List<double> calories = [];
class _discussionState extends State<restaurant_reviews>
    with TickerProviderStateMixin {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

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
  List<Reviews> reviews =[];
  double topBarOpacity = 0.0;
  @override
  void initState() {
    getReviews();
    super.initState();
  }


  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title:  Text(widget.thisPlace.name+"'s"+' Reviews', style: TextStyle(
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
                          child: add_restaurant_review(thisPlace: widget.thisPlace ),
                        ),
                        ),
                      ).then((value) {
                        Future.delayed(const Duration(milliseconds: 1500), (){
                          setState((){
                          });
                        });
                      });
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
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 14),
                              child: GestureDetector(
                                // onTap: () {
                                //   showModalBottomSheet(context: context,
                                //     isScrollControlled: true,
                                //     builder: (context) => SingleChildScrollView(child: Container(
                                //       padding: EdgeInsets.only(
                                //           bottom: MediaQuery.of(context).viewInsets.bottom),
                                //       // child: add_medication(thislist: medtemp),
                                //       child: info_restaurant(),
                                //     ),
                                //     ),
                                //   ).then((value) =>
                                //       Future.delayed(const Duration(milliseconds: 1500), (){
                                //         setState((){
                                //         });
                                //       }));
                                // },
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
                                                  if ( reviews[index].recommend) ...[
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
                                                            initialRating:  double.parse(reviews[index].rating.toString()),
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
                                                              reviews[index].user_name,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.bold
                                                              ),
                                                            ),

                                                            SizedBox(width: 10),
                                                            Text(
                                                              getDateFormatted(reviews[index].reviewDate.toString()) +  " " +
                                                              getTimeFormatted(reviews[index].reviewTime.toString()),
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

                                          child: Text(
                                            reviews[index].review,
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
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
  String getDateFormatted (String date){
    var dateTime = DateTime.parse(date);
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}\r\r";
  }
  String getTimeFormatted (String date){
    print(date);
    var dateTime = DateTime.parse(date);
    var hours = dateTime.hour.toString().padLeft(2, "0");
    var min = dateTime.minute.toString().padLeft(2, "0");
    return "$hours:$min";
  }
  void getReviews() async{
    final User user = auth.currentUser;
    final uid = user.uid;
    // var userUID = widget.userUID;
    final readReviews = databaseReference.child('reviews/' + widget.thisPlace.placeId+ "/");
    await readReviews.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        reviews.add(Reviews.fromJson(jsonString));
        print(reviews.length.toString()+ "<<<<<<<<<<<");
      });
    });
    setState(() {

      print("Tapos na get reviews");
    });

  }

}
