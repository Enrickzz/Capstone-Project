import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/users.dart';

import '../fitness_app_theme.dart';

class HRTimeSeries extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  const HRTimeSeries({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  State<HRTimeSeries> createState() => _HRTimeSeriesState();

/// Create one series with sample hard coded data.

}

class _HRTimeSeriesState extends State<HRTimeSeries> {
  List<Heart_Rate> hr = [];
  List<charts.Series> thisseries =[];
  bool isLoading = true;
  @override
  void initState(){
    getData();

    Future.delayed(const Duration(milliseconds: 2000),(){
      thisseries = _createSampleData(hr);
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
                color: FitnessAppTheme.grey.withOpacity(0.2),
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
            // Optionally pass in a [DateTimeFactory] used by the chart. The factory
            // should create the same type of [DateTime] as the data provided. If none
            // specified, the default creates local date time.
            dateTimeFactory: const charts.LocalDateTimeFactory(),
            behaviors: [
              charts.ChartTitle("Heart Rate", titleStyleSpec: charts.TextStyleSpec(color: charts.Color.black, fontSize: 16)),
            ],
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
    final readBC = databaseReference.child('users/' + uid + '/vitals/health_records/heartrate_list/');
    await readBC.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      if(temp != null){
        temp.forEach((jsonString) {
          hr.add(Heart_Rate.fromJson(jsonString));
        });
      }
    });
  }
  List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData(List<Heart_Rate> bg) {
    List<TimeSeriesSales> data = [];
    for(var i = 0 ; i < bg.length; i++){
      print("TIME = " + bg[i].hr_date.year.toString());
      data.add(new TimeSeriesSales(new DateTime(bg[i].hr_date.year, bg[i].hr_date.month, bg[i].hr_date.day), double.parse(bg[i].bpm.toString())));
    }
    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Heart Rate',
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