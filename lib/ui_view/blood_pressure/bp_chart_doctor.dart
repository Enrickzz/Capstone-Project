import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/users.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../fitness_app_theme.dart';
class bp_chart_doctor extends StatefulWidget{
  final AnimationController animationController;
  final Animation<double> animation;
  final String userUID;
  bp_chart_doctor({Key key, this.animationController, this.animation, this.userUID})
      : super(key: key);

  @override
  _blood_pressureState createState() => _blood_pressureState();
}
List<LineSeries<_ChartData, String>> finalLine = new List();
List<_ChartData> finaList = new List();
class _blood_pressureState extends State<bp_chart_doctor> {
  @override
  void initState(){
    super.initState();
    getData();
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
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
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
                        child: SfCartesianChart(
                          plotAreaBorderWidth: 0,
                          legend: Legend(
                              isVisible: true,
                              overflowMode: LegendItemOverflowMode.wrap,
                              position: LegendPosition.top),
                          // primaryXAxis: CategoryAxis(
                          //     isVisible: false,
                          //     edgeLabelPlacement: EdgeLabelPlacement.shift,
                          //     interval: 1,
                          //     axisLabelFormatter: (AxisLabelRenderDetails details) => axis(details),
                          //     majorGridLines: const MajorGridLines(width: 0)),
                          primaryXAxis: CategoryAxis(
                            majorGridLines: MajorGridLines(width: 0),
                            // plotOffset: 50,
                          ),
                          title: ChartTitle(text: 'Blood Pressure'),
                          // primaryYAxis: NumericAxis(
                          //     labelFormat: '{value}',
                          //     interval: 30,
                          //     minimum: 40,
                          //     axisLine: const AxisLine(width: 0),
                          //     majorTickLines: const MajorTickLines(color: Colors.transparent)),
                          primaryYAxis: NumericAxis(

                              majorGridLines: MajorGridLines(width: 0),
                              numberFormat: NumberFormat.compact()),
                          series: finalLine,
                          tooltipBehavior: TooltipBehavior(enable: true, format: 'series.name : ' + 'point.y' ),

                        ),
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
  Future<void> getData() async{
    finaList.clear();
    // final FirebaseAuth auth = FirebaseAuth.instance;
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
    final bmiRef = databaseReference.child('users/' +userUID+'/vitals/health_records/bp_list/');
    await bmiRef.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      List<Blood_Pressure> thisbp=[];
      temp.forEach((jsonString) {
        thisbp.add(new Blood_Pressure.fromJson(jsonString));
        Blood_Pressure a = new Blood_Pressure.fromJson(jsonString);
        // if(count <= 14){
        finaList.add(new _ChartData("${a.bp_date.month.toString().padLeft(2,"0")}/${a.bp_date.day.toString().padLeft(2,"0")}",double.parse(a.systolic_pressure), double.parse(a.diastolic_pressure)));
        // }
      });

      finalLine = getLine(finaList);
    });
  }
}

  axis(AxisLabelRenderDetails details) {
    return ChartAxisLabel(returnDate(details.value.toString()), details.textStyle);
  }
  String returnDate(String num){
    DateTime now = DateTime.now();
    String a = "";
    a = now.month.toString() + "/" + (double.parse(now.day.toString()) - double.parse(num)).toString().replaceAll(".0", "");
    return a;
  }


List<LineSeries<_ChartData, String>> getLine(List<_ChartData> thisList){
  thisList.sort((a,b) => a.x.compareTo(b.x));
  return  <LineSeries<_ChartData, String>>[
    LineSeries<_ChartData, String>(
      animationDuration: 2500,
      dataSource: thisList,
      xValueMapper: (_ChartData bp, _) => bp.x,
      yValueMapper: (_ChartData bp, _) => bp.y,
      name: 'Systolic',
      xAxisName: "Days",
      markerSettings: const MarkerSettings(isVisible: true),
    ),
    LineSeries<_ChartData, String>(
      animationDuration: 2500,
      dataSource: thisList,
      name: 'Diastolic',
      xAxisName: "Days",yAxisName: "BP",
      xValueMapper: (_ChartData sales, _) => sales.x,
      yValueMapper: (_ChartData sales, _) => sales.y2,
      markerSettings: const MarkerSettings(isVisible: true),
    )
  ];
}
class _ChartData {
  _ChartData(this.x, this.y, this.y2);
  String x;
  double y;
  double y2;
}
