import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/nutritionixApi.dart';
import 'package:my_app/services/auth.dart';

class meals_list extends StatefulWidget {
  @override
  _meals_listState createState() => _meals_listState();
}

class _meals_listState extends State<meals_list> with SingleTickerProviderStateMixin {
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
    breakfast_list.clear();
    lunch_list.clear();
    dinner_list.clear();
    snack_list.clear();
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


                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Date: " + breakfast_list[index].intakeDate,
                                                style: TextStyle(
                                                  fontSize:12,
                                                  // color:Colors.grey,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _showMyDialogDelete("Breakfast", index);

                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                ),
                                              ),
                                            ],
                                          ),

                                        ]
                                    ),
                                  ))
                            ]
                        )
                    ),
                  ],
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


                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Date: " + lunch_list[index].intakeDate,
                                                style: TextStyle(
                                                  fontSize:12,
                                                  // color:Colors.grey,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _showMyDialogDelete("Lunch", index);

                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                    ),
                                  ))
                            ]
                        )
                    ),
                  ],
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

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Date: " + dinner_list[index].intakeDate,
                                                style: TextStyle(
                                                  fontSize:12,
                                                  // color:Colors.grey,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _showMyDialogDelete("Dinner", index);

                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                    ),
                                  ))
                            ]
                        )
                    ),
                  ],
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

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Date: " + snack_list[index].intakeDate,
                                                style: TextStyle(
                                                  fontSize:12,
                                                  // color:Colors.grey,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _showMyDialogDelete("Snack", index);

                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                    ),
                                  ))
                            ]
                        )
                    ),
                  ],
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
      breakfast_list.sort((a, b){ //sorting in ascending order
        List<String> dateA = a.intakeDate.split("/");
        String dateAfi = dateA[2] + "-" + dateA[0].padLeft(2, "0")+"-"+dateA[1].padLeft(2, "0") + " 00:00:00";
        List<String> dateB = b.intakeDate.split("/");
        String dateBfi = dateB[2] + "-" + dateB[0].padLeft(2, "0")+"-"+dateB[1].padLeft(2, "0")+ " 00:00:00";
        return DateTime.parse(dateBfi).compareTo(DateTime.parse(dateAfi));
      });
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
      lunch_list.sort((a, b){ //sorting in ascending order
        List<String> dateA = a.intakeDate.split("/");
        String dateAfi = dateA[2] + "-" + dateA[0].padLeft(2, "0")+"-"+dateA[1].padLeft(2, "0") + " 00:00:00";
        List<String> dateB = b.intakeDate.split("/");
        String dateBfi = dateB[2] + "-" + dateB[0].padLeft(2, "0")+"-"+dateB[1].padLeft(2, "0")+ " 00:00:00";
        return DateTime.parse(dateBfi).compareTo(DateTime.parse(dateAfi));
      });
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
      dinner_list.sort((a, b){ //sorting in ascending order
        List<String> dateA = a.intakeDate.split("/");
        String dateAfi = dateA[2] + "-" + dateA[0].padLeft(2, "0")+"-"+dateA[1].padLeft(2, "0") + " 00:00:00";
        List<String> dateB = b.intakeDate.split("/");
        String dateBfi = dateB[2] + "-" + dateB[0].padLeft(2, "0")+"-"+dateB[1].padLeft(2, "0")+ " 00:00:00";
        return DateTime.parse(dateBfi).compareTo(DateTime.parse(dateAfi));
      });
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
      snack_list.sort((a, b){ //sorting in ascending order
        List<String> dateA = a.intakeDate.split("/");
        String dateAfi = dateA[2] + "-" + dateA[0].padLeft(2, "0")+"-"+dateA[1].padLeft(2, "0") + " 00:00:00";
        List<String> dateB = b.intakeDate.split("/");
        String dateBfi = dateB[2] + "-" + dateB[0].padLeft(2, "0")+"-"+dateB[1].padLeft(2, "0")+ " 00:00:00";
        return DateTime.parse(dateBfi).compareTo(DateTime.parse(dateAfi));
      });
    });
  }

  Future<void> _showMyDialogDelete(String mealtype, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text('Are you sure you want to delete these record/s?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                final User user = auth.currentUser;
                final uid = user.uid;
                if(mealtype == "Breakfast"){
                  int initialLength = breakfast_list.length;
                  for(int i = 1; i <= initialLength; i++){
                    final bpRef = databaseReference.child('users/' + uid + '/intake/food_intake/Breakfast/' + i.toString());
                    bpRef.remove();
                  }
                  for(int i = 0; i < breakfast_list.length; i++){
                    final breakfastRef = databaseReference.child('users/' + uid + '/intake/food_intake/Breakfast/' + (i+1).toString());
                    breakfastRef.set({
                      "img": breakfast_list[i].img.toString(),
                      "foodName": breakfast_list[i].foodName.toString(),
                      "weight": breakfast_list[i].weight.toString(),
                      "calories": breakfast_list[i].calories.toString(),
                      "cholesterol": breakfast_list[i].cholesterol.toString(),
                      "total_fat": breakfast_list[i].total_fat.toString(),
                      "sugar": breakfast_list[i].sugar.toString(),
                      "protein": breakfast_list[i].protein.toString(),
                      "potassium": breakfast_list[i].potassium.toString(),
                      "sodium": breakfast_list[i].sodium.toString(),
                      "serving_size": breakfast_list[i].serving_size.toString(),
                      "food_unit": breakfast_list[i].food_unit.toString(),
                      "mealtype": breakfast_list[i].mealtype.toString(),
                      "intakeDate": breakfast_list[i].intakeDate.toString(),
                    });
                  }
                }
                else if(mealtype == "Lunch"){
                  int initialLength = lunch_list.length;
                  for(int i = 1; i <= initialLength; i++){
                    final bpRef = databaseReference.child('users/' + uid + '/intake/food_intake/Lunch/' + i.toString());
                    bpRef.remove();
                  }
                  for(int i = 0; i < lunch_list.length; i++){
                    final lunchRef = databaseReference.child('users/' + uid + '/intake/food_intake/Lunch/' + (i+1).toString());
                    lunchRef.set({
                      "img": lunch_list[i].img.toString(),
                      "foodName": lunch_list[i].foodName.toString(),
                      "weight": lunch_list[i].weight.toString(),
                      "calories": lunch_list[i].calories.toString(),
                      "cholesterol": lunch_list[i].cholesterol.toString(),
                      "total_fat": lunch_list[i].total_fat.toString(),
                      "sugar": lunch_list[i].sugar.toString(),
                      "protein": lunch_list[i].protein.toString(),
                      "potassium": lunch_list[i].potassium.toString(),
                      "sodium": lunch_list[i].sodium.toString(),
                      "serving_size": lunch_list[i].serving_size.toString(),
                      "food_unit": lunch_list[i].food_unit.toString(),
                      "mealtype": lunch_list[i].mealtype.toString(),
                      "intakeDate": lunch_list[i].intakeDate.toString(),
                    });
                  }
                }
                else if(mealtype == "Dinner"){
                  int initialLength = dinner_list.length;
                  for(int i = 1; i <= initialLength; i++){
                    final bpRef = databaseReference.child('users/' + uid + '/intake/food_intake/Dinner/' + i.toString());
                    bpRef.remove();
                  }
                  for(int i = 0; i < dinner_list.length; i++){
                    final dinnerRef = databaseReference.child('users/' + uid + '/intake/food_intake/Dinner/' + (i+1).toString());
                    dinnerRef.set({
                      "img": dinner_list[i].img.toString(),
                      "foodName": dinner_list[i].foodName.toString(),
                      "weight": dinner_list[i].weight.toString(),
                      "calories": dinner_list[i].calories.toString(),
                      "cholesterol": dinner_list[i].cholesterol.toString(),
                      "total_fat": dinner_list[i].total_fat.toString(),
                      "sugar": dinner_list[i].sugar.toString(),
                      "protein": dinner_list[i].protein.toString(),
                      "potassium": dinner_list[i].potassium.toString(),
                      "sodium": dinner_list[i].sodium.toString(),
                      "serving_size": dinner_list[i].serving_size.toString(),
                      "food_unit": dinner_list[i].food_unit.toString(),
                      "mealtype": dinner_list[i].mealtype.toString(),
                      "intakeDate": dinner_list[i].intakeDate.toString(),
                    });
                  }
                }
                else if(mealtype == "Snack"){
                  int initialLength = snack_list.length;
                  for(int i = 1; i <= initialLength; i++){
                    final bpRef = databaseReference.child('users/' + uid + '/intake/food_intake/Snacks/' + i.toString());
                    bpRef.remove();
                  }
                  for(int i = 0; i < snack_list.length; i++){
                    final snackRef = databaseReference.child('users/' + uid + '/intake/food_intake/Snacks/' + (i+1).toString());
                    snackRef.set({
                      "img": snack_list[i].img.toString(),
                      "foodName": snack_list[i].foodName.toString(),
                      "weight": snack_list[i].weight.toString(),
                      "calories": snack_list[i].calories.toString(),
                      "cholesterol": snack_list[i].cholesterol.toString(),
                      "total_fat": snack_list[i].total_fat.toString(),
                      "sugar": snack_list[i].sugar.toString(),
                      "protein": snack_list[i].protein.toString(),
                      "potassium": snack_list[i].potassium.toString(),
                      "sodium": snack_list[i].sodium.toString(),
                      "serving_size": snack_list[i].serving_size.toString(),
                      "food_unit": snack_list[i].food_unit.toString(),
                      "mealtype": snack_list[i].mealtype.toString(),
                      "intakeDate": snack_list[i].intakeDate.toString(),
                    });
                  }
                }



                Navigator.of(context).pop();

              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
