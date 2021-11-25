import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../fitness_app_theme.dart';
import '../main.dart';

class calorie_intake extends StatelessWidget{
  final AnimationController animationController;
  final Animation<double> animation;
  calorie_intake({Key key, this.animationController, this.animation})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
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
                          title: ChartTitle(text: 'Calorie Intake Past 30 days'),
                          legend: Legend(isVisible: false),
                          series: <ColumnSeries<calorie_intake_data, String>>[
                            ColumnSeries<calorie_intake_data, String>(
                              // Binding the chartData to the dataSource of the column series.
                                dataSource: getChartData(),
                                xValueMapper: (calorie_intake_data sales, _) => sales.date,
                                yValueMapper: (calorie_intake_data sales, _) => sales.calories,
                                color: Colors.red,
                                animationDuration: 8000,
                            ),
                          ],
                          primaryXAxis: CategoryAxis(
                              maximumLabels: 0
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true,
                          tooltipPosition: TooltipPosition.pointer),
                          primaryYAxis: NumericAxis(
                              edgeLabelPlacement: EdgeLabelPlacement.shift,
                              title: AxisTitle(text: 'Calories'),
                          minimum: 300),
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
List<calorie_intake_data> getChartData(){
  final List<calorie_intake_data> chartData =[
    calorie_intake_data('1/1/21', 1204),
    calorie_intake_data('1/2/21', 1032),
    calorie_intake_data('1/3/21', 2000),
    calorie_intake_data('1/4/21', 1500),
    calorie_intake_data('1/5/21', 1235),
    calorie_intake_data('1/6/21', 1204),
    calorie_intake_data('1/7/21', 1032),
    calorie_intake_data('1/8/21', 1204),
    calorie_intake_data('1/9/21', 1032),
    calorie_intake_data('1/10/21', 2000),
    calorie_intake_data('1/11/21', 1500),
    calorie_intake_data('1/12/21', 1235),
    calorie_intake_data('1/13/21', 1204),
    calorie_intake_data('1/14/21', 1032),
    calorie_intake_data('1/15/21', 1204),
    calorie_intake_data('1/16/21', 1032),
    calorie_intake_data('1/17/21', 2000),
    calorie_intake_data('1/18/21', 1500),
    calorie_intake_data('1/19/21', 1235),
    calorie_intake_data('1/20/21', 1204),
    calorie_intake_data('1/21/21', 1032),
    calorie_intake_data('1/22/21', 1204),
    calorie_intake_data('1/23/21', 1032),
    calorie_intake_data('1/24/21', 2000),
    calorie_intake_data('1/25/21', 1500),
    calorie_intake_data('1/26/21', 1235),
    calorie_intake_data('1/27/21', 1204),
    calorie_intake_data('1/28/21', 1032),
    calorie_intake_data('1/29/21', 1204),
    calorie_intake_data('1/30/21', 1032),

  ];
  return chartData;
}

class calorie_intake_data{
  calorie_intake_data(this.date, this.calories);
  final String date;
  final double calories;
}