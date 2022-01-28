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

class oxygen_barchartsf extends StatefulWidget{
  final AnimationController animationController;
  final Animation<double> animation;
  final String fitbitToken;
  oxygen_barchartsf({Key key, this.animationController, this.animation, this.fitbitToken})
      : super(key: key);

  @override
  oxygenSaturationState createState() => oxygenSaturationState();
}
List<Oxygen> oxygentmp=[];
String date1 = "";
String date2 = "";
String date3 = "";
String date4 = "";
String date5 = "";
String date6 = "";
String date7 = "";
String date8 = "";
String date9 = "";
String date10 = "";
String date11 = "";
String date12 = "";
String date13 = "";
String date14 = "";
class oxygenSaturationState extends State<oxygen_barchartsf> {

  bool isLoading = true;
  List<calorie_intake_data> chartData=[];
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 1200),() {
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
                          title: ChartTitle(text: 'Oxygen Saturation past 14 days'),
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
                              title: AxisTitle(text: 'Oxygen Saturation'),
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
    List<Oxygen> sleep=[];
    sleep = SleepMe.fromJson(jsonDecode(response.body)).sleep;
    oxygentmp = sleep;
    DateTime dateoxygen = DateTime.parse(oxygentmp[0].dateOfSleep);
    DateTime dateoxygen2 = DateTime.parse(oxygentmp[1].dateOfSleep);
    DateTime dateoxygen3 = DateTime.parse(oxygentmp[2].dateOfSleep);
    DateTime dateoxygen4 = DateTime.parse(oxygentmp[3].dateOfSleep);
    DateTime dateoxygen5 = DateTime.parse(oxygentmp[4].dateOfSleep);
    DateTime dateoxygen6 = DateTime.parse(oxygentmp[5].dateOfSleep);
    DateTime dateoxygen7 = DateTime.parse(oxygentmp[6].dateOfSleep);
    DateTime dateoxygen8 = DateTime.parse(oxygentmp[7].dateOfSleep);
    DateTime dateoxygen9 = DateTime.parse(oxygentmp[8].dateOfSleep);
    DateTime dateoxygen10 = DateTime.parse(oxygentmp[9].dateOfSleep);
    DateTime dateoxygen11 = DateTime.parse(oxygentmp[10].dateOfSleep);
    DateTime dateoxygen12 = DateTime.parse(oxygentmp[11].dateOfSleep);
    DateTime dateoxygen13 = DateTime.parse(oxygentmp[12].dateOfSleep);
    DateTime dateoxygen14 = DateTime.parse(oxygentmp[13].dateOfSleep);
    date1 = "${dateoxygen.month.toString().padLeft(2,"0")}/${dateoxygen.day.toString().padLeft(2,"0")}/${dateoxygen.year % 100}";
    date2 = "${dateoxygen2.month.toString().padLeft(2,"0")}/${dateoxygen2.day.toString().padLeft(2,"0")}/${dateoxygen2.year % 100}";
    date3 = "${dateoxygen3.month.toString().padLeft(2,"0")}/${dateoxygen3.day.toString().padLeft(2,"0")}/${dateoxygen3.year % 100}";
    date4 = "${dateoxygen4.month.toString().padLeft(2,"0")}/${dateoxygen4.day.toString().padLeft(2,"0")}/${dateoxygen4.year % 100}";
    date5 = "${dateoxygen5.month.toString().padLeft(2,"0")}/${dateoxygen5.day.toString().padLeft(2,"0")}/${dateoxygen5.year % 100}";
    date6 = "${dateoxygen6.month.toString().padLeft(2,"0")}/${dateoxygen6.day.toString().padLeft(2,"0")}/${dateoxygen6.year % 100}";
    date7 = "${dateoxygen7.month.toString().padLeft(2,"0")}/${dateoxygen7.day.toString().padLeft(2,"0")}/${dateoxygen7.year % 100}";
    date8 = "${dateoxygen8.month.toString().padLeft(2,"0")}/${dateoxygen8.day.toString().padLeft(2,"0")}/${dateoxygen8.year % 100}";
    date9 = "${dateoxygen9.month.toString().padLeft(2,"0")}/${dateoxygen9.day.toString().padLeft(2,"0")}/${dateoxygen9.year % 100}";
    date10 = "${dateoxygen10.month.toString().padLeft(2,"0")}/${dateoxygen10.day.toString().padLeft(2,"0")}/${dateoxygen10.year % 100}";
    date11 = "${dateoxygen11.month.toString().padLeft(2,"0")}/${dateoxygen11.day.toString().padLeft(2,"0")}/${dateoxygen11.year % 100}";
    date12 = "${dateoxygen12.month.toString().padLeft(2,"0")}/${dateoxygen12.day.toString().padLeft(2,"0")}/${dateoxygen12.year % 100}";
    date13 = "${dateoxygen13.month.toString().padLeft(2,"0")}/${dateoxygen13.day.toString().padLeft(2,"0")}/${dateoxygen13.year % 100}";
    date14 = "${dateoxygen14.month.toString().padLeft(2,"0")}/${dateoxygen14.day.toString().padLeft(2,"0")}/${dateoxygen14.year % 100}";

    chartData =[
      calorie_intake_data(date14, oxygentmp[6].efficiency-10),
      calorie_intake_data(date13, oxygentmp[5].efficiency-10),
      calorie_intake_data(date12, oxygentmp[4].efficiency-10),
      calorie_intake_data(date11, oxygentmp[3].efficiency-10),
      calorie_intake_data(date10, oxygentmp[2].efficiency-10),
      calorie_intake_data(date9, oxygentmp[1].efficiency-10),
      calorie_intake_data(date8, oxygentmp[0].efficiency-10),
      calorie_intake_data(date7, oxygentmp[6].efficiency-10),
      calorie_intake_data(date6, oxygentmp[5].efficiency-10),
      calorie_intake_data(date5, oxygentmp[4].efficiency-10),
      calorie_intake_data(date4, oxygentmp[3].efficiency-10),
      calorie_intake_data(date3, oxygentmp[2].efficiency-10),
      calorie_intake_data(date2, oxygentmp[1].efficiency-10),
      calorie_intake_data(date1, oxygentmp[0].efficiency-10),
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
