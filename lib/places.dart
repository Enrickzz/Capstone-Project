import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:location/location.dart' as locs;
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/GooglePlaces.dart';
import 'package:my_app/models/nutritionixApi.dart';
import 'package:my_app/reviews/drugstore/info_drugstore.dart';
import 'package:my_app/reviews/hospital/info_hospital.dart';
import 'package:my_app/reviews/recreational/info_recreational.dart';
import 'package:my_app/reviews/restaurant/info_restaurant.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/set_up.dart';
import '../additional_data_collection.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import '../dialogs/policy_dialog.dart';
import '../fitness_app_theme.dart';

import 'data_inputs/medicine_intake/add_medication.dart';
import 'models/Reviews.dart';
import 'models/users.dart';
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
  List<Results> drugstores=[], hospitals=[], restaurants=[], recreations=[];
  List<Reviews> reviews =[];
  bool isLoading = true;

  locs.Location location = new locs.Location();
  bool _serviceEnabled;
  locs.PermissionStatus _permissionGranted;
  locs.LocationData _locationData;
  bool _isListenLocation=false, _isGetLocation=false;
  List<Medication_Prescription> medical_list = [];
  List<Supplement_Prescription> supplement_list = [];
  List<listMeds> medical_name = [];
  List<listMeds> mySupplements =[];
  List<Reviews> reviewsrecomm=[];

  @override
  void initState() {
    super.initState();
    reviews.clear();
    getSupplementName();
    getPrescriptionGName();
    getPrescriptionBName();
    controller = TabController(length: 4, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    Future.delayed(const Duration(milliseconds: 1000), (){
      setState(() {
        isLoading = false;
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
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  _serviceEnabled = await location.serviceEnabled();
                  if (!_serviceEnabled) {
                    _serviceEnabled = await location.requestService();
                    if (!_serviceEnabled) {
                      return;
                    }
                  }

                  _permissionGranted = await location.hasPermission();
                  if (_permissionGranted == locs.PermissionStatus.denied) {
                    _permissionGranted = await location.requestPermission();
                    if (_permissionGranted != locs.PermissionStatus.granted) {
                      return;
                    }
                  }

                  _locationData = await location.getLocation();

                  setState(() {
                    _isGetLocation = true;
                  });

                  _isGetLocation ? print('Location: ${_locationData.latitude}, ${_locationData.longitude}'):print("wala");

                  setState(() {
                    reviewsrecomm.clear();
                  });

                  Places("${_locationData.latitude}, ${_locationData.longitude}").then((value) {

                  });
                },
                child: Icon(
                    IconData(0xe2dc, fontFamily: 'MaterialIcons')
                ),

              )
          ),
        ],
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
              text: 'Recreational', icon: Image.asset('assets/images/recreation.png',
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
      body: new TabBarView(
        controller: controller,
        children: [
          DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TabBar(
                  labelColor: Colors.black,
                  tabs: <Widget>[
                    Tab(
                      text: "Locations Nearby",
                    ),
                    Tab(
                      text: "Reviews Nearby",
                    )
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      isLoading
                          ? Center(
                        child: CircularProgressIndicator(),
                      ):
                      ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 100),
                        itemCount: drugstores.length,
                        itemBuilder: (context, index){
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                            child: Card(
                              child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                                    child: Text(""+drugstores[index].name,
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
                                        checkrating(drugstores[index].placeId),
                                        SizedBox(width: 8.0),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on, size: 15,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 4.0),
                                            Flexible(
                                              child: Text(
                                                ''+drugstores[index].formattedAddress,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: Colors.black, fontSize: 12),
                                              ),
                                            ),
                                            SizedBox(height: 30.0),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'See more..',
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
                                        child: _displayMedia(drugstores[index].photos.photoReference)
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
                                        child: info_drugstore(this_info:  drugstores[index], thisrating: checkrating2(drugstores[index].placeId), type: "drugstore"),
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
                      isLoading
                          ? Center(
                        child: CircularProgressIndicator(),
                      ):
                      /// REVIEWS NEARBY
                      ListView.builder(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 100),
                          itemCount: reviewsrecomm.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                              child: Card(
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                                    child: Row(
                                      children: [

                                        Flexible(
                                          child: RichText(
                                            text: TextSpan(
                                              // Here is the explicit parent TextStyle
                                              style: new TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,

                                              ),
                                              children: <TextSpan>[
                                                new TextSpan(text: reviewsrecomm[index].user_name,  style: new TextStyle(fontWeight: FontWeight.bold)),
                                                new TextSpan(text: " reviewed "),
                                                new TextSpan(text: checkPlaceNameString(reviewsrecomm[index].place_name),  style: new TextStyle(fontWeight: FontWeight.bold)),
                                                new TextSpan(text: " located at "),
                                                new TextSpan(text: checkPlaceLocString(reviewsrecomm[index].place_loc),  style: new TextStyle(fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  subtitle:
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            RatingBar(
                                              initialRating:  double.parse(reviewsrecomm[index].rating.toString()),
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              ignoreGestures: true,
                                              itemSize: 14.0,
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
                                            SizedBox(width: 10.0),
                                            if (reviewsrecomm[index].recommend) ...[
                                              Icon(
                                                Icons.thumb_up_alt_sharp, color: Colors.green, size: 15,
                                              ),
                                            ] else ...[
                                              Icon(
                                                Icons.thumb_down_alt_sharp, color: Colors.red, size: 15,
                                              ),
                                            ],
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          getDateFormatted(reviewsrecomm[index].reviewDate.toString()) +  "   " +
                                              getTimeFormatted(reviewsrecomm[index].reviewTime.toString()),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Container(

                                          child: Text(
                                            reviewsrecomm[index].review,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black
                                            ),

                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        checkRev(reviewsrecomm[index].special),
                                      ],
                                    ),
                                  ),

                                  isThreeLine: false,
                                  selected: true,
                                  // onTap: () {
                                  // showModalBottomSheet(context: context,
                                  //   isScrollControlled: true,
                                  //   builder: (context) => SingleChildScrollView(child: Container(
                                  //     padding: EdgeInsets.only(
                                  //         bottom: MediaQuery.of(context).viewInsets.bottom),
                                  //     // child: add_medication(thislist: medtemp),
                                  //     child: info_drugstore(this_info:  drugstores[index], thisrating: checkrating2(drugstores[index].placeId), type: "drugstore"),
                                  //   ),
                                  //   ),
                                  // ).then((value) =>
                                  //     Future.delayed(const Duration(milliseconds: 1500), (){
                                  //       setState((){
                                  //       });
                                  //     }));
                                  // }

                                ),

                              ),
                            );



                            // return Container(
                            //   margin: EdgeInsets.fromLTRB(0, 0, 0, 14),
                            //   child: GestureDetector(
                            //     child: Container(
                            //       decoration: BoxDecoration(
                            //           color: Colors.white,
                            //           borderRadius: BorderRadius.circular(10.0),
                            //           boxShadow: [BoxShadow(
                            //               color: Colors.black26.withOpacity(0.05),
                            //               offset: Offset(0.0,6.0),
                            //               blurRadius: 10.0,
                            //               spreadRadius: 0.10
                            //           )]
                            //       ),
                            //       child: Padding(
                            //         padding: EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
                            //         child: Column(
                            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //           children: <Widget>[
                            //             Container(
                            //               height: 70,
                            //               child: Row(
                            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //                 children: <Widget>[
                            //                   Row(
                            //                     children: <Widget>[
                            //                       if (reviewsrecomm[index].recommend) ...[
                            //                         Icon(
                            //                           Icons.thumb_up_alt_sharp, color: Colors.green,
                            //                         ),
                            //                       ] else ...[
                            //                         Icon(
                            //                           Icons.thumb_down_alt_sharp, color: Colors.red,
                            //                         ),
                            //                       ],
                            //
                            //                       Padding(
                            //                         padding: const EdgeInsets.only(left: 8.0),
                            //                         child: Column(
                            //                           crossAxisAlignment: CrossAxisAlignment.start,
                            //                           mainAxisAlignment: MainAxisAlignment.center,
                            //                           children: <Widget>[
                            //
                            //
                            //                             Column(
                            //                               crossAxisAlignment: CrossAxisAlignment.start,
                            //                               children: [
                            //                                 Row(
                            //                                   children: <Widget>[
                            //                                     Text(
                            //                                       reviewsrecomm[index].user_name,
                            //                                       style: TextStyle(
                            //                                           fontSize: 14,
                            //                                           fontWeight: FontWeight.bold
                            //                                       ),
                            //                                     ),
                            //                                     SizedBox(width: 10),
                            //
                            //                                     Text(
                            //                                       getDateFormatted(reviewsrecomm[index].reviewDate.toString()) +  " " +
                            //                                           getTimeFormatted(reviewsrecomm[index].reviewTime.toString()),
                            //                                       style: TextStyle(
                            //                                         fontSize: 12,
                            //                                       ),
                            //                                     )
                            //                                   ],
                            //                                 ),
                            //                                 SizedBox(height: 2,),
                            //                                 RatingBar(
                            //                                   initialRating:  double.parse(reviewsrecomm[index].rating.toString()),
                            //                                   direction: Axis.horizontal,
                            //                                   allowHalfRating: true,
                            //                                   itemCount: 5,
                            //                                   ignoreGestures: true,
                            //                                   itemSize: 15.0,
                            //                                   onRatingUpdate: (rating) {
                            //                                     print(rating);
                            //                                   },
                            //                                   ratingWidget: RatingWidget(
                            //                                       full: Icon(Icons.star, color: Colors.orange),
                            //                                       half: Icon(
                            //                                         Icons.star_half,
                            //                                         color: Colors.orange,
                            //                                       ),
                            //                                       empty: Icon(
                            //                                         Icons.star_outline,
                            //                                         color: Colors.orange,
                            //                                       )),
                            //                                 ),
                            //
                            //                               ],
                            //                             )
                            //
                            //                           ],
                            //                         ),
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //             checkPlaceName(reviewsrecomm[index].place_name),
                            //             SizedBox(width: 10),
                            //             checkPlaceLoc(reviewsrecomm[index].place_loc),
                            //             SizedBox(width: 10),
                            //             Container(
                            //               width: 300,
                            //               child: Text(
                            //                 reviewsrecomm[index].review,
                            //                 style: TextStyle(
                            //                   fontSize: 14,
                            //                 ),
                            //
                            //               ),
                            //             ),
                            //             SizedBox(height: 5),
                            //             checkRev(reviewsrecomm[index].special),
                            //
                            //             SizedBox(height: 5),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // );
                          }
                      ) ,
                    ],
                  ),
                )
              ],
            ),
          ),
          DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TabBar(
                  labelColor: Colors.black,
                  tabs: <Widget>[
                    Tab(
                      text: "Locations Nearby",
                    ),
                    Tab(
                      text: "Reviews Nearby",
                    )
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      isLoading
                          ? Center(
                        child: CircularProgressIndicator(),
                      ):
                      ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 100),
                        itemCount: hospitals.length,
                        itemBuilder: (context, index){
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                            child: Card(
                              child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                                    child: Text(""+hospitals[index].name,
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
                                        checkrating(hospitals[index].placeId),
                                        SizedBox(width: 8.0),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on, size: 15,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 8.0),
                                            Flexible(
                                              child: Text(
                                                ''+hospitals[index].formattedAddress,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: Colors.black, fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'See more..',
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
                                        child: _displayMedia(hospitals[index].photos.photoReference)
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
                                        child: info_hospital(this_info:  hospitals[index], thisrating: checkrating2(hospitals[index].placeId), type: "hospital"),
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
                      isLoading
                          ? Center(
                        child: CircularProgressIndicator(),
                      ):
                      ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 100),
                        itemCount: hospitals.length,
                        itemBuilder: (context, index){
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                            child: Card(
                              child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                                    child: Text(""+hospitals[index].name,
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
                                        checkrating(hospitals[index].placeId),
                                        SizedBox(width: 8.0),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on, size: 15,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 8.0),
                                            Flexible(
                                              child: Text(
                                                ''+hospitals[index].formattedAddress,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: Colors.black, fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'See more..',
                                                style: TextStyle(color: Colors.black, fontSize: 12),
                                              ),
                                            ),
                                            // Icon(
                                            //   Icons.local_phone_outlined, size: 12,
                                            // ),
                                            // SizedBox(width: 8.0),
                                            // Flexible(
                                            //   child: Text(
                                            //     '7655-1701',
                                            //     style: TextStyle(color: Colors.black, fontSize: 12),
                                            //   ),
                                            // ),
                                            // SizedBox(width: 20.0),
                                            // Icon(
                                            //   Icons.access_time_sharp, size: 12,
                                            // ),
                                            // SizedBox(width: 8.0),
                                            // Flexible(
                                            //   child: Text(
                                            //     '7am - 10pm',
                                            //     style: TextStyle(color: Colors.black, fontSize: 12),
                                            //   ),
                                            // ),
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
                                        child: _displayMedia(hospitals[index].photos.photoReference)
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
                                        child: info_hospital(this_info:  hospitals[index], thisrating: checkrating2(hospitals[index].placeId), type: "hospital"),
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
                )
              ],
            ),
          ),
          DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TabBar(
                  labelColor: Colors.black,
                  tabs: <Widget>[
                    Tab(
                      text: "Locations Nearby",
                    ),
                    Tab(
                      text: "Reviews Nearby",
                    )
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      isLoading
                          ? Center(
                        child: CircularProgressIndicator(),
                      ):
                      ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 100),
                        itemCount: recreations.length,
                        itemBuilder: (context, index){
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                            child: Card(
                              child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                                    child: Text(recreations[index].name,
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
                                        checkrating(recreations[index].placeId),
                                        SizedBox(width: 8.0),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on, size: 15,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 8.0),
                                            Flexible(
                                              child: Text(
                                                recreations[index].formattedAddress,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: Colors.black, fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'See more..',
                                                style: TextStyle(color: Colors.black, fontSize: 12),
                                              ),
                                            )
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
                                        child: _displayMedia(recreations[index].photos.photoReference)
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
                                        child: info_recreational(this_info:  recreations[index],thisrating: checkrating2(recreations[index].placeId), type: "recreation"),
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
                      isLoading
                          ? Center(
                        child: CircularProgressIndicator(),
                      ):
                      ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 100),
                        itemCount: recreations.length,
                        itemBuilder: (context, index){
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                            child: Card(
                              child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                                    child: Text(recreations[index].name,
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
                                        checkrating(recreations[index].placeId),
                                        SizedBox(width: 8.0),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on, size: 15,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 8.0),
                                            Flexible(
                                              child: Text(
                                                recreations[index].formattedAddress,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: Colors.black, fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'See more..',
                                                style: TextStyle(color: Colors.black, fontSize: 12),
                                              ),
                                            )
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
                                        child: _displayMedia(recreations[index].photos.photoReference)
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
                                        child: info_recreational(this_info:  recreations[index],thisrating: checkrating2(recreations[index].placeId), type: "recreation"),
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
                )
              ],
            ),
          ),
          DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TabBar(
                  labelColor: Colors.black,
                  tabs: <Widget>[
                    Tab(
                      text: "Locations Nearby",
                    ),
                    Tab(
                      text: "Reviews Nearby",
                    )
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      isLoading
                          ? Center(
                        child: CircularProgressIndicator(),
                      ):
                      ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 100),
                        itemCount: restaurants.length,
                        itemBuilder: (context, index){
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                            child: Card(
                              child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                                    child: Text(restaurants[index].name,
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
                                        checkrating(restaurants[index].placeId),
                                        SizedBox(width: 8.0),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on, size: 15,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 8.0),
                                            Flexible(
                                              child: Text(
                                                restaurants[index].formattedAddress,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: Colors.black, fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'See more..',
                                                style: TextStyle(color: Colors.black, fontSize: 12),
                                              ),
                                            )
                                            // Icon(
                                            //   Icons.local_phone_outlined, size: 12,
                                            // ),
                                            // SizedBox(width: 8.0),
                                            // Flexible(
                                            //   child: Text(
                                            //     '7655-1701',
                                            //     style: TextStyle(color: Colors.black, fontSize: 12),
                                            //   ),
                                            // ),
                                            // SizedBox(width: 20.0),
                                            // Icon(
                                            //   Icons.access_time_sharp, size: 12,
                                            // ),
                                            // SizedBox(width: 8.0),
                                            // Flexible(
                                            //   child: Text(
                                            //     '7am - 10pm',
                                            //     style: TextStyle(color: Colors.black, fontSize: 12),
                                            //   ),
                                            // ),
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
                                        child: _displayMedia(restaurants[index].photos.photoReference)
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
                                        child: info_restaurant(this_info:  restaurants[index], thisrating: checkrating2(restaurants[index].placeId), type: "restaurant"),
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
                      isLoading
                          ? Center(
                        child: CircularProgressIndicator(),
                      ):
                      ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 100),
                        itemCount: restaurants.length,
                        itemBuilder: (context, index){
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                            child: Card(
                              child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                                    child: Text(restaurants[index].name,
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
                                        checkrating(restaurants[index].placeId),
                                        SizedBox(width: 8.0),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on, size: 15,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 8.0),
                                            Flexible(
                                              child: Text(
                                                restaurants[index].formattedAddress,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: Colors.black, fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'See more..',
                                                style: TextStyle(color: Colors.black, fontSize: 12),
                                              ),
                                            )
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
                                        child: _displayMedia(restaurants[index].photos.photoReference)
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
                                        child: info_restaurant(this_info:  restaurants[index], thisrating: checkrating2(restaurants[index].placeId), type: "restaurant"),
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
                )
              ],
            ),
          ),

        ],
      ),
    );
  }

  Future<List<Results>> Places(String query) async{
    final User user = auth.currentUser;
    final uid = user.uid;
    String a;
    String key = "AIzaSyBFsY_boEXrduN5Huw0f_eY88JDhWwiDrk";
    String
    //loc = "16.03599037979812, 120.33470282456094",
    loc = query,

        radius ="2000",
        type="drugstore",
        query1= "Drugstore";
    print(loc + " <<<<<<<");

    var drugstorres = await http.get(Uri.parse("https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query1&key=$key&location=$loc&radius=$radius&type=$type"));
    var hospitalres = await http.get(Uri.parse("https://maps.googleapis.com/maps/api/place/textsearch/json?key=$key&location=$loc&radius=$radius&type=hospital"));
    var recreationres = await http.get(Uri.parse("https://maps.googleapis.com/maps/api/place/textsearch/json?query=recreational&key=$key&location=$loc&radius=$radius&type=recreation"));
    var restaurantsres = await http.get(Uri.parse("https://maps.googleapis.com/maps/api/place/textsearch/json?key=$key&location=$loc&radius=$radius&type=restaurant"));
    // var restaurantsres = await http.get(Uri.parse("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=16.03599037979812, 120.33470282456094&radius=1000&key=AIzaSyBFsY_boEXrduN5Huw0f_eY88JDhWwiDrk&type=restaurant"));

    List<Results> gplaces=[];
    gplaces = GooglePlaces.fromJson(jsonDecode(drugstorres.body)).results;
    drugstores = gplaces;
    hospitals = GooglePlaces.fromJson(jsonDecode(hospitalres.body)).results;
    recreations = GooglePlaces.fromJson(jsonDecode(recreationres.body)).results;
    restaurants = GooglePlaces.fromJson(jsonDecode(restaurantsres.body)).results;

    for(var i = 0 ; i < drugstores.length; i++){
      if(drugstores[i].photos != "photoref"){
        String replace = "https://maps.googleapis.com/maps/api/place/photo?photoreference=" +
            drugstores[i].photos.photoReference+
            "&sensor=false&maxheight=300&maxwidth=300&key=$key";
        drugstores[i].photos.photoReference = replace;
        // print(drugstores[i].photos.photoReference + "<<<<<<<<<<<<<<<<<<");
      }
    }
    for(var i = 0 ; i < hospitals.length; i++){
      if(hospitals[i].photos != "photoref"){
        String replace = "https://maps.googleapis.com/maps/api/place/photo?photoreference=" +
            hospitals[i].photos.photoReference+
            "&sensor=false&maxheight=300&maxwidth=300&key=$key";
        hospitals[i].photos.photoReference = replace;
        // print(drugstores[i].photos.photoReference + "<<<<<<<<<<<<<<<<<<");
      }
    }
    for(var i = 0 ; i < recreations.length; i++){
      if(recreations[i].photos != "photoref"){
        String replace = "https://maps.googleapis.com/maps/api/place/photo?photoreference=" +
            recreations[i].photos.photoReference+
            "&sensor=false&maxheight=300&maxwidth=300&key=$key";
        recreations[i].photos.photoReference = replace;
        // print(drugstores[i].photos.photoReference + "<<<<<<<<<<<<<<<<<<");
      }
    }

    for(var i = 0 ; i < restaurants.length; i++){
      if(restaurants[i].photos != "photoref"){
        String replace = "https://maps.googleapis.com/maps/api/place/photo?photoreference=" +
            restaurants[i].photos.photoReference+
            "&sensor=false&maxheight=300&maxwidth=300&key=$key";
        restaurants[i].photos.photoReference = replace;
        // print(drugstores[i].photos.photoReference + "<<<<<<<<<<<<<<<<<<");
      }
    }

    reviews.clear();
    getReviews().then((value) {
      reviewRecs();
      setState(() {
        print("NAGSETSTATE SA CALL NG SHIT");
        isLoading = false;
      });
    });
    return gplaces;
  }
  void reviewRecs(){
    print("REVIEWRECS");
    final User user = auth.currentUser;
    final uid = user.uid;
    for(var i = 0; i < reviews.length; i++){
      for(var j = 0; j < drugstores.length; j++){
        if(reviews[i].placeid == drugstores[j].placeId){
          for(var k = 0 ; k < medical_name.length; k++){
            if(medical_name[k].name == reviews[i].special){
              ///checks if meds is in patient db
              // if(reviews[i].added_by != uid){
              reviewsrecomm.add(reviews[i]);
              print("REVIEW FOUND" + reviews[i].user_name);
              // }
            }
          }
        }
      }
    }
  }
  void getPrescriptionBName() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readprescription = databaseReference.child('users/' + uid + '/management_plan/medication_prescription_list/');
    readprescription.once().then((DataSnapshot snapshot){
      int bcount = 0;
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      if(temp != null){
        temp.forEach((jsonString) {
          medical_list.add(Medication_Prescription.fromJson(jsonString));
          // medical_name.add(medical_list[bcount].branded_name);
          medical_name.add(new listMeds(medical_list[bcount].generic_name, medical_list[bcount].dosage.toString(), medical_list[bcount].prescription_unit));

          bcount++;
        });
      }

    });
  }
  void getPrescriptionGName() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readprescription = databaseReference.child('users/' + uid + '/management_plan/medication_prescription_list/');
    readprescription.once().then((DataSnapshot snapshot){
      int gcount = 0;
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        medical_list.add(Medication_Prescription.fromJson(jsonString));
        //medical_name.add(medical_list[gcount].generic_name);
        //medical_name.add(new listMeds(medical_list[gcount].generic_name, medical_list[gcount].dosage.toString(), medical_list[gcount].prescription_unit));
        gcount++;
      });
    });
  }
  void getSupplementName() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readsupplement = databaseReference.child('users/' + uid + '/management_plan/supplement_prescription_list/');
    readsupplement.once().then((DataSnapshot snapshot){
      int suppcount = 0;
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      if(temp != null){
        temp.forEach((jsonString) {
          supplement_list.add(Supplement_Prescription.fromJson(jsonString));
          // medical_name.add(supplement_list[suppcount].supplement_name);
          medical_name.add(new listMeds(supplement_list[suppcount].supplement_name, supplement_list[suppcount].dosage.toString(), supplement_list[suppcount].prescription_unit));

          suppcount++;
        });
      }
    });
  }
  Future<bool> getReviews() async{
    for (var i = 0; i < drugstores.length;i++){
      final readReviews = databaseReference.child('reviews/' + drugstores[i].placeId+"/");
      await readReviews.once().then((DataSnapshot snapshot){
        List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
        if(temp != null){
          temp.forEach((jsonString) {
            reviews.add(Reviews.fromJson(jsonString));
            // print(reviews.length.toString()+ "<<<<<<<<<<<");
          });
        }
      });
    }
    for (var i = 0; i < hospitals.length;i++){
      final readReviews = databaseReference.child('reviews/' + hospitals[i].placeId+"/");
      await readReviews.once().then((DataSnapshot snapshot){
        // print(snapshot.value);
        List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
        if(temp != null){
          temp.forEach((jsonString) {
            reviews.add(Reviews.fromJson(jsonString));
            // print(reviews.length.toString()+ "<<<<<<<<<<<");
          });
        }
      });
    }
    for (var i = 0; i < recreations.length;i++){
      final readReviews = databaseReference.child('reviews/' + recreations[i].placeId+"/");
      await readReviews.once().then((DataSnapshot snapshot){
        // print(snapshot.value);
        List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
        if(temp != null){
          temp.forEach((jsonString) {
            reviews.add(Reviews.fromJson(jsonString));
            // print(reviews.length.toString()+ "<<<<<<<<<<<");
          });
        }
      });
    }
    for (var i = 0; i < restaurants.length;i++){
      final readReviews = databaseReference.child('reviews/' + restaurants[i].placeId+"/");
      await readReviews.once().then((DataSnapshot snapshot){
        // print(snapshot.value);
        List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
        if(temp != null){
          temp.forEach((jsonString) {
            reviews.add(Reviews.fromJson(jsonString));
            // print(reviews.length.toString()+ "<<<<<<<<<<<");
          });
        }
      });
    }
    return true;
  }
  Widget _displayMedia(String media) {
    if(media == "photoref") {
      // print("PHOTOREF ITO ");
      return Image.asset("assets/images/no-image.jpg");
    }
    else{
      return Image.network(media,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset("assets/images/no-image.jpg");
          },fit: BoxFit.cover);
    }

  }
  Widget checkrating(String placeid) {
    double thisrating=0;
    String textRate="";
    int counter = 0;
    bool checker = true;
    for(var i =0 ; i < reviews.length; i++){
      if(reviews[i].placeid == placeid){
        thisrating = thisrating + double.parse(reviews[i].rating.toString());
        // print( reviews[i].placeid +"  "+reviews[i].rating.toString());
        counter ++;
      }
    }
    if(thisrating >0 ){
      thisrating = thisrating/counter;
    }
    if(counter == 0){
      textRate = "No reviews yet";
      checker = false;
    }else{
      textRate = '(' +thisrating.toString() +')';
    }
    // print("This rating = " +thisrating.toString() + " "+placeid);
    return Row(
      children: [
        SizedBox(height: 16.0),
        Text(
          '',
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        ratingWidget(checker, thisrating),
        Text(
          textRate,
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),

      ],
    );
  }
  double checkrating2(String placeid){
    double thisrating=0;
    String textRate="";
    int counter = 0;
    bool checker = true;
    for(var i =0 ; i < reviews.length; i++){
      if(reviews[i].placeid == placeid){
        thisrating = thisrating + double.parse(reviews[i].rating.toString());
        // print( reviews[i].placeid +"  "+reviews[i].rating.toString());
        counter ++;
      }
    }
    if(thisrating >0 ){
      thisrating = thisrating/counter;
    }
    if(counter == 0){
      textRate = "No reviews yet";
      checker = false;
    }else{
      textRate = '(' +thisrating.toString() +')';
    }
    return thisrating;
  }
  Widget ratingWidget(bool check, double thisrating){
    if(check == true){
      return RatingBar(
        initialRating: thisrating,
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
      );
    }else{
      return Text(
        "",
        style: TextStyle(color: Colors.black, fontSize: 12),
      );
    }
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
  Widget checkRev(String special) {
    if(special == ""){
      return Text("");
    }else{
      return
        Container(
          child: Row(
            children: [
              Icon(
                Icons.medication_outlined, color: Colors.blue,
              ),
              Text(special, style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
              ),
            ],
          ),
        );
    }
  }
  Widget checkPlaceName(String check){
    if(check =="" || check == null){
      return Text("Wala pang place name DB prob");
    }else{
      return Text(
        check.toString()+"",
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold
        ),
      );
    }
  }

  String checkPlaceNameString(String check){
    if(check =="" || check == null){
      return "Wala pang place name DB prob";
    }else{
      return check.toString();

    }
  }
  Widget checkPlaceLoc(String check){
    if(check =="" || check == null){
      return Text("Wala pang place loc DB prob");
    }else{
      return Text(
        check.toString()+"",
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold
        ),
      );
    }
  }

  String checkPlaceLocString(String check){
    if(check =="" || check == null){
      return "Wala pang place loc DB prob";
    }else{
      return check.toString();
    }
  }

}
