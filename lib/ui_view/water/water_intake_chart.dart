import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/users.dart';

import '../../fitness_app_theme.dart';
import '../meals/meals_list_view.dart';

class water_intake_chart extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  const water_intake_chart({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  State<water_intake_chart> createState() => _water_intake_chartState();


  /// Create one series with sample hard coded data.
  static List<charts.Series<Waterintake, String>> _createSampleData(int sunday, int monday, int tuesday, int wednesday, int thursday, int friday, int saturday, double goal) {


    final data = [
      new Waterintake('Su', sunday),
      new Waterintake('M', monday),
      new Waterintake('T', tuesday),
      new Waterintake('W', wednesday),
      new Waterintake('Th', thursday),
      new Waterintake('F', friday),
      new Waterintake('Sa', saturday),
    ];

    return [
      new charts.Series<Waterintake, String>(
          id: 'Water',
          domainFn: (Waterintake water, _) => water.day,
          measureFn: (Waterintake water, _) => water.water,
          data: data,
          // Set a label accessor to control the text of the bar label.
          // ignore: missing_return
          labelAccessorFn: (Waterintake water, _) {
            if (water.water >= goal && water.water != 0) {
              // return '${water.water.toString()}';
              return '★';
            }

          })
    ];
  }
}

class _water_intake_chartState extends State<water_intake_chart> {
  List<WaterIntake> waterintake_list = [];
  Water_Goal water_goal = new Water_Goal();
  int sunday = 0;
  int monday = 0;
  int tuesday = 0;
  int wednesday = 0;
  int thursday = 0;
  int friday = 0;
  int saturday = 0;
  double goal = 0;

  @override
  void initState() {
    super.initState();
    getWaterIntake();
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        print("setstate");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series> thisseries;
    thisseries = water_intake_chart._createSampleData(sunday, monday, tuesday, wednesday, thursday, friday,saturday, goal);

    final myNumericFormatter =
    BasicNumericTickFormatterSpec.fromNumberFormat(
        NumberFormat.compact()
    );

    return Padding(
      padding: const EdgeInsets.only(
          left: 24, right: 24, top: 16, bottom: 18),
      child: Container(
        height: 270,
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
            padding: const EdgeInsets.all(10.0),

            child: charts.BarChart(
              thisseries,
              animate: false,
              behaviors: [
                charts.ChartTitle("Daily Water Intake", titleStyleSpec: charts.TextStyleSpec(color: charts.Color.black, fontSize: 16)),
                charts.RangeAnnotation([charts.LineAnnotationSegment(goal, charts.RangeAnnotationAxisType.measure,  color: charts.ColorUtil.fromDartColor(Colors.black), startLabel: '' , labelAnchor: charts.AnnotationLabelAnchor.middle, labelDirection: charts.AnnotationLabelDirection.horizontal)], layoutPaintOrder: 10)
              ],
              // Set a bar label decorator.
              // Example configuring different styles for inside/outside:
              //       barRendererDecorator: new charts.BarLabelDecorator(
              //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
              //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),

              barRendererDecorator: new charts.BarLabelDecorator<String>(),
              primaryMeasureAxis: NumericAxisSpec(
                  tickFormatterSpec: myNumericFormatter
              ),
              domainAxis: new charts.OrdinalAxisSpec(),
            )
        ) ,
      ),
    );


  }

  void getWaterIntake() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readWaterIntake = databaseReference.child('users/' + uid + '/goal/water_intake/');
    final readWaterGoal = databaseReference.child('users/' + uid + '/goal/water_goal/');
    DateTime today = DateTime.now();
    DateTime firstDayOfTheweek = today.subtract(new Duration(days: today.weekday));
    DateTime lastDayOfTheweek = firstDayOfTheweek.add(new Duration(days: 6));
    readWaterIntake.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      readWaterGoal.once().then((DataSnapshot datasnapshot){
        Map<String, dynamic> temp2 = jsonDecode(jsonEncode(datasnapshot.value));
        water_goal = Water_Goal.fromJson(temp2);
      temp.forEach((jsonString) {
        waterintake_list.add(WaterIntake.fromJson(jsonString));
      });
      goal = water_goal.water_goal;
      for(int i = 0; i< waterintake_list.length; i++){
        if(firstDayOfTheweek.isBefore(waterintake_list[i].dateCreated) && lastDayOfTheweek.isAfter(waterintake_list[i].dateCreated)){
          switch(waterintake_list[i].dateCreated.weekday){
            case 1:
              monday += waterintake_list[i].water_intake;
              break;
            case 2:
              tuesday += waterintake_list[i].water_intake;
              break;
            case 3:
              wednesday += waterintake_list[i].water_intake;
              break;
            case 4:
              thursday += waterintake_list[i].water_intake;
              break;
            case 5:
              friday += waterintake_list[i].water_intake;
              break;
            case 6:
              saturday += waterintake_list[i].water_intake;
              break;
            case 7:
              sunday += waterintake_list[i].water_intake;
              break;
          }
        }

        print("THIS IS DATE CREATED WEEK");
        print(waterintake_list[i].dateCreated.weekday);
      }
      });
    });
  }
}

/// Sample ordinal data type.
class Waterintake {
  final String day;
  final int water;

  Waterintake(this.day, this.water);
}