import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/mainScreen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:my_app/models/nutritionixApi.dart';
import '../fitness_app_theme.dart';
import '../main.dart';

class stacked_sleep_chart extends StatefulWidget{
  final AnimationController animationController;
  final Animation<double> animation;
  stacked_sleep_chart({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  _calorie_intakeState createState() => _calorie_intakeState();
}


class _calorie_intakeState extends State<stacked_sleep_chart> {

   List<MySleep> _chartData;
   TooltipBehavior _tooltpBehavior;
  @override
  void initState() {
    _chartData = getChartData();
    _tooltpBehavior = TooltipBehavior(enable: true);
    super.initState();
    setState(() {
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
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: SfCartesianChart(
                          title: ChartTitle(text: "Sleep Composition"),
                          legend: Legend(isVisible: true),
                          tooltipBehavior: _tooltpBehavior,
                          series: <ChartSeries>[
                            StackedColumnSeries<MySleep, String>(dataSource: _chartData,
                                xValueMapper: (MySleep exp, _) => exp.sleepDate,
                                yValueMapper: (MySleep exp, _) => exp.rem,
                            name: 'REM',
                            markerSettings: MarkerSettings(isVisible: true)),
                            StackedColumnSeries<MySleep, String>(dataSource: _chartData,
                                xValueMapper: (MySleep exp, _) => exp.sleepDate,
                                yValueMapper: (MySleep exp, _) => exp.deep,
                                name: 'DEEP',
                                markerSettings: MarkerSettings(isVisible: true)),
                            StackedColumnSeries<MySleep, String>(dataSource: _chartData,
                                xValueMapper: (MySleep exp, _) => exp.sleepDate,
                                yValueMapper: (MySleep exp, _) => exp.light,
                                name: 'Light',
                                markerSettings: MarkerSettings(isVisible: true)),
                            StackedColumnSeries<MySleep, String>(dataSource: _chartData,
                                xValueMapper: (MySleep exp, _) => exp.sleepDate,
                                yValueMapper: (MySleep exp, _) => exp.wake,
                                name: 'Wake',
                                markerSettings: MarkerSettings(isVisible: true)),

                          ],
                          primaryXAxis: CategoryAxis(),

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

  List<MySleep> getChartData(){
    final List<MySleep> chartData = [
      MySleep('01/12/2022', 4, 1, 1, 1),
      MySleep('01/13/2022', 5, 2, 2, 1),
      MySleep('01/14/2022', 6, 3, 1, 2),
      MySleep('01/15/2022', 4, 2, 2, 3),
      MySleep('01/16/2022', 4, 1, 1, 2),
      MySleep('01/17/2022', 5, 1, 1, 2),
      MySleep('01/18/2022', 3, 1, 1, 2),


    ];
    return chartData;
  }









  }



class MySleep{
  MySleep(this.sleepDate, this.rem, this.deep, this.light, this.wake);
  final String sleepDate;
  final num rem;
  final num deep;
  final num light;
  final num wake;
}

// Future<void> getData (var name, var id) async {
//   var url = Uri.parse("https://trackapi.nutritionix.com/v2/natural/nutrients");
// }
