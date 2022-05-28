import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/storage_service.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../fitness_app_theme.dart';

class BMI_Chart_doctor extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  final String userUID;
  const BMI_Chart_doctor({Key key, this.animationController, this.animation, this.userUID})
      : super(key: key);

  @override
  State<BMI_Chart_doctor> createState() => _BMI_Chart_doctorState();
}

class _BMI_Chart_doctorState extends State<BMI_Chart_doctor> {
  Physical_Parameters AIobj;
  String bmi = "0";
  String bmi_status = "error";
  bool isLoading = true;
  @override
  void initState(){
    super.initState();
    getBMIdata();
    Future.delayed(const Duration(milliseconds: 3000), (){
      setState(() {
        print(AIobj);
        double bmiDouble = (AIobj.weight / (AIobj.height * AIobj.height) * 10000);
        bmi = bmiDouble.toStringAsFixed(2);
        if (bmiDouble < 18.5){
          bmi_status = "You are underweight!";
        }else if(bmiDouble >= 18.5 && bmiDouble <= 24.9){
          bmi_status = "Your weight is normal!";
        }else if(bmiDouble >= 25 && bmiDouble <= 29.9){
          bmi_status = "You are overweight!";
        }else if(bmiDouble >= 30 && bmiDouble <= 34.9){
          bmi_status = "You are obese!";
        }else if(bmiDouble > 35){
          bmi_status = "You are extremely obese!";
        }
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context)  {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    final Storage storage = Storage();
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
                  color: FitnessAppTheme.nearlyWhite,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.6),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Body Mass Index',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: FitnessAppTheme.fontName,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),

                        child: isLoading
                            ? Center(
                          heightFactor: 5,
                          child: CircularProgressIndicator(
                          ),
                        ): new SfRadialGauge(
                            enableLoadingAnimation: true, animationDuration: 3000,
                            axes: <RadialAxis>[
                              RadialAxis(minimum: 10, maximum: 50,
                                  axisLineStyle: AxisLineStyle(thickness: 30), showTicks: false,
                                  ranges: <GaugeRange>[
                                    GaugeRange(startValue: 10,endValue: 24,color: Colors.greenAccent,startWidth: 10,endWidth:10),
                                    GaugeRange(startValue: 24,endValue: 34,color: Colors.orangeAccent,startWidth: 10,endWidth: 10),
                                    GaugeRange(startValue: 34,endValue: 50,color: Colors.redAccent,startWidth: 10,endWidth: 10)],

                                pointers: <GaugePointer>[
                                    RangePointer(value: double.parse(bmi), pointerOffset: 10,
                                    color: FitnessAppTheme.nearlyBlack, sizeUnit: GaugeSizeUnit.logicalPixel, width: 20,)
                                  ],
                                  annotations: <GaugeAnnotation>[
                                    GaugeAnnotation(widget: Container(
                                        child: Column(
                                          children: [
                                            Text(bmi,
                                                style: TextStyle(color: Colors.black,
                                                    fontSize: 50,
                                                    fontWeight:
                                                    FontWeight.bold)
                                            ),
                                            Text(bmi_status,
                                                style: TextStyle(color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.bold)
                                            )
                                          ],
                                        )
                                    ),
                                        angle: 90,positionFactor: .8)],
                              )]
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void getBMIdata() async{
    final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
    final FirebaseAuth auth = FirebaseAuth.instance;
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    final readBP = databaseReference.child('users/' + userUID + '/physical_parameters/');
    readBP.once().then((DataSnapshot snapshot){
      var temp = jsonDecode(jsonEncode(snapshot.value));
      print(snapshot.value.toString());
      Physical_Parameters a = Physical_Parameters.fromJson(temp);
      AIobj = a;
      print(a.toString());
      print("STATUS " + bmi_status);

    });
  }
}