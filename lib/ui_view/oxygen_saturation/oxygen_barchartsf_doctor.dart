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
import '../../fitness_app_theme.dart';
import '../../main.dart';

class oxygen_barchartsfDoctor extends StatefulWidget{
  final AnimationController animationController;
  final Animation<double> animation;
  final String fitbitToken;
  final String userUID;

  oxygen_barchartsfDoctor({Key key, this.animationController, this.animation, this.fitbitToken,this.userUID})
      : super(key: key);

  @override
  oxygenSaturationState createState() => oxygenSaturationState();
}

class oxygenSaturationState extends State<oxygen_barchartsfDoctor> {

  bool isLoading = true;
  List<calorie_intake_data> chartData=[];
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Oxygen_Saturation> listtemp = [];

  @override
  void initState() {
    super.initState();
    getOxygen();
    Future.delayed(const Duration(milliseconds: 1200),() {
      isLoading = false;
      setState(() {
        chartData = getChartData();
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
                          title: ChartTitle(text: 'Oxygen Saturation'),
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
                              minimum: 30,
                              plotBands: <PlotBand>[
                                // PlotBand(
                                //   isVisible: true,
                                //   start: 120,
                                //   end: 120,
                                //   borderWidth: 1,
                                //
                                //   borderColor: Colors.red,
                                // ),
                                PlotBand(

                                    text: 'Normal',
                                    textAngle: 0,
                                    start: 95,
                                    end: 95,
                                    textStyle: TextStyle(color: Colors.green, fontSize: 22),
                                    borderColor: Colors.green,
                                    borderWidth: 1
                                ),


                              ]),
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
  List <calorie_intake_data> getChartData(){
    List <calorie_intake_data> chartData = [];
    List<Oxygen_Saturation> o2_list = [];
    for(int i = 1; i <= listtemp.length; i++){
      o2_list.add(listtemp[listtemp.length-i]);
      if(i == 9){
        i = 99999;
      }
    }
    o2_list = o2_list.reversed.toList();
    for(int i = 0; i < o2_list.length; i++){
      chartData.add(calorie_intake_data("${o2_list[i].os_date.month.toString().padLeft(2,"0")}/${o2_list[i].os_date.day.toString().padLeft(2,"0")}", o2_list[i].oxygen_saturation));

    }
    return chartData;
  }
  void getOxygen (){
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    final readBC = databaseReference.child('users/' + userUID + '/vitals/health_records/oxygen_saturation_list/');
    readBC.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        listtemp.add(Oxygen_Saturation.fromJson(jsonString));
      });
      listtemp.sort((a,b) => a.os_date.compareTo(b.os_date));
    });
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
