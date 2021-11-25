import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../fitness_app_theme.dart';
import '../main.dart';

class glucose_levels extends StatelessWidget{
  final AnimationController animationController;
  final Animation<double> animation;
  glucose_levels({Key key, this.animationController, this.animation})
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
                          title: ChartTitle(text: 'Glucose Levels Past 30 days'),
                          legend: Legend(isVisible: false),
                          series: <ColumnSeries<glucose_levels_data, String>>[
                            ColumnSeries<glucose_levels_data, String>(
                              // Binding the chartData to the dataSource of the column series.
                                dataSource: getChartData(),
                                xValueMapper: (glucose_levels_data data, _) => data.date,
                                yValueMapper: (glucose_levels_data data, _) => data.glucoseLevel,
                                color: Colors.pinkAccent
                            ),
                          ],
                          primaryXAxis: CategoryAxis(
                              maximumLabels: 0
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

}
List<glucose_levels_data> getChartData(){
  final List<glucose_levels_data> chartData =[
    glucose_levels_data('1/1/21', 120),
    glucose_levels_data('1/2/21', 1032),
    glucose_levels_data('1/3/21', 2000),
    glucose_levels_data('1/4/21', 100),
    glucose_levels_data('1/5/21', 125),
    glucose_levels_data('1/6/21', 1204),
    glucose_levels_data('1/7/21', 1032),
    glucose_levels_data('1/8/21', 124),
    glucose_levels_data('1/9/21', 102),
    glucose_levels_data('1/10/21', 200),
    glucose_levels_data('1/11/21', 100),
    glucose_levels_data('1/12/21', 1235),
    glucose_levels_data('1/13/21', 1204),
    glucose_levels_data('1/14/21', 132),
    glucose_levels_data('1/15/21', 1204),
    glucose_levels_data('1/16/21', 102),
    glucose_levels_data('1/17/21', 200),
    glucose_levels_data('1/18/21', 150),
    glucose_levels_data('1/19/21', 1235),
    glucose_levels_data('1/20/21', 124),
    glucose_levels_data('1/21/21', 1032),
    glucose_levels_data('1/22/21', 12),
    glucose_levels_data('1/23/21', 1032),
    glucose_levels_data('1/24/21', 2000),
    glucose_levels_data('1/25/21', 150),
    glucose_levels_data('1/26/21', 125),
    glucose_levels_data('1/27/21', 124),
    glucose_levels_data('1/28/21', 132),
    glucose_levels_data('1/29/21', 104),
    glucose_levels_data('1/30/21', 103),

  ];
  return chartData;
}

class glucose_levels_data{
  glucose_levels_data(this.date, this.glucoseLevel);
  final String date;
  final double glucoseLevel;
}