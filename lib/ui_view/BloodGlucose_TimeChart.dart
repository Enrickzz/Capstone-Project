import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/users.dart';

import '../fitness_app_theme.dart';

class BGTimeSeries extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  const BGTimeSeries({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  State<BGTimeSeries> createState() => _BGTimeSeriesState();

  /// Create one series with sample hard coded data.

}

class _BGTimeSeriesState extends State<BGTimeSeries> {
  List<Blood_Glucose> bgtemp = [];
  List<charts.Series> thisseries =[];
  bool isLoading = true;
  @override
  void initState(){
    getData();

    Future.delayed(const Duration(milliseconds: 2000),(){
      thisseries = _createSampleData(bgtemp);
      setState(() {
        print("SET STATE");
        isLoading= false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // thisseries = _createSampleData();
    return Padding(
      padding: const EdgeInsets.only(
          left: 24, right: 24, top: 16, bottom: 18),
      child: Container(
        height: 300,
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

          child: isLoading
              ? Center(
            child: CircularProgressIndicator(),
          ): new charts.TimeSeriesChart(
            thisseries,
            animate: false,
              behaviors: [
                charts.ChartTitle("Glucose", titleStyleSpec: charts.TextStyleSpec(color: charts.Color.black, fontSize: 16)),
              ],            // Optionally pass in a [DateTimeFactory] used by the chart. The factory
            // should create the same type of [DateTime] as the data provided. If none
            // specified, the default creates local date time.
            dateTimeFactory: const charts.LocalDateTimeFactory(),
            domainAxis: charts.DateTimeAxisSpec(
              tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                day: charts.TimeFormatterSpec(
                  format: 'dd',
                  transitionFormat: 'dd MMM',
                ),
              ),
            ),
          ),


        ) ,
      ),
    );

  }
  void getData() async{
    final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBC = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list/');
    await readBC.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        bgtemp.add(Blood_Glucose.fromJson(jsonString));
      });
    });
  }
  List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData(List<Blood_Glucose> bg) {
    List<TimeSeriesSales> data = [];
    for(var i = 0 ; i < bg.length; i++){
      print("TIME = " + bg[i].bloodGlucose_date.year.toString());
      data.add(new TimeSeriesSales(new DateTime(bg[i].bloodGlucose_date.year, bg[i].bloodGlucose_date.month, bg[i].bloodGlucose_date.day), bg[i].glucose));
    }
    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Blood Glucose',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}


/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final double sales;

  TimeSeriesSales(this.time, this.sales);
}