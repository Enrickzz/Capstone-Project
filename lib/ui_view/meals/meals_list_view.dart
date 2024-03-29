import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/fitness_app_theme.dart';
import 'package:my_app/goal_tab/meals/nutritionix_meals.dart';
import 'package:my_app/models/meals_list_data.dart';
import 'package:my_app/main.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/nutritionixApi.dart';

import '../../main.dart';
import '../../goal_tab/meals/meals_list.dart';

class MealsListView extends StatefulWidget {
  const MealsListView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<double> mainScreenAnimation;

  @override
  _MealsListViewState createState() => _MealsListViewState();
}
final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
final FirebaseAuth auth = FirebaseAuth.instance;
List<FoodIntake> breakfast_list = [];
List<FoodIntake> lunch_list = [];
List<FoodIntake> dinner_list = [];
List<FoodIntake> snack_list = [];

class _MealsListViewState extends State<MealsListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<MealsListData> mealsListData = MealsListData.tabIconsList;


  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    int totalBcalories = 0;
    int totalLcalories = 0;
    int totalDcalories = 0;
    int totalScalories = 0;
    List<String> bmeal = [];
    List<String> lmeal = [];
    List<String> dmeal = [];
    List<String> smeal = [];
    breakfast_list.clear();
    lunch_list.clear();
    dinner_list.clear();
    snack_list.clear();
    getBFoodIntake();
    getLFoodIntake();
    getDFoodIntake();
    getSFoodIntake();
    print("init");

    Future.delayed(const Duration(milliseconds: 3300), (){

      bmeal.clear();
      lmeal.clear();
      dmeal.clear();
      smeal.clear();
      for(int i = 0; i < breakfast_list.length; i++){
        totalBcalories += breakfast_list[i].calories;
        bmeal.add(breakfast_list[i].foodName);
      }
      for(int i = 0; i < lunch_list.length; i++){
        totalLcalories += lunch_list[i].calories;
        lmeal.add(lunch_list[i].foodName);
      }
      for(int i = 0; i < dinner_list.length; i++){
        totalDcalories += dinner_list[i].calories;
        dmeal.add(dinner_list[i].foodName);
      }
      for(int i = 0; i < snack_list.length; i++){
        totalScalories += snack_list[i].calories;
        smeal.add(snack_list[i].foodName);
      }
      print(breakfast_list);

      mealsListData[0].kacl = totalBcalories;
      mealsListData[1].kacl = totalLcalories;
      mealsListData[2].kacl = totalDcalories;
      mealsListData[3].kacl = totalScalories;
      mealsListData[0].meals = bmeal;
      mealsListData[1].meals = lmeal;
      mealsListData[2].meals = dmeal;
      mealsListData[3].meals = smeal;

      for(var i = 0 ; i < mealsListData.length; i++){
        for(var j = 0 ; j < mealsListData[i].meals.length; j++){
          print(mealsListData[i].kacl.toString() + " " + mealsListData[i].meals[j]);
        }
      }
      setState(() {
        print("setstate here");
      });
    });

  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: Container(
              height: 216,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: mealsListData.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                      mealsListData.length > 10 ? 10 : mealsListData.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController?.forward();

                  return MealsView(
                    mealsListData: mealsListData[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

}

class MealsView extends StatelessWidget {
  const MealsView(
      {Key key, this.mealsListData, this.animationController, this.animation})
      : super(key: key);

  final MealsListData mealsListData;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => meals_list()
              ));
            },
            child: Transform(
              transform: Matrix4.translationValues(
                  100 * (1.0 - animation.value), 0.0, 0.0),
              child: SizedBox(
                width: 130,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 32, left: 8, right: 8, bottom: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: HexColor(mealsListData.endColor)
                                    .withOpacity(0.6),
                                offset: const Offset(1.1, 4.0),
                                blurRadius: 8.0),
                          ],
                          gradient: LinearGradient(
                            colors: <HexColor>[
                              HexColor(mealsListData.startColor),
                              HexColor(mealsListData.endColor),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(54.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 54, left: 16, right: 16, bottom: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                mealsListData.titleTxt,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.2,
                                  color: FitnessAppTheme.white,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        mealsListData.meals.join('\n'),
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          letterSpacing: 0.2,
                                          color: FitnessAppTheme.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              mealsListData.kacl != 0
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          mealsListData.kacl.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 24,
                                            letterSpacing: 0.2,
                                            color: FitnessAppTheme.white,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, bottom: 3),
                                          child: Text(
                                            'kcal',
                                            style: TextStyle(
                                              fontFamily:
                                                  FitnessAppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                              letterSpacing: 0.2,
                                              color: FitnessAppTheme.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => nutritionix_meals(animationController: animationController)),
                                        );
                                      },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: FitnessAppTheme.nearlyWhite,
                                          shape: BoxShape.circle,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: FitnessAppTheme.nearlyBlack
                                                    .withOpacity(0.4),
                                                offset: Offset(8.0, 8.0),
                                                blurRadius: 8.0),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Icon(
                                            Icons.add,
                                            color: HexColor(mealsListData.endColor),
                                            size: 24,),
                                        ),
                                      ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: FitnessAppTheme.nearlyWhite.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 8,
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset(mealsListData.imagePath),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
DateTime today = DateTime.now();

