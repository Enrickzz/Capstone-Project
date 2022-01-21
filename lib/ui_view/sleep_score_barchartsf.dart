import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/Sleep.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:my_app/models/nutritionixApi.dart';
import '../fitness_app_theme.dart';
import '../main.dart';

class sleep_barchart_sf extends StatefulWidget{
  final AnimationController animationController;
  final Animation<double> animation;
  final String fitbitToken;
  sleep_barchart_sf({Key key, this.animationController, this.animation, this.fitbitToken})
      : super(key: key);

  @override
  sleepScoreState createState() => sleepScoreState();
}
List<calorie_intake_data> finaList = new List();
List<Sleep> sleeptmp=[];
String sleepdate1 = "";
String sleepdate2 = "";
String sleepdate3 = "";
String sleepdate4 = "";
String sleepdate5 = "";
String sleepdate6 = "";
String sleepdate7 = "";
class sleepScoreState extends State<sleep_barchart_sf> {

  bool isLoading = true;
  List<calorie_intake_data> chartData=[];
  @override
  void initState() {
    super.initState();
    getFitbit();
    Future.delayed(const Duration(milliseconds: 2000),() {
      isLoading = false;
      setState(() {

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
                          // Setting isTransposed to true to render vertically.
                          // isTransposed: true,
                          title: ChartTitle(text: 'Sleep Score past 7 days'),
                          legend: Legend(isVisible: false),
                          series: <ColumnSeries<calorie_intake_data, String>>[
                            ColumnSeries<calorie_intake_data, String>(
                              // Binding the chartData to the dataSource of the column series.
                                dataSource: chartData,
                                xValueMapper: (calorie_intake_data sales, _) => sales.date,
                                yValueMapper: (calorie_intake_data sales, _) => sales.calories,
                                color: Colors.purple,
                                animationDuration: 5000, animationDelay: 500
                            ),
                          ],
                          primaryXAxis: CategoryAxis(
                              maximumLabels: 0
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true,
                              tooltipPosition: TooltipPosition.pointer),
                          primaryYAxis: NumericAxis(
                              edgeLabelPlacement: EdgeLabelPlacement.shift,
                              title: AxisTitle(text: 'Sleep Score'),
                              minimum: 30),
                        ),
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



  void getFitbit() async {
    String token = widget.fitbitToken;
    var response = await http.get(Uri.parse("https://api.fitbit.com/1.2/user/-/sleep/list.json?beforeDate=2022-03-27&sort=desc&offset=0&limit=30"),
        headers: {
          'Authorization': "Bearer " + token,
        });
    List<Sleep> sleep=[];
    sleep = SleepMe.fromJson(jsonDecode(response.body)).sleep;
    sleeptmp = sleep;
    DateTime datesleep = DateTime.parse(sleeptmp[0].dateOfSleep);
    DateTime datesleep2 = DateTime.parse(sleeptmp[1].dateOfSleep);
    DateTime datesleep3 = DateTime.parse(sleeptmp[2].dateOfSleep);
    DateTime datesleep4 = DateTime.parse(sleeptmp[3].dateOfSleep);
    DateTime datesleep5 = DateTime.parse(sleeptmp[4].dateOfSleep);
    DateTime datesleep6 = DateTime.parse(sleeptmp[5].dateOfSleep);
    DateTime datesleep7 = DateTime.parse(sleeptmp[6].dateOfSleep);
    sleepdate1 = "${datesleep.month.toString().padLeft(2,"0")}/${datesleep.day.toString().padLeft(2,"0")}/${datesleep.year % 100}";
    sleepdate2 = "${datesleep2.month.toString().padLeft(2,"0")}/${datesleep2.day.toString().padLeft(2,"0")}/${datesleep2.year % 100}";
    sleepdate3 = "${datesleep3.month.toString().padLeft(2,"0")}/${datesleep3.day.toString().padLeft(2,"0")}/${datesleep3.year % 100}";
    sleepdate4 = "${datesleep4.month.toString().padLeft(2,"0")}/${datesleep4.day.toString().padLeft(2,"0")}/${datesleep4.year % 100}";
    sleepdate5 = "${datesleep5.month.toString().padLeft(2,"0")}/${datesleep5.day.toString().padLeft(2,"0")}/${datesleep5.year % 100}";
    sleepdate6 = "${datesleep6.month.toString().padLeft(2,"0")}/${datesleep6.day.toString().padLeft(2,"0")}/${datesleep6.year % 100}";
    sleepdate7 = "${datesleep7.month.toString().padLeft(2,"0")}/${datesleep7.day.toString().padLeft(2,"0")}/${datesleep7.year % 100}";

    chartData =[
      calorie_intake_data(sleepdate7, sleeptmp[6].efficiency-10),
      calorie_intake_data(sleepdate6, sleeptmp[5].efficiency-10),
      calorie_intake_data(sleepdate5, sleeptmp[4].efficiency-10),
      calorie_intake_data(sleepdate4, sleeptmp[3].efficiency-10),
      calorie_intake_data(sleepdate3, sleeptmp[2].efficiency-10),
      calorie_intake_data(sleepdate2, sleeptmp[1].efficiency-10),
      calorie_intake_data(sleepdate1, sleeptmp[0].efficiency-10),
    ];
  }


}



class calorie_intake_data{
  calorie_intake_data(this.date, this.calories);
  final String date;
  final int calories;
}

// Future<void> getData (var name, var id) async {
//   var url = Uri.parse("https://trackapi.nutritionix.com/v2/natural/nutrients");
// }
