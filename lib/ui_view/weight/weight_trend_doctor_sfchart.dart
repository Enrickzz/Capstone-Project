import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/users.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:my_app/fitness_app_theme.dart';


class weight_trend_sf_doctor extends StatefulWidget{
  final AnimationController animationController;
  final Animation<double> animation;
  final String userUID;

  weight_trend_sf_doctor({Key key, this.animationController, this.animation,this.userUID })
      : super(key: key);

  @override
  WeightTrendState createState() => WeightTrendState();
}

class WeightTrendState extends State<weight_trend_sf_doctor> {

  List<SalesData> _chartData;
  TooltipBehavior _tooltipBehavior;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Weight> weights = new List<Weight>();
  List<Heart_Rate> listtemp = [];
  Weight_Goal weight_goal = new Weight_Goal();

  bool isLoading = true;


  @override
  void initState() {
    getWeightGoal();
    getWeight();
    Future.delayed(const Duration(milliseconds: 1200),() {
      isLoading = false;
      setState(() {
        _tooltipBehavior = TooltipBehavior(enable: true);
        _chartData = getChartData();
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
                  color: FitnessAppTheme.nearlyWhite,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(68.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
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
                      Padding(
                          padding: const EdgeInsets.only(top: 1.0),
                          child: isLoading
                              ? Center(
                            child: CircularProgressIndicator(),
                          ): new SfCartesianChart(
                            title: ChartTitle(text: 'Weight Trend'),
                            legend: Legend(isVisible: false),
                            tooltipBehavior: _tooltipBehavior,
                            series: <ChartSeries>[
                              LineSeries<SalesData, String>(
                                  dataSource: _chartData,
                                  xValueMapper: (SalesData sales, _) => sales.date,
                                  yValueMapper: (SalesData sales, _) => sales.sales,
                                  dataLabelSettings: DataLabelSettings(isVisible: false),
                                  enableTooltip: true,
                                  markerSettings: MarkerSettings(
                                      isVisible: true
                                  ))
                            ],
                            primaryXAxis: CategoryAxis(
                              majorGridLines: MajorGridLines(width: 0),
                            ),
                            primaryYAxis: NumericAxis(
                                majorGridLines: MajorGridLines(width: 0),
                                numberFormat: NumberFormat.compact(),
                                plotBands: <PlotBand>[
                                  // PlotBand(
                                  //   isVisible: true,
                                  //   start: 120,
                                  //   end: 120,
                                  //   borderWidth: 1,
                                  //
                                  //   borderColor: Colors.red,
                                  // ),
                                  PlotBand(

                                      text: 'Goal',
                                      textAngle: 0,
                                      start: weight_goal.target_weight,
                                      end: weight_goal.target_weight,
                                      textStyle: TextStyle(color: Colors.deepOrange, fontSize: 16),
                                      borderColor: Colors.red,
                                      borderWidth: 1
                                  ),

                                  // PlotBand(
                                  //   isVisible: true,
                                  //   start: 80,
                                  //   end: 80,
                                  //   borderWidth: 1,
                                  //   borderColor: Colors.blue,
                                  // )
                                ]
                            ),
                          )

                        // primaryXAxis: NumericAxis,
                      ),

                      SizedBox(
                        height: 32,
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

  void getWeightGoal() {
    // final User user = auth.currentUser;
    final uid = widget.userUID;
    final readWeightGoal = databaseReference.child('users/' + uid + '/goal/weight_goal/');
    readWeightGoal.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      weight_goal = Weight_Goal.fromJson(temp);
    });
  }

  void getWeight() {
    // final User user = auth.currentUser;
    final uid = widget.userUID;
    final readWeight = databaseReference.child('users/' + uid + '/goal/weight/');
    readWeight.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        weights.add(Weight.fromJson(jsonString));
      });
    });
  }

  List <SalesData> getChartData(){
    List <SalesData> chartData = [];
    List<Weight> weightList = [];
    for(int i = 1; i <= weights.length; i++){
      weightList.add(weights[weights.length-i]);
      if(i == 9){
        i = 99999;
      }
    }
    weightList = weightList.reversed.toList();
    for(int i = 0; i < weightList.length; i++){
      chartData.add(SalesData("${weightList[i].dateCreated.month.toString().padLeft(2,"0")}/${weightList[i].dateCreated.day.toString().padLeft(2,"0")}", double.parse(weightList[i].weight.toString())));

    }
    return chartData;
  }





}

class SalesData{
  SalesData(this.date, this.sales);
  final String date;
  final double sales;
}

// class calorie_intake_data{
//   calorie_intake_data(this.date, this.calories);
//   final String date;
//   final int calories;
// }

// Future<void> getData (var name, var id) async {
//   var url = Uri.parse("https://trackapi.nutritionix.com/v2/natural/nutrients");
// }
