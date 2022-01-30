import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/database.dart';
import 'package:my_app/goal_tab/meals/nutritionix_meals.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/nutritionixApi.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/set_up.dart';
import 'package:my_app/additional_data_collection.dart';
import 'package:flutter/gestures.dart';

import 'package:my_app/dialogs/policy_dialog.dart';
import 'package:my_app/fitness_app_theme.dart';
import 'package:my_app/management_plan/medication_prescription/add_medication_prescription.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/edit_medication_prescription.dart';
import 'package:http/http.dart' as http;





class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpecificFoodPrescriptionViewAsPatien(title: 'Flutter Demo Home Page'),
    );
  }
}
class CardItem{
  final String urlImage;
  final String foodName;
  final String calories;

  const CardItem({
    this.urlImage,
    this.foodName,
    this.calories

  });
}

class SpecificFoodPrescriptionViewAsPatien extends StatefulWidget {
  SpecificFoodPrescriptionViewAsPatien({Key key, this.title, this.index, this.thislist, this.animationController}) : super(key: key);
  final List<FoodPlan> thislist;
  final String title;
  int index;
  final AnimationController animationController;
  @override
  _SpecificFoodPrescriptionViewAsDoctorState createState() => _SpecificFoodPrescriptionViewAsDoctorState();
}

class _SpecificFoodPrescriptionViewAsDoctorState extends State<SpecificFoodPrescriptionViewAsPatien> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  List<FoodPlan> templist = [];
  Users doctor = new Users();
  String purpose = "";
  List<String> food = [];
  List<Common> result = [];
  String consumption_time = "";
  String important_notes = "";
  String prescribedBy = "";
  String dateCreated = "";

  List<CardItem> items=[];



  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    templist.clear();
    templist = widget.thislist;
    int index = widget.index;
    // getFoodplan();
    purpose = templist[index].purpose;
    food = templist[index].food;
    important_notes = templist[index].important_notes;
    dateCreated = templist[index].dateCreated;
    prescribedBy = templist[index].doctor_name;
    for(int i = 0; i < templist[index].food.length; i++){
      fetchNutritionix(templist[index].food[i]).then((value) => setState((){
        result=value;
        FocusScope.of(context).requestFocus(FocusNode());
        items.insert(0, CardItem(urlImage: result[i].photo.thumb, foodName: result[i].foodName, calories: result[i].getCalories().toStringAsFixed(0) + " kcal"));
      }));
    }
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        // items = items.reversed.toList();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Plan'),
      ),
      body:SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 28, 24, 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:<Widget>[
                        Expanded(
                          child: Text( "Food Plan",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:Color(0xFF4A6572),
                              )
                          ),
                        ),

                      ]
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                    height: 230,
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
                                        Text("Purpose",
                                          style: TextStyle(
                                            fontSize:14,
                                            color:Color(0xFF363f93),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(purpose,
                                          style: TextStyle(
                                              fontSize:16,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),


                                        SizedBox(height: 16),
                                        Text("Important Notes/Assessments",
                                          style: TextStyle(
                                            fontSize:14,
                                            color:Color(0xFF363f93),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(important_notes,
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
                SizedBox(height: 10.0),
                Container(
                  height: 250,
                  child: ListView.separated(
                    padding: EdgeInsets.all(16),
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    separatorBuilder: (context, _) => SizedBox(width: 12,),
                    itemBuilder: (context, index) => buildCard(items[index], index),



                  ),



                ),
                Container(
                    height: 150,
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
                                        Text("Planned by",
                                          style: TextStyle(
                                            fontSize:14,
                                            color:Color(0xFF363f93),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text("Dr." + prescribedBy,
                                          style: TextStyle(
                                              fontSize:16,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Text("Date Planned",
                                              style: TextStyle(
                                                fontSize:14,
                                                color:Color(0xFF363f93),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Text(dateCreated,
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
            )

          ],

        ),
      ),


    );



  }
  Widget buildCard(CardItem item, int index) => Container(
    width: 200,
    child:Column(
        children: [
          Expanded(
              child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Material(
                        child: Ink.image(
                          image: NetworkImage(item.urlImage),
                          fit: BoxFit.cover,
                          child: InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => nutritionix_meals(animationController: widget.animationController, search: templist[widget.index].food[index])),
                              );
                            },
                          ),),
                      )

                  )

              )

          ),
          Text(
            item.foodName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

          ),

          Text(
            item.calories,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),

          ),



        ]
    ),

  );

// Widget buildCopy() => Row(children: [
//   TextField(controller: controller),
//   IconButton(
//       icon: Icon(Icons.content_copy),
//       onPressed: (){
//         FlutterClipboard.copy(text);
//       },
//   )
//
// ],)

  void getFoodplan() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readFoodPlan = databaseReference.child('users/' + uid + '/management_plan/foodplan/');
    int index = widget.index;
    readFoodPlan.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        templist.add(FoodPlan.fromJson(jsonString));
      });
      final readDoctorName = databaseReference.child('users/' + templist[index].prescribedBy + '/personal_info/');
      readDoctorName.once().then((DataSnapshot snapshot){
        Map<String, dynamic> temp2 = jsonDecode(jsonEncode(snapshot.value));
        print(temp2);
        doctor = Users.fromJson(temp2);
        prescribedBy = doctor.lastname + " " + doctor.firstname;
      });
      purpose = templist[index].purpose;
      important_notes = templist[index].important_notes ;
      dateCreated = templist[index].dateCreated;
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
      final parsedJson = jsonDecode(data);
      print(parsedJson);
      final food = nutritionixApi.fromJson(parsedJson);
      print("NUTRITIONIX SEARCH = $thisquery SUCCESS");
      return food.common;
    }
    else{
      print("response status code is " + response.statusCode.toString());
    }
  }
}