import 'package:my_app/fitness_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:my_app/goal_tab/exercises/exercise_screen_support.dart';
import 'package:my_app/goal_tab/meals/meals_list_doctor.dart';
import 'package:my_app/goal_tab/meals/meals_list_support.dart';
import 'package:my_app/goal_tab/meals/nutritionix_meals_support.dart';
import 'package:my_app/goal_tab/sleep/sleep_list_doctor_view.dart';
import 'package:my_app/goal_tab/sleep/sleep_list_patient_view.dart';
import 'package:my_app/goal_tab/sleep/sleep_list_support_view.dart';
import 'package:my_app/goal_tab/sleep/sleep_score.dart';
import 'package:my_app/goal_tab/water/water_intake_doctor_view.dart';
import 'package:my_app/goal_tab/water/water_intake_patient_view.dart';
import 'package:my_app/goal_tab/water/water_intake_support_view.dart';
import 'package:my_app/goal_tab/weight/weight_list_doctor_view.dart';
import 'package:my_app/goal_tab/weight/weight_list_patient_view.dart';
import 'package:my_app/goal_tab/meals/nutritionix_meals.dart';
import 'package:my_app/goal_tab/weight/weight_list_support_view.dart';
import 'package:my_app/management_plan/exercise_plan/exercise_plan_doctor_view.dart';
import 'package:my_app/management_plan/exercise_plan/exercise_plan_patient_view.dart';
import 'package:my_app/management_plan/exercise_plan/exercise_plan_supp_view.dart';
import 'package:my_app/management_plan/food_plan/food_plan_doctor_view.dart';
import 'package:my_app/management_plan/food_plan/food_plan_patient_view.dart';
import 'package:my_app/goal_tab/exercises/exercise_screen.dart';
import 'package:my_app/management_plan/food_plan/food_plan_support_view.dart';

class TitleView extends StatelessWidget {

  final String titleTxt;
  final String subTxt;
  final int redirect;
  final String userType;
  final AnimationController animationController;
  final Animation<double> animation;
  final String userUID;
  final String fitbitToken;


  const TitleView(
      {Key key,
        this.fitbitToken,
        this.userUID,
        this.titleTxt: "",
        this.subTxt: "",
        this.redirect,
        this.userType: "",
        this.animationController,
        this.animation, Map Function() onTap
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        titleTxt,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: FitnessAppTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          letterSpacing: 0.5,
                          color: FitnessAppTheme.lightText,
                        ),
                      ),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              child: Text(
                                subTxt,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                  color: FitnessAppTheme.nearlyDarkBlue,
                                ),
                              ),
                              onTap: () async{
                                if (redirect == 1) {
                                  if (userType == "Patient") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ExerciseScreen(animationController: animationController)),
                                    );
                                  }
                                  else if (userType == "Support") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ExerciseScreenSupport(animationController: animationController, userUID: userUID)),
                                    );
                                  }
                                } else if (redirect == 2) {
                                  if (userType == "Patient") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => nutritionix_meals(animationController: animationController)),
                                    );
                                  }
                                  else if (userType == "Doctor") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => meals_list_doctor(userUID: userUID)),
                                    );
                                  }
                                  else if (userType == "Support") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => nutritionix_meals_support(animationController: animationController, userUID: userUID)),
                                    );
                                  }
                                }
                                else if (redirect == 3) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => food_prescription_patient_view(animationController: animationController)),
                                  );
                                }
                                else if (redirect == 4) {
                                  if (userType == "Patient") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => weight_list_patient_view()),
                                    );
                                  }
                                  else if (userType == "Doctor") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => weight_list_doctor_view(userUID: userUID)),
                                    );
                                  }
                                  else if (userType == "Support") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => weight_list_support_view(userUID: userUID)),
                                    );
                                  }
                                }
                                else if (redirect == 5) {
                                  if (userType == "Patient") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => water_intake()),
                                    );
                                  }
                                  else if (userType == "Doctor") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => water_intake_doctor_view(userUID: userUID)),
                                    );
                                  }
                                  else if (userType == "Support") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => water_intake_support_view(userUID: userUID)),
                                    );
                                  }
                                }
                                else if (redirect == 6) {
                                  if (userType == "Patient") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => sleep_patient_view(fitbitToken: fitbitToken)),
                                    );
                                  }
                                  else if (userType == "Doctor") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => sleep_doctor_view(userUID: userUID, fitbitToken: fitbitToken)),
                                    );
                                  }
                                  else if (userType == "Support") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => sleep_support_view()),
                                    );
                                  }
                                }
                                else if (redirect == 7) {
                                  if (userType == "Patient") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => food_prescription_patient_view(animationController: animationController)),
                                    );
                                  }
                                  else if (userType == "Doctor") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => food_prescription_doctor_view(userUID: userUID)),
                                    );
                                  }
                                  else if (userType == "Support") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => food_prescription_support_view(animationController: animationController, userUID: userUID)),
                                    );
                                  }
                                }
                                else if (redirect == 9) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => sleep_score()),
                                  );
                                }
                                else if (redirect == 10) {
                                  if (userType == "Patient") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => exercise_prescription_patient_view(animationController: animationController)),
                                    );
                                  }
                                  else if (userType == "Doctor") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => exercise_prescription_doctor_view(userUID: userUID)),
                                    );
                                  }
                                  else if (userType == "Support") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => exercise_prescription_supp_view(userUID: userUID)),
                                    );
                                  }
                                }else if(redirect == 11){

                                }
                              },
                            ),
                            SizedBox(
                              height: 38,
                              width: 26,
                              child: Icon(
                                Icons.arrow_forward,
                                color: FitnessAppTheme.darkText,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
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
