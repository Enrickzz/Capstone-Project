import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/users.dart';

import '../../fitness_app_theme.dart';

class weight_trend extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  const weight_trend({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  State<weight_trend> createState() => _weight_trendState();
}

class _weight_trendState extends State<weight_trend> {
  /// Creates a [TimeSeriesChart] with sample data and no transition.

  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  List<Weight> weights = new List<Weight>();
  Weight_Goal weight_goal = new Weight_Goal();

  @override
  void initState() {
    super.initState();
    getWeightGoal();
    getWeight();
    Future.delayed(const Duration(milliseconds: 1000), (){
      setState(() {
        print("setstate");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series> thisseries;
    thisseries = _createSampleData();
    return Padding(
      padding: const EdgeInsets.only(
          left: 24, right: 24, top: 16, bottom: 18),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          color: FitnessAppTheme.nearlyWhite,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(8.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: FitnessAppTheme.grey.withOpacity(0.6),
                offset: Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
        ),
        child:Padding(
          padding: const EdgeInsets.all(16.0),

          child: charts.TimeSeriesChart(
            thisseries,
            animate: false,
            // Optionally pass in a [DateTimeFactory] used by the chart. The factory
            // should create the same type of [DateTime] as the data provided. If none
            // specified, the default creates local date time.
            dateTimeFactory: const charts.LocalDateTimeFactory(),
            behaviors: [
              charts.ChartTitle("Weight Trend", titleStyleSpec: charts.TextStyleSpec(color: charts.Color.black, fontSize: 16)),
              charts.RangeAnnotation([
                charts.LineAnnotationSegment(weight_goal.target_weight,
                  charts.RangeAnnotationAxisType.measure,
                  color: charts.ColorUtil.fromDartColor(Colors.greenAccent), startLabel: 'goal' ,
                  labelAnchor: charts.AnnotationLabelAnchor.middle,
                  labelDirection: charts.AnnotationLabelDirection.horizontal)], layoutPaintOrder: 10)
            ],
          ),
        ) ,
      ),
    );
  }
  void getWeightGoal() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readWeightGoal = databaseReference.child('users/' + uid + '/goal/weight_goal/');
    readWeightGoal.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      weight_goal = Weight_Goal.fromJson(temp);
    });
  }
  void getWeight() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readWeight = databaseReference.child('users/' + uid + '/goal/weight/');
    readWeight.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        weights.add(Weight.fromJson(jsonString));
      });
    });
  }
  /// Create one series with sample hard coded data.
  List<charts.Series<TimeSeriesWeight, DateTime>> _createSampleData() {

    List<TimeSeriesWeight> data = [];
    for(int i =0; i < weights.length; i++){
      data.add(new TimeSeriesWeight.TimeSeriesWeight(new DateTime(weights[i].dateCreated.year, weights[i].dateCreated.month, weights[i].dateCreated.day), weights[i].weight));
    }
    return [
      new charts.Series<TimeSeriesWeight, DateTime>(
        id: 'Weight',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesWeight weight, _) => weight.time,
        measureFn: (TimeSeriesWeight weight, _) => weight.weight,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesWeight {
  final DateTime time;
  final double weight;

  TimeSeriesWeight.TimeSeriesWeight(this.time, this.weight);
}