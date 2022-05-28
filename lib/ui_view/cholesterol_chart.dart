import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/users.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../fitness_app_theme.dart';
class cholesterol_chart extends StatefulWidget{
  final AnimationController animationController;
  final Animation<double> animation;
  cholesterol_chart({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  _blood_pressureState createState() => _blood_pressureState();
}
List<LineSeries<_ChartData, num>> finalLine = new List();
List<_ChartData> finaList = new List();
class _blood_pressureState extends State<cholesterol_chart> {
  @override
  void initState(){
    super.initState();
    getChart();
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
         print("SET STATE");
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
                        child: SfCartesianChart(
                          plotAreaBorderWidth: 0,
                          legend: Legend(
                              isVisible: true,
                              overflowMode: LegendItemOverflowMode.wrap,
                              position: LegendPosition.top),
                          primaryXAxis: CategoryAxis(
                              isVisible: false,
                              edgeLabelPlacement: EdgeLabelPlacement.shift,
                              interval: 30,
                              //maximum: 30,
                              minimum: 0,
                              majorGridLines: const MajorGridLines(width: 0)),
                          title: ChartTitle(text: 'Cholesterol Levels'),
                          primaryYAxis: NumericAxis(
                              labelFormat: '{value}',
                              interval: 5,
                              axisLine: const AxisLine(width: 0),
                              majorTickLines: const MajorTickLines(color: Colors.transparent)),
                          series: finalLine,
                          tooltipBehavior: TooltipBehavior(enable: true),

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
}
void getChart() {
  finaList.clear();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User user = auth.currentUser;
  final uid = user.uid;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  double counter = 0;
  final readlabresult = databaseReference.child('users/' + uid + '/vitals/health_records/labResult_list/');
  readlabresult.once().then((DataSnapshot snapshot){
    List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
    temp.forEach((jsonString) {
      Lab_Result res = Lab_Result.fromJson(jsonString);
      if(res.ldl != " " && res.hdl != " "){
        finaList.add(new _ChartData(counter,double.parse(res.ldl),double.parse(res.hdl)));
        counter++;
        print(res.ldl + res.hdl);
      }
    });
  });
  finalLine = getLine(finaList);
}

List<LineSeries<_ChartData, num>> getLine(List<_ChartData> thisList){
  thisList.sort((a,b) => a.x.compareTo(b.x));
  return  <LineSeries<_ChartData, num>>[
    LineSeries<_ChartData, num>(
      animationDuration: 2500,
      dataSource: thisList,
      name: 'HDL',
      xValueMapper: (_ChartData sales, _) => sales.x,
      yValueMapper: (_ChartData sales, _) => sales.hdl,
      markerSettings: const MarkerSettings(isVisible: true),
    ),
    LineSeries<_ChartData, num>(
      animationDuration: 2500,
      dataSource: thisList,
      name: 'LDL',
      xValueMapper: (_ChartData sales, _) => sales.x,
      yValueMapper: (_ChartData sales, _) => sales.ldl,
      markerSettings: const MarkerSettings(isVisible: true),
    ),
  ];
}
class _ChartData {
  _ChartData(this.x,this.ldl, this.hdl);
  final double x;
  final double ldl;
  final double hdl;
}
