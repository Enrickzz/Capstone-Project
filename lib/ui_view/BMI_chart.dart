import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/main.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../fitness_app_theme.dart';

class BMI_Chart extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> animation;

  const BMI_Chart({Key key, this.animationController, this.animation})
      : super(key: key);



  @override
  Widget build(BuildContext context)  {
    final Future<String> bmi = getBMIdata();
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Body Mass Index',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: FitnessAppTheme.fontName,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 0.0,
                          color: FitnessAppTheme.nearlyBlack,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),

                        child: SfRadialGauge(
                            enableLoadingAnimation: true, animationDuration: 5500,
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
                                    GaugeAnnotation(widget: Container(child:
                                    Text('25',style: TextStyle(color: Colors.black, fontSize: 50,fontWeight: FontWeight.bold))),
                                        angle: 90,positionFactor: .01)],
                              )]
                        ),


                        // child: SfCircularChart(
                        //     legend: Legend(isVisible: false, position: LegendPosition.bottom),
                        //     series: <CircularSeries>[
                        //       RadialBarSeries<BMIData, String>(
                        //         dataSource: getBMIdata(),
                        //         xValueMapper: (BMIData data, _) => data.xData,
                        //         yValueMapper: (BMIData data, _) => data.yData,
                        //         pointColorMapper: (BMIData data, _) => data.color,
                        //         radius: '100%',
                        //         dataLabelSettings: DataLabelSettings(
                        //           // Renders the data label
                        //             isVisible: true,
                        //             textStyle: TextStyle(
                        //                 fontFamily: 'Arial',
                        //                 fontStyle: FontStyle.italic,
                        //                 fontWeight: FontWeight.bold,
                        //                 fontSize: 20,
                        //                 color: FitnessAppTheme.nearlyDarkBlue
                        //             )
                        //         ),
                        //         cornerStyle: CornerStyle.bothCurve,
                        //
                        //         maximumValue: 40,
                        //
                        //       )
                        //     ]
                        // ),
                      ),
                      SizedBox(
                        height: 32,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.timer,
                                color: FitnessAppTheme.nearlyBlack,
                                size: 16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: const Text(
                                'Goal: ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                  color: FitnessAppTheme.nearlyBlack,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: HexColor("#808080"),
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
                                padding: const EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.arrow_right,
                                  color: FitnessAppTheme.nearlyWhite,
                                  size: 44,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
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
  Future<String> getBMIdata() async {
    final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
    //<---------- insert data to db  ----------->
    // try{
    //   final bmiRef = databaseReference.child('users/1vl6taoaSbNJN7Aeq1JR2id4l7y2/vitals/additional_info');
    //   await bmiRef.set({"BMI": "24"});
    //   print("HAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA!");
    // }catch(e) {
    //   print("you got an error! $e");
    // }
    // <----------- read data from db ----------->
    try{
      final bmiRef = databaseReference.child('users/1vl6taoaSbNJN7Aeq1JR2id4l7y2/vitals/additional_info/BMI');
      bmiRef.once().then((DataSnapshot snapshot) {
        print('Data : ${snapshot.value}');
        return snapshot.value;
      });

    }catch(e) {
      print("you got an error! $e");
    }






    final List<BMIData> data = [
      BMIData("BMI", 24, const Color.fromRGBO(235, 97, 143, 1), "aa"),

    ];

  }
}


class BMIData {
  BMIData(this.xData, this.yData, this.color, [this.text]);
  final String xData;
  final num yData;
  final Color color;
  final String text;

}