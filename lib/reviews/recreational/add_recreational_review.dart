
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/FirebaseFile.dart';
import 'package:my_app/models/GooglePlaces.dart';
import 'package:my_app/models/Reviews.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_app/widgets/rating.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';


class add_recreational_review extends StatefulWidget {
  final List<FirebaseFile> files;
  final Results thisPlace;
  final String type;
  add_recreational_review({Key key, this.files, this.thisPlace, this.type});
  @override
  _create_postState createState() => _create_postState();
}
final _formKey = GlobalKey<FormState>();
class _create_postState extends State<add_recreational_review> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  var path;
  User user;
  var uid, fileName;
  // File file;
  String thisURL;
  String title = '';
  String description = '';

  List<FirebaseFile> trythis =[];
  String thisIMG="";

  //for upload image
  bool pic = false;
  String cacheFile="";
  File file = new File("path");

  //for rating
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  int _rating = 0;
  bool isSwitched = false;
  int count = 0;
  List<Reviews> reviews=[];
  Users thisuser;
  String date="",min="",hours="";

  //borj added
  bool activityRecommend = false;
  String recommendedActivity = '';

  @override
  void initState(){
    DateTime a = new DateTime.now();
    date = "${a.month}/${a.day}/${a.year}";
    print("THIS DATE");
    TimeOfDay time = TimeOfDay.now();
    hours = time.hour.toString().padLeft(2,'0');
    min = time.minute.toString().padLeft(2,'0');
    print("DATE = " + date);
    print("TIME = " + "$hours:$min");
    final User user = auth.currentUser;
    final uid = user.uid;
    final readUser = databaseReference.child('users/'+uid+"/personal_info/");
    readUser.once().then((DataSnapshot snapshot){
      // print(snapshot.value);
      var temp1 = jsonDecode(jsonEncode(snapshot.value));
      thisuser = Users.fromJson3(temp1);
      print(thisuser);
      Future.delayed(const Duration(milliseconds: 2000),(){
        print("this user\n"+thisuser.firstname);
        print(thisuser.firstname + " " + thisuser.lastname);

      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // trythis.clear();
    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;
    final Storage storage = Storage();

    return Container(
        key: _formKey,
        color:Color(0xff757575),
        child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft:Radius.circular(20),
                topRight:Radius.circular(20),
              ),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    ' Review/Recommendation',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SwitchListTile(
                    title: Text('Activity Recommendation', style: TextStyle(fontSize: 16.0)),
                    subtitle: Text('There are suitable activities for CVD patients to perform', style: TextStyle(fontSize: 12.0)),
                    secondary: Icon(Icons. sports, size: 34.0, color: Colors.blue),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: activityRecommend,
                    onChanged: (value){
                      setState(() {
                        activityRecommend = value;


                      });
                    },
                  ),
                  SizedBox(height: 8.0),
                  Visibility(
                    visible: activityRecommend,
                    child: TextFormField(
                      showCursor: true,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            width:0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        fillColor: Color(0xFFF2F3F5),
                        hintStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: defaultFontFamily,
                            fontSize: defaultFontSize),
                        hintText: "What activity do you recommend?",
                      ),
                      onChanged: (val){
                        setState(() => recommendedActivity = val);
                      },
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    showCursor: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width:0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "Description",
                    ),
                    onChanged: (val){
                      setState(() => description = val);
                    },
                  ),
                  SizedBox(height: 8.0),
                  SwitchListTile(
                    title: Text('Recommend', style: TextStyle(fontSize: 22.0)),
                    subtitle: Text('I would like to recommend this restaurant to other CVD patients.', style: TextStyle(fontSize: 12.0)),
                    secondary: Icon(Icons.thumb_up_alt_sharp, size: 34.0, color: Colors.green),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: isSwitched,
                    onChanged: (value){
                      setState(() {
                        isSwitched = value;
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text("Rating", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                      SizedBox(width: 14,),
                      Rating((rating){
                        setState(() {
                          _rating = rating;
                        });

                      }),
                    ],

                  ),

                  SizedBox(
                    height: 44,
                    child: _rating != null && _rating >0
                        ? Text("I give this place a rating of $_rating star/s",
                        style: TextStyle(fontSize: 18))
                        :SizedBox.shrink(),

                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:() {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text(
                          'Post',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.green,
                        onPressed:() async {
                          try{
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            final readReview = databaseReference.child('reviews/'+ widget.thisPlace.placeId +"/");
                            //DatabaseReference last = addReview.push();
                            readReview.once().then((DataSnapshot datasnapshot) {
                              if(datasnapshot.value == null){
                                final addReview = databaseReference.child('reviews/'+ widget.thisPlace.placeId+"/"+0.toString());
                                addReview.set({"added_by": uid,
                                  "placeid": widget.thisPlace.placeId,
                                  "user_name": thisuser.firstname+" "
                                      +thisuser.lastname,
                                  "review": description,
                                  "rating": _rating,
                                  "recommend": isSwitched,
                                  "reviewDate": "$date",
                                  "reviewTime": "$hours:$min",
                                  "special": recommendedActivity,
                                  "place_loc": widget.thisPlace.formattedAddress,
                                  "place_name": widget.thisPlace.name
                                });
                              }else{
                                List<dynamic> temp = jsonDecode(jsonEncode(datasnapshot.value));
                                temp.forEach((jsonString) {
                                  reviews.add(Reviews.fromJson(jsonString));
                                  print(reviews.length.toString()+ "<<<<<<<<<<<");
                                });
                                count = reviews.length--;
                                print("count " + count.toString());
                                final addReview = databaseReference.child('reviews/'+ widget.thisPlace.placeId+"/"+count.toString());
                                addReview.set({"added_by": uid,
                                  "placeid": widget.thisPlace.placeId,
                                  "user_name": thisuser.firstname+" "
                                      +thisuser.lastname,
                                  "review": description,
                                  "rating": _rating,
                                  "recommend": isSwitched,
                                  "reviewDate": "$date",
                                  "reviewTime": "$hours:$min",
                                  "special": recommendedActivity,
                                  "place_loc": widget.thisPlace.formattedAddress,
                                  "place_name": widget.thisPlace.name
                                });
                              }
                            });
                            Reviews newR = new Reviews(added_by: uid, placeid: widget.thisPlace.placeId,
                                review: description, user_name: thisuser.firstname+" " +thisuser.lastname, rating: _rating, reviewDate: DateFormat("MM/dd/yyyy").parse(date),
                                reviewTime: DateFormat("hh:mm").parse("$hours:$min"), recommend: isSwitched, special: recommendedActivity
                                ,place_loc: widget.thisPlace.formattedAddress, place_name:  widget.thisPlace.name);
                            Navigator.pop(context, newR);
                          }catch(e){
                            print("Error");
                          }


                          // Navigator.pop(context);
                        },
                      )
                    ],
                  ),

                ]
            )
        )
    );
  }
  void NotifyPatients(Results placeobj) async{
    final User user = auth.currentUser;
    final loggedId = user.uid;
    List<Users> patients;
    List<PatientIds> plist=[];
    final idRef = databaseReference.child('patient_ids/');
    await idRef.once().then((DataSnapshot snapshot) {
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      if(temp == null){

      }else{
        temp.forEach((jsonString) {
          plist.add(PatientIds.fromJson(jsonString));
        });

        for(var i = 0 ; i < plist.length; i++){
          getRecomm(plist[i].id);
          var readUsers = databaseReference.child('users/'+plist[i].id+"/personal_info");
          readUsers.once().then((DataSnapshot snapshot2) {
            var temp2 = jsonDecode(jsonEncode(snapshot2.value));
            Users thisUser = Users.fromJson2(temp2);
            print("ADD RECOMMENDATIONS TO "+ thisUser.firstname + " << " + thisUser.uid);
            if(plist[i].id != loggedId){
              addtoRecommendation("Another Heartistant CVD user has recommended "+placeobj.name+", a "+ widget.type+", "
                  "which is suitable for other CVD patients. Click here to view",
                  "Peer Recommendation!",
                  "1",
                  placeobj.placeId,
                  plist[i].id);
            }
          });
        }
      }
    });
  }
  Future <List<String>>_getDownloadLinks(List<Reference> refs) {
    return Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());
  }

  Future<List<FirebaseFile>> listAll (String path) async {
    final User user = auth.currentUser;
    final uid = user.uid;
    final ref = FirebaseStorage.instance.ref('test/' + uid + "/");
    final result = await ref.listAll();
    final urls = await _getDownloadLinks(result.items);
    // print("IN LIST ALL\n\n " + urls.toString() + "\n\n" + result.items[1].toString());
    return urls
        .asMap()
        .map((index, url){
      final ref = result.items[index];
      final name = ref.name;
      final file = FirebaseFile(ref: ref, name:name, url: url);
      trythis.add(file);
      print("This file " + file.url);
      return MapEntry(index, file);
    })
        .values
        .toList();

  }



  Future <String> downloadUrl(String imagename) async{
    final ref = FirebaseStorage.instance.ref('test/$imagename');
    String downloadurl = await ref.getDownloadURL();
    print ("THIS IS THE URL = "+ downloadurl);
    thisURL = downloadurl;
    return downloadurl;
  }
  void getRecomm(String uid) {
    print("GET RECOM");
    recommList.clear();
    final readBP = databaseReference.child('users/' + uid + '/recommendations/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        recommList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  void addtoRecommendation(String message, String title, String priority,String redirect, String uid) async {
    final ref = databaseReference.child('users/' + uid + '/recommendations/');
    getRecomm(uid);
    await ref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final ref = databaseReference.child('users/' + uid + '/recommendations/' + 0.toString());
        ref.set({"id": 0.toString(), "message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "recommend", "redirect": redirect});
      }else{
        // count = recommList.length--;
        final ref = databaseReference.child('users/' + uid + '/recommendations/' + recommList.length.toString());
        ref.set({"id": recommList.length.toString(), "message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "recommend", "redirect": redirect});

      }
    });
  }


}