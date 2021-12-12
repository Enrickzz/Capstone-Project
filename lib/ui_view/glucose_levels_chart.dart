import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../fitness_app_theme.dart';
import '../main.dart';

class glucose_levels extends StatefulWidget{
  final AnimationController animationController;
  final Animation<double> animation;
  glucose_levels({Key key, this.animationController, this.animation})
      : super(key: key);
  @override
  _glucose_levelsState createState() => _glucose_levelsState();
}
List<glucose_levels_data> finaList = new List();
class _glucose_levelsState extends State<glucose_levels> {
  @override
  void initState() {
    super.initState();
    setState(() {
      getChartData();
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
                          title: ChartTitle(text: 'Glucose Levels Past 30 days'),
                          legend: Legend(isVisible: false),
                          series: <ColumnSeries<glucose_levels_data, String>>[
                            ColumnSeries<glucose_levels_data, String>(
                              // Binding the chartData to the dataSource of the column series.
                                dataSource: finaList,
                                xValueMapper: (glucose_levels_data data, _) => data.date,
                                yValueMapper: (glucose_levels_data data, _) => data.glucoseLevel,
                                color: Colors.blue,
                              animationDuration: 5000,animationDelay: 500
                            ),
                          ],
                          primaryXAxis: CategoryAxis(
                              maximumLabels: 0,
                            //isVisible: false
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true,
                              tooltipPosition: TooltipPosition.pointer),
                          primaryYAxis: NumericAxis(
                              edgeLabelPlacement: EdgeLabelPlacement.shift,
                              title: AxisTitle(text: 'Glucose levels')),
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
  getChartData(){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
    final bmiRef = databaseReference.child('users/' +uid+'/vitals/health_records/blood_glucose_list/');
    List<glucose_levels_data> tempList= new List();
    Future<void> getData() async{
      await bmiRef.once().then((DataSnapshot snapshot){
        print(snapshot.value);
        String temp1 = snapshot.value.toString();
        List<String> temp = temp1.split('},');
        List<String> tempFull = new List();
        for(var i = 0 ; i < temp.length; i++){
          String full = temp[i].replaceAll("{", "").replaceAll("}", "");
          tempFull.add(full);
          //print(full+"<<<< 1 iteration");
        }
        for(var i= 0 ; i < tempFull.length; i++){
          List<String> _1item = tempFull[i].split(",");
          //print(_1item.length.toString() + "<<<<<<< 1item");
          List<String> a = _1item[0].split(" ");
          if(i==0){

            _1item[0] = _1item[0].replaceAll("[glucose: ", "");
            _1item[1] = _1item[1].replaceAll("bloodGlucose_date: ", "");
            print("======\n\n GLUCOSE \n\n======= \n0 = "+_1item[0] +"\n1 = "+_1item[1]+"\n\n");
            tempList.add(new glucose_levels_data(_1item[1],double.parse(_1item[0])));

          }else{
            //print(_1item[0].replaceAll(_1item[0],a[3]) +"\n\n");
            _1item[0] = _1item[0].replaceAll("glucose: ", "");
            _1item[1] = _1item[1].replaceAll("bloodGlucose_date: ", "");
            print(_1item[0] +"  "+_1item[1]+"\n");
            print("======\n\n GLUCOSE \n\n======= \n0 = "+_1item[0] +"\n1 = "+_1item[1]+"\n\n");

            tempList.add(new glucose_levels_data(_1item[1],double.parse(_1item[0])));
          }
          //print(_1item[0] + "\n" + _1item[1] + "\n====================================");
        }
        finaList = tempList;
        finaList.sort((a,b) => a.date.compareTo(b.date));
      });
    }
    getData();
    Future.delayed(const Duration(seconds: 2), (){
      setState(() {
        print("SET STATE GLUCOSE");
        finaList = finaList;
      });
    });
  }
}
class glucose_levels_data{
  glucose_levels_data(this.date, this.glucoseLevel);
  final String date;
  final double glucoseLevel;
}


  // final List<glucose_levels_data> chartData =[
  //   glucose_levels_data('1/1/21', 120),
  //   glucose_levels_data('1/2/21', 1032),
  //   glucose_levels_data('1/3/21', 2000),
  //   glucose_levels_data('1/4/21', 100),
  //   glucose_levels_data('1/5/21', 125),
  //   glucose_levels_data('1/6/21', 1204),
  //   glucose_levels_data('1/7/21', 1032),
  //   glucose_levels_data('1/8/21', 124),
  //   glucose_levels_data('1/9/21', 102),
  //   glucose_levels_data('1/10/21', 200),
  //   glucose_levels_data('1/11/21', 100),
  //   glucose_levels_data('1/12/21', 1235),
  //   glucose_levels_data('1/13/21', 1204),
  //   glucose_levels_data('1/14/21', 132),
  //   glucose_levels_data('1/15/21', 1204),
  //   glucose_levels_data('1/16/21', 102),
  //   glucose_levels_data('1/17/21', 200),
  //   glucose_levels_data('1/18/21', 150),
  //   glucose_levels_data('1/19/21', 1235),
  //   glucose_levels_data('1/20/21', 124),
  //   glucose_levels_data('1/21/21', 1032),
  //   glucose_levels_data('1/22/21', 12),
  //   glucose_levels_data('1/23/21', 1032),
  //   glucose_levels_data('1/24/21', 2000),
  //   glucose_levels_data('1/25/21', 150),
  //   glucose_levels_data('1/26/21', 125),
  //   glucose_levels_data('1/27/21', 124),
  //   glucose_levels_data('1/28/21', 132),
  //   glucose_levels_data('1/29/21', 104),
  //   glucose_levels_data('1/30/21', 103),
  //
  // ];
  // final FirebaseAuth auth = FirebaseAuth.instance;
  // final User user = auth.currentUser;
  // final uid = user.uid;
  // final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  // try{
  //     for(var i = 1; i <= chartData.length && i <= 30; i++){
  //       print(chartData.length.toString()+"<<<<<<<<<<<<<< LENGTH");
  //       final bmiRef = databaseReference.child('users/'+uid+'/vitals/health_records/glucose_levels/'+"record_"+ i.toString());
  //       bmiRef.set({"date": chartData[i-1].date, "glucose_level": chartData[i-1].glucoseLevel});
  //       print("CHECK DB PASOK!");
  //     }
  //   }catch(e) {
  //     print("you got an error! $e");
  //   }



