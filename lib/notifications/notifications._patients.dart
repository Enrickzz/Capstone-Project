import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_app/data_inputs/medicine_intake/add_medication.dart';
import 'package:my_app/data_inputs/vitals/blood_glucose/add_blood_glucose.dart';
import 'package:my_app/data_inputs/vitals/blood_pressure/add_blood_pressure.dart';
import 'package:my_app/data_inputs/vitals/heart_rate/add_heart_rate.dart';
import 'package:my_app/data_inputs/vitals/oxygen_saturation/add_o2_saturation.dart';
import 'package:my_app/goal_tab/meals/recommended_meals.dart';
import 'package:my_app/goal_tab/music/music_recommendation.dart';
import 'package:my_app/management_plan/exercise_plan/exercise_plan_patient_view.dart';
import 'package:my_app/management_plan/food_plan/food_plan_patient_view.dart';
import 'package:my_app/management_plan/medication_prescription/view_medical_prescription_as_patient.dart';
import 'package:my_app/management_plan/vitals_plan/vitals_plan_patient_view.dart';
import 'package:my_app/models/OnePlace.dart';
import 'package:my_app/models/Reviews.dart';
import 'package:my_app/reviews/info_place.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/models/nutritionixApi.dart';
import 'dart:convert' as convert;
import '../fitness_app_theme.dart';
import '../models/users.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class notifications extends StatefulWidget {
  const notifications({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _notificationsState createState() => _notificationsState();
}

class _notificationsState extends State<notifications> with SingleTickerProviderStateMixin {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  List<String> generate =  List<String>.generate(100, (index) => "$index ror");
  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  List<Reviews> reviews =[];
  Result2 thisPlace;
  List<Common> foodrecomm=[];
  @override
  void initState() {
    super.initState();
    getNotifs();
    getRecomm();
    print("NGI");
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    Future.delayed(const Duration(milliseconds: 2000), (){
      setState(() {
        print("Set State this");
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
          controller: controller,
          indicatorColor: Colors.grey,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs:<Widget>[
            Tab(
              text: 'Notifications',
            ),
            Tab(
              text: 'Recommendations',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [

          //notifications
          Container(
            color: FitnessAppTheme.background,
              child: Scrollbar(
                child: ListView.separated(
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.all(8.0),
                    itemCount: notifsList.length,
                    itemBuilder: (context, index) {
                      final notif = notifsList[index];
                      return Dismissible(key: Key(notif.id),
                          child: ListTile(
                            leading: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(image:DecorationImage(image: AssetImage('assets/images/priority'+notif.priority+ '.png'), fit: BoxFit.contain))
                            ),
                            title: Text(''+notif.title, style: TextStyle(fontSize: 14.0)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(''+notif.message, style: TextStyle(fontSize: 12.0)),
                                SizedBox(height: 4),
                                Text(''+notif.rec_date.toString()+" "+notif.rec_time.toString(), style: TextStyle(fontSize: 11.0)),
                              ],
                            ),
                            onTap: (){
                              if(notif.title.toString().toLowerCase().contains("added to your food plan")){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => food_prescription_patient_view(animationController: widget.animationController)));
                              }
                              if(notif.title.toString().toLowerCase().contains("added to your exercise plan")){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => exercise_prescription_patient_view(animationController: widget.animationController)));
                              }
                              if(notif.title.toString().toLowerCase().contains("added to your medication plan")){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => medication_prescription_patientView()));
                              }
                              if(notif.title.toString().toLowerCase().contains("added to your vitals plan")){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => vitals_prescription_patient_view()));
                              }

                              if(notif.title == "Take your meds!"){
                                showModalBottomSheet(context: context,
                                  isScrollControlled: true,
                                  builder: (context) => SingleChildScrollView(child: Container(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom),
                                    // child: add_medication(thislist: medtemp),
                                    child: add_medication(instance: "Recommend"),
                                  ),
                                  ),
                                );
                              }
                              Future.delayed(const Duration(milliseconds: 1000), (){
                                if(notif.title == "Reminder!" && notif.redirect == "Blood Pressure"){
                                  showModalBottomSheet(context: context,
                                    isScrollControlled: true,
                                    builder: (context) => SingleChildScrollView(child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                      // child: add_medication(thislist: medtemp),
                                      child: add_blood_pressure(instance: "Recommend"),
                                    ),
                                    ),
                                  );
                                }
                                print("===" + notif.title +"\n"+notif.category);
                                if(notif.title == "Reminder!" && notif.category == "heartrate"){
                                  showModalBottomSheet(context: context,
                                    isScrollControlled: true,
                                    builder: (context) => SingleChildScrollView(child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                      // child: add_medication(thislist: medtemp),
                                      child: add_heart_rate(instance: "Recommend"),
                                    ),
                                    ),
                                  );
                                }
                                if(notif.title == "Reminder!" && notif.category == "oxygen"){
                                  showModalBottomSheet(context: context,
                                    isScrollControlled: true,
                                    builder: (context) => SingleChildScrollView(child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                      // child: add_medication(thislist: medtemp),
                                      child: add_o2_saturation(instance: "Recommend"),
                                    ),
                                    ),
                                  );
                                }
                                if(notif.title == "Reminder!" && notif.redirect == "Glucose"){
                                  showModalBottomSheet(context: context,
                                    isScrollControlled: true,
                                    builder: (context) => SingleChildScrollView(child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                      // child: add_medication(thislist: medtemp),
                                      child: add_blood_glucose(instance: "Recommend"),
                                    ),
                                    ),
                                  );
                                }
                              });

                            },
                          ),
                        onDismissed: (direction){
                          setState(() {
                            notifsList.removeAt(index);
                            deleteOneNotif(index);
                            // deleteOneNotif(index);
                          });
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('Notification dismissed')));

                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    }
                ),
              ),
          ),
          //Recommendations
          Container(
            color: FitnessAppTheme.background,
            child: Scrollbar(
              child: ListView.separated(
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.all(8.0),
                  itemCount: recommList.length,
                  itemBuilder: (context, index) {
                    final recomm = recommList[index];
                    return Dismissible(
                      child: ListTile(
                        leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(image:DecorationImage(image: AssetImage('assets/images/priority'+recomm.priority+ '.png'), fit: BoxFit.contain))
                        ),
                        title: Text(''+recomm.title, style: TextStyle(fontSize: 14.0)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(''+recomm.message.replaceAll("For the meantime you can sit, stay calm, and rest with the help of this soothing song.", "")
                                .replaceAll("For the meantime please relax yourself and perform deep breathing exercises as you listen to some soothing music.", "")
                                , style: TextStyle(fontSize: 12.0)),
                            SizedBox(height: 4),
                            Text(''+recomm.rec_date.toString()+" "+recomm.rec_time.toString(), style: TextStyle(fontSize: 11.0)),
                          ],
                        ),
                        onTap: (){
                          String type="";
                          if(recomm.message.contains("restaurant")){
                            type = "restaurant";
                          }else if(recomm.message.contains("hospital")){
                            type = "hospital";
                          }else if(recomm.message.contains("drugstore")){
                            type = "drugstore";
                          }else if(recomm.message.contains("recreation")){
                            type = "recreation";
                          }
                          Future.delayed(const Duration(milliseconds: 2000), (){
                            if(recomm.redirect ==  "Food - Hemoglobin" && recomm.title == "Low Hemoglobin!"){
                              List<String> query = ["Spinach", "Legumes", "Brocolli"];
                              var rng = new Random();
                              fetchNutritionix(query[rng.nextInt(query.length)]).then((value) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => recommended_meals(mealsrecommendation: value, animationController: widget.animationController)));
                              });
                            }
                            if(recomm.redirect ==   "Food - Cholesterol" && recomm.title == "High Cholesterol!"){
                              List<String> query = ["Tuna", "Walnuts", "Salmon"];
                              var rng = new Random();
                              fetchNutritionix(query[rng.nextInt(query.length)]).then((value) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => recommended_meals(mealsrecommendation: value, animationController: widget.animationController)));
                              });
                            }
                            if(recomm.redirect ==   "Food - Cholesterol" && recomm.title == "High Cholesterol!"){
                              List<String> query = ["Tuna", "Walnuts", "Salmon"];
                              var rng = new Random();
                              fetchNutritionix(query[rng.nextInt(query.length)]).then((value) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => recommended_meals(mealsrecommendation: value, animationController: widget.animationController)));
                              });
                            }
                            if(recomm.redirect ==   "Food - Potassium" && recomm.title == "Low Potassium!"){
                              List<String> query = ["Spinach", "Banana", "Beef"];
                              var rng = new Random();
                              fetchNutritionix(query[rng.nextInt(query.length)]).then((value) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => recommended_meals(mealsrecommendation: value, animationController: widget.animationController)));
                              });
                            }
                            if(recomm.redirect ==   "Food - Glucose" && recomm.title == "Unusually Low Blood Sugar"){
                              List<String> query = ["Candy", "Banana", "Peanut Butter"];
                              var rng = new Random();
                              fetchNutritionix(query[rng.nextInt(query.length)]).then((value) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => recommended_meals(mealsrecommendation: value, animationController: widget.animationController)));
                              });
                            }
                            if(recomm.redirect == "food_intake"){
                              if(recomm.title == "Meals too fatty!"){
                                List<String> query = ["Fish", "Lean Meat", "Vegetables"];
                                var rng = new Random();
                                fetchNutritionix(query[rng.nextInt(query.length)]);
                                fetchNutritionix(query[rng.nextInt(query.length)]).then((value) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => recommended_meals(mealsrecommendation: value, animationController: widget.animationController)));
                                });
                              }else if (recomm.title == "Too much cholesterol!" ){
                                List<String> query = ["Avocado", "Salmon", "Dark Chocolate"];
                                var rng = new Random();
                                fetchNutritionix(query[rng.nextInt(query.length)]).then((value) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => recommended_meals(mealsrecommendation: value, animationController: widget.animationController)));
                                });
                              }else if (recomm.title == "Salty food!" ){
                                List<String> query = ["Banana", "Tuna", "Salad"];
                                var rng = new Random();
                                fetchNutritionix(query[rng.nextInt(query.length)]).then((value) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => recommended_meals(mealsrecommendation: value, animationController: widget.animationController)));
                                });
                              }else if (recomm.title == "Too much salt!" ){
                                List<String> query = ["Banana", "Tuna", "Salad"];
                                var rng = new Random();
                                fetchNutritionix(query[rng.nextInt(query.length)]).then((value) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => recommended_meals(mealsrecommendation: value, animationController: widget.animationController)));
                                });
                              }else if (recomm.title == "Had Coffee?" ){
                                List<String> query = ["Green Tea", "Hot Tea", "Black Tea"];
                                var rng = new Random();
                                fetchNutritionix(query[rng.nextInt(query.length)]).then((value) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => recommended_meals(mealsrecommendation: value, animationController: widget.animationController)));
                                });
                              }else if (recomm.title == "Too much Sugar!" ){

                              }
                            }
                            if(recomm.title == "Peer Recommendation!"){
                              getPlace(recomm.redirect).then((value) {
                                Result2 val = value;
                                showModalBottomSheet(context: context,
                                  isScrollControlled: true,
                                  builder: (context) => SingleChildScrollView(
                                    child: Container(
                                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                    child: info_place(this_info:  val, thisrating: checkrating2(val.placeId), type: type)
                                    )
                                  ),
                                );
                              });
                              // getReview(recomm.redirect);
                              Future.delayed(const Duration(milliseconds: 1200), (){
                                print("DELAYED");
                              });
                            }
                          });
                        },
                      ),
                      key: Key(recomm.id),
                      onDismissed: (direction){
                        setState(() {
                          recommList.removeAt(index);
                          deleteOneRecom(index);
                        });
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Recommendation dismissed')));
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  }
              ),
            ),
          ),
        ],
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
  void getReview(String placeid){
    reviews.clear();
    final readReviews = databaseReference.child('reviews/' + placeid +"/");
    readReviews.once().then((DataSnapshot snapshot){
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
  Future<Result2> getPlace(String placeid) async{
    String key = "AIzaSyBFsY_boEXrduN5Huw0f_eY88JDhWwiDrk";
    String
    loc = "14.589281719512666, 121.03772954435867",
        radius ="2000",
        type="drugstore",
        query1= "Drugstore";
    var placeRead = await http.get(Uri.parse("https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeid&key=$key"));
    print(placeRead.body.toString());
    Result2 a;
    a = OnePlace.fromJson(jsonDecode(placeRead.body)).result;
    thisPlace = a;
    print("THIS IS A ");
    print(a.name);
    return a;
    //a = Results.fromJson(jsonDecode(placeRead.body));
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
  void deleteOneNotif(int index) async{
    final User user = auth.currentUser;
    final uid = user.uid;
    final readExers = databaseReference.child('users/' + uid + '/notifications/'+ index.toString());
    //readExers.reference().child("exerciseId").child(widget.exercise.exerciseId.toString()).remove().then((value) => Navigator.pop(context));
    await readExers.remove().then((value) {
      final nextread = databaseReference.child('users/' + uid + '/notifications/');
      nextread.once().then((DataSnapshot datasnapshot) {
        List<dynamic> temp = jsonDecode(jsonEncode(datasnapshot.value));
        final deleteread = databaseReference.child('users/' + uid + '/notifications/');
        deleteread.remove();
        if(temp != null){
          // notifsList.clear();
          int counter2 = 0;
          print("THIS ONE");
          print(datasnapshot);
          List<RecomAndNotif> temp = notifsList.reversed.toList();
          temp.forEach((jsonString) {
            RecomAndNotif a = temp[counter2];
            final exerRef = databaseReference.child('users/' + uid + '/notifications/' + counter2.toString());
            exerRef.set({
              "id": counter2.toString(),
              "message": a.message,
              "title": a.title,
              "priority": a.priority,
              "rec_date": a.rec_date,
              "rec_time": a.rec_time,
              "category": a.category,
              "redirect": a.redirect,
            });
            counter2++;
            print("Added Body exercise Successfully! " + uid);
            // notifsList.add(a);
          });
        }
      });
    });
  }
  void getNotifs() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    readBP.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
      });
      notifsList = notifsList.reversed.toList();
    });
  }
  void deleteOneRecom(int index) async{
    final User user = auth.currentUser;
    final uid = user.uid;
    final readExers = databaseReference.child('users/' + uid + '/recommendations/'+ index.toString());
    //readExers.reference().child("exerciseId").child(widget.exercise.exerciseId.toString()).remove().then((value) => Navigator.pop(context));
    await readExers.remove().then((value) {
      final nextread = databaseReference.child('users/' + uid + '/recommendations/');
      nextread.once().then((DataSnapshot datasnapshot) {
        List<dynamic> temp = jsonDecode(jsonEncode(datasnapshot.value));
        final deleteread = databaseReference.child('users/' + uid + '/recommendations/');
        deleteread.remove();
        if(temp != null){
          int counter2 = 0;
          print("THIS ONE");
          print(datasnapshot);
          List<RecomAndNotif> temp = recommList.reversed.toList();
          temp.forEach((jsonString) {
            RecomAndNotif a = temp[counter2];
            final exerRef = databaseReference.child('users/' + uid + '/recommendations/' + counter2.toString());
            exerRef.set({
              "message": a.message,
              "title": a.title,
              "priority": a.priority,
              "rec_date": a.rec_date,
              "rec_time": a.rec_time,
              "category": a.category,
              "redirect": a.redirect,
            });
            counter2++;
            print("Added Body exercise Successfully! " + uid);
          });
        }
      });
    });
  }
  void getRecomm() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/recommendations/');
    readBP.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        recommList.add(RecomAndNotif.fromJson(jsonString));
      });
      recommList = recommList.reversed.toList();
    });
  }
  Future<List<Common>> fetchNutritionix(String thisquery) async {
    var url = Uri.parse("https://trackapi.nutritionix.com/v2/search/instant");
    Map<String, String> headers = {
      "x-app-id": "f4507302",
      "x-app-key": "6db30b5553ddddbb5e2543a32c2d58de",
      "x-remote-user-id": "0",
    };
    // String query = '{ "query" : "chicken noodle soup" }';

    // http.Response response = await http.post(url, headers: headers, body: query);
    List<FullNutrients> temp;
    var response = await http.post(
      url,
      headers: headers,
      body: {
        'query': '$thisquery',
        'detailed': "true",
      },
    );

    if(response.statusCode == 200){
      String data = response.body;
      final parsedJson = convert.jsonDecode(data);
      print(parsedJson);
      final food = nutritionixApi.fromJson(parsedJson);
      print("NUTRITIONIX SEARCH = $thisquery SUCCESS");
      foodrecomm = food.common;
      return foodrecomm;
    }
    else{
      print("response status code is " + response.statusCode.toString());
      return foodrecomm;
    }
  }
}


