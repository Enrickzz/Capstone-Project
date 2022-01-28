import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/Sleep.dart';
import 'package:my_app/models/users.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:my_app/models/nutritionixApi.dart';
import 'package:my_app/fitness_app_theme.dart';

import 'package:my_app/main.dart';

class blood_glucose_sf_doctor extends StatefulWidget{
  final AnimationController animationController;
  final Animation<double> animation;
  final String userUID;
  blood_glucose_sf_doctor({Key key, this.animationController, this.animation, this.userUID})
      : super(key: key);

  @override
  bloodGlucoseState createState() => bloodGlucoseState();
}

class bloodGlucoseState extends State<blood_glucose_sf_doctor> {

  List<SalesData> _chartData;
  TooltipBehavior _tooltipBehavior;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Blood_Glucose> bgtemp = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getBloodGlucose();
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
                            title: ChartTitle(text: 'Blood Glucose'),
                            legend: Legend(isVisible: false),
                            tooltipBehavior: _tooltipBehavior,
                            series: <ChartSeries>[
                              LineSeries<SalesData, String>(
                                  dataSource: _chartData,
                                  xValueMapper: (SalesData sales, _) => sales.date,
                                  yValueMapper: (SalesData sales, _) => sales.sales,
                                  dataLabelSettings: DataLabelSettings(isVisible: false),
                                  enableTooltip: true)
                            ],
                            primaryXAxis: CategoryAxis(
                              majorGridLines: MajorGridLines(width: 0),
                            ),
                            primaryYAxis: NumericAxis(
                                majorGridLines: MajorGridLines(width: 0),
                                numberFormat: NumberFormat.compact()),
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

  List <SalesData> getChartData(){
    List <SalesData> chartData = [];
    List<Blood_Glucose> bg_list = [];
    for(int i = 1; i <= bgtemp.length; i++){
      bg_list.add(bgtemp[bgtemp.length-i]);
      if(i == 9){
        i = 99999;
      }
    }
    bg_list = bg_list.reversed.toList();
    for(int i = 0; i < bg_list.length; i++){
      chartData.add(SalesData("${bg_list[i].bloodGlucose_date.month.toString().padLeft(2,"0")}/${bg_list[i].bloodGlucose_date.day.toString().padLeft(2,"0")}", bg_list[i].glucose));

    }
    return chartData;
  }
  void getBloodGlucose() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    final readBC = databaseReference.child('users/' + userUID + '/vitals/health_records/blood_glucose_list/');
    readBC.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        bgtemp.add(Blood_Glucose.fromJson(jsonString));
      });
      bgtemp.sort((a,b) => a.bloodGlucose_date.compareTo(b.bloodGlucose_date));
    });
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