String now = today.month.toString() +"/"+today.day.toString()+"/" +today.year.toString();
void getBFoodIntake() {
  String now = today.month.toString() +"/"+today.day.toString()+"/" +today.year.toString();

  print("DATE NOW\n$now" );
  final User user = auth.currentUser;
  final uid = user.uid;
  final readFoodIntake = databaseReference.child('users/' + uid + '/intake/food_intake/Breakfast');
  readFoodIntake.once().then((DataSnapshot snapshot){
    List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
    List<FoodIntake> intake = [];
    if(temp != null){
      temp.forEach((jsonString) {
        intake.add(FoodIntake.fromJson(jsonString));
      });
      for(int i = 0; i < intake.length; i++){
        if(intake[i].intakeDate == now){
          print(now + "  " +intake[i].intakeDate );
          breakfast_list.add(intake[i]);
        }
      }
    }
  });
}
void getLFoodIntake() {
  String now = today.month.toString() +"/"+today.day.toString()+"/" +today.year.toString();

  final User user = auth.currentUser;
  final uid = user.uid;
  final readFoodIntake = databaseReference.child('users/' + uid + '/intake/food_intake/Lunch');
  readFoodIntake.once().then((DataSnapshot snapshot){
    List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
    List<FoodIntake> intake = [];
    if(temp != null){
      temp.forEach((jsonString) {
        intake.add(FoodIntake.fromJson(jsonString));
      });
      for(int i = 0; i < intake.length; i++){
        if(intake[i].intakeDate == now){
          lunch_list.add(intake[i]);
        }
      }
    }
  });
}
void getDFoodIntake() {
  String now = today.month.toString() +"/"+today.day.toString()+"/" +today.year.toString();

  final User user = auth.currentUser;
  final uid = user.uid;
  final readFoodIntake = databaseReference.child('users/' + uid + '/intake/food_intake/Dinner');
  readFoodIntake.once().then((DataSnapshot snapshot){
    List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
    List<FoodIntake> intake = [];
    if(temp != null){
      temp.forEach((jsonString) {
        intake.add(FoodIntake.fromJson(jsonString));
      });
      for(int i = 0; i < intake.length; i++){
        if(intake[i].intakeDate == now){
          dinner_list.add(intake[i]);
        }
      }
    }
  });
}
void getSFoodIntake() {
  String now = today.month.toString() +"/"+today.day.toString()+"/" +today.year.toString();

  final User user = auth.currentUser;
  final uid = user.uid;
  final readFoodIntake = databaseReference.child('users/' + uid + '/intake/food_intake/Snacks');
  readFoodIntake.once().then((DataSnapshot snapshot){
    List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
    List<FoodIntake> intake = [];
    if(temp != null){
      temp.forEach((jsonString) {
        intake.add(FoodIntake.fromJson(jsonString));
      });
      for(int i = 0; i < intake.length; i++){
        if(intake[i].intakeDate == now){
          snack_list.add(intake[i]);
        }
      }

    }
  });
}