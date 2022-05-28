import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/fitness_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/users.dart';

class weight_progress_support extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;

  const weight_progress_support({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  State<weight_progress_support> createState() => _weight_progress_supportState();
}

class _weight_progress_supportState extends State<weight_progress_support> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  Weight_Goal weight_goal = new Weight_Goal();
  double weight_to_meet_goal = 0;
  double weight_difference = 0;
  String goalCheck ="";
  bool isLoading= true;
  bool maintain_current_weight_is_lower = true;

  @override
  void initState() {
    super.initState();
    getLatestWeight();
    Future.delayed(const Duration(milliseconds: 2000), (){
      setState(() {
        isLoading = false;
        print("setstate");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: isLoading
                    ? Center(
                  child: CircularProgressIndicator(),
                ): new Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              if(goalCheck != "Maintain") ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, bottom: 3),
                                      child: Text(
                                        weight_difference.toStringAsFixed(1),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 30,
                                          color: FitnessAppTheme.nearlyDarkBlue,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, bottom: 8),
                                      child: Text(
                                        'kg',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          letterSpacing: -0.2,
                                          color: FitnessAppTheme.nearlyDarkBlue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              ],


                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, bottom: 1),
                                    child: Row(
                                      children: [
                                        Text(
                                          weight_to_meet_goal.toStringAsFixed(1),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            letterSpacing: 0.0,
                                            color: FitnessAppTheme.nearlyDarkBlue,
                                          ),
                                        ),
                                        Text(
                                          ' kg',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            color: FitnessAppTheme.nearlyDarkBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 1, bottom: 1),
                                    child: Row(
                                      children: [
                                        if(goalCheck != "Maintain") ...[
                                          Text(
                                            'to go to meet your goal!',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: FitnessAppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                        ]else ...[

                                          if(maintain_current_weight_is_lower) ...[
                                            Text(
                                              'is needed to be be gained to maintain your weight goal!!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: FitnessAppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                letterSpacing: 0.0,
                                              ),
                                            ),

                                          ]
                                          else ...[
                                            Text(
                                              'is needed to be be lost to maintain your weight goal!!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: FitnessAppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                letterSpacing: 0.0,
                                              ),
                                            ),
                                          ]



                                        ]

                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),


                          if (goalCheck == "Lose") ...[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 4, bottom: 16, top: 0),
                              child: isLoading
                                  ? Center(
                                child: CircularProgressIndicator(),
                              ): new Text(
                                'lost since ' +
                                    "${weight_goal.dateCreated.month.toString().padLeft(2,"0")}/"+
                                    "${weight_goal.dateCreated.day.toString().padLeft(2,"0")}/"+
                                    "${weight_goal.dateCreated.year}"
                                ,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: FitnessAppTheme.darkText),
                              ),
                            ),

                          ]else if(goalCheck == "Gain")...[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 4, bottom: 16, top: 0),
                              child: isLoading
                                  ? Center(
                                child: CircularProgressIndicator(),
                              ): new Text(
                                'gained since ' +
                                    "${weight_goal.dateCreated.month.toString().padLeft(2,"0")}/"+
                                    "${weight_goal.dateCreated.day.toString().padLeft(2,"0")}/"+
                                    "${weight_goal.dateCreated.year}"
                                ,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: FitnessAppTheme.darkText),
                              ),
                            ),

                          ]else ...[

                          ],

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 8),
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: FitnessAppTheme.background,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  weight_goal.current_weight.toString() + ' kg',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    letterSpacing: -0.2,
                                    color: FitnessAppTheme.darkText,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Current weight',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color:
                                          FitnessAppTheme.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      weight_goal.target_weight.toString() + ' kg',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: -0.2,
                                        color: FitnessAppTheme.darkText,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        'Goal weight',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: FitnessAppTheme.grey
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Expanded(
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.end,
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: <Widget>[
                          //       Column(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         crossAxisAlignment: CrossAxisAlignment.end,
                          //         children: <Widget>[
                          //           GestureDetector(
                          //             onTap: () {
                          //               showModalBottomSheet(context: context,
                          //                 isScrollControlled: true,
                          //                 builder: (context) => SingleChildScrollView(child: Container(
                          //                   padding: EdgeInsets.only(
                          //                       bottom: MediaQuery.of(context).viewInsets.bottom),
                          //                   child: change_weight_goal(),
                          //                 ),
                          //                 ),
                          //               );
                          //             },
                          //             child: Text(
                          //               'Edit Goal',
                          //               style: TextStyle(
                          //                 fontFamily: FitnessAppTheme.fontName,
                          //                 fontSize: 16,
                          //                 color: FitnessAppTheme.nearlyDarkBlue,
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // )
                        ],
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
  void getLatestWeight () {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readWeightGoal = databaseReference.child('users/' + uid + '/goal/weight_goal/');
    readWeightGoal.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      weight_goal = Weight_Goal.fromJson(temp);

      goalCheck = weight_goal.objective;
      if(weight_goal.objective == "Gain"){
        /// 0 siya if si C < SW
        weight_to_meet_goal = weight_goal.target_weight - weight_goal.current_weight;
        weight_difference =  weight_goal.current_weight - weight_goal.weight ;
        print(weight_difference);
        if(weight_to_meet_goal <= 0){
          weight_to_meet_goal = 0;
        }
        if(weight_goal.current_weight <= weight_goal.weight){
          weight_difference = 0;
        }
      }
      if(weight_goal.objective == "Lose"){
        /// 0 siya if si C > SW
        weight_to_meet_goal = weight_goal.current_weight - weight_goal.target_weight;
        weight_difference = weight_goal.weight - weight_goal.current_weight;
        if(weight_to_meet_goal <= 0){
          weight_to_meet_goal = 0;
        }
        if(weight_goal.current_weight >= weight_goal.weight){
          weight_difference = 0;
        }
      }
      if(weight_goal.objective == "Maintain"){
        weight_difference = 0;
        if(weight_goal.target_weight > weight_goal.current_weight){
          weight_to_meet_goal = weight_goal.target_weight - weight_goal.current_weight;

        }
        else if(weight_goal.target_weight < weight_goal.current_weight){
          weight_to_meet_goal =  weight_goal.current_weight - weight_goal.target_weight;
          maintain_current_weight_is_lower = false;

        }
        else{
          weight_to_meet_goal = 0;
        }

      }

    });
  }

}

