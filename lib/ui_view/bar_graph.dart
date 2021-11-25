import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../fitness_app_theme.dart';
import '../main.dart';

class barGraph extends StatelessWidget{
  final AnimationController animationController;
  final Animation<double> animation;
  barGraph({Key key, this.animationController, this.animation})
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
                      Text(
                        'Body Mass Index',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: FitnessAppTheme.fontName,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 0.0,
                          color: FitnessAppTheme.nearlyBlack,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: SfCartesianChart(
                                plotAreaBorderWidth: 0,
                                legend: Legend(
                                    isVisible: true,
                                    overflowMode: LegendItemOverflowMode.wrap,
                                    position: LegendPosition.top),
                                primaryXAxis: NumericAxis(
                                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                                    interval: 1,
                                    majorGridLines: const MajorGridLines(width: 0)),
                                title: ChartTitle(text: 'Blood Pressure'),
                                primaryYAxis: NumericAxis(
                                    labelFormat: '{value}',
                                    interval: 20,
                                    axisLine: const AxisLine(width: 0),
                                    majorTickLines: const MajorTickLines(color: Colors.transparent)),
                                series: _getDefaultLineSeries(),
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
        // return FadeTransition(
        //   opacity: animation,
        //   child: new Transform(
        //     transform: new Matrix4.translationValues(
        //         0.0, 30 * (1.0 - animation.value), 0.0),
        //     child: SfCartesianChart(
        //       plotAreaBorderWidth: 0,
        //       legend: Legend(
        //           isVisible: true,
        //           overflowMode: LegendItemOverflowMode.wrap,
        //           position: LegendPosition.top),
        //       primaryXAxis: NumericAxis(
        //           edgeLabelPlacement: EdgeLabelPlacement.shift,
        //           interval: 1,
        //           majorGridLines: const MajorGridLines(width: 0)),
        //       title: ChartTitle(text: 'Blood Pressure'),
        //       primaryYAxis: NumericAxis(
        //           labelFormat: '{value}',
        //           interval: 20,
        //           axisLine: const AxisLine(width: 0),
        //           majorTickLines: const MajorTickLines(color: Colors.transparent)),
        //       series: _getDefaultLineSeries(),
        //       tooltipBehavior: TooltipBehavior(enable: true),
        //
        //     )
        // ));
      },
    );
  }


  }

  List<LineSeries<_ChartData, num>> _getDefaultLineSeries() {
    final List<_ChartData> chartData = <_ChartData>[
      _ChartData(1, 120, 70),
      _ChartData(2, 120, 70),
      _ChartData(3, 130, 90),
      _ChartData(4, 120, 70),
      _ChartData(5, 115, 85),
      _ChartData(6, 122, 78),
      _ChartData(7, 132, 80),
      _ChartData(8, 120, 85),
      _ChartData(9, 140, 90),
      _ChartData(10, 120, 78),
      _ChartData(11, 120, 84)
    ];
    return <LineSeries<_ChartData, num>>[
      LineSeries<_ChartData, num>(
          animationDuration: 2500,
          dataSource: chartData,
          xValueMapper: (_ChartData bp, _) => bp.x,
          yValueMapper: (_ChartData bp, _) => bp.y,
          width: 1,
          name: 'Systolic',
          markerSettings: const MarkerSettings(isVisible: true),
          ),
      LineSeries<_ChartData, num>(
          animationDuration: 2500,
          dataSource: chartData,
          width: 1,
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
class GDPData{
  GDPData(this.continent, this.gdp);
  final String continent;
  final double gdp;
}