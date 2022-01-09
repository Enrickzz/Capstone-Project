import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/nutritionixApi.dart';
import 'package:my_app/reviews/restaurant/info_restaurant.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/set_up.dart';
import '../additional_data_collection.dart';
import 'package:flutter/gestures.dart';

import '../dialogs/policy_dialog.dart';
import '../fitness_app_theme.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class places extends StatefulWidget {
  @override
  _placesState createState() => _placesState();
}

class _placesState extends State<places> with SingleTickerProviderStateMixin {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Drugstores', 'Hospitals', 'Recreational Centers', 'Restaurants'];

  TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 4, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    Future.delayed(const Duration(milliseconds: 1000), (){
      setState(() {
        print("setstate");
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text(tabs[controller.index],
            style: TextStyle(
                color: Colors.black
            )
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        bottom: TabBar(
          isScrollable: true,
          controller: controller,
          indicatorColor: Colors.grey,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs:<Widget>[
            Tab(
              text: 'Drugstores', icon: Image.asset('assets/images/drugstore.png',
              width: 24,
              height:24,),
            ),
            Tab(
              text: 'Hospitals', icon: Image.asset('assets/images/hospital.png',
              width: 24,
              height:24,),
            ),
            Tab(
              text: 'Recreational Centers', icon: Image.asset('assets/images/recreation.png',
              width: 24,
              height:24,),
            ),
            Tab(
              text: 'Restaurants', icon: Image.asset('assets/images/restaurant.png',
              width: 24,
              height:24,),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            itemCount: 3,
            itemBuilder: (context, index){
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                child: Card(
                  child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                        child: Text("Hotel Sogo De La Salle University",
                            style:TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,

                            )),
                      ),
                      subtitle:
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(height: 16.0),
                                Text(
                                  'Rating',
                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                ),
                                RatingBar(
                                  initialRating: 4.5,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  ignoreGestures: true,
                                  itemSize: 12,
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
                                Text(
                                  '(' +'10' +')',
                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                ),

                              ],
                            ),
                            SizedBox(width: 8.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on, size: 12,
                                ),
                                SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    '2401 Taft Ave, Malate, Manila, 1004 Metro Manila ',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.local_phone_outlined, size: 12,
                                ),
                                SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    '7655-1701',
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ),
                                SizedBox(width: 20.0),
                                Icon(
                                  Icons.access_time_sharp, size: 12,
                                ),
                                SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    '7am - 10pm',
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      trailing: ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Image border
                        child: Container(
                          height: 70.0,
                          width: 70.0,// Image radius
                          child: Image.network('https://aiscracker.com/wp-content/uploads/2008/12/sogoBldg.jpg', fit: BoxFit.cover),
                        ),
                      ),
                      isThreeLine: false,
                      selected: true,
                      onTap: () {
                        showModalBottomSheet(context: context,
                          isScrollControlled: true,
                          builder: (context) => SingleChildScrollView(child: Container(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom),
                            // child: add_medication(thislist: medtemp),
                            child: info_restaurant(),
                          ),
                          ),
                        ).then((value) =>
                            Future.delayed(const Duration(milliseconds: 1500), (){
                              setState((){
                              });
                            }));
                      }

                  ),

                ),
              );
            },
          ) ,
          ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            itemCount: 3,
            itemBuilder: (context, index){
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                child: Card(
                  child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                        child: Text("Hotel Sogo De La Salle University",
                            style:TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,

                            )),
                      ),
                      subtitle:
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(height: 16.0),
                                Text(
                                  'Rating',
                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                ),
                                RatingBar(
                                  initialRating: 4.5,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  ignoreGestures: true,
                                  itemSize: 12,
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
                                Text(
                                  '(' +'10' +')',
                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                ),

                              ],
                            ),
                            SizedBox(width: 8.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on, size: 12,
                                ),
                                SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    '2401 Taft Ave, Malate, Manila, 1004 Metro Manila ',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.local_phone_outlined, size: 12,
                                ),
                                SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    '7655-1701',
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ),
                                SizedBox(width: 20.0),
                                Icon(
                                  Icons.access_time_sharp, size: 12,
                                ),
                                SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    '7am - 10pm',
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      trailing: ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Image border
                        child: Container(
                          height: 70.0,
                          width: 70.0,// Image radius
                          child: Image.network('https://aiscracker.com/wp-content/uploads/2008/12/sogoBldg.jpg', fit: BoxFit.cover),
                        ),
                      ),
                      isThreeLine: false,
                      selected: true,
                      onTap: () {
                        showModalBottomSheet(context: context,
                          isScrollControlled: true,
                          builder: (context) => SingleChildScrollView(child: Container(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom),
                            // child: add_medication(thislist: medtemp),
                            child: info_restaurant(),
                          ),
                          ),
                        ).then((value) =>
                            Future.delayed(const Duration(milliseconds: 1500), (){
                              setState((){
                              });
                            }));
                      }

                  ),

                ),
              );
            },
          ) ,
          ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            itemCount: 3,
            itemBuilder: (context, index){
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                child: Card(
                  child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                        child: Text("Hotel Sogo De La Salle University",
                            style:TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,

                            )),
                      ),
                      subtitle:
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(height: 16.0),
                                Text(
                                  'Rating',
                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                ),
                                RatingBar(
                                  initialRating: 4.5,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  ignoreGestures: true,
                                  itemSize: 12,
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
                                Text(
                                  '(' +'10' +')',
                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                ),

                              ],
                            ),
                            SizedBox(width: 8.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on, size: 12,
                                ),
                                SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    '2401 Taft Ave, Malate, Manila, 1004 Metro Manila ',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.local_phone_outlined, size: 12,
                                ),
                                SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    '7655-1701',
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ),
                                SizedBox(width: 20.0),
                                Icon(
                                  Icons.access_time_sharp, size: 12,
                                ),
                                SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    '7am - 10pm',
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      trailing: ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Image border
                        child: Container(
                          height: 70.0,
                          width: 70.0,// Image radius
                          child: Image.network('https://aiscracker.com/wp-content/uploads/2008/12/sogoBldg.jpg', fit: BoxFit.cover),
                        ),
                      ),
                      isThreeLine: false,
                      selected: true,
                      onTap: () {
                        showModalBottomSheet(context: context,
                          isScrollControlled: true,
                          builder: (context) => SingleChildScrollView(child: Container(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom),
                            // child: add_medication(thislist: medtemp),
                            child: info_restaurant(),
                          ),
                          ),
                        ).then((value) =>
                            Future.delayed(const Duration(milliseconds: 1500), (){
                              setState((){
                              });
                            }));
                      }

                  ),

                ),
              );
            },
          ) ,
          ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            itemCount: 3,
            itemBuilder: (context, index){
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                child: Card(
                  child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                        child: Text("Hotel Sogo De La Salle University",
                            style:TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,

                            )),
                      ),
                      subtitle:
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(height: 16.0),
                                Text(
                                  'Rating',
                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                ),
                                RatingBar(
                                  initialRating: 4.5,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  ignoreGestures: true,
                                  itemSize: 12,
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
                                Text(
                                  '(' +'10' +')',
                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                ),

                              ],
                            ),
                            SizedBox(width: 8.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on, size: 12,
                                ),
                                SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    '2401 Taft Ave, Malate, Manila, 1004 Metro Manila ',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.local_phone_outlined, size: 12,
                                ),
                                SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    '7655-1701',
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ),
                                SizedBox(width: 20.0),
                                Icon(
                                  Icons.access_time_sharp, size: 12,
                                ),
                                SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    '7am - 10pm',
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      trailing: ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Image border
                        child: Container(
                          height: 70.0,
                          width: 70.0,// Image radius
                          child: Image.network('https://aiscracker.com/wp-content/uploads/2008/12/sogoBldg.jpg', fit: BoxFit.cover),
                        ),
                      ),
                      isThreeLine: false,
                      selected: true,
                      onTap: () {
                        showModalBottomSheet(context: context,
                          isScrollControlled: true,
                          builder: (context) => SingleChildScrollView(child: Container(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom),
                            // child: add_medication(thislist: medtemp),
                            child: info_restaurant(),
                          ),
                          ),
                        ).then((value) =>
                            Future.delayed(const Duration(milliseconds: 1500), (){
                              setState((){
                              });
                            }));
                      }

                  ),

                ),
              );
            },
          ) ,
        ],
      ),
    );
  }

}
