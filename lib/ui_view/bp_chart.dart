import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../fitness_app_theme.dart';
import '../main.dart';
class bp_chart extends StatefulWidget{
  final AnimationController animationController;
  final Animation<double> animation;
  bp_chart({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  _blood_pressureState createState() => _blood_pressureState();
}
List<LineSeries<_ChartData, num>> finalLine = new List();
List<_ChartData> finaList = new List();
class _blood_pressureState extends State<bp_chart> {
  @override
  void initState(){
    super.initState();
    setState(() {
      _getDefaultLineSeries();
      //finalLine = getLine(finaList);
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
                                title: ChartTitle(text: 'Blood Pressure'),
                                primaryYAxis: NumericAxis(
                                    labelFormat: '{value}',
                                    interval: 15,
                                    minimum: 50,
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

  List<LineSeries<_ChartData, num>> _getDefaultLineSeries() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

    //======================================================ADD DATA TO DB=================================================//
    // final List<_ChartData> chartData = <_ChartData>[
    //   _ChartData(1, 120, 70),
    //   _ChartData(2, 120, 70),
    //   _ChartData(3, 130, 90),
    //   _ChartData(4, 120, 70),
    //   _ChartData(5, 115, 85),
    //   _ChartData(6, 122, 78),
    //   _ChartData(7, 132, 80),
    //   _ChartData(8, 120, 85),
    //   _ChartData(9, 140, 90),
    //   _ChartData(10, 120, 78),
    //   _ChartData(11, 120, 84),
    //   _ChartData(1, 120, 70),
    //   _ChartData(2, 120, 70),
    //   _ChartData(3, 130, 90),
    //   _ChartData(4, 120, 70),
    //   _ChartData(5, 115, 85),
    //   _ChartData(6, 122, 78),
    //   _ChartData(7, 132, 80),
    //   _ChartData(8, 120, 85),
    //   _ChartData(9, 140, 90),
    //   _ChartData(10, 120, 78),
    //   _ChartData(11, 120, 84),
    //   _ChartData(1, 120, 70),
    //   _ChartData(2, 120, 70),
    //   _ChartData(3, 130, 90),
    //   _ChartData(4, 120, 70),
    //   _ChartData(5, 115, 85),
    //   _ChartData(6, 122, 78),
    //   _ChartData(7, 132, 80),
    //   _ChartData(8, 120, 85),
    //   _ChartData(9, 140, 90),
    //   _ChartData(10, 120, 78),
    //   _ChartData(11, 120, 84)
    //
    // ];
    //
    // try{
    //   // final bmiRef = databaseReference.child('users/'+uid+'/vitals/health_records/blood_pressure');
    //   for(var i = 1; i <= chartData.length && i <= 30; i++){
    //     print(chartData.length.toString()+"<<<<<<<<<<<<<< LENGTH");
    //     final bmiRef = databaseReference.child('users/'+uid+'/vitals/health_records/blood_pressure/'+"record_"+ i.toString());
    //     bmiRef.set({"date": chartData[i-1].x, "systolic": chartData[i-1].y, "diastolic": chartData[i-1].y2});
    //     print("CHECK DB PASOK!");
    //   }
    // }catch(e) {
    //   print("you got an error! $e");
    // }
    //======================================================ADD DATA TO DB=================================================//


    Future<void> getData() async{
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;
      final uid = user.uid;
      final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
      final bmiRef = databaseReference.child('users/' +uid+'/vitals/health_records/bp_list/');
      await bmiRef.once().then((DataSnapshot snapshot){
        //print(snapshot.value);
        String temp1 = snapshot.value.toString();
        List<String> temp = temp1.split('},');
        List<String> tempFull = new List();
        double counter = 0;
        for(var i = 0 ; i < temp.length; i++){
          String full = temp[i].replaceAll("{", "").replaceAll("}", "");
          tempFull.add(full);
          //print(full+"<<<< 1 iteration");
        }
        for(var i= 0 ; i < tempFull.length; i++){
          List<String> _1item = tempFull[i].split(",");
          // print(_1item.length.toString() + "<<<<<<< 1item");
          List<String> a = _1item[0].split(" ");
          if(i==0){
            //print(_1item[0].replaceAll(_1item[0],a[2]) +"\n\n");
            // _1item[0] = _1item[0].replaceAll(_1item[0],a[2]);
            // print("LOOK\n" +_1item[0]+"\n" + _1item[1] + "\n" + _1item[2] + "\n" + _1item[3] + "\n" + _1item[4]);
            _1item[1] = _1item[1].replaceAll("diastolic_pressure: ", "");
            _1item[4] = _1item[4].replaceAll("systolic_pressure: ", "");
            _1item[4] = _1item[4].replaceAll("]", "");
            // print("\n y" + _1item[2] + "\ny2 =" + _1item[1]);
            finaList.add(new _ChartData(counter,double.parse(_1item[4]),double.parse(_1item[1])));
            counter++;
            print("counter == " +counter.toString());

          }else{
            //print(_1item[0].replaceAll(_1item[0],a[3]) +"\n\n");
            // _1item[0] = _1item[0].replaceAll(_1item[0],a[3]);
            _1item[1] = _1item[1].replaceAll("diastolic_pressure: ", "");
            _1item[4] = _1item[4].replaceAll("systolic_pressure: ", "");
            _1item[4] = _1item[4].replaceAll("]", "");
            // print("LOOK\n" +_1item[0]+"\n" + _1item[1] + "\n" + _1item[2] + "\n" + _1item[3] + "\n" + _1item[4]);

           // print("\n y" + _1item[2] + "\ny2 =" + _1item[1]);
            finaList.add(new _ChartData(counter,double.parse(_1item[4]),double.parse(_1item[1])));
            counter++;
            // print("counter == " +counter.toString());

          }
          //print(_1item[0] + "\n" + _1item[1] +"\n"+_1item[2] + "\n====================================");
        }
        //print(finaList.length);
        finalLine = getLine(finaList);
        for(var i = 0; i < finaList.length;i++){
          //print(finaList[i].x.toString() + " " + finaList[i].y.toString() + " " + finaList[i].y2.toString());
        }
      });
    }
    getData();
  }

List<LineSeries<_ChartData, num>> getLine(List<_ChartData> thisList){
  thisList.sort((a,b) => a.x.compareTo(b.x));
  return  <LineSeries<_ChartData, num>>[
    LineSeries<_ChartData, num>(
      animationDuration: 2500,
      dataSource: thisList,
      xValueMapper: (_ChartData bp, _) => bp.x,
      yValueMapper: (_ChartData bp, _) => bp.y,
      name: 'Systolic',
      markerSettings: const MarkerSettings(isVisible: true),
    ),
    LineSeries<_ChartData, num>(
      animationDuration: 2500,
      dataSource: thisList,
      name: 'Diastolic',
      xValueMapper: (_ChartData sales, _) => sales.x,
      yValueMapper: (_ChartData sales, _) => sales.y2,
      markerSettings: const MarkerSettings(isVisible: true),
    )
  ];
}
class _ChartData {
  _ChartData(this.x, this.y, this.y2);
  final double x;
  final double y;
  final double y2;
}
