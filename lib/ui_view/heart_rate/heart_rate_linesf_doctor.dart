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
import 'package:my_app/fitness_app_theme.dart';

import 'package:my_app/main.dart';

class heart_rate_sf_doctor extends StatefulWidget{
  final AnimationController animationController;
  final Animation<double> animation;
  heart_rate_sf_doctor({Key key, this.animationController, this.animation, })
      : super(key: key);

  @override
  bloodGlucoseState createState() => bloodGlucoseState();
}

class bloodGlucoseState extends State<heart_rate_sf_doctor> {

  List<SalesData> _chartData;
  TooltipBehavior _tooltipBehavior;
  bool isLoading = true;
  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
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
                            title: ChartTitle(text: 'Heart Rate'),
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
    List <SalesData> chartData = [
      SalesData("1/22/22", 25),
      SalesData("1/24/22", 31),
      SalesData("1/26/22", 23),
      SalesData("1/27/22", 37),
      SalesData("1/29/22", 30),
    ];

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
