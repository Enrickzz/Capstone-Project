import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/nutritionixApi.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/set_up.dart';
import '../additional_data_collection.dart';
import 'package:flutter/gestures.dart';

import '../dialogs/policy_dialog.dart';
import '../fitness_app_theme.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class my_meals extends StatefulWidget {
  @override
  _my_mealsState createState() => _my_mealsState();
}

class _my_mealsState extends State<my_meals> with SingleTickerProviderStateMixin {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
  List<FoodIntake> breakfast_list = [];
  List<FoodIntake> lunch_list = [];
  List<FoodIntake> dinner_list = [];
  List<FoodIntake> snack_list = [];
  TabController controller;

  @override
  void initState() {
    super.initState();
    getBFoodIntake();
    getLFoodIntake();
    getDFoodIntake();
    getSFoodIntake();
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
          controller: controller,
          indicatorColor: Colors.grey,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs:<Widget>[
            Tab(
              text: 'Breakfast',
            ),
            Tab(
              text: 'Lunch',
            ),
            Tab(
              text: 'Dinner',
            ),
            Tab(
              text: 'Snack',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 20),
            itemCount: breakfast_list.length,
            itemBuilder: (context, index){
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: InkWell(
                  onTap: (){
                  },
                  child: Column(
                    children: [
                      Container(
                          height: 150,
                          child: Stack(
                              children: [
                                Positioned(
                                    top: 25,
                                    left: 25,
                                    child: Material(
                                      child: Container(
                                          height: 110.0,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(5.0),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey.withOpacity(0.5),
                                                  blurRadius: 20.0)],
                                          )
                                      ),

                                    )),
                                Positioned(
                                    top: 10,
                                    left: 30,
                                    child: Card(
                                        elevation: 10.0,
                                        shadowColor: Colors.grey.withOpacity(0.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        child: Container(
                                          height: 110,
                                          width: 120,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.0),
                                              image: DecorationImage(
                                                  fit:BoxFit.cover,
                                                  image: NetworkImage(breakfast_list[index].img)
                                              )
                                          ),
                                        )
                                    )
                                ),
                                Positioned(
                                    top:35,
                                    left: 165,
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(breakfast_list[index].foodName,
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                            Divider(color: Colors.blue),
                                            Text("Calories:" + breakfast_list[index].calories.toString() + " kcal",
                                              style: TextStyle(
                                                fontSize:14,
                                                // color:Colors.grey,
                                              ),),
                                            SizedBox(height: 1,),
                                            Text("Weight:" + breakfast_list[index].serving_size.toString() + "g",
                                              style: TextStyle(
                                                fontSize:14,
                                                // color:Colors.grey,
                                              ),),
                                            SizedBox(height: 5,),


                                            Text("Date:" + breakfast_list[index].intakeDate,
                                              style: TextStyle(
                                                fontSize:12,
                                                // color:Colors.grey,
                                              ),

                                            ),

                                          ]
                                      ),
                                    ))
                              ]
                          )
                      ),
                    ],
                  ),
                ),
              );
            },
          ) ,
          ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 20),
            itemCount: lunch_list.length,
            itemBuilder: (context, index){
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: InkWell(
                  onTap: (){
                  },
                  child: Column(
                    children: [
                      Container(
                          height: 150,
                          child: Stack(
                              children: [
                                Positioned(
                                    top: 25,
                                    left: 25,
                                    child: Material(
                                      child: Container(
                                          height: 110.0,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(5.0),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey.withOpacity(0.5),
                                                  blurRadius: 20.0)],
                                          )
                                      ),

                                    )),
                                Positioned(
                                    top: 10,
                                    left: 30,
                                    child: Card(
                                        elevation: 10.0,
                                        shadowColor: Colors.grey.withOpacity(0.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        child: Container(
                                          height: 110,
                                          width: 120,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.0),
                                              image: DecorationImage(
                                                  fit:BoxFit.cover,
                                                  image: NetworkImage(lunch_list[index].img)
                                              )
                                          ),
                                        )
                                    )
                                ),
                                Positioned(
                                    top:35,
                                    left: 165,
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(lunch_list[index].foodName,
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                            Divider(color: Colors.blue),
                                            Text("Calories: " + lunch_list[index].calories.toString() +" kcal",
                                              style: TextStyle(
                                                fontSize:14,
                                                // color:Colors.grey,
                                              ),),
                                            SizedBox(height: 1,),
                                            Text("Weight:" + lunch_list[index].serving_size.toString() + "g",
                                              style: TextStyle(
                                                fontSize:14,
                                                // color:Colors.grey,
                                              ),),
                                            SizedBox(height: 5,),


                                            Text("Date:" + lunch_list[index].intakeDate,
                                              style: TextStyle(
                                                fontSize:12,
                                                // color:Colors.grey,
                                              ),

                                            ),
                                          ]
                                      ),
                                    ))
                              ]
                          )
                      ),
                    ],
                  ),
                ),
              );
            },
          ) ,
          ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 20),
            itemCount: dinner_list.length,
            itemBuilder: (context, index){
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: InkWell(
                  onTap: (){
                  },
                  child: Column(
                    children: [
                      Container(
                          height: 150,
                          child: Stack(
                              children: [
                                Positioned(
                                    top: 25,
                                    left: 25,
                                    child: Material(
                                      child: Container(
                                          height: 110.0,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(5.0),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey.withOpacity(0.5),
                                                  blurRadius: 20.0)],
                                          )
                                      ),

                                    )),
                                Positioned(
                                    top: 10,
                                    left: 30,
                                    child: Card(
                                        elevation: 10.0,
                                        shadowColor: Colors.grey.withOpacity(0.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        child: Container(
                                          height: 110,
                                          width: 120,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.0),
                                              image: DecorationImage(
                                                  fit:BoxFit.cover,
                                                  image: NetworkImage(dinner_list[index].img)
                                              )
                                          ),
                                        )
                                    )
                                ),
                                Positioned(
                                    top:35,
                                    left: 165,
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(dinner_list[index].foodName,
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                            Divider(color: Colors.blue),
                                            Text("Calories:"+ dinner_list[index].calories.toString()+" kcal",
                                              style: TextStyle(
                                                fontSize:14,
                                                // color:Colors.grey,
                                              ),),
                                            SizedBox(height: 1,),
                                            Text("Weight:" + dinner_list[index].serving_size.toString() + "g",
                                              style: TextStyle(
                                                fontSize:14,
                                                // color:Colors.grey,
                                              ),),
                                            SizedBox(height: 5,),


                                            Text("Date:" + dinner_list[index].intakeDate,
                                              style: TextStyle(
                                                fontSize:12,
                                                // color:Colors.grey,
                                              ),

                                            ),
                                          ]
                                      ),
                                    ))
                              ]
                          )
                      ),
                    ],
                  ),
                ),
              );
            },
          ) ,
          ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 20),
            itemCount: snack_list.length,
            itemBuilder: (context, index){
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: InkWell(
                  onTap: (){
                  },
                  child: Column(
                    children: [
                      Container(
                          height: 150,
                          child: Stack(
                              children: [
                                Positioned(
                                    top: 25,
                                    left: 25,
                                    child: Material(
                                      child: Container(
                                          height: 110.0,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(5.0),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey.withOpacity(0.5),
                                                  blurRadius: 20.0)],
                                          )
                                      ),

                                    )),
                                Positioned(
                                    top: 10,
                                    left: 30,
                                    child: Card(
                                        elevation: 10.0,
                                        shadowColor: Colors.grey.withOpacity(0.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        child: Container(
                                          height: 110,
                                          width: 120,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.0),
                                              image: DecorationImage(
                                                  fit:BoxFit.cover,
                                                  image: NetworkImage(snack_list[index].img)
                                              )
                                          ),
                                        )
                                    )
                                ),
                                Positioned(
                                    top:35,
                                    left: 165,
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(snack_list[index].foodName,
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                            Divider(color: Colors.blue),
                                            Text("Calories: "+snack_list[index].calories.toString()+" kcal",
                                              style: TextStyle(
                                                fontSize:14,
                                                // color:Colors.grey,
                                              ),),
                                            SizedBox(height: 1,),
                                            Text("Weight:" + snack_list[index].serving_size.toString() + "g",
                                              style: TextStyle(
                                                fontSize:14,
                                                // color:Colors.grey,
                                              ),),
                                            SizedBox(height: 5,),


                                            Text("Date:" + snack_list[index].intakeDate,
                                              style: TextStyle(
                                                fontSize:12,
                                                // color:Colors.grey,
                                              ),

                                            ),
                                          ]
                                      ),
                                    ))
                              ]
                          )
                      ),
                    ],
                  ),
                ),
              );
            },
          ) ,
        ],
      ),
    );
  }
  void getBFoodIntake() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readFoodIntake = databaseReference.child('users/' + uid + '/intake/food_intake/Breakfast');
    readFoodIntake.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      if(temp != null){
        temp.forEach((jsonString) {
          breakfast_list.add(FoodIntake.fromJson(jsonString));
        });
      }
    });
  }
  void getLFoodIntake() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readFoodIntake = databaseReference.child('users/' + uid + '/intake/food_intake/Lunch');
    readFoodIntake.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      if(temp != null){
        temp.forEach((jsonString) {
          lunch_list.add(FoodIntake.fromJson(jsonString));
        });
      }
    });
  }
  void getDFoodIntake() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readFoodIntake = databaseReference.child('users/' + uid + '/intake/food_intake/Dinner');
    readFoodIntake.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      if(temp != null){
        temp.forEach((jsonString) {
          dinner_list.add(FoodIntake.fromJson(jsonString));
        });
      }
    });
  }
  void getSFoodIntake() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readFoodIntake = databaseReference.child('users/' + uid + '/intake/food_intake/Snacks');
    readFoodIntake.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      if(temp != null){
        temp.forEach((jsonString) {
          snack_list.add(FoodIntake.fromJson(jsonString));
        });
      }
    });
  }
}
